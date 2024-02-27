Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391FA13AA2F;
	Tue, 27 Feb 2024 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041372; cv=none; b=NZpzus0gI5kqCKP1ifKDLTUv7LdhPg88MhEfPPo20dH3G7tGCdiNnOHbh1uLY4qeiNG+XBVcfdZ0xv9LahjDpFFcCMjZ4mVVYG4QPrwt5WQasgsn2FvPjHK3FEd51egPRa9jZR/33rMAUfW4t6UXDXEDZ4BdJ+VsdbybP32HIMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041372; c=relaxed/simple;
	bh=RzyDDO3ORnE/oiU4Snu8t8c5eftJV82sT6MzPTM+J20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJplw9qH2HtsVkwsj6xfYZyEK+YQqu5XD/PPivr4n0bgeFB10OyoEcIZiMRSb1y9t6k2htz6BfaS9QNvRL1F7jAu7/Me1o48AH+ijXYdH2jpI1x4gEIrPPjzpZTfHzKGgOLmvaiJP4Ell2IMQ8UHFfJveIo72Yt2SeehHhY5kns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9OVYXDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9OVYXDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB2BC433C7;
	Tue, 27 Feb 2024 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041372;
	bh=RzyDDO3ORnE/oiU4Snu8t8c5eftJV82sT6MzPTM+J20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9OVYXDyKb7MS2Q0tSTcw0SQtHRdARq0EW60lwDedXNedyrxWUG2tIOB1tdQfu8kv
	 PW+UyKVlS5prAGRn10FhgxW0asHKvwY5Hz+iSnLvJLSRwlWWGeCms7txmfja8vUI7S
	 lhg7sA9wnoyleVOEtw8tLEIJOlwKYAJgfRAyle4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luosili <rootlab@huawei.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 317/334] phonet: take correct lock to peek at the RX queue
Date: Tue, 27 Feb 2024 14:22:55 +0100
Message-ID: <20240227131641.327539412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rémi Denis-Courmont <courmisch@gmail.com>

[ Upstream commit 3b2d9bc4d4acdf15a876eae2c0d83149250e85ba ]

The receive queue is protected by its embedded spin-lock, not the
socket lock, so we need the former lock here (and only that one).

Fixes: 107d0d9b8d9a ("Phonet: Phonet datagram transport protocol")
Reported-by: Luosili <rootlab@huawei.com>
Signed-off-by: Rémi Denis-Courmont <courmisch@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240218081214.4806-1-remi@remlab.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/datagram.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index 3aa50dc7535b7..976fe250b5095 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -34,10 +34,10 @@ static int pn_ioctl(struct sock *sk, int cmd, int *karg)
 
 	switch (cmd) {
 	case SIOCINQ:
-		lock_sock(sk);
+		spin_lock_bh(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
 		*karg = skb ? skb->len : 0;
-		release_sock(sk);
+		spin_unlock_bh(&sk->sk_receive_queue.lock);
 		return 0;
 
 	case SIOCPNADDRESOURCE:
-- 
2.43.0




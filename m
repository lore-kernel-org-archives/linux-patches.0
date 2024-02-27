Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575A21420A8;
	Tue, 27 Feb 2024 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042468; cv=none; b=MpjqT8fSXWwTNhBb90lJH9rP63f9LpCRBhZjUOJNKn1sWnkc6aqOC4273b5Zw+RtzonjYa18YYnXAjPbXvbwHidNe2nHiwJZARiFo+16tK04jkrJuwqxWYdUPJnChAOmTlhOYxzzVdJIHEcq/5Mch2GiJctySRyXy/63OfSxN3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042468; c=relaxed/simple;
	bh=wfTj/HvG+nRllQpGAckExf04R0OLnbk82KJg6JwyvMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmSRTbpuRb1mGElZfvLJiCw6Ca1ncUnVIGj2zRE5ZpjWXK3AhLCBE6UP54vvN99ATDVPeryPlc3K/kjPe4+6Wy0wWDV6MSTVLyjVGPAGhPdUVY1NQ6p3LyDVKt+sz7IRJiaB+bx3ZYgbLE5ffNT0fDvDxf+hewns+wuvFiZy4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dom9Nf4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dom9Nf4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8035C433F1;
	Tue, 27 Feb 2024 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042468;
	bh=wfTj/HvG+nRllQpGAckExf04R0OLnbk82KJg6JwyvMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dom9Nf4hQ5mihF3KBnWR1Os+Z8t3eZ+ur77XAN3E62XSTXV0BCxuwVRf/uprofU9y
	 zpo0zDOJwEUVAyzGkxmYXJY6k7j7sAK6eqh6xD0wzdQuVC4B3pU/0VlWClRnJK6N0a
	 R2FaS368c0HAlhBphcetlMquZmUTtWjv8aksXjzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luosili <rootlab@huawei.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/299] phonet: take correct lock to peek at the RX queue
Date: Tue, 27 Feb 2024 14:26:33 +0100
Message-ID: <20240227131634.757883271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882C478B61;
	Tue, 27 Feb 2024 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043630; cv=none; b=AlHY99AgRiVuIDTN6FcqZ4j6zniDpnG3858i2ODy1s3x3xMG7OZsXJGuGZNZHCr70V8AZRaLBAr/M+qwJXtIbARmDt/oxjethL97N1mjlZSZxajpsOy7m97lYPR4cdKi/HFCOtg7vN0AZFp6yffFSLY6+fRU3x3/l+OJCStfB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043630; c=relaxed/simple;
	bh=rAZtjv20HtosyLTgU+WGzI40Nnf05mvIXqS3l/qXE84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPQOI2eaxncaJ5/oIZ6ulHphpULgwN5+Ym7FJLmh2c7ELs17UXL5tW6/SAJBZNRgh23kEmPy7PxslAnrjyXHAQG4FHLYyBreCV5KGGQMylKRlbb9pEeddVJK5YxIzmou2u20n2SjYAFsh5aoCdl3TMganq0wvxVI13yYxg3qhGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmv8lGZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmv8lGZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1245BC433C7;
	Tue, 27 Feb 2024 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043630;
	bh=rAZtjv20HtosyLTgU+WGzI40Nnf05mvIXqS3l/qXE84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmv8lGZQb5j5QqyS6gMq7FaOz+jKK8TIASmvrU/6eK8YQj5HWhHB40EVUsGHg1qxW
	 irnGlt1q9+sYhiptGBFNpRzc11t2/tUrhbUHzTX1quljgltiGs7exkpDO9zEEmQwZf
	 5Hk9KotqyXcCrnMsad1EtoL2AkkhOvmkw/icWIx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luosili <rootlab@huawei.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/195] phonet: take correct lock to peek at the RX queue
Date: Tue, 27 Feb 2024 14:27:19 +0100
Message-ID: <20240227131616.280793263@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/phonet/datagram.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -35,10 +35,10 @@ static int pn_ioctl(struct sock *sk, int
 
 	switch (cmd) {
 	case SIOCINQ:
-		lock_sock(sk);
+		spin_lock_bh(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
 		answ = skb ? skb->len : 0;
-		release_sock(sk);
+		spin_unlock_bh(&sk->sk_receive_queue.lock);
 		return put_user(answ, (int __user *)arg);
 
 	case SIOCPNADDRESOURCE:



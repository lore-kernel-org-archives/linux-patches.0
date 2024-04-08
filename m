Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09F77A15C;
	Mon,  8 Apr 2024 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581414; cv=none; b=tLEIbpnaB3U0p/YXOjfpmPjVxJa+5DmtyNtOyWAt8yMjZijKxwMq3d9aXMD65zG0gyA4Nx42aoYg3b/9waCGtAZ25MGx0lNMQ4A9E8EJ6Blt/BQUS6uRAufCVXpIDmpbNVW5LtyTZ6goq1f6Y8iDfh92QXp9tfIJypKGCMekcdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581414; c=relaxed/simple;
	bh=taH9A+eEwqA7vIG+LdbcckrtqeKkE1Cf6kWBEU03uRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8CpAcFwQvoz+8m05ACCn74AiudZyJDUvD3CvEBu445LTz64Q8G+W5KF6WM1WsthnQ3ikW6X8VdWG8m12OHytxZ76p9WmBlu1HaeOFWRvNYh49y3fzfVDfA2ciU1bvw8qvE+/O8icNYM6q7j8RG3bxa/iKeDhb7u0SdL4r+Nb7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+0bF6xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+0bF6xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7422DC433F1;
	Mon,  8 Apr 2024 13:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581413;
	bh=taH9A+eEwqA7vIG+LdbcckrtqeKkE1Cf6kWBEU03uRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+0bF6xnoqJaNOueTdxbMTlSeYHtmp7/ZLnB3lCjp/b8HH+RoS4seT6d985iR3faW
	 watAtO6oaY9BHHh5qLmEnhvZMi0VyH60v845UISmh472hdtnA1YdtF15UP3Q0tXznP
	 2Q75wuN4XIrRStQ05G5ld62n4yoCceAIwzfTQBhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/138] tls: get psock ref after taking rxlock to avoid leak
Date: Mon,  8 Apr 2024 14:57:10 +0200
Message-ID: <20240408125256.736049629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 417e91e856099e9b8a42a2520e2255e6afe024be ]

At the start of tls_sw_recvmsg, we take a reference on the psock, and
then call tls_rx_reader_lock. If that fails, we return directly
without releasing the reference.

Instead of adding a new label, just take the reference after locking
has succeeded, since we don't need it before.

Fixes: 4cbc325ed6b4 ("tls: rx: allow only one reader at a time")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/fe2ade22d030051ce4c3638704ed58b67d0df643.1711120964.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 7166c0606527f..348abadbc2d82 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2062,10 +2062,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return sock_recv_errqueue(sk, msg, len, SOL_IP, IP_RECVERR);
 
-	psock = sk_psock_get(sk);
 	err = tls_rx_reader_lock(sk, ctx, flags & MSG_DONTWAIT);
 	if (err < 0)
 		return err;
+	psock = sk_psock_get(sk);
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* If crypto failed the connection is broken */
-- 
2.43.0




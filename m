Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD31078F32;
	Tue, 27 May 2025 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365929; cv=none; b=KI9Jx8a2zKbxrrAm/EeYeDTiboivzfr/Pm2wgGxn8IAdnH1dhGuxdkh+QyBMtd20V82yY1I/pOoiS8N2ouZCqmzkiV3XW4vb4FvInE/MSKkCxnXsJDXEsnvLQRRqZCZJ6mgrNP0A2GiYtTIJKNH6rkhIl/d4UxQGeCyITfw4kEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365929; c=relaxed/simple;
	bh=fRYr15sbZj++cmPpWQXhGuGF3LcfwyhOfzhKvIl6zvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCZF6/UuuUZafa8zJM0jIJUzHkNLQbd7iwS6rM5yt6K7jUyBgFb0HYH8TOPFZfnqTLVtjEefBUcBruIQgAEjkcEWVkgu7dn0f6kOtNUk+7rsbRQQQdl132yLTQ1+8LOovipB8qSvPNswmTdKXr5rYrvxXt2SA77IzJ92oBTBLIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9mbOXed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9mbOXed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5F2C4CEE9;
	Tue, 27 May 2025 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365929;
	bh=fRYr15sbZj++cmPpWQXhGuGF3LcfwyhOfzhKvIl6zvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9mbOXedWJ6l+rV5CUwOfMTwV219YH8RpQ3b32b4udQ60MSgIUPpoDVN35JmNYigR
	 Letpxwuscfp98JN6iruZZt08vARJMwxQu1F2ZZpTXtqzCri+N1PrDhfB8r80s4cBjD
	 sB9YWMScK91qWDyRqLvLmpUVOxTLPWNmeXBKqit0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 535/626] espintcp: fix skb leaks
Date: Tue, 27 May 2025 18:27:08 +0200
Message-ID: <20250527162506.732283867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 63c1f19a3be3169e51a5812d22a6d0c879414076 ]

A few error paths are missing a kfree_skb.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c     | 4 +++-
 net/ipv6/esp6.c     | 4 +++-
 net/xfrm/espintcp.c | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index f3281312eb5eb..f0a7f06df3ade 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -199,8 +199,10 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 
 	sk = esp_find_tcp_sk(x);
 	err = PTR_ERR_OR_ZERO(sk);
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		goto out;
+	}
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b2400c226a325..3810cfbc44103 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -216,8 +216,10 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 
 	sk = esp6_find_tcp_sk(x);
 	err = PTR_ERR_OR_ZERO(sk);
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		goto out;
+	}
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index fe82e2d073006..fc7a603b04f13 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -171,8 +171,10 @@ int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
 	if (skb_queue_len(&ctx->out_queue) >=
-	    READ_ONCE(net_hotdata.max_backlog))
+	    READ_ONCE(net_hotdata.max_backlog)) {
+		kfree_skb(skb);
 		return -ENOBUFS;
+	}
 
 	__skb_queue_tail(&ctx->out_queue, skb);
 
-- 
2.39.5




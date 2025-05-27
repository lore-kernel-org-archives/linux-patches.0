Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186DF27D784;
	Tue, 27 May 2025 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368360; cv=none; b=KBbeBtu8zkqceNgxAlSORE3k2KL0ADoQP+T4Eb9DtJyRkSu3cmCq3n6/vXPeKb7sopzNF27fvldO4GC/BbyPjMziH3nKNXplRl9pzEQF8Serjwk4Yj277GU5OkYSjifwvpP0/5KaAYHpuT3Zqu7EMQuhNX0KhBHjF5PuyPfFVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368360; c=relaxed/simple;
	bh=jyWAs4qYUr0KWucV8H7uBRUq7s9Pm/543b37jF41E9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VM5iHnZYLlcomrp+GPL0MO1MlZ2TWHC5kZET8cgBpTlvCY1L8p/zk+43nTErHyQvCVGuIn9rGiKoQwJAUFFR20CHvMynPg2MPibRfqsif9hvm/pUue3tYF7G0kBb9bvp3hAFsTUEhJvP/3AS8LqzNZ+bE/Sk1WY+m5vzgiSJcRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHzkQrEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHzkQrEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DC2C4CEE9;
	Tue, 27 May 2025 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368359;
	bh=jyWAs4qYUr0KWucV8H7uBRUq7s9Pm/543b37jF41E9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHzkQrEgdES/XUsKCfnxZL45sSy0HAJigkULL3uK76LTMGDLyW4NPtVzAnwf2PPuj
	 v7nzW3SWy7UK9bqOd3fH4jfAnPPOGqQaJs2nSodL+kdDnqdJ7UjtWL058MD2Qrg2uK
	 nFbl2VZhwNIPF42I+VFd9oMDgd4x6QrMCuVbwdvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 682/783] espintcp: fix skb leaks
Date: Tue, 27 May 2025 18:27:59 +0200
Message-ID: <20250527162540.902513071@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0e4076866c0a4..876df672c0bfa 100644
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
index 9e73944e3b530..574989b82179c 100644
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




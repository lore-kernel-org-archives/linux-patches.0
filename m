Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399C744AB7F;
	Tue, 21 Jul 2026 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669588; cv=none; b=K27k9hq4GDpeF2G0QJKRrB/vc8mrpr9mEcaaQJPFAPAiqub/TgMINWxaMW9Xis1Zt+aYlBn/y3oKJr4GScliofYZHU4y4eb0LuLDXOkYWRlv5xMCzHKsHzaOm4RSnnrTCmj8J5ZS1pNiGZpG+LwHPFlex4o9A4xvtdb0UvNf7jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669588; c=relaxed/simple;
	bh=WChDaFVe9vCdNWQLT+jgjEKRb9wn62SWlQOpydmm7c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGAzIr9Q3G+pnTkLAR7EzbDIxvtjGeReOqXG5vgUJbWAhR1MgGGgUX9I20WIvopOYs6rygK1rDyxnDEQ2kBbqeibdiM5cgyf1MGDYKuikxUVA4ur4UI+gwu/31tlF4duYYIkBZBqfb+0JyQFJ77UvRK/cm+DmirxK//OW39LXTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gt2oKbE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gt2oKbE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A090E1F000E9;
	Tue, 21 Jul 2026 21:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669587;
	bh=pewOK1N08sGBCCIfub/cQDNRz7amTzaFERQg9Dvrli0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gt2oKbE5YCvNiXtmEP/e0ryYuybbM+j/DCkg2KAk1BtoL41fGNqhShuo+KzP8bWog
	 hXkadxq78T77ebm6TjC2rqXV34ixG15ONldsvc8nqmtA4HFkGcP5I6a/JydqVKxd5N
	 YU6sWDEOmXF6MM8qV0FK2ZdeWm8rBSvL+8tHuPLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Antony Antony <antony.antony@secunet.com>,
	Eyal Birger <eyal.birger@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0568/1067] xfrm: Use the XFRM_GRO to indicate a GRO call on input
Date: Tue, 21 Jul 2026 17:19:29 +0200
Message-ID: <20260721152437.310263934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit b439475a0dba2b50fb39a6356069969780e45fd4 ]

This is needed to support GRO for ESP in UDP encapsulation.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Co-developed-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Stable-dep-of: 68de007d5ac9 ("xfrm: annotate data-races around xfrm_policy_count[] and xfrm_policy_default[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 2 +-
 net/ipv6/esp6_offload.c | 2 +-
 net/xfrm/xfrm_input.c   | 6 ++----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8d6a40054eaabd..12b59cc97125ef 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -76,7 +76,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 
 	/* We don't need to handle errors from xfrm_input, it does all
 	 * the error handling and frees the resources on error. */
-	xfrm_input(skb, IPPROTO_ESP, spi, -2);
+	xfrm_input(skb, IPPROTO_ESP, spi, 0);
 
 	return ERR_PTR(-EINPROGRESS);
 out_reset:
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 460cf1dab9da2d..ad26b4d539b38a 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -104,7 +104,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 
 	/* We don't need to handle errors from xfrm_input, it does all
 	 * the error handling and frees the resources on error. */
-	xfrm_input(skb, IPPROTO_ESP, spi, -2);
+	xfrm_input(skb, IPPROTO_ESP, spi, 0);
 
 	return ERR_PTR(-EINPROGRESS);
 out_reset:
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index efad2e467e1f65..190cc865131491 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -470,7 +470,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
-	if (encap_type < 0) {
+	if (encap_type < 0 || (xo && xo->flags & XFRM_GRO)) {
 		x = xfrm_input_state(skb);
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
@@ -493,9 +493,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			seq = XFRM_SKB_CB(skb)->seq.input.low;
 			goto resume;
 		}
-
-		/* encap_type < -1 indicates a GRO call. */
-		encap_type = 0;
+		/* GRO call */
 		seq = XFRM_SPI_SKB_CB(skb)->seq;
 
 		if (xo && (xo->flags & CRYPTO_DONE)) {
-- 
2.53.0




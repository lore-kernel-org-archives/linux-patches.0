Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A4D26B0A9;
	Tue, 16 Jun 2026 15:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623339; cv=none; b=KehpEyeJnue5ukthmjQFer5hlogfHU6YMT4w6FpAIHxU87SWm3rFF4yQF4/e+LuL28JJZBQr22NDZXp53Htel+Rh1YY3NzLWUaTwmPj9kUP04jSDTTNtynelTxPpofCCn6VXYEIQh2s28IElfvMlU3xi7o4+B7a7rC/SFw6Eyg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623339; c=relaxed/simple;
	bh=DukH3FfDqjsXZYdcM0AkxLAkQ1juPXyXeBn8024xfH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fphwbXFH2zk0JSkhqcPrFbQF07TrmHmQE543f9s54ESx4jndU0yW9TkEMr7ahR2Fv1Eco/qaZmyyJ+hjyFGcdGW4sR6+1abh3rzEcLfFJAyoXMBnfmxYESj8AGpqzeBb8TjtJULC128xiu1E9qgUZdP9djFM15GBJP+6CE0nKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuK09b4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuK09b4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7511E1F000E9;
	Tue, 16 Jun 2026 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623338;
	bh=2HsvlnynqSey3w5jDpO/q3ALvuscg06VbHDahAP+rLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuK09b4B1xcUsm4HexFzTx9GslPkc5CEcosKRfFYhoSxU+j1pdvqudbs7oSyAyiZ4
	 riHJAPMSZ2BsqvKwsVBvBIIdFBMnJXtVEJaVQbeF3YIJXzRLfULJtlEPSIhhMW4Kxj
	 yQgEQb88JsEJwR5apgLhkTlHWCn+ty+5WMauYiik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Schino <7991aleschino@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 129/378] esp: fix page frag reference leak on skb_to_sgvec failure
Date: Tue, 16 Jun 2026 20:26:00 +0530
Message-ID: <20260616145117.113400641@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Schino <7991aleschino@gmail.com>

[ Upstream commit 2982e599fff6faa21c8df147d96fc7af6c1a2f24 ]

In esp_output_tail(), when esp->inplace is false, the old skb page frags
are replaced with a new page from the xfrm page_frag cache. The source
scatterlist (sg) is built from the old frags before the replacement, and
esp_ssg_unref() is responsible for releasing the old page references
after the crypto operation completes.

However, if the second skb_to_sgvec() call (which builds the destination
scatterlist from the new page) fails, the code jumps to error_free which
only calls kfree(tmp). The old page frag references captured in the
source scatterlist are never released:

  1. sg[] is built from old frags via skb_to_sgvec() (no extra get_page)
  2. nr_frags is set to 1 and frag[0] is replaced with the new page
  3. Second skb_to_sgvec() fails -> goto error_free
  4. kfree(tmp) frees the sg[] memory but old frags are not unref'd
  5. kfree_skb() only releases frag[0] (the new page), not the old ones

Fix this by adding a bool parameter to esp_ssg_unref() that, when true,
unconditionally unrefs the source scatterlist frags without checking
req->src and req->dst, since those fields are not yet initialized by
aead_request_set_crypt() at the point of the error. Existing callers
pass false to preserve the original behavior.

The same issue exists in both esp4 and esp6 as the code is identical.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")

Signed-off-by: Alessandro Schino <7991aleschino@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 26aad08a9289 ("esp: fix page frag reference leak on skb_to_sgvec failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 17 +++++++++++------
 net/ipv6/esp6.c | 17 +++++++++++------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 513c8215c947f1..dfc81ee969ae03 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -96,7 +96,7 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 			     __alignof__(struct scatterlist));
 }
 
-static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
+static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb, bool already_unref)
 {
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
@@ -113,10 +113,13 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	/* Unref skb_frag_pages in the src scatterlist if necessary.
 	 * Skip the first sg which comes from skb->data.
 	 */
-	if (req->src != req->dst)
-		for (sg = sg_next(req->src); sg; sg = sg_next(sg))
+	if (already_unref || req->src != req->dst) {
+		struct scatterlist *src = already_unref ? esp_req_sg(aead, req) : req->src;
+
+		for (sg = sg_next(src); sg; sg = sg_next(sg))
 			skb_page_unref(page_to_netmem(sg_page(sg)),
 				       skb->pp_recycle);
+	}
 }
 
 #ifdef CONFIG_INET_ESPINTCP
@@ -220,7 +223,7 @@ static void esp_output_done(void *data, int err)
 	}
 
 	tmp = ESP_SKB_CB(skb)->tmp;
-	esp_ssg_unref(x, tmp, skb);
+	esp_ssg_unref(x, tmp, skb, false);
 	kfree(tmp);
 
 	if (xo && (xo->flags & XFRM_DEV_RESUME)) {
@@ -569,8 +572,10 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 		err = skb_to_sgvec(skb, dsg,
 			           (unsigned char *)esph - skb->data,
 			           assoclen + ivlen + esp->clen + alen);
-		if (unlikely(err < 0))
+		if (unlikely(err < 0)) {
+			esp_ssg_unref(x, tmp, skb, true);
 			goto error_free;
+		}
 	}
 
 	if ((x->props.flags & XFRM_STATE_ESN))
@@ -602,7 +607,7 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	}
 
 	if (sg != dsg)
-		esp_ssg_unref(x, tmp, skb);
+		esp_ssg_unref(x, tmp, skb, false);
 
 	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 		err = esp_output_tail_tcp(x, skb);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 57481e423e59e6..296b57926abb98 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -113,7 +113,7 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 			     __alignof__(struct scatterlist));
 }
 
-static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
+static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb, bool already_unref)
 {
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
@@ -130,10 +130,13 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	/* Unref skb_frag_pages in the src scatterlist if necessary.
 	 * Skip the first sg which comes from skb->data.
 	 */
-	if (req->src != req->dst)
-		for (sg = sg_next(req->src); sg; sg = sg_next(sg))
+	if (already_unref || req->src != req->dst) {
+		struct scatterlist *src = already_unref ? esp_req_sg(aead, req) : req->src;
+
+		for (sg = sg_next(src); sg; sg = sg_next(sg))
 			skb_page_unref(page_to_netmem(sg_page(sg)),
 				       skb->pp_recycle);
+	}
 }
 
 #ifdef CONFIG_INET6_ESPINTCP
@@ -254,7 +257,7 @@ static void esp_output_done(void *data, int err)
 	}
 
 	tmp = ESP_SKB_CB(skb)->tmp;
-	esp_ssg_unref(x, tmp, skb);
+	esp_ssg_unref(x, tmp, skb, false);
 	kfree(tmp);
 
 	esp_output_encap_csum(skb);
@@ -600,8 +603,10 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 		err = skb_to_sgvec(skb, dsg,
 			           (unsigned char *)esph - skb->data,
 			           assoclen + ivlen + esp->clen + alen);
-		if (unlikely(err < 0))
+		if (unlikely(err < 0)) {
+			esp_ssg_unref(x, tmp, skb, true);
 			goto error_free;
+		}
 	}
 
 	if ((x->props.flags & XFRM_STATE_ESN))
@@ -634,7 +639,7 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	}
 
 	if (sg != dsg)
-		esp_ssg_unref(x, tmp, skb);
+		esp_ssg_unref(x, tmp, skb, false);
 
 	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 		err = esp_output_tail_tcp(x, skb);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA093101A6;
	Sun,  7 Jun 2026 10:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826749; cv=none; b=Z8qx2/y/iFJqjcgxR4mwG5Wy6kMwVbhZNGBn5I3m60EMYr76RsriarAHwqeZDNtBimE89H+0cJ4Ib+A5VVwN1c16hMpxOYD9SeCJ71UC8Yj/8LPlMLFoCxphmaivQOBpfxVwoe7pPi/MLFTJP4wDm7fANGLksnPkQYyNrL0nEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826749; c=relaxed/simple;
	bh=OazCAWbRiAVS43dgjaT3w9pPUW4FujXBag5g3LnlGeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl569mi9Cgsy2Lp4v3vmTVm8YSyVC7XrHWon5iK7Ic+LekrDIFbD8NVA0q1pTYTpO2DxuRwQzlk0hNQlbkzaeRkGPax7okjFn02wc4vGthdmkVPOa4EWwQxacJwkwZ6ARHx21OsPE04HiL7S9ZNxXcMSX+TrrHoduoSv8MK61Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUMabSPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUMabSPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ADD1F00893;
	Sun,  7 Jun 2026 10:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826746;
	bh=MwdvGBf7Sgibsn5vg5mWG2pyHXY3pZT9y4IupFa3A94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUMabSPYGjGP9PadY8A45HtgCdEZzpbAgEGUFGu1Eg4CV2RatDDLfnPhjSsMLCc4r
	 RlQlT1t6+oPNuxWR5UVb6BRzgI7q+/zrwSzl+OlriDL6pfbVTiWKqVywK2Z20UZCZq
	 M5OpjQrsBWy5xt8bVDq1Cki+h1IjN0HDa5andizE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Schino <7991aleschino@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 016/332] esp: fix page frag reference leak on skb_to_sgvec failure
Date: Sun,  7 Jun 2026 11:56:25 +0200
Message-ID: <20260607095728.644422375@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: e521588 <alessandro.schino@sbb.ch>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 12 +++++++-----
 net/ipv6/esp6.c | 12 +++++++-----
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 6a5febbdbee493..8314d7bddcb715 100644
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
@@ -113,7 +113,7 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	/* Unref skb_frag_pages in the src scatterlist if necessary.
 	 * Skip the first sg which comes from skb->data.
 	 */
-	if (req->src != req->dst)
+	if (already_unref || req->src != req->dst)
 		for (sg = sg_next(req->src); sg; sg = sg_next(sg))
 			skb_page_unref(page_to_netmem(sg_page(sg)),
 				       skb->pp_recycle);
@@ -220,7 +220,7 @@ static void esp_output_done(void *data, int err)
 	}
 
 	tmp = ESP_SKB_CB(skb)->tmp;
-	esp_ssg_unref(x, tmp, skb);
+	esp_ssg_unref(x, tmp, skb, false);
 	kfree(tmp);
 
 	if (xo && (xo->flags & XFRM_DEV_RESUME)) {
@@ -569,8 +569,10 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
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
@@ -602,7 +604,7 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	}
 
 	if (sg != dsg)
-		esp_ssg_unref(x, tmp, skb);
+		esp_ssg_unref(x, tmp, skb, false);
 
 	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 		err = esp_output_tail_tcp(x, skb);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 9c06c5a1419dc4..9d0c4957ac6276 100644
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
@@ -130,7 +130,7 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	/* Unref skb_frag_pages in the src scatterlist if necessary.
 	 * Skip the first sg which comes from skb->data.
 	 */
-	if (req->src != req->dst)
+	if (already_unref || req->src != req->dst)
 		for (sg = sg_next(req->src); sg; sg = sg_next(sg))
 			skb_page_unref(page_to_netmem(sg_page(sg)),
 				       skb->pp_recycle);
@@ -254,7 +254,7 @@ static void esp_output_done(void *data, int err)
 	}
 
 	tmp = ESP_SKB_CB(skb)->tmp;
-	esp_ssg_unref(x, tmp, skb);
+	esp_ssg_unref(x, tmp, skb, false);
 	kfree(tmp);
 
 	esp_output_encap_csum(skb);
@@ -600,8 +600,10 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
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
@@ -634,7 +636,7 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	}
 
 	if (sg != dsg)
-		esp_ssg_unref(x, tmp, skb);
+		esp_ssg_unref(x, tmp, skb, false);
 
 	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 		err = esp_output_tail_tcp(x, skb);
-- 
2.53.0




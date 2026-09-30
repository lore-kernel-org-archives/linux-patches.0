Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAD4D7D26;
	Wed, 30 Sep 2026 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785751; cv=none; b=iCYdBq3OxLs4y041m+I3ZojflhDtHzL1PaQRcJBTC3mO1tnLgv1etbRz0wcdxgaj0OGcYDYryvdmmoXQq8HCumdWiz5bF/6KRDcrn4DdqF4ZRSoYKOhmp4LcbczSJEZZoY9CbNyF2rZltsarbkh4IuHXtkjl1Ptr6U8h3e3HXt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785751; c=relaxed/simple;
	bh=MxDC2/9EAEu1u61+XEOJoSk/fXtiIyS/BRmEBBaerPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlMbN/4Z0UoL2ua0D4OyaOxiUjrhhP/k9i2iXg6luiYlOUVKlrOA5BsUyGhbEZaquFy7+nPtVvC+vaSPyBLvmTQ3kdguryrMi3WKd3kXzEif9MHnDbCGj+p2BEGEB9Tjws2zPdUAXOi0DXSB265kOSooZTL1834vCSjUxDjiXWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEBDprEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEBDprEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D2B1F000FF;
	Wed, 30 Sep 2026 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785750;
	bh=E/uVDw+Q4cF+XuFZ4jRJR9joi2HFEpbKiSS4DvE8p2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEBDprEz+cauU4L+dyV710skLpLAI6tL+dLXxg4ZI0qp7KEK1YXe29plciw5tnT6h
	 eLuBwVRwLwpWxWD6iQCs3oqAOuGM/2rywZOfJEWS7ZL8pR0phH7P/eVEw7V2atXH1w
	 Vn8kJyf347INYd0Vt1Eh99lhoMlMtPi0TVCUm3V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Azzouzi <maherazz04@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 592/982] esp: downgrade zerocopy managed frags before mutating skb frags
Date: Wed, 30 Sep 2026 17:22:08 +0200
Message-ID: <20260930152429.501423472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Maher Azzouzi <maherazz04@gmail.com>

[ Upstream commit f89416eb3db151170a6f3c6dfc5239d26cdce4d2 ]

On the out-of-place output path (esp->inplace == false) ESP rewrites the
skb frag array: esp_output_head() appends a trailer frag and
esp_output_tail() replaces the frags with a destination page, both
referenced with get_page().

When the skb carries zerocopy managed frags (SKBFL_MANAGED_FRAG_REFS) the
payload frags are owned by the ubuf and must not be referenced or
unreferenced individually, but ESP mutates the frag array without ever
downgrading the skb.  This breaks the managed-frag invariant two ways:

  - esp_ssg_unref() walks the source scatterlist and drops a page
    reference for every frag, including the ubuf-owned payload frags,
    pushing their refcount below the GUP pin bias while the pages are
    still pinned, i.e. a use-after-free of the zerocopy pages;

  - esp_output_tail() installs its destination page as frag 0 with
    get_page() but leaves SKBFL_MANAGED_FRAG_REFS set, so
    skb_release_data() takes the skip_unref branch and never drops that
    reference, leaking the x->xfrag page at packet rate.

Fix this the way every other frag-mutating site does (__ip_append_data(),
__ip6_append_data(), tcp_sendmsg_locked()) and call
skb_zcopy_downgrade_managed() before ESP touches the frag array: it takes
a real reference on each existing frag and clears SKBFL_MANAGED_FRAG_REFS,
so the per-frag unref in esp_ssg_unref() and the frag release in
skb_release_data() are both balanced and no mixed-ownership frag array is
left behind.

Fixes: 753f1ca4e1e5 ("net: introduce managed frags infrastructure")
Signed-off-by: Maher Azzouzi <maherazz04@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 6 ++++++
 net/ipv6/esp6.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index aa1178f627552..09c2efa3a5b10 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -438,6 +438,12 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 
 			esp->inplace = false;
 
+			/* Take real page refs and clear SKBFL_MANAGED_FRAG_REFS before
+			 * we mutate the frag array, so the per-frag unref stays balanced
+			 * for zerocopy managed frags (see __ip_append_data()).
+			 */
+			skb_zcopy_downgrade_managed(skb);
+
 			allocsize = ALIGN(tailen, L1_CACHE_BYTES);
 
 			spin_lock_bh(&x->lock);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 312e4307ce0d5..d404f7bec268c 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -473,6 +473,12 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 
 			esp->inplace = false;
 
+			/* Take real page refs and clear SKBFL_MANAGED_FRAG_REFS before
+			 * we mutate the frag array, so the per-frag unref stays balanced
+			 * for zerocopy managed frags (see __ip_append_data()).
+			 */
+			skb_zcopy_downgrade_managed(skb);
+
 			allocsize = ALIGN(tailen, L1_CACHE_BYTES);
 
 			spin_lock_bh(&x->lock);
-- 
2.53.0




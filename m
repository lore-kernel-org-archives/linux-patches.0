Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E5B1FC101;
	Mon, 23 Mar 2026 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275443; cv=none; b=sT1uZ2pEkcGWfOvVKVKEjGTp64eLgjUsUckwI6J+VIoVcVVvZf+HqmXHTfqJx+P8uPzc7OpReUok2LnX8mjNY0c+Wyratw002KRLFdKmE2HHJ+z9Fal/OyO7v5606FgAm7MuuBONxUFaWw90qIehRkbTA505kwayuJKvFw1HbTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275443; c=relaxed/simple;
	bh=p9qyvMMMB6a5OXUbuVJLh2HOqB9x6rfR9citvsgrMLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzttQ55kBf2FgsDGFJ7iQuvRIv78H+VZ/vFwJKi9f7NQlUuF1S27jA5RHtP5UtFCLZfhmtK0Dg6e7sTTpBVlHEZyx+GgjxNeCdbKfOs1vMvtctkli46laSe71OvYzDpwg8ngtGd7ks/zLrHMhPUfbb0wFScVlL/cBVGJB362/qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6vmJPK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6vmJPK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFB1C4CEF7;
	Mon, 23 Mar 2026 14:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275443;
	bh=p9qyvMMMB6a5OXUbuVJLh2HOqB9x6rfR9citvsgrMLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6vmJPK3duFCDyech11yqAUpSw+fAsOzro92/DCE/QGoq249iuLidUl6cxvNbg4Hg
	 emIvh1RaCg6YKS00ONBHcGDfeXS+JGAZ+gt4Zi53CD7rOcfMdpWvZbrFGf6wzvsgPZ
	 T3a/FPTDWN+1Rx3oOiPICcOypmOmJTTJZ1o3/110=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/460] xdp: allow attaching already registered memory model to xdp_rxq_info
Date: Mon, 23 Mar 2026 14:40:55 +0100
Message-ID: <20260323134528.160716141@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit f65966fe0178c06065d354c22fb456fc4370b527 ]

One may need to register memory model separately from xdp_rxq_info. One
simple example may be XDP test run code, but in general, it might be
useful when memory model registering is managed by one layer and then
XDP RxQ info by a different one.
Allow such scenarios by adding a simple helper which "attaches"
already registered memory model to the desired xdp_rxq_info. As this
is mostly needed for Page Pool, add a special function to do that for
a &page_pool pointer.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20241203173733.3181246-5-aleksander.lobakin@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp.h | 32 +++++++++++++++++++++++++++
 net/core/xdp.c    | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index b80953f0affb0..05be2de2fd472 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -356,6 +356,38 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq);
 int xdp_reg_mem_model(struct xdp_mem_info *mem,
 		      enum xdp_mem_type type, void *allocator);
 void xdp_unreg_mem_model(struct xdp_mem_info *mem);
+int xdp_reg_page_pool(struct page_pool *pool);
+void xdp_unreg_page_pool(const struct page_pool *pool);
+void xdp_rxq_info_attach_page_pool(struct xdp_rxq_info *xdp_rxq,
+				   const struct page_pool *pool);
+
+/**
+ * xdp_rxq_info_attach_mem_model - attach registered mem info to RxQ info
+ * @xdp_rxq: XDP RxQ info to attach the memory info to
+ * @mem: already registered memory info
+ *
+ * If the driver registers its memory providers manually, it must use this
+ * function instead of xdp_rxq_info_reg_mem_model().
+ */
+static inline void
+xdp_rxq_info_attach_mem_model(struct xdp_rxq_info *xdp_rxq,
+			      const struct xdp_mem_info *mem)
+{
+	xdp_rxq->mem = *mem;
+}
+
+/**
+ * xdp_rxq_info_detach_mem_model - detach registered mem info from RxQ info
+ * @xdp_rxq: XDP RxQ info to detach the memory info from
+ *
+ * If the driver registers its memory providers manually and then attaches it
+ * via xdp_rxq_info_attach_mem_model(), it must call this function before
+ * xdp_rxq_info_unreg().
+ */
+static inline void xdp_rxq_info_detach_mem_model(struct xdp_rxq_info *xdp_rxq)
+{
+	xdp_rxq->mem = (struct xdp_mem_info){ };
+}
 
 /* Drivers not supporting XDP metadata can use this helper, which
  * rejects any room expansion for metadata as a result.
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 23e7d736718b0..8a3ea90e8cf97 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -365,6 +365,62 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 
+/**
+ * xdp_reg_page_pool - register &page_pool as a memory provider for XDP
+ * @pool: &page_pool to register
+ *
+ * Can be used to register pools manually without connecting to any XDP RxQ
+ * info, so that the XDP layer will be aware of them. Then, they can be
+ * attached to an RxQ info manually via xdp_rxq_info_attach_page_pool().
+ *
+ * Return: %0 on success, -errno on error.
+ */
+int xdp_reg_page_pool(struct page_pool *pool)
+{
+	struct xdp_mem_info mem;
+
+	return xdp_reg_mem_model(&mem, MEM_TYPE_PAGE_POOL, pool);
+}
+EXPORT_SYMBOL_GPL(xdp_reg_page_pool);
+
+/**
+ * xdp_unreg_page_pool - unregister &page_pool from the memory providers list
+ * @pool: &page_pool to unregister
+ *
+ * A shorthand for manual unregistering page pools. If the pool was previously
+ * attached to an RxQ info, it must be detached first.
+ */
+void xdp_unreg_page_pool(const struct page_pool *pool)
+{
+	struct xdp_mem_info mem = {
+		.type	= MEM_TYPE_PAGE_POOL,
+		.id	= pool->xdp_mem_id,
+	};
+
+	xdp_unreg_mem_model(&mem);
+}
+EXPORT_SYMBOL_GPL(xdp_unreg_page_pool);
+
+/**
+ * xdp_rxq_info_attach_page_pool - attach registered pool to RxQ info
+ * @xdp_rxq: XDP RxQ info to attach the pool to
+ * @pool: pool to attach
+ *
+ * If the pool was registered manually, this function must be called instead
+ * of xdp_rxq_info_reg_mem_model() to connect it to the RxQ info.
+ */
+void xdp_rxq_info_attach_page_pool(struct xdp_rxq_info *xdp_rxq,
+				   const struct page_pool *pool)
+{
+	struct xdp_mem_info mem = {
+		.type	= MEM_TYPE_PAGE_POOL,
+		.id	= pool->xdp_mem_id,
+	};
+
+	xdp_rxq_info_attach_mem_model(xdp_rxq, &mem);
+}
+EXPORT_SYMBOL_GPL(xdp_rxq_info_attach_page_pool);
+
 /* XDP RX runs under NAPI protection, and in different delivery error
  * scenarios (e.g. queue full), it is possible to return the xdp_frame
  * while still leveraging this protection.  The @napi_direct boolean
-- 
2.51.0




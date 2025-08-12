Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85482FF14E;
	Tue, 12 Aug 2025 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025004; cv=none; b=Jwfv7ymQ+P59x9fybj456maNTnXZADLLgYuNXiqYaYBCULMyTJKbsXcPg26AmvjnEx+tuhv5L6FSz/dYmT9UePAgmHC0Z3Xu9z0e+TKuRy5Wy8w0bdOsaxHWv53Va+f4REPlTaStRe+yCsrva/75vaFl3i7sS6+n+cfNeK6S/VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025004; c=relaxed/simple;
	bh=HDdhz/gat4YrkffH1yuokcfZyWxKTg53Vc4xrm7PeBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3kS1vyPesrlWcXpR3VPa8XRcpZTzUzScnDwIx7tbLtVfNhzAANwq/q12vdVnYvA5sEBfKULkotQaplLoyMwKQdQAA9wUhxd38U121LBIjSe8muIfXQlgq8jc5ca9kTxLe2FFUT/SOAZIdHBHUr3MrZF2qL2LtQe+WfTBfZVbyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t57tWxh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t57tWxh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD4EC4CEF0;
	Tue, 12 Aug 2025 18:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025004;
	bh=HDdhz/gat4YrkffH1yuokcfZyWxKTg53Vc4xrm7PeBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t57tWxh8+ZjnwhBuAxp+dClF+D3iRkSGqiyGdurBI0Rfouk4d36Ruk/yFiSyPkjQa
	 U3a8jAwcCRnwc0vKi5IdDN9Qgf3Odv8gNlNMOXZlKEyZV2Ev9MoU1aEsrCTTjfbefp
	 U4IgAJ15pKLQ1KLJsCelzLrwylEypwGlNz0WJapk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 542/627] net: devmem: fix DMA direction on unmapping
Date: Tue, 12 Aug 2025 19:33:57 +0200
Message-ID: <20250812173452.522383540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fa516c0d8bf90da9d5b168757162205aafe5d0e1 ]

Looks like we always unmap the DMA_BUF with DMA_FROM_DEVICE direction.
While at it unexport __net_devmem_dmabuf_binding_free(), it's internal.

Found by code inspection.

Fixes: bd61848900bf ("net: devmem: Implement TX path")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250801011335.2267515-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devmem.c | 6 +++---
 net/core/devmem.h | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index b3a62ca0df65..24c591ab38ae 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -70,14 +70,13 @@ void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
 		gen_pool_destroy(binding->chunk_pool);
 
 	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
-					  DMA_FROM_DEVICE);
+					  binding->direction);
 	dma_buf_detach(binding->dmabuf, binding->attachment);
 	dma_buf_put(binding->dmabuf);
 	xa_destroy(&binding->bound_rxqs);
 	kvfree(binding->tx_vec);
 	kfree(binding);
 }
-EXPORT_SYMBOL(__net_devmem_dmabuf_binding_free);
 
 struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
@@ -208,6 +207,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 	mutex_init(&binding->lock);
 
 	binding->dmabuf = dmabuf;
+	binding->direction = direction;
 
 	binding->attachment = dma_buf_attach(binding->dmabuf, dev->dev.parent);
 	if (IS_ERR(binding->attachment)) {
@@ -312,7 +312,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 	kvfree(binding->tx_vec);
 err_unmap:
 	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
-					  DMA_FROM_DEVICE);
+					  direction);
 err_detach:
 	dma_buf_detach(dmabuf, binding->attachment);
 err_free_binding:
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 0a3b28ba5c13..41cd6e1c9141 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -56,6 +56,9 @@ struct net_devmem_dmabuf_binding {
 	 */
 	u32 id;
 
+	/* DMA direction, FROM_DEVICE for Rx binding, TO_DEVICE for Tx. */
+	enum dma_data_direction direction;
+
 	/* Array of net_iov pointers for this binding, sorted by virtual
 	 * address. This array is convenient to map the virtual addresses to
 	 * net_iovs in the TX path.
@@ -165,10 +168,6 @@ static inline void net_devmem_put_net_iov(struct net_iov *niov)
 {
 }
 
-static inline void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
-{
-}
-
 static inline struct net_devmem_dmabuf_binding *
 net_devmem_bind_dmabuf(struct net_device *dev,
 		       enum dma_data_direction direction,
-- 
2.39.5




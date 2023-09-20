Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6A31D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB7FC433C7;
	Wed, 20 Sep 2023 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211044;
	bh=qgU9PjwEj9cTkaktt73IxmiWjYW7eF2+30kpvRFT/FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SMrOS6nzrgIMBhzZnCO+Cn7g8IZ9Kh+ZVFf3knaGHBK210HoRMpMXAPdB4haRGDn
	 yalXqvn2/emsYGfzatWJ/tlUfZxETN0fJMlVoKTVbQAm9HNMgO1s8yoQSInYSQHF75
	 nPpc+E3i0Br3Fk1yphn2oc/8mFrVBAZJgnDSy/ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/139] dma-buf: Add unlocked variant of attachment-mapping functions
Date: Wed, 20 Sep 2023 13:30:22 +0200
Message-ID: <20230920112838.903693721@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 19d6634d8789573a9212ce78dbb4348ffd4f7f78 ]

Add unlocked variant of dma_buf_map/unmap_attachment() that will
be used by drivers that don't take the reservation lock explicitly.

Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221017172229.42269-3-dmitry.osipenko@collabora.com
Stable-dep-of: a2cb9cd6a394 ("misc: fastrpc: Fix incorrect DMA mapping unmap request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 53 +++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   |  6 +++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index eb6b59363c4f5..3d58514d04826 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1105,6 +1105,34 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment, DMA_BUF);
 
+/**
+ * dma_buf_map_attachment_unlocked - Returns the scatterlist table of the attachment;
+ * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
+ * dma_buf_ops.
+ * @attach:	[in]	attachment whose scatterlist is to be returned
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * Unlocked variant of dma_buf_map_attachment().
+ */
+struct sg_table *
+dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
+				enum dma_data_direction direction)
+{
+	struct sg_table *sg_table;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	dma_resv_lock(attach->dmabuf->resv, NULL);
+	sg_table = dma_buf_map_attachment(attach, direction);
+	dma_resv_unlock(attach->dmabuf->resv);
+
+	return sg_table;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment_unlocked, DMA_BUF);
+
 /**
  * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
  * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
@@ -1141,6 +1169,31 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment, DMA_BUF);
 
+/**
+ * dma_buf_unmap_attachment_unlocked - unmaps and decreases usecount of the buffer;might
+ * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
+ * dma_buf_ops.
+ * @attach:	[in]	attachment to unmap buffer from
+ * @sg_table:	[in]	scatterlist info of the buffer to unmap
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * Unlocked variant of dma_buf_unmap_attachment().
+ */
+void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
+				       struct sg_table *sg_table,
+				       enum dma_data_direction direction)
+{
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
+		return;
+
+	dma_resv_lock(attach->dmabuf->resv, NULL);
+	dma_buf_unmap_attachment(attach, sg_table, direction);
+	dma_resv_unlock(attach->dmabuf->resv);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, DMA_BUF);
+
 /**
  * dma_buf_move_notify - notify attachments that DMA-buf is moving
  *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 71731796c8c3a..9c31f1f430d8e 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -627,6 +627,12 @@ int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
 			   enum dma_data_direction dir);
+struct sg_table *
+dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
+				enum dma_data_direction direction);
+void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
+				       struct sg_table *sg_table,
+				       enum dma_data_direction direction);
 
 int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
-- 
2.40.1




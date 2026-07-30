Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913483750CF;
	Thu, 30 Jul 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423456; cv=none; b=dTQqIOnM3KEeTHu0r8Oq56ccl1R2dkJlNID2LuFeAoTHqQNUrgSoQyW87zgA4pQkR3UNRLFtDk8swxf7pvQyO7hR8KPvH3Hv1C6JpKl2Z4U++66QSnnPJxpjWQfzl5iUCkcc5rKU+0HuqpfhyrnHMFm5wk94WuOZAyEMjJIxc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423456; c=relaxed/simple;
	bh=+cvcXFEt+N+z1nZJpUFpww2BIRRyp52coCqq9RPfd+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+uecIMWXhYBP9LkYWWblwI/QwaoXOAg4Ekm8l2bCVJLsVfkdaRTaR8/JS8h35wsf8gzeBccfWAcsRtXmHH4wC9mcTMykFdZ/D9GTvwXEEXyRJbfetm1m+bXawfdoGy3pmkSfDMhH5T6qWecG5tGxd1OCqx1uj1E0eZwsRetr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdPB9gYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdPB9gYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4451F000E9;
	Thu, 30 Jul 2026 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423455;
	bh=FOuoZX3NO+GsyhowI/iUhDsXcNgvNkg6ehQgigfcTfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdPB9gYtu3C6IdsnFJ7poISE71pPEJekwc2VlqMzFaYLK9BWmY89e79WPsHsQXmZR
	 CogLc3GlYKF6PeKkVtgcN9M1eBekTTHEMd0PA0X7vxxqxlkwZ/STUXIiJlzksI53W6
	 3+7R0lYircKOHnJ0fV2M7IER+1qAIPO5GhRj3HJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/675] RDMA/umem: Add pinned revocable dmabuf import interface
Date: Thu, 30 Jul 2026 16:06:20 +0200
Message-ID: <20260730141446.181624256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit ff85a2ebacbdaec9f28c4660c991295ace93cd1c ]

Added an interface for importing a pinned but revocable dmabuf.
This interface can be used by drivers that are capable of revocation
so that they can import dmabufs from exporters that may require it,
such as VFIO.

This interface implements a two step process, where drivers will first
call ib_umem_dmabuf_get_pinned_revocable_and_lock() which will pin and
map the dmabuf (and provide a functional move_notify/invalidate_mappings
callback), but will return with the lock still held so that the
driver can then populate the callback via
ib_umem_dmabuf_set_revoke_locked() without races from concurrent
revocations. This scheme also allows for easier integration with drivers
that may not have actually allocated their internal MR objects at the time
of the get_pinned_revocable* call.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260305170826.3803155-4-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a846aecb931b ("RDMA/irdma: Prevent rereg_mr for non-mem regions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_dmabuf.c | 61 +++++++++++++++++++++++++++
 include/rdma/ib_umem.h                | 19 +++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index b239ac09ec2921..4fc73f53342b7e 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -206,6 +206,10 @@ static void ib_umem_dmabuf_revoke_locked(struct dma_buf_attachment *attach)
 
 	if (umem_dmabuf->revoked)
 		return;
+
+	if (umem_dmabuf->pinned_revoke)
+		umem_dmabuf->pinned_revoke(umem_dmabuf->private);
+
 	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
 	if (umem_dmabuf->pinned) {
 		dma_buf_unpin(umem_dmabuf->attach);
@@ -214,6 +218,11 @@ static void ib_umem_dmabuf_revoke_locked(struct dma_buf_attachment *attach)
 	umem_dmabuf->revoked = 1;
 }
 
+static struct dma_buf_attach_ops ib_umem_dmabuf_attach_pinned_revocable_ops = {
+	.allow_peer2peer = true,
+	.move_notify = ib_umem_dmabuf_revoke_locked,
+};
+
 static struct ib_umem_dmabuf *
 ib_umem_dmabuf_get_pinned_and_lock(struct ib_device *device,
 				   struct device *dma_device,
@@ -266,6 +275,58 @@ ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned_with_dma_device);
 
+/**
+ * ib_umem_dmabuf_get_pinned_revocable_and_lock - Map & pin a revocable dmabuf
+ * @device: IB device.
+ * @offset: Start offset.
+ * @size: Length.
+ * @fd: dmabuf fd.
+ * @access: Access flags.
+ *
+ * Obtains a umem from a dmabuf for drivers/devices that can support revocation.
+ *
+ * Returns with dma_resv_lock held upon success. The driver must set the revoke
+ * callback prior to unlock by calling ib_umem_dmabuf_set_revoke_locked().
+ *
+ * When a revocation occurs, the revoke callback will be called. The driver must
+ * ensure that the region is no longer accessed when the callback returns. Any
+ * subsequent access attempts should also probably cause an AE for MRs.
+ *
+ * If the umem is used for an MR, the driver must ensure that the key remains in
+ * use such that it cannot be obtained by a new region until this region is
+ * fully deregistered (i.e., ibv_dereg_mr). If a driver needs to serialize with
+ * revoke calls, it can use dma_resv_lock.
+ *
+ * If successful, then the revoke callback may be called at any time and will
+ * also be called automatically upon ib_umem_release (serialized). The revoke
+ * callback will be called one time at most.
+ *
+ * Return: A pointer to ib_umem_dmabuf on success, or an ERR_PTR on failure.
+ */
+struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_revocable_and_lock(struct ib_device *device,
+					     unsigned long offset, size_t size,
+					     int fd, int access)
+{
+	const struct dma_buf_attach_ops *ops =
+		&ib_umem_dmabuf_attach_pinned_revocable_ops;
+
+	return ib_umem_dmabuf_get_pinned_and_lock(device, device->dma_device,
+						  offset, size, fd, access,
+						  ops);
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned_revocable_and_lock);
+
+void ib_umem_dmabuf_set_revoke_locked(struct ib_umem_dmabuf *umem_dmabuf,
+				      void (*revoke)(void *priv), void *priv)
+{
+	dma_resv_assert_held(umem_dmabuf->attach->dmabuf->resv);
+
+	umem_dmabuf->pinned_revoke = revoke;
+	umem_dmabuf->private = priv;
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_set_revoke_locked);
+
 struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
 						 unsigned long offset,
 						 size_t size, int fd,
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 5122f78467675e..90b1ea19a90a0a 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -36,6 +36,7 @@ struct ib_umem_dmabuf {
 	struct scatterlist *last_sg;
 	unsigned long first_sg_offset;
 	unsigned long last_sg_trim;
+	void (*pinned_revoke)(void *priv);
 	void *private;
 	u8 pinned : 1;
 	u8 revoked : 1;
@@ -141,6 +142,12 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
 						 size_t size, int fd,
 						 int access);
 struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_revocable_and_lock(struct ib_device *device,
+					     unsigned long offset, size_t size,
+					     int fd, int access);
+void ib_umem_dmabuf_set_revoke_locked(struct ib_umem_dmabuf *umem_dmabuf,
+				      void (*revoke)(void *priv), void *priv);
+struct ib_umem_dmabuf *
 ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 					  struct device *dma_device,
 					  unsigned long offset, size_t size,
@@ -201,6 +208,18 @@ ib_umem_dmabuf_get_pinned(struct ib_device *device, unsigned long offset,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_revocable_and_lock(struct ib_device *device,
+					     unsigned long offset, size_t size,
+					     int fd, int access)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void
+ib_umem_dmabuf_set_revoke_locked(struct ib_umem_dmabuf *umem_dmabuf,
+				 void (*revoke)(void *priv), void *priv) {}
+
 static inline struct ib_umem_dmabuf *
 ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 					  struct device *dma_device,
-- 
2.53.0




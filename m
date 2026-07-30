Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D11383983;
	Thu, 30 Jul 2026 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427199; cv=none; b=c4hUOvXtKmTZIoRxfHAcUUZtj6vv56XEeWH/r3reqNjYcPwz76qJThf1CpQe7WMpo6ZiJF41uB51upErpK2fyp0zKPqxIbQ2ANK50osspJcZJ5xr0s+F981Lf/zh5yd6zTpfOqpz7pKUchVqRlLjyN2rB8xAsc/8AA3IJEfaSrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427199; c=relaxed/simple;
	bh=6197rrAe8mfzr39kKF92eN3mtaLELgmFHh3LEBSTaoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6lEsQjq4tWDOjn3/TDxSTshgt+biN2ouQBAXCmTq5UWeV3oEvm1ufG/luagmzD6pFfaNGjYI9NgkOJssWMZ+cPHRS9oCuQEOHX+UPOTGLhmvRhUZ7MW0uN5FwQuExU6TcHXFnWgZOi6/dtNZCS9CZNDJLZSxvWZbN9RINtMFIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efXDC7iZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efXDC7iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5C81F000E9;
	Thu, 30 Jul 2026 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427197;
	bh=6C492zzMDuF0xN2ZiketovYfsOROxFOVnWN2JsHGrh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efXDC7iZXEEjbphh/sQhKLA+GZkgNEEBZVbOJfSIqJwftqFiS7BJ99KgWzSsVo7Hq
	 WbMJ6nFXh4OGPoBYiGtSXfHMVXWcZqma+DlqzOEUoliRJ1wjbkFvmPpI5Qnuzm12ki
	 sABjnY1TEBGtkUNH2dsBLieoP1+GFoWLM4MANzR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/484] RDMA/umem: Add pinned revocable dmabuf import interface
Date: Thu, 30 Jul 2026 16:08:58 +0200
Message-ID: <20260730141424.315682712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be5977daafa1de..091af1f7aa29db 100644
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
index 3ec9f1deca7db4..7637ff06bb5b10 100644
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
@@ -124,6 +125,12 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
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
@@ -178,6 +185,18 @@ ib_umem_dmabuf_get_pinned(struct ib_device *device, unsigned long offset,
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




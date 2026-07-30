Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54722374A0E;
	Thu, 30 Jul 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427139; cv=none; b=rvA3x+lmVwFpabQ7r/PwQtHYP5HjQjPvDsHyp1dg9tGR/Syt0w9+QP9BOp3/DLADMmopZyNqSztqZLG1bQezy0+I30q95prC+PmMC3WuYUgv0OotWZmHk6fr2TXpT/0QMJZ/NcinQMAJHG8mMklqszDQeDkfM36kZIGKIH986Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427139; c=relaxed/simple;
	bh=3bLBGCHcq5Ay4q25gph9sLJ30dniAsnirl3pnWAYr6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li7LuBbOKP5AmlN7aCK91VQKoLHGxmU6jmza/kmxmLW8RMJu0/msttECo3KOLEVS+Vtffeg57IMdtyt29pnLBaw6NJT6r54QzvbZ6MjcYBugE6KobdaCCW38Fc92cqyV9RcRUb+MSrvwqquBGtTAbtKZRcQ3F3fvVahfWyzpeQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjb3Au1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjb3Au1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A711F000E9;
	Thu, 30 Jul 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427138;
	bh=+4hFMxcz3daKg/rDLrLl1UQr9GPhhJNVFTUGksHRcVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tjb3Au1xlGjEUGrfd+JWNYFQ55lX1g7aQNjXYxKd3qgZ8aIRC8eqHAQvIXAU+5Gvv
	 giAgsUSs9aEe5LaQs1BjD0rVHXEywtlhp34DSg5abIDq7YBCqXJ0lNBHAmDNuXChMz
	 rEU4eTLeA2k7pqBBC0CAI4HRNEteCUChpOjgPJ9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/484] RDMA/umem: Introduce an option to revoke DMABUF umem
Date: Thu, 30 Jul 2026 16:08:55 +0200
Message-ID: <20260730141424.250270395@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 253c61dc256b3e6be65657f78b4a8452163ce00f ]

Introduce an option to revoke DMABUF umem.

This option will retain the umem allocation while revoking its DMA
mapping. Furthermore, any subsequent attempts to map the pages should
fail once the umem has been revoked.

This functionality will be utilized in the upcoming patches in the
series, where we aim to delay umem deallocation until the mkey
deregistration. However, we must unmap its pages immediately.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/a38270f2fe4a194868ca2312f4c1c760e51bcbff.1722512548.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a846aecb931b ("RDMA/irdma: Prevent rereg_mr for non-mem regions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_dmabuf.c | 21 +++++++++++++++++++--
 include/rdma/ib_umem.h                |  3 +++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 674a4b45e7bfe7..44bb7449738cf4 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -23,6 +23,9 @@ int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 
 	dma_resv_assert_held(umem_dmabuf->attach->dmabuf->resv);
 
+	if (umem_dmabuf->revoked)
+		return -EINVAL;
+
 	if (umem_dmabuf->sgt)
 		goto wait_fence;
 
@@ -240,15 +243,29 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned);
 
-void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf)
+void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf)
 {
 	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
 
 	dma_resv_lock(dmabuf->resv, NULL);
+	if (umem_dmabuf->revoked)
+		goto end;
 	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
-	if (umem_dmabuf->pinned)
+	if (umem_dmabuf->pinned) {
 		dma_buf_unpin(umem_dmabuf->attach);
+		umem_dmabuf->pinned = 0;
+	}
+	umem_dmabuf->revoked = 1;
+end:
 	dma_resv_unlock(dmabuf->resv);
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_revoke);
+
+void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf)
+{
+	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
+
+	ib_umem_dmabuf_revoke(umem_dmabuf);
 
 	dma_buf_detach(dmabuf, umem_dmabuf->attach);
 	dma_buf_put(dmabuf);
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 3441ba9f2a0daf..3ec9f1deca7db4 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -38,6 +38,7 @@ struct ib_umem_dmabuf {
 	unsigned long last_sg_trim;
 	void *private;
 	u8 pinned : 1;
+	u8 revoked : 1;
 };
 
 static inline struct ib_umem_dmabuf *to_ib_umem_dmabuf(struct ib_umem *umem)
@@ -130,6 +131,7 @@ ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf);
+void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf);
 
 int ib_umem_check_rereg(struct ib_umem *umem, int flags, int new_access_flags);
 
@@ -191,6 +193,7 @@ static inline int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 }
 static inline void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf) { }
 static inline void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf) { }
+static inline void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf) {}
 
 static inline int ib_umem_check_rereg(struct ib_umem *umem, int flags,
 				      int new_access_flags)
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DB02F745E;
	Tue, 16 Jun 2026 16:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627840; cv=none; b=QdjNkmiHvLcxM5bNEiHg0V+3dMANOuahvWhg969IW1mVdaWKaYuSlpLcB+L8bVgLacnpdfQ9rhz7gysZ3OjGLnewN0Zcre39DQqepkbQB0EQKsz1n5ZY5pLaMD0icsLAOBR+UmXFOj6mpLpTgL2j7Kn9PKU/c62V8N5jo0ubZBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627840; c=relaxed/simple;
	bh=Ty5b+v+B6KyxFfDsn2y8bshQ2A6/vcBM3NxiBV6IrIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEsa7Fr2al7dp6/Xs0P/rN2hym/cv7wjWr6us62pb+8N3IdxkZGLH/pXgGDaO8P9nr8b6SuIXJ8Zxr1WO8h8MLyP3FTXhMM9wrErUscoQGHEx20aWo5VGM1YHL8XsqpmE4oTJZEFZV5BbD6A6E/AEbdOppXmwSJTbY/l0DQOiT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkl15EEN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkl15EEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BF31F000E9;
	Tue, 16 Jun 2026 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627839;
	bh=MtuQXm9SIbwzgbGhWKH6+TezxsYd7n4apDlVaKQJdyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkl15EENywhOq10gJLLUIRTwGBtfnMIdjnmJLaCoShRqSnerEcqST1MAFUq32kEyl
	 7fvYVMGOp4azBjsYV2H+m47e6tQKqZ/ANfEd0EIVnEGjrn3AEmuUYkJRrvltcIATbZ
	 puUnEIeEP4cyZ+Yo0i+7VLxA5sUgRHLqaRvhX8iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/261] RDMA/umem: Move umem dmabuf revoke logic into helper function
Date: Tue, 16 Jun 2026 20:31:15 +0530
Message-ID: <20260616145056.050169143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 797291a66ce346c96114b72222fc290d402da005 ]

This same logic will eventually be reused from within the
invalidate_mappings callback which already has the dma_resv_lock
held, so break it out into a separate function so it can be reused.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260305170826.3803155-3-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: badad6fad60d ("RDMA: During rereg_mr ensure that REREG_ACCESS is compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/umem_dmabuf.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -198,6 +198,22 @@ static struct dma_buf_attach_ops ib_umem
 	.move_notify = ib_umem_dmabuf_unsupported_move_notify,
 };
 
+static void ib_umem_dmabuf_revoke_locked(struct dma_buf_attachment *attach)
+{
+	struct ib_umem_dmabuf *umem_dmabuf = attach->importer_priv;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (umem_dmabuf->revoked)
+		return;
+	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
+	if (umem_dmabuf->pinned) {
+		dma_buf_unpin(umem_dmabuf->attach);
+		umem_dmabuf->pinned = 0;
+	}
+	umem_dmabuf->revoked = 1;
+}
+
 static struct ib_umem_dmabuf *
 ib_umem_dmabuf_get_pinned_and_lock(struct ib_device *device,
 				   struct device *dma_device,
@@ -265,15 +281,7 @@ void ib_umem_dmabuf_revoke(struct ib_ume
 	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
 
 	dma_resv_lock(dmabuf->resv, NULL);
-	if (umem_dmabuf->revoked)
-		goto end;
-	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
-	if (umem_dmabuf->pinned) {
-		dma_buf_unpin(umem_dmabuf->attach);
-		umem_dmabuf->pinned = 0;
-	}
-	umem_dmabuf->revoked = 1;
-end:
+	ib_umem_dmabuf_revoke_locked(umem_dmabuf->attach);
 	dma_resv_unlock(dmabuf->resv);
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_revoke);



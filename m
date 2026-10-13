Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0B54F4CE6;
	Tue, 13 Oct 2026 12:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894081; cv=none; b=lTyH7w2/nNjBNmMLDDb5SY7EK+AQTrw3g0hBCcuucBcTIaDzKovDbWBON4Ft0Cwp5zvt4l+TeJ4uliMn6tsm0xySV4cTSzEy3wVTVEhl7v6xUiaMNa+PfQNNQyE3tV6QBG0HIFsT6xhPPHmBIh21NsvOnX524xES7h4iJW9wrJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894081; c=relaxed/simple;
	bh=bWRDcyDJozlZPN4qHDJWNh08TZMRtjdes2najvyZj3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1CFVHUyheUDx5H1bFZZCcMUJpA34+kBQMxnpLlGvjVI0GaZ+JBXyZFeT6YIi8NkIaG0S0e4947CXg6bD4DhgWFLZvJ2UqusaD8dNdsbs0HXAJis8lbvQylsCOYNj3z0Nx9IyTcFJ8RqGdfmhGsDJGT1gC2qYuG5dwid8l0fF/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qV+8SUYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qV+8SUYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7620E1F000FF;
	Tue, 13 Oct 2026 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894080;
	bh=ao2u+e9TWvoRBqkFpDhngMIrmCmJxM5687xq6Y3Lnmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qV+8SUYtqVlSKX9oRjzfcz4NmR/OAD5UboGqClhKOsHC0Nk/WKavXYyYgvzO09p+W
	 UJhDQg0/DgA/N9GWRxHWr6n1baAB90e5566H5ZqvkQ02AKMv0bP3KQB9UGIePLQmqj
	 a3drMAn/qDj9a8AwbAsoNApwCwwYcs+WMQ+LyIqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Krishna <saikrishnag@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/621] octeontx2-af: fix cn20k mailbox lifetime on repeated rvu_mbox_init()
Date: Tue, 13 Oct 2026 13:36:31 +0200
Message-ID: <20261013112930.240954969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Sai Krishna <saikrishnag@marvell.com>

[ Upstream commit 3b11a77f69980932c3924054d66e565c9a135747 ]

rvu_mbox_init() is called separately for AF-PF mailboxes during probe
and for AF-VF mailboxes when SR-IOV is enabled.  Each call used to
allocate a new ng_rvu object, leaking the first allocation when the
pointer was overwritten on the second call.

Sharing one ng_rvu across both paths exposed several teardown bugs:
the error path freed all cn20k mailbox DMA and kfree()d ng_rvu even
when only the failing init type should be unwound, leaving live AF-PF
mailbox memory in use after an AF-VF init failure.  mutex_init() was
also re-run on the AF-VF path while AF-PF mailbox handlers could still
hold rvu->mbox_lock.  Probe and SR-IOV failure paths did not release
cn20k mailbox DMA either, since cleanup only happened in rvu_remove().

Allocate ng_rvu once with devm_kzalloc(), initialize mbox_lock in the
same block, unwind only the mailbox memory for the failing init type,
and free cn20k mailbox DMA from the probe and pci_enable_sriov()
error paths.

Fixes: e53ee4acb220 ("octeontx2-af: CN20k basic mbox operations and structures")
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260821102337.2989169-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/cn20k/api.h |  1 +
 .../marvell/octeontx2/af/cn20k/mbox_init.c    | 21 +++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 39 +++++++++++--------
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/api.h b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/api.h
index 4285b5d6a6a29..f36a1d5f236f6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/api.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/api.h
@@ -21,6 +21,7 @@ int cn20k_rvu_mbox_init(struct rvu *rvu, int type, int num);
 int cn20k_rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
 			       int num, int type, unsigned long *pf_bmap);
 void cn20k_free_mbox_memory(struct rvu *rvu);
+void cn20k_free_mbox_memory_type(struct rvu *rvu, int type);
 int cn20k_register_afpf_mbox_intr(struct rvu *rvu);
 int cn20k_register_afvf_mbox_intr(struct rvu *rvu, int pf_vec_start);
 void cn20k_rvu_enable_mbox_intr(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/mbox_init.c b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/mbox_init.c
index bd3aab7770ddf..ded91a91bb3dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/mbox_init.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/mbox_init.c
@@ -335,13 +335,30 @@ int cn20k_rvu_mbox_init(struct rvu *rvu, int type, int ndevs)
 	return rvu_alloc_mbox_memory(rvu, type, ndevs, MBOX_SIZE);
 }
 
+void cn20k_free_mbox_memory_type(struct rvu *rvu, int type)
+{
+	if (!is_cn20k(rvu->pdev) || !rvu->ng_rvu)
+		return;
+
+	switch (type) {
+	case TYPE_AFPF:
+		qmem_free(rvu->dev, rvu->ng_rvu->pf_mbox_addr);
+		rvu->ng_rvu->pf_mbox_addr = NULL;
+		break;
+	case TYPE_AFVF:
+		qmem_free(rvu->dev, rvu->ng_rvu->vf_mbox_addr);
+		rvu->ng_rvu->vf_mbox_addr = NULL;
+		break;
+	}
+}
+
 void cn20k_free_mbox_memory(struct rvu *rvu)
 {
 	if (!is_cn20k(rvu->pdev))
 		return;
 
-	qmem_free(rvu->dev, rvu->ng_rvu->pf_mbox_addr);
-	qmem_free(rvu->dev, rvu->ng_rvu->vf_mbox_addr);
+	cn20k_free_mbox_memory_type(rvu, TYPE_AFPF);
+	cn20k_free_mbox_memory_type(rvu, TYPE_AFVF);
 }
 
 void cn20k_rvu_disable_afvf_intr(struct rvu *rvu, int vfs)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 0590313bcd81c..bf6440c55ea2e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2516,12 +2516,6 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 	if (!pf_bmap)
 		return -ENOMEM;
 
-	ng_rvu_mbox = kzalloc(sizeof(*ng_rvu_mbox), GFP_KERNEL);
-	if (!ng_rvu_mbox) {
-		err = -ENOMEM;
-		goto free_bitmap;
-	}
-
 	/* RVU VFs */
 	if (type == TYPE_AFVF)
 		bitmap_set(pf_bmap, 0, num);
@@ -2535,15 +2529,22 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		}
 	}
 
-	rvu->ng_rvu = ng_rvu_mbox;
+	if (!rvu->ng_rvu) {
+		ng_rvu_mbox = devm_kzalloc(rvu->dev, sizeof(*ng_rvu_mbox), GFP_KERNEL);
+		if (!ng_rvu_mbox) {
+			err = -ENOMEM;
+			goto free_bitmap;
+		}
+
+		rvu->ng_rvu = ng_rvu_mbox;
 
-	rvu->ng_rvu->rvu_mbox_ops = &rvu_mbox_ops;
+		rvu->ng_rvu->rvu_mbox_ops = &rvu_mbox_ops;
+		mutex_init(&rvu->mbox_lock);
+	}
 
 	err = cn20k_rvu_mbox_init(rvu, type, num);
 	if (err)
-		goto free_mem;
-
-	mutex_init(&rvu->mbox_lock);
+		goto free_bitmap;
 
 	mbox_regions = kcalloc(num, sizeof(void __iomem *), GFP_KERNEL);
 	if (!mbox_regions) {
@@ -2633,14 +2634,18 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 free_regions:
 	kfree(mbox_regions);
 free_qmem:
-	cn20k_free_mbox_memory(rvu);
-free_mem:
-	kfree(rvu->ng_rvu);
+	cn20k_free_mbox_memory_type(rvu, type);
 free_bitmap:
 	bitmap_free(pf_bmap);
 	return err;
 }
 
+static void rvu_free_cn20k_mbox_memory(struct rvu *rvu)
+{
+	if (is_cn20k(rvu->pdev))
+		cn20k_free_mbox_memory(rvu);
+}
+
 static void rvu_mbox_destroy(struct mbox_wq_info *mw)
 {
 	struct otx2_mbox *mbox = &mw->mbox;
@@ -3438,6 +3443,7 @@ static int rvu_enable_sriov(struct rvu *rvu)
 	if (err) {
 		rvu_disable_afvf_intr(rvu);
 		rvu_mbox_destroy(&rvu->afvf_wq_info);
+		cn20k_free_mbox_memory_type(rvu, TYPE_AFVF);
 		return err;
 	}
 
@@ -3590,6 +3596,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_mbox:
 	rvu_mbox_destroy(&rvu->afpf_wq_info);
 err_hwsetup:
+	rvu_free_cn20k_mbox_memory(rvu);
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
 	rvu_mcs_exit(rvu);
@@ -3631,9 +3638,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 
 	devm_kfree(&pdev->dev, rvu->hw);
-	if (is_cn20k(rvu->pdev))
-		cn20k_free_mbox_memory(rvu);
-	kfree(rvu->ng_rvu);
+	rvu_free_cn20k_mbox_memory(rvu);
 	devm_kfree(&pdev->dev, rvu);
 }
 
-- 
2.53.0




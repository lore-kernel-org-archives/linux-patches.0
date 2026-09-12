Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E02361960;
	Sat, 12 Sep 2026 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204475; cv=none; b=GS/s7gCNjXYRA221Rk284EPJsVxMP5Oiz+HTvhLWKKUP2uOMQZwpflF251toLFS1jruoVvH9KI/+xl3Zlor+qxRD+UUSF63wNinVVvJ+thY64oy/3FAbwOWrfPyO8fXxLeX2Y2MHufa8yhgboDCkz4TDeeGNyNhm9u123yhFLyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204475; c=relaxed/simple;
	bh=4F/68khy2jgJ44qWtYt6Efj9/aqXm3gvwmShi63WvNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AAxMsj3T55fxl8VlSaiLJFyInYoNFTKUc+8CilQL0oT4swfNdJppT8QJEe1+/I318wW9NbJn59VwkGUCRrpjMZu+Pl/AXnIQ9Vmt31Z3c+hcuVia13/QKGVWJjFWYshIxRQ0Pa5bgRU3tOrEeoa1gtRDH6dpws19EiLwKxyk8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B6s+Sds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B6s+Sds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEBA1F000FF;
	Sat, 12 Sep 2026 09:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204473;
	bh=a6fD7SulPtyEoutyOkDrB/1p0E5Wn4fgrxU1PcNbgYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2B6s+SdsJukg2mSlOaeXKk1QTQf9MFK7gib7WiJTS/1LSE8WUjvpf/K2DUUwYGkgw
	 EwSMi7GfGpBNyDShtV0mwLiKgUNTABMcl2lhcykeZtHnQAp3A9nIo2OhtBUfVFEDiJ
	 jEYJhYFj7Wx7ktiUjLh6UJ+qJDP+c7V4j8l5KbEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	=?UTF-8?q?Linfeng=20Sun=C2=A0?= <linfeng.sun.dev@gamil.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1620/1815] vdpa_sim: fix cleanup after worker creation failure
Date: Sat, 12 Sep 2026 08:56:10 +0200
Message-ID: <20260912065727.021391549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun  <linfeng.sun.dev@gamil.com>

[ Upstream commit bd670e5dfd2b01fd9692f61fa1456434c54026a4 ]

vdpasim_create() leaves vdpasim->worker as an ERR_PTR when
kthread_run_worker() fails. The error path then drops the device
reference, which releases the partially initialized simulator.

vdpasim_free() unconditionally passes the worker pointer to
kthread_destroy_worker(), so the ERR_PTR is dereferenced and can trigger
a general protection fault.

Store the worker error, clear the pointer, and only clean up the worker
when it was successfully initialized. Also make the release path tolerate
partially initialized objects by guarding virtqueue and IOTLB cleanup,
since the same release path can be reached from other initialization
failures.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 76acfa7bc54f ("vdpa_sim: use kthread worker")
Assisted-by: OpenAI-Codex:GPT-5
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gamil.com>
Message-ID: <20260620100959.2070316-1-slf@hdu.edu.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 4d116644851d9..c748fe4511635 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -233,8 +233,11 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
 	vdpasim->worker = kthread_run_worker(0, "vDPA sim worker: %s",
 						dev_attr->name);
-	if (IS_ERR(vdpasim->worker))
+	if (IS_ERR(vdpasim->worker)) {
+		ret = PTR_ERR(vdpasim->worker);
+		vdpasim->worker = NULL;
 		goto err_iommu;
+	}
 
 	mutex_init(&vdpasim->mutex);
 	spin_lock_init(&vdpasim->iommu_lock);
@@ -746,18 +749,24 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int i;
 
-	kthread_cancel_work_sync(&vdpasim->work);
-	kthread_destroy_worker(vdpasim->worker);
+	if (vdpasim->worker) {
+		kthread_cancel_work_sync(&vdpasim->work);
+		kthread_destroy_worker(vdpasim->worker);
+	}
 
-	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
-		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
-		vringh_kiov_cleanup(&vdpasim->vqs[i].in_iov);
+	if (vdpasim->vqs) {
+		for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
+			vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
+			vringh_kiov_cleanup(&vdpasim->vqs[i].in_iov);
+		}
 	}
 
 	vdpasim->dev_attr.free(vdpasim);
 
-	for (i = 0; i < vdpasim->dev_attr.nas; i++)
-		vhost_iotlb_reset(&vdpasim->iommu[i]);
+	if (vdpasim->iommu) {
+		for (i = 0; i < vdpasim->dev_attr.nas; i++)
+			vhost_iotlb_reset(&vdpasim->iommu[i]);
+	}
 	kfree(vdpasim->iommu);
 	kfree(vdpasim->iommu_pt);
 	kfree(vdpasim->vqs);
-- 
2.53.0




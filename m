Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037F63BADA3;
	Sat, 12 Sep 2026 11:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211944; cv=none; b=PUc2DFqYraTjaFNtf8ixVI+0GHZcsRiVRPlJh9fEY2z7t6vWGiFs1QlwxGGYZxFRCWathd9w0TCrOvIGp9FR+4NHROur3H7qSKLbtI/haUegnWJU9VUbiC8/+JUW/PjGI9yMqaDHYpyB6bgpTemUz/txgMFYj6E8AOgMW91X/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211944; c=relaxed/simple;
	bh=n7N9ikL7z44WSeOGGtWvbbhX1gulF+S/ZOla3uBIhIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnvJwtUtenP5/F+mev/hMF36yEVf9PhygwgVkIG4nWrjiEzqcjKkD0eeQWVrIZ0xzHqSYnHrvipSvV14O0flBjB9NhGC4EPfi8aEIMUjYVCHdC8fAc3OOlk1zzxy03MXnBEifONm46cCrPOE+nXG+0vGkssOq6NhA7eOz53spOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXydl7aD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXydl7aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7841F000FF;
	Sat, 12 Sep 2026 11:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211942;
	bh=BDoIo9sE+/vkVehVX94ffsdoCXnyDKSknOwEWlWeYOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXydl7aDX5NBBYV8B+z+ZRZfnJfEQa4nf9HUJ29g5cajvOubtik8wwO/G19XNKgfY
	 Qkyp7j3+Ndf4/c+4nu6H861yc9iAF/2VP0QIPvsW7XeHQhUVQ4Unlo3Mne64qsa5cL
	 Iw8MIZZBZ0dZ7PNme/bJE+trS65mBr9SK8b3IaXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	=?UTF-8?q?Linfeng=20Sun=C2=A0?= <linfeng.sun.dev@gamil.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1292/1518] vdpa_sim: fix cleanup after worker creation failure
Date: Sat, 12 Sep 2026 08:57:41 +0200
Message-ID: <20260912065652.743505439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index df9c7ddc5d782..445c45080d453 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -231,8 +231,11 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
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
@@ -744,18 +747,24 @@ static void vdpasim_free(struct vdpa_device *vdpa)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA343AC17;
	Sat, 12 Sep 2026 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225983; cv=none; b=tDjRsONsBdxf9qVcgMCMHFBwDR5cwdoYuO+FxrNijcVevU1Y87BMLWGracMaVZ7F7rloTZulC3bGO9nSyhxsSIH/4DJqemU1Fks2lmnYOVbty5+XdTmqfpRjODF6uOVLSuTFRlQS2ht89qjEJ4rcoo7YW4hxsBQ5Xz9ljC3ipUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225983; c=relaxed/simple;
	bh=eiWB0tc7w5riqxhKbm7StrT6GtzDK7RuwSm+yS6T3ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEJqafGRECkp15Y7VFIcVsrPFFAIOVijH30O2CYOc0hKedpGzCbWvF+NnTqbTrh/IiJViWrFNa3ya/JoCipbIMncoGRmXpcFgx/2OAGwyYdMyoQFIuDshqCPUqNN6hIy6P5e/QmfRNxPNf6rPhs8AL7fLi5R9LqwjNGJiyrRmzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ME1Gg/QO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ME1Gg/QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B131F000FF;
	Sat, 12 Sep 2026 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225981;
	bh=6gzdg5pvWA8lRLTcbehMlvOIJJJA6C4ECFNsMa1MPzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ME1Gg/QO/bJGGvXgfDQ/x/rWOLnvQ355zxhspCrWeCTIPmL38L/JnTmkM1GgD+W+R
	 +4IX1/vE5mccen5LfuG0SatlNfmxboewznGi7+it+Oc7jcsNEGeqpOM2er6oJAPP7z
	 8ROMbzpK23pdWX2VQK+LjPebZ87v8MZcgKI2oep0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	=?UTF-8?q?Linfeng=20Sun=C2=A0?= <linfeng.sun.dev@gamil.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1308/1424] vdpa_sim: fix cleanup after worker creation failure
Date: Sat, 12 Sep 2026 09:02:20 +0200
Message-ID: <20260912065636.555424115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 421ab01ef06ba..58cb711e981d3 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -229,8 +229,11 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
 	vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
 						dev_attr->name);
-	if (IS_ERR(vdpasim->worker))
+	if (IS_ERR(vdpasim->worker)) {
+		ret = PTR_ERR(vdpasim->worker);
+		vdpasim->worker = NULL;
 		goto err_iommu;
+	}
 
 	mutex_init(&vdpasim->mutex);
 	spin_lock_init(&vdpasim->iommu_lock);
@@ -709,18 +712,24 @@ static void vdpasim_free(struct vdpa_device *vdpa)
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




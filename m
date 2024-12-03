Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C211DE8A5;
	Tue,  3 Dec 2024 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241878; cv=none; b=kA9jOvsOE9ninxfcfGtC04YqX65Srmu4OQ/GlzHmSNmruL3vRp+qC1f7vmL5HGO7DUsNQYYADPxplXBwyj14eS2HE9X1CE7HzJzIa+7QLo66rEKlKSiariKXejT4sJuQjYl85p9nHyr3dmU4AbPK5ZoIXmiQoiXrIy/3+NzrQwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241878; c=relaxed/simple;
	bh=K4X/61PgwI7fJdet9Gn3GzPVNPHQZ/3siF7ARNCFSQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n45rvCRTBRXSIrAcC2E4mPBVtTOQUz8Zke00PxS0ICnGSJ+xuQ8VAAHxsGSSTm+2+4bsfP5hQmqGtOq5ltF6sO9dHI0lOUw4HwLK4TxE+PiUuUV5rSCvy3/i0PxRy/uL2V8Z9yKTKvovLGNQ3EYWshEMncMJc9NXSmrSJMRTHiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bunTEEOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bunTEEOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7443C4CECF;
	Tue,  3 Dec 2024 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241878;
	bh=K4X/61PgwI7fJdet9Gn3GzPVNPHQZ/3siF7ARNCFSQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bunTEEOyyYZaXFk7pS43scux50LrDH7o0XaZKJkQ4Nbet+JUDEW+wl9AzQ+C6WTBS
	 S45YySZfX4COPohAB6HFYw/O56cSgSV66cD+HuOSGk5yaVZLGVC1mSCe8L55sbdhnw
	 Lm9UfBR3Ib9HWGcOgkTisAK4KG7zljCL7/CNSJsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 541/826] vfio/mlx5: Fix unwind flows in mlx5vf_pci_save/resume_device_data()
Date: Tue,  3 Dec 2024 15:44:28 +0100
Message-ID: <20241203144804.856848377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit cb04444c243c001fc27f275e84792ff1c2b96867 ]

Fix unwind flows in mlx5vf_pci_save_device_data() and
mlx5vf_pci_resume_device_data() to avoid freeing the migf pointer at the
'end' label, as this will be handled by fput(migf->filp) through
mlx5vf_release_file().

To ensure mlx5vf_release_file() functions correctly, move the
initialization of migf fields (such as migf->lock) to occur before any
potential unwind flow, as these fields may be accessed within
mlx5vf_release_file().

Fixes: 9945a67ea4b3 ("vfio/mlx5: Refactor PD usage")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241114095318.16556-3-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/main.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 242c23eef452e..8833e60d42f56 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -640,14 +640,11 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 					O_RDONLY);
 	if (IS_ERR(migf->filp)) {
 		ret = PTR_ERR(migf->filp);
-		goto end;
+		kfree(migf);
+		return ERR_PTR(ret);
 	}
 
 	migf->mvdev = mvdev;
-	ret = mlx5vf_cmd_alloc_pd(migf);
-	if (ret)
-		goto out_free;
-
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
@@ -663,6 +660,11 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
+
+	ret = mlx5vf_cmd_alloc_pd(migf);
+	if (ret)
+		goto out;
+
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, &full_size, 0);
 	if (ret)
 		goto out_pd;
@@ -692,10 +694,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	mlx5vf_free_data_buffer(buf);
 out_pd:
 	mlx5fv_cmd_clean_migf_resources(migf);
-out_free:
+out:
 	fput(migf->filp);
-end:
-	kfree(migf);
 	return ERR_PTR(ret);
 }
 
@@ -1016,13 +1016,19 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 					O_WRONLY);
 	if (IS_ERR(migf->filp)) {
 		ret = PTR_ERR(migf->filp);
-		goto end;
+		kfree(migf);
+		return ERR_PTR(ret);
 	}
 
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
+	spin_lock_init(&migf->list_lock);
 	migf->mvdev = mvdev;
 	ret = mlx5vf_cmd_alloc_pd(migf);
 	if (ret)
-		goto out_free;
+		goto out;
 
 	buf = mlx5vf_alloc_data_buffer(migf, 0, DMA_TO_DEVICE);
 	if (IS_ERR(buf)) {
@@ -1041,20 +1047,13 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	migf->buf_header[0] = buf;
 	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
 
-	stream_open(migf->filp->f_inode, migf->filp);
-	mutex_init(&migf->lock);
-	INIT_LIST_HEAD(&migf->buf_list);
-	INIT_LIST_HEAD(&migf->avail_list);
-	spin_lock_init(&migf->list_lock);
 	return migf;
 out_buf:
 	mlx5vf_free_data_buffer(migf->buf[0]);
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
-out_free:
+out:
 	fput(migf->filp);
-end:
-	kfree(migf);
 	return ERR_PTR(ret);
 }
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2791F7569;
	Tue,  3 Dec 2024 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239265; cv=none; b=nxD7VkvKPEE/9H9WnB8g+sFzJnrI1d9tauVU9fdLC5R3xqcbg/0d/hJr42mpLbTzdUtYa1pM5CXHSgHJVuwz1KsEhEZGp5xzM0GvbFw0Gk+wZe/bKu5Zur+mSeNIqHT8fkeLvNK58F+feab7S9MGB9gPb9P0W1jcaOrRkJ7THns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239265; c=relaxed/simple;
	bh=QZX1YLgP8PtJRi5oBSti+COEd0BXYQEThAYFVR/KbMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPAZaaxcA7z2VkpN9Zot8bP1TKTWUqmpgXSz+aWyh3bFVZVsCPDFIMfvzQHxTaoUtOygm0Z8TFbxoEbF18dS4tSanKXGFVsP1kcmByGaNLCJYPV6Su3bgUnPsS89EM6tOjkL4UxcYtK9hSvdh4T2Jvo0lIn/DXLzaHpM9lDhQrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpqvkL7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpqvkL7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9316C4CED6;
	Tue,  3 Dec 2024 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239265;
	bh=QZX1YLgP8PtJRi5oBSti+COEd0BXYQEThAYFVR/KbMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpqvkL7BaWWFIhF48Tp+xalmRAL8Hos74hL1pX8cbQAKBW/MB93BjL1kTFizbMIZ0
	 y48h64+S5HgJujcOimaQTQQBphBQv/pHtSlg7G/E62oHagR0SFTFoPjC3IrzitNH/c
	 BywiHo6W27l8cMpUyZvQSirMFlGBOuuqThnkP6vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 555/817] vfio/mlx5: Fix unwind flows in mlx5vf_pci_save/resume_device_data()
Date: Tue,  3 Dec 2024 15:42:07 +0100
Message-ID: <20241203144017.576210771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 61d9b0f9146d1..8de6037c88194 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -641,14 +641,11 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
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
@@ -664,6 +661,11 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
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
@@ -693,10 +695,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
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
 
@@ -1018,13 +1018,19 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
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
@@ -1043,20 +1049,13 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
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




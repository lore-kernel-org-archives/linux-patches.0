Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B98A223315;
	Thu, 12 Dec 2024 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018600; cv=none; b=A5/sRmeQoALFwO2hOtiM7kytpKFltZkLpQWmFdWVNLrp7CEOPQ8NxX7pOYEZvIonIrpQhRDdl4gH6hXoJcATOcjjzVDawaRSFQNb0Z7JASfIoV96NFlfGLbmxqq4Lbc9RJh4znhUfwyOnzTMxJyg5ZtQNN1j3i0aPW2o5UI10Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018600; c=relaxed/simple;
	bh=o+ee6p4rXqS4zaGppRTgbCm1u3FdsOEqKU1xQRS1fCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeRZhEua3qo+Vo+xMwq9CK4uO0KRedCq5W9F+4IDG733XccGRae1pdsYRrSluyP6qFwJ1sL7u3/QWj92gc1tk9KyPeDXFe0sR9lkqbW399lzXqkBtHTfnDt2cemkCEGKv2/6oHwywEo2kB+5IKZCztB975zbqrFNsHfXPpdt2ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoXY6edE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoXY6edE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EFFC4CEDF;
	Thu, 12 Dec 2024 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018600;
	bh=o+ee6p4rXqS4zaGppRTgbCm1u3FdsOEqKU1xQRS1fCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoXY6edENlEOe8phwSB+arplX+OMbHPUJeMXoflPxoK5GydM9p1njFCnD5sw/hTxq
	 BH254F2Wu4oleQZDJ+8OOYPsbwvvUky9J19wDF/6505hNajvJM2qh/5jZq2UQCUyiR
	 LCVOQfT2Np74Edxjk71pHJDKrOOlljGbbPwPdmy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yingshun Cui <yicui@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/356] vfio/mlx5: Align the page tracking max message size with the device capability
Date: Thu, 12 Dec 2024 16:00:56 +0100
Message-ID: <20241212144257.883913513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 9c7c5430bca36e9636eabbba0b3b53251479c7ab ]

Align the page tracking maximum message size with the device's
capability instead of relying on PAGE_SIZE.

This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
but the firmware only supports a maximum message size of 4K.

Now that we rely on the device's capability for max_message_size, we
must account for potential future increases in its value.

Key considerations include:
- Supporting message sizes that exceed a single system page (e.g., an 8K
  message on a 4K system).
- Ensuring the RQ size is adjusted to accommodate at least 4
  WQEs/messages, in line with the device specification.

The above has been addressed as part of the patch.

Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Tested-by: Yingshun Cui <yicui@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20241205122654.235619-1-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 33574b04477da..2d996c913ecd5 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1368,7 +1368,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_core_dev *mdev;
-	u32 max_msg_size = PAGE_SIZE;
+	u32 log_max_msg_size;
+	u32 max_msg_size;
 	u64 rq_size = SZ_2M;
 	u32 max_recv_wr;
 	int err;
@@ -1385,6 +1386,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	}
 
 	mdev = mvdev->mdev;
+	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
+	max_msg_size = (1ULL << log_max_msg_size);
+	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
+	if (rq_size < 4 * max_msg_size)
+		rq_size = 4 * max_msg_size;
+
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(tracker->uar)) {
@@ -1474,25 +1481,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 {
 	u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
 	u32 nent = size / entry_size;
+	u32 nent_in_page;
+	u32 nent_to_set;
 	struct page *page;
+	u32 page_offset;
+	u32 page_index;
+	u32 buf_offset;
+	void *kaddr;
 	u64 addr;
 	u64 *buf;
 	int i;
 
-	if (WARN_ON(index >= qp->recv_buf.npages ||
+	buf_offset = index * qp->max_msg_size;
+	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-	page = qp->recv_buf.page_list[index];
-	buf = kmap_local_page(page);
-	for (i = 0; i < nent; i++) {
-		addr = MLX5_GET(page_track_report_entry, buf + i,
-				dirty_address_low);
-		addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
-				      dirty_address_high) << 32;
-		iova_bitmap_set(dirty, addr, qp->tracked_page_size);
-	}
-	kunmap_local(buf);
+	do {
+		page_index = buf_offset / PAGE_SIZE;
+		page_offset = buf_offset % PAGE_SIZE;
+		nent_in_page = (PAGE_SIZE - page_offset) / entry_size;
+		page = qp->recv_buf.page_list[page_index];
+		kaddr = kmap_local_page(page);
+		buf = kaddr + page_offset;
+		nent_to_set = min(nent, nent_in_page);
+		for (i = 0; i < nent_to_set; i++) {
+			addr = MLX5_GET(page_track_report_entry, buf + i,
+					dirty_address_low);
+			addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
+					      dirty_address_high) << 32;
+			iova_bitmap_set(dirty, addr, qp->tracked_page_size);
+		}
+		kunmap_local(kaddr);
+		buf_offset += (nent_to_set * entry_size);
+		nent -= nent_to_set;
+	} while (nent);
 }
 
 static void
-- 
2.43.0




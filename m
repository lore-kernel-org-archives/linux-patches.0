Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D241F2381;
	Thu, 12 Dec 2024 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021440; cv=none; b=MweGivqh/fYwxgwjWT/pU94mf0DO+BOm000DyaLf9RpIriLiOpOJIPVu+kEdtSc9B2U/7fF4spjWfPJx1XjRy/Igxq/VoGz5wsLPgKXp63avX2v+/Y7zXGkYyxjPe6CwLgbEeaZTsJvhSWzGmDqAKVI6/Qq/8nAqHFjBP/xyUm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021440; c=relaxed/simple;
	bh=go2GMSTp8266UPqRCGCVlruvK0lC5oabmjWwJOr8eyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLdb6Y5tFHW0w/GIZY9Cwb0F6r2zkq7Ew5yzGX6CMmirVAMUmXE6w36yPKez/9BOa4+pPMLbA/PkRuY9zTrT0n67TJy7ly+hK53HPy1As7R3AETdxNQHJ92AiFztkuKHCuEJjnZQLe1tpeDrhkR1g34Y/YOQfRl4Ixy+OMK0cVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHl8JwJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHl8JwJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B141C4CECE;
	Thu, 12 Dec 2024 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021439;
	bh=go2GMSTp8266UPqRCGCVlruvK0lC5oabmjWwJOr8eyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHl8JwJ+SDtbMcedLcZmQey50yEu3wZ50JZQ7G+azlPRpt69VOxVFVuwleOjX6WY3
	 7v0/j8BbZKEvQOAXdX/eiomDiv/F9lu+yVJwYWMRWdGO/39R5Ocq3ARwlCL4ENwshT
	 2aiZ127g8Tc/BD6GmNelw3V5GYZ6p72XN8GsVvpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yingshun Cui <yicui@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 737/772] vfio/mlx5: Align the page tracking max message size with the device capability
Date: Thu, 12 Dec 2024 16:01:22 +0100
Message-ID: <20241212144420.385920241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c604b70437a5d..3f93b5c3f0993 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1106,7 +1106,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_core_dev *mdev;
-	u32 max_msg_size = PAGE_SIZE;
+	u32 log_max_msg_size;
+	u32 max_msg_size;
 	u64 rq_size = SZ_2M;
 	u32 max_recv_wr;
 	int err;
@@ -1123,6 +1124,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
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
@@ -1212,25 +1219,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
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




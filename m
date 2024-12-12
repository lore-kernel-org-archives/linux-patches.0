Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861FE1487CD;
	Thu, 12 Dec 2024 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017347; cv=none; b=DyZwh2H6agXyqVmJatPPqMVuHqfrQoAFvoN5Ez28BZkwf8ZlD8+049niwZfwF5gQv1NXErI0sSw5htChYozhvkIrYq66yL+qcCxrpe69rd/BZb/olxXWszKHioecloPQL5uZk5YvV3yfgU8HK5r6cpxXVoZ8ssRvyMvw+b1zP2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017347; c=relaxed/simple;
	bh=afecilv0NAcg925xGAILk54qS12Nx5XWqpOpRo46bD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mmfv4hKP/ULOZxS2PTv+W557N41mLfM+W/3WntENwQWkcTW60ZvR/jhpx2n5tpTP+2OLdWgZgmSg3dr3W1ckJgzfqFnlR8ZMAsMWmZNJjw0Dy/ehY5/ubZ5+UaK50ieSYq0LSgjQHjSWuEXr+W2kUSK0r+Ezn36KBNXZ8F2Aa/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAj9hY/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAj9hY/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E924BC4CECE;
	Thu, 12 Dec 2024 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017347;
	bh=afecilv0NAcg925xGAILk54qS12Nx5XWqpOpRo46bD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAj9hY/mJMYakOn1ssYHF2kRT4PLbP2uENkciwawz+jN3wnEx/Iws0PF6DPwXIVj3
	 0GSGOVMr4OFjYwsCC0EtBKR6zq7OyiJVe/rsYW63sSNDdVu3SEQa3pgosjpUDVgFPM
	 FiLfnjOM+qJ6oKTpq28ArZlV2JVyY3NMY5u24g2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yingshun Cui <yicui@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/466] vfio/mlx5: Align the page tracking max message size with the device capability
Date: Thu, 12 Dec 2024 16:00:21 +0100
Message-ID: <20241212144324.727308968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7527e277c8989..eb7387ee6ebd1 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_core_dev *mdev;
-	u32 max_msg_size = PAGE_SIZE;
+	u32 log_max_msg_size;
+	u32 max_msg_size;
 	u64 rq_size = SZ_2M;
 	u32 max_recv_wr;
 	int err;
@@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
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
@@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97296153814;
	Mon,  6 Jan 2025 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177953; cv=none; b=kKeCS3cG+7V6rThUIAVJVY6hEJMiiwRgzP4PwroMqL+rkJuy2hLjHVvR6Q+k6SwNo89+RFBSD9XE66xmgUdlRzJkuPracCPJmcgqzv/LZicKhIkXAQ0V4WlHRqeAtTHNQg1i1f7eNhj/C3sDPkpDpOJg7D8lDEQlP6LleaNmh04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177953; c=relaxed/simple;
	bh=oCiOEzGw9vtRuTIT3HwnzmcuGdQy49cuN5QV0b8heJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d88LW+vv41SXrSZlU42utCXnUwBXubPXwSlnaEY2pmaxhF44vYvI4rVanluA/uPotSRGxF5EwSbr/8SkBB/MzQLuU4e1f1gxfsFXk74ZMlsF+1S/DGp16FnoLe+CxsnTBODWyU0AQ6KJol/sfECCdFDQuZ4vWMhDgsCyGH8/RwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIEsGeMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIEsGeMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAA8C4CED2;
	Mon,  6 Jan 2025 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177953;
	bh=oCiOEzGw9vtRuTIT3HwnzmcuGdQy49cuN5QV0b8heJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIEsGeMiGX5t4h2hMuun0DOdsbZ/YB18/llfMe1oyzGPk4bYnC1guO2qaF6wzJD7q
	 oBcjhX1XxHrFZnZcII8OnOFxQCu7xLZBl6ZLYzSMr6YZSR1rbpZn4/gChQ2Sx3tpZ0
	 J4EzwZ/f+UtQGLd4qlu4aWJY11DetozGWgi/MMIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Poli <invernomuto@paranoici.org>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 111/156] RDMA/mlx5: Enable multiplane mode only when it is supported
Date: Mon,  6 Jan 2025 16:16:37 +0100
Message-ID: <20250106151145.908217414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Zhang <markzhang@nvidia.com>

commit 45d339fefaa3dcd237038769e0d34584fb867390 upstream.

Driver queries vport_cxt.num_plane and enables multiplane when it is
greater then 0, but some old FWs (versions from x.40.1000 till x.42.1000),
report vport_cxt.num_plane = 1 unexpectedly.

Fix it by querying num_plane only when HCA_CAP2.multiplane bit is set.

Fixes: 2a5db20fa532 ("RDMA/mlx5: Add support to multi-plane device and port")
Link: https://patch.msgid.link/r/1ef901acdf564716fcf550453cf5e94f343777ec.1734610916.git.leon@kernel.org
Cc: stable@vger.kernel.org
Reported-by: Francesco Poli <invernomuto@paranoici.org>
Closes: https://lore.kernel.org/all/nvs4i2v7o6vn6zhmtq4sgazy2hu5kiulukxcntdelggmznnl7h@so3oul6uwgbl/
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/main.c |    2 +-
 include/linux/mlx5/mlx5_ifc.h     |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2831,7 +2831,7 @@ static int mlx5_ib_get_plane_num(struct
 	int err;
 
 	*num_plane = 0;
-	if (!MLX5_CAP_GEN(mdev, ib_virt))
+	if (!MLX5_CAP_GEN(mdev, ib_virt) || !MLX5_CAP_GEN_2(mdev, multiplane))
 		return 0;
 
 	err = mlx5_query_hca_vport_context(mdev, 0, 1, 0, &vport_ctx);
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2113,7 +2113,9 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   migration_in_chunks[0x1];
 	u8	   reserved_at_d1[0x1];
 	u8	   sf_eq_usage[0x1];
-	u8	   reserved_at_d3[0xd];
+	u8	   reserved_at_d3[0x5];
+	u8	   multiplane[0x1];
+	u8	   reserved_at_d9[0x7];
 
 	u8	   cross_vhca_object_to_object_supported[0x20];
 



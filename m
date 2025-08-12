Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D6B6BB5B;
	Tue, 12 Aug 2025 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023892; cv=none; b=BgtcAv/pxUxvEuntCIp+nAT4pLH2gkepwEFOhWkyRr/nw4RD/xf29HrKtVkzdrk4gdeex9UaGqz/GXIyPs+Oc7KoFwzWhluWUeETNfsW5dhBeImXfPY6hjOZKBvdHYBhwRGPjoCnkHL7dTL3zQMh1I7tdE7Ww6+R/q11ERArWTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023892; c=relaxed/simple;
	bh=VbgCIOiH69oKrdgQJ7n/7YvXdsMTwST1fZgIYA52+nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uixNxHbtPbE4C89Ee6cI3ixTKzs1ACI3ZGvZUCjRUqmc31iq0Cih6o2FL4irTvYxPZpahUK5pFjvrwpBFtaRCgGf7PYnDqsAisnneTsN6s9VYQLjDymsVN1r4+JdVirKQX9EonGihdk+AWz5he/gucH3xsASGRrtBfjRLrS19Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzyyYm4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzyyYm4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6248C4CEF0;
	Tue, 12 Aug 2025 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023892;
	bh=VbgCIOiH69oKrdgQJ7n/7YvXdsMTwST1fZgIYA52+nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzyyYm4e6aybxc1L9r3qsVLLRguDhbYF2Y7ArdcAhaCVBkunIwcAGNYadxSyE1BO7
	 bQytumN3RBqZr3EqqhhW99pWvCICO2qUX5KTg8DUjpomQHfUZHGAMlVWQjLmRkSk8P
	 mgw/ZPboy1Hmm2V/TZoeENWQ6G4ZXw46jirHVKNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Srouji <edwards@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 213/627] RDMA/mlx5: Fix UMR modifying of mkey page size
Date: Tue, 12 Aug 2025 19:28:28 +0200
Message-ID: <20250812173427.385636131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Srouji <edwards@nvidia.com>

[ Upstream commit c4f96972c3c206ac8f6770b5ecd5320b561d0058 ]

When changing the page size on an mkey, the driver needs to set the
appropriate bits in the mkey mask to indicate which fields are being
modified.
The 6th bit of a page size in mlx5 driver is considered an extension,
and this bit has a dedicated capability and mask bits.

Previously, the driver was not setting this mask in the mkey mask when
performing page size changes, regardless of its hardware support,
potentially leading to an incorrect page size updates.

This fixes the issue by setting the relevant bit in the mkey mask when
performing page size changes on an mkey and the 6th bit of this field is
supported by the hardware.

Fixes: cef7dde8836a ("net/mlx5: Expand mkey page size to support 6 bits")
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9f43a9c73bf2db6085a99dc836f7137e76579f09.1751979184.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/umr.c | 6 ++++--
 include/linux/mlx5/device.h      | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 5be4426a2884..25601dea9e30 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -32,13 +32,15 @@ static __be64 get_umr_disable_mr_mask(void)
 	return cpu_to_be64(result);
 }
 
-static __be64 get_umr_update_translation_mask(void)
+static __be64 get_umr_update_translation_mask(struct mlx5_ib_dev *dev)
 {
 	u64 result;
 
 	result = MLX5_MKEY_MASK_LEN |
 		 MLX5_MKEY_MASK_PAGE_SIZE |
 		 MLX5_MKEY_MASK_START_ADDR;
+	if (MLX5_CAP_GEN_2(dev->mdev, umr_log_entity_size_5))
+		result |= MLX5_MKEY_MASK_PAGE_SIZE_5;
 
 	return cpu_to_be64(result);
 }
@@ -654,7 +656,7 @@ static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
 		flags & MLX5_IB_UPD_XLT_ENABLE || flags & MLX5_IB_UPD_XLT_ADDR;
 
 	if (update_translation) {
-		wqe->ctrl_seg.mkey_mask |= get_umr_update_translation_mask();
+		wqe->ctrl_seg.mkey_mask |= get_umr_update_translation_mask(dev);
 		if (!mr->ibmr.length)
 			MLX5_SET(mkc, &wqe->mkey_seg, length64, 1);
 	}
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 6822cfa5f4ad..9d2467f982ad 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -280,6 +280,7 @@ enum {
 	MLX5_MKEY_MASK_SMALL_FENCE	= 1ull << 23,
 	MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE	= 1ull << 25,
 	MLX5_MKEY_MASK_FREE			= 1ull << 29,
+	MLX5_MKEY_MASK_PAGE_SIZE_5		= 1ull << 42,
 	MLX5_MKEY_MASK_RELAXED_ORDERING_READ	= 1ull << 47,
 };
 
-- 
2.39.5




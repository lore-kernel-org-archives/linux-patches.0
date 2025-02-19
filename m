Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042F71DF972;
	Wed, 19 Feb 2025 09:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956546; cv=none; b=G+sAwbADMhuw6HXj7oihgHKOPCfVVLlJim4qmv9VPi1NCVro5W7Uxrj40ZsEUd7b+L3zxbIRMFo3nxOsBlM/1pwPWL5x0B/MAziN29G8oiNtzoWMnDAV/n2u6AAbInKy+OXVoi8vGuOOV/sgZR6Oyl91H6kEMTqrW71YSfFKwG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956546; c=relaxed/simple;
	bh=0Zq+qkeWBfSGTDQDrxjlkJZHKk8E22i3laPcsA2eNwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rW4OFVRwSVVS+r7zt9mK7e2EeFn+lO2poKVrF7VRFGX9MY9VtJwlfFGfwwUXPDBEeJyy37NO6eR+ZS0rbsKg0YPEg2ulvzCmN/5S7V8hZjR2U/vLiXsEN2WZR++aflKgXa3E5htfa11ScvuG5WGbGY31gKzbaSD74LIocAf8dLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXgxoFgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXgxoFgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4B8C4CEE6;
	Wed, 19 Feb 2025 09:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956545;
	bh=0Zq+qkeWBfSGTDQDrxjlkJZHKk8E22i3laPcsA2eNwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXgxoFgUq5RMX1YJlnz2Oe2tVfY7pX9g5EjoUF5OCdusFwb2r0bjqwNPlCsdoKe8d
	 C6U2YjRNFOyCXjB6eslblFv6gjitSQw/ggJQNdg1WA9CpNSgeIXwaxxd6sg+XUTZ5b
	 a81uMC/DNNENiAtxIPYdzhT0qiiPU41+BOVbQT10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Artemy Kovalyov <artemyko@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/578] RDMA/mlx5: Fix indirect mkey ODP page count
Date: Wed, 19 Feb 2025 09:23:07 +0100
Message-ID: <20250219082700.162436786@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 235f238402194a78ac5fb882a46717eac817e5d1 ]

Restrict the check for the number of pages handled during an ODP page
fault to direct mkeys.
Perform the check right after handling the page fault and don't
propagate the number of handled pages to callers.

Indirect mkeys and their associated direct mkeys can have different
start addresses. As a result, the calculation of the number of pages to
handle for an indirect mkey may not match the actual page fault
handling done on the direct mkey.

For example:
A 4K sized page fault on a KSM mkey that has a start address that is not
aligned to a page will result a calculation that assumes the number of
pages required to handle are 2.
While the underlying MTT might be aligned will require fetching only a
single page.
Thus, do the calculation and compare number of pages handled only per
direct mkey.

Fixes: db570d7deafb ("IB/mlx5: Add ODP support to MW")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Artemy Kovalyov <artemyko@nvidia.com>
Link: https://patch.msgid.link/86c483d9e75ce8fe14e9ff85b62df72b779f8ab1.1736187990.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d3cada2ae5a5b..87fbee8061003 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -808,8 +808,7 @@ static bool mkey_is_eq(struct mlx5_ib_mkey *mmkey, u32 key)
 /*
  * Handle a single data segment in a page-fault WQE or RDMA region.
  *
- * Returns number of OS pages retrieved on success. The caller may continue to
- * the next data segment.
+ * Returns zero on success. The caller may continue to the next data segment.
  * Can return the following error codes:
  * -EAGAIN to designate a temporary error. The caller will abort handling the
  *  page fault and resolve it.
@@ -822,7 +821,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 					 u32 *bytes_committed,
 					 u32 *bytes_mapped)
 {
-	int npages = 0, ret, i, outlen, cur_outlen = 0, depth = 0;
+	int ret, i, outlen, cur_outlen = 0, depth = 0, pages_in_range;
 	struct pf_frame *head = NULL, *frame;
 	struct mlx5_ib_mkey *mmkey;
 	struct mlx5_ib_mr *mr;
@@ -865,13 +864,20 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	case MLX5_MKEY_MR:
 		mr = container_of(mmkey, struct mlx5_ib_mr, mmkey);
 
+		pages_in_range = (ALIGN(io_virt + bcnt, PAGE_SIZE) -
+				  (io_virt & PAGE_MASK)) >>
+				 PAGE_SHIFT;
 		ret = pagefault_mr(mr, io_virt, bcnt, bytes_mapped, 0, false);
 		if (ret < 0)
 			goto end;
 
 		mlx5_update_odp_stats(mr, faults, ret);
 
-		npages += ret;
+		if (ret < pages_in_range) {
+			ret = -EFAULT;
+			goto end;
+		}
+
 		ret = 0;
 		break;
 
@@ -962,7 +968,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	kfree(out);
 
 	*bytes_committed = 0;
-	return ret ? ret : npages;
+	return ret;
 }
 
 /*
@@ -981,8 +987,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
  *                   the committed bytes).
  * @receive_queue: receive WQE end of sg list
  *
- * Returns the number of pages loaded if positive, zero for an empty WQE, or a
- * negative error code.
+ * Returns zero for success or a negative error code.
  */
 static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 				   struct mlx5_pagefault *pfault,
@@ -990,7 +995,7 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 				   void *wqe_end, u32 *bytes_mapped,
 				   u32 *total_wqe_bytes, bool receive_queue)
 {
-	int ret = 0, npages = 0;
+	int ret = 0;
 	u64 io_virt;
 	u32 key;
 	u32 byte_count;
@@ -1046,10 +1051,9 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 						    bytes_mapped);
 		if (ret < 0)
 			break;
-		npages += ret;
 	}
 
-	return ret < 0 ? ret : npages;
+	return ret;
 }
 
 /*
@@ -1285,12 +1289,6 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	free_page((unsigned long)wqe_start);
 }
 
-static int pages_in_range(u64 address, u32 length)
-{
-	return (ALIGN(address + length, PAGE_SIZE) -
-		(address & PAGE_MASK)) >> PAGE_SHIFT;
-}
-
 static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
 					   struct mlx5_pagefault *pfault)
 {
@@ -1329,7 +1327,7 @@ static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
 	if (ret == -EAGAIN) {
 		/* We're racing with an invalidation, don't prefetch */
 		prefetch_activated = 0;
-	} else if (ret < 0 || pages_in_range(address, length) > ret) {
+	} else if (ret < 0) {
 		mlx5_ib_page_fault_resume(dev, pfault, 1);
 		if (ret != -ENOENT)
 			mlx5_ib_dbg(dev, "PAGE FAULT error %d. QP 0x%x, type: 0x%x\n",
-- 
2.39.5




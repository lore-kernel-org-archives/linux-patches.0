Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3684E80B5;
	Tue, 13 Oct 2026 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894389; cv=none; b=RvRF1K6xHycS0h4Ms7GOcEN0+qZe1zF2NE+aWl4KUB1yTYe5rTj5TQDg1bTmsd2zkAo8BtffKmuy/MVLTu0IDQb+5YbMB2+lQ0Kh0NkbDQbqz8Hh7Wgn23Y1L0P7yo8cUnQlkpQil9PDatX9YtqCwDN+q9wlqfbEiQzTnPCsJGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894389; c=relaxed/simple;
	bh=W5LsdCAMHS0E81GQXUmm56ehNEpveUuOTLTzyiC3fts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1GHv+BblHyYWlOUa/7tEduIToMT1EaHS/eakOz69KgdS32GZNNBPPlt7qyy22fHArZNmwKZ9QmVKWLw2X3J9sM5Wr45pVslv5+wkMmgkcSQMj2sXRACnuERqkBGfjNFf/mcFfuLPXjhYjOMpgXB2C2aqYxhCKFFuyYqjqcOIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dwq9o6lp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dwq9o6lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D221F000FF;
	Tue, 13 Oct 2026 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894388;
	bh=C8KoY7HLX2CCmlBtVmK3c/J79tNxR6FrFeKZaKW4ARQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dwq9o6lpE//R7tB+POgudORSnS4tmpXszGoU7BQmfeI5H7lNL1Ify4J8qd1nTfY5I
	 b9R6PuLQRgKxlm1wkyHPNoDzRdKmO1njYHZN9MBjQL+8kXkXQ94gJ25S2diqzXjdt3
	 EUL+Y2ASSF/FLsM6upT9a/t0j2Mf3p0cvCFBWsnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liming Sun <limings@nvidia.com>,
	James Hurley <jahurley@nvidia.com>,
	Dave Thompson <davthompson@nvidia.com>,
	Mahantesh Salimath <mahantesh@nvidia.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 545/621] tee: optee: ffa: support shared memory offsets on large-page kernels
Date: Tue, 13 Oct 2026 13:39:00 +0200
Message-ID: <20261013112933.751865219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahantesh Salimath <mahantesh@nvidia.com>

[ Upstream commit 3c0d2f1f431c51a11253f28763be723ac782fd7a ]

OP-TEE FF-A memory objects use 4 KiB pages, while the kernel page
size may be larger. Consequently, tee_shm->offset can be greater than
or equal to FFA_PAGE_SIZE, but OP-TEE rejects such a value in
internal_offs.

Do not encode the excess page offset in offs_low/offs_high. Those
fields describe the logical memref offset and are copied back into
tee_param->shm_offs on return. Folding the page offset into them breaks
parameter round trips when a memref is reused. They are also ignored by
the OPTEE_RPC_CMD_SHM_ALLOC response path, which uses only global_id and
internal_offs to construct the shared-memory mobj.

Instead, start the FF-A descriptor at the 4 KiB page containing the
shared buffer, the same approach as optee_fill_pages_list() in the SMC
ABI. Store the remaining in-page offset in internal_offs and preserve
shm_offs in offs_low/offs_high. This keeps internal_offs within the
FF-A page size, maps RPC allocations at the correct address, and
preserves normal memref offsets across repeated invocations.

Tested on ARMv8-A with 64 KiB PAGE_SIZE. OP-TEE OS ran as a secure
partition under Hafnium (SPMC) over FF-A. Verified registered shared
memory with tee_shm->offset >= 4 KiB, memref reuse on the same
TEEC_Operation, and RPC OPTEE_RPC_CMD_SHM_ALLOC (xtest regression
6007-6009). optee_hello_world, optee_aes, and xtest regression 1005,
1007, 1008, 4001-4003 and 6001-6003 also passed.

Fixes: 4615e5a34b95 ("optee: add FF-A support")
Acked-by: Liming Sun <limings@nvidia.com>
Acked-by: James Hurley <jahurley@nvidia.com>
Acked-by: Dave Thompson <davthompson@nvidia.com>
Signed-off-by: Mahantesh Salimath <mahantesh@nvidia.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c   | 22 ++++++++++++++++++----
 drivers/tee/optee/optee_msg.h |  4 ++--
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index 058b7b073a903..41bb103221bc6 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -198,7 +198,8 @@ static int to_msg_param_ffa_mem(struct optee_msg_param *mp,
 	if (shm) {
 		u64 shm_offs = p->u.memref.shm_offs;
 
-		mp->u.fmem.internal_offs = shm->offset;
+		mp->u.fmem.internal_offs = tee_shm_get_page_offset(shm) &
+					   (FFA_PAGE_SIZE - 1);
 
 		mp->u.fmem.offs_low = shm_offs;
 		mp->u.fmem.offs_high = shm_offs >> 32;
@@ -284,14 +285,26 @@ static int optee_ffa_shm_register(struct tee_context *ctx, struct tee_shm *shm,
 		.nattrs = 1,
 	};
 	struct sg_table sgt;
+	size_t ffa_offs;
 	int rc;
 
+	if (!num_pages)
+		return -EINVAL;
+
 	rc = optee_check_mem_type(start, num_pages);
 	if (rc)
 		return rc;
 
-	rc = sg_alloc_table_from_pages(&sgt, pages, num_pages, 0,
-				       num_pages * PAGE_SIZE, GFP_KERNEL);
+	/*
+	 * Start the FF-A descriptor at the 4 KiB page containing the shared
+	 * buffer, skipping unused leading 4 KiB pages when PAGE_SIZE is
+	 * larger. Same approach as optee_fill_pages_list() in the SMC ABI.
+	 * This leaves only the offset into that 4 KiB page for internal_offs.
+	 */
+	ffa_offs = round_down(tee_shm_get_page_offset(shm), FFA_PAGE_SIZE);
+	rc = sg_alloc_table_from_pages(&sgt, pages, num_pages, ffa_offs,
+				       num_pages * PAGE_SIZE - ffa_offs,
+				       GFP_KERNEL);
 	if (rc)
 		return rc;
 	args.sg = sgt.sgl;
@@ -458,7 +471,8 @@ static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		.attr = OPTEE_MSG_ATTR_TYPE_FMEM_OUTPUT,
 		.u.fmem.size = tee_shm_get_size(shm),
 		.u.fmem.global_id = shm->sec_world_id,
-		.u.fmem.internal_offs = shm->offset,
+		.u.fmem.internal_offs = tee_shm_get_page_offset(shm) &
+					(FFA_PAGE_SIZE - 1),
 	};
 
 	arg->ret = TEEC_SUCCESS;
diff --git a/drivers/tee/optee/optee_msg.h b/drivers/tee/optee/optee_msg.h
index 7d9b12e71c035..6c3043f8da33c 100644
--- a/drivers/tee/optee/optee_msg.h
+++ b/drivers/tee/optee/optee_msg.h
@@ -136,8 +136,8 @@ struct optee_msg_param_rmem {
  * struct optee_msg_param_fmem - FF-A memory reference parameter
  * @offs_low:		lower bits of offset into shared memory reference
  * @offs_high:		higher bits of offset into shared memory reference
- * @internal_offs:	internal offset into the first page of shared memory
- *			reference
+ * @internal_offs:	offset into the first 4 KiB page of the FF-A shared
+ *			memory region
  * @size:		size of the buffer
  * @global_id:		global identifier of the shared memory
  */
-- 
2.53.0




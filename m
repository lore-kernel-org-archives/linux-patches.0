Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D578145A16;
	Fri,  6 Dec 2024 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498341; cv=none; b=QY8JmlRTGxzaYUGMRuSfeeNKnY0ynmnCH9Ilws+c/YYnHt3NGKOE7WDdJtXnjC/I8nO951nDcBYQcr01dczazW/+Jxs3Z40jRIMDTEWHy1gVQjIguSP9PP5HAY/SgOgZDg2qkqEagDjduIQkuZy8IzqCuQwMQbxFj1hIl0dR7R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498341; c=relaxed/simple;
	bh=l4AZHE40Ei6d3RjzMs0zHl6M/nx3clON7NCrFSkCgrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIRLmdhdRBtZu2q4V0qoNDJzrCpdc1ldLMdDc5TlZDx9tGKg5Qk0Uhcx+AfM5ikjLfAvvm2wkPff28BSjStaqOmoPbV+tKm4iX4TJ+719CdUnxW9q79T/jOG1/6YmmnbO38j5BetUHidPF2lYLYsy/lpCjUtXyo593OBSb9QXG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jny4HuLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jny4HuLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA33C4CED1;
	Fri,  6 Dec 2024 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498341;
	bh=l4AZHE40Ei6d3RjzMs0zHl6M/nx3clON7NCrFSkCgrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jny4HuLKeL/AmeCju2QuzsOJV3xg2GHBCQhoX+xgQKf1o8jbMNyFoExZ7xBWyzkhC
	 NKnvp2SOtPETFi+FK5LKOx7myzNawo3J2MKdXphOS0talyCyj70dCJS0sxevxSOnOi
	 ++mH0dm8gTzYfFEiDN826+ZBRwmcXMyI4sMCms6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 524/676] ublk: fix ublk_ch_mmap() for 64K page size
Date: Fri,  6 Dec 2024 15:35:43 +0100
Message-ID: <20241206143713.828803511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit d369735e02ef122d19d4c3d093028da0eb400636 upstream.

In ublk_ch_mmap(), queue id is calculated in the following way:

	(vma->vm_pgoff << PAGE_SHIFT) / `max_cmd_buf_size`

'max_cmd_buf_size' is equal to

	`UBLK_MAX_QUEUE_DEPTH * sizeof(struct ublksrv_io_desc)`

and UBLK_MAX_QUEUE_DEPTH is 4096 and part of UAPI, so 'max_cmd_buf_size'
is always page aligned in 4K page size kernel. However, it isn't true in
64K page size kernel.

Fixes the issue by always rounding up 'max_cmd_buf_size' with PAGE_SIZE.

Cc: stable@vger.kernel.org
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241111110718.1394001-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -713,12 +713,21 @@ static inline char *ublk_queue_cmd_buf(s
 	return ublk_get_queue(ub, q_id)->io_cmd_buf;
 }
 
+static inline int __ublk_queue_cmd_buf_size(int depth)
+{
+	return round_up(depth * sizeof(struct ublksrv_io_desc), PAGE_SIZE);
+}
+
 static inline int ublk_queue_cmd_buf_size(struct ublk_device *ub, int q_id)
 {
 	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
 
-	return round_up(ubq->q_depth * sizeof(struct ublksrv_io_desc),
-			PAGE_SIZE);
+	return __ublk_queue_cmd_buf_size(ubq->q_depth);
+}
+
+static int ublk_max_cmd_buf_size(void)
+{
+	return __ublk_queue_cmd_buf_size(UBLK_MAX_QUEUE_DEPTH);
 }
 
 static inline bool ublk_queue_can_use_recovery_reissue(
@@ -1387,7 +1396,7 @@ static int ublk_ch_mmap(struct file *fil
 {
 	struct ublk_device *ub = filp->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
-	unsigned max_sz = UBLK_MAX_QUEUE_DEPTH * sizeof(struct ublksrv_io_desc);
+	unsigned max_sz = ublk_max_cmd_buf_size();
 	unsigned long pfn, end, phys_off = vma->vm_pgoff << PAGE_SHIFT;
 	int q_id, ret = 0;
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849A01F892E;
	Tue,  3 Dec 2024 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242603; cv=none; b=VEUcP1HJfrK/SkbsxuDCTHwnJJdc7LaO5iP0hlagvTn6D1drbxKjUnH/YMTeL1mqbp34Q+Re4y9m2pszpMGRZ+wCiUQPmc3piGDDYxtq9gqq+dZ7I9FX+3Qm4FPle8KPBZ4NIflc5VdmRykrbVMAfCANqcvsmUgzpxsnQig/ULA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242603; c=relaxed/simple;
	bh=Zvnnwt8oFITCUf3i710WxyeYfTnvaGdQhUIHZJ1z01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxvYJF9NiHezpJvTBl5667mU9E68SapWSIcFzqHQx4D1Kp9mM/956MKHouva8WMMzsnD+XKbYYvhB4q9LA6tBq6I4ER2CE42NAjRoZkSjOvLMk/wh7rI1OrxTcijNj5zV4SJ/Tp5U/7TpWyyth5DvdFmmJTYBGNoD/5IB30ruj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdFY63qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdFY63qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC3BC4CECF;
	Tue,  3 Dec 2024 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242603;
	bh=Zvnnwt8oFITCUf3i710WxyeYfTnvaGdQhUIHZJ1z01o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdFY63qCcECH3ZVUd9TwkATZy9Zbc+oQctig9ve/FtLVOS8prBtJB7W0iBWwACT2J
	 Gyvwzw+GzZsQRIAUIQ5Fe+b0ygZSpEt6O8ewpHGiua2AQ+o2SQYuzw9FCvg77JbmgN
	 qd+OiOI+8rPBi1OLKPOC72W8j0DAEVnInBUU7CNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 722/826] ublk: fix ublk_ch_mmap() for 64K page size
Date: Tue,  3 Dec 2024 15:47:29 +0100
Message-ID: <20241203144811.927007701@linuxfoundation.org>
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
@@ -664,12 +664,21 @@ static inline char *ublk_queue_cmd_buf(s
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
@@ -1322,7 +1331,7 @@ static int ublk_ch_mmap(struct file *fil
 {
 	struct ublk_device *ub = filp->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
-	unsigned max_sz = UBLK_MAX_QUEUE_DEPTH * sizeof(struct ublksrv_io_desc);
+	unsigned max_sz = ublk_max_cmd_buf_size();
 	unsigned long pfn, end, phys_off = vma->vm_pgoff << PAGE_SHIFT;
 	int q_id, ret = 0;
 



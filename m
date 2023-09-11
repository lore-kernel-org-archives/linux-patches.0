Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7098D11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60E9C433C9;
	Mon, 11 Sep 2023 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444276;
	bh=wl+gMjPD3zQrC/q4pQoLBrfiuMgJQ5qijoqFMXrS3Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SshwLrOTOIffmN9Kr9cBb/zOoK4YZd4M/JG9oU2yZvOGiinA9w6CxxpzJI5RJGSi9
	 JFIc1f3rnDULoXPptC5rrbn5O4x1bvcM5xLOh1+2ByEP9xayKLfr3LnC4+oJ00ocPM
	 NpsMhMcFfLsEhtCLHTkACvQzMGGXcTFOcfWP9o04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Hou Tao <houtao1@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.4 645/737] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
Date: Mon, 11 Sep 2023 15:48:24 +0200
Message-ID: <20230911134708.550166726@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

commit c1dbd8a849183b9c12d257ad3043ecec50db50b3 upstream.

When doing mkfs.xfs on a pmem device, the following warning was
reported:

 ------------[ cut here ]------------
 WARNING: CPU: 2 PID: 384 at block/blk-core.c:751 submit_bio_noacct
 Modules linked in:
 CPU: 2 PID: 384 Comm: mkfs.xfs Not tainted 6.4.0-rc7+ #154
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 RIP: 0010:submit_bio_noacct+0x340/0x520
 ......
 Call Trace:
  <TASK>
  ? submit_bio_noacct+0xd5/0x520
  submit_bio+0x37/0x60
  async_pmem_flush+0x79/0xa0
  nvdimm_flush+0x17/0x40
  pmem_submit_bio+0x370/0x390
  __submit_bio+0xbc/0x190
  submit_bio_noacct_nocheck+0x14d/0x370
  submit_bio_noacct+0x1ef/0x520
  submit_bio+0x55/0x60
  submit_bio_wait+0x5a/0xc0
  blkdev_issue_flush+0x44/0x60

The root cause is that submit_bio_noacct() needs bio_op() is either
WRITE or ZONE_APPEND for flush bio and async_pmem_flush() doesn't assign
REQ_OP_WRITE when allocating flush bio, so submit_bio_noacct just fail
the flush bio.

Simply fix it by adding the missing REQ_OP_WRITE for flush bio. And we
could fix the flush order issue and do flush optimization later.

Cc: stable@vger.kernel.org # 6.3+
Fixes: b4a6bb3a67aa ("block: add a sanity check for non-write flush/fua bios")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/nd_virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c6a648fd8744..1f8c667c6f1e 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -105,7 +105,8 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 	 * parent bio. Otherwise directly call nd_region flush.
 	 */
 	if (bio && bio->bi_iter.bi_sector != -1) {
-		struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_PREFLUSH,
+		struct bio *child = bio_alloc(bio->bi_bdev, 0,
+					      REQ_OP_WRITE | REQ_PREFLUSH,
 					      GFP_ATOMIC);
 
 		if (!child)
-- 
2.42.0




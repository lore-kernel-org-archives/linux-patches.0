Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD72415F0C;
	Tue, 21 Jul 2026 22:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674789; cv=none; b=XJP9BXMFFEQGY7wAvh+SijmIvnYkk0av07zlhRIfZ+224ejL3du0ZPlqJjjIPZw0+Wdu8f3NUmWJumh0MSU/g7DWp7XDfKDm+Ieb+XdjqjUb7Ahum4X3b5IRxtNK8rMlnGVuAoYHZ4dmH1eYE2GCTNnZlq+S6GCPFCqFEoPUuWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674789; c=relaxed/simple;
	bh=cvmE8MHQWgt7OJDshgxcZ4mS8S3eopiwArVAIwMUg2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5Ai1w9nwLXC7QgQiKN8+JHczmfF2zObzfLe7JfG7GgaVmXPmbm4nnknhA6MRP+POj3Sz75d42SK6NutS2UlRgHuP5r7KHEzH85VU+Q/Yp0WUI6EjiF5PTF2gU+XN1LYkG7HDvWoKKcKmV2Jd7SPxpmiR4x7/lOtwmvalw/0E7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD6RCzFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD6RCzFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4018B1F000E9;
	Tue, 21 Jul 2026 22:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674787;
	bh=iypgATXh+FGCKOHXO73cb+iqVgK8vW0BoB5P8gDmsF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MD6RCzFJT1O52TH9MZHuvDy3b7zRdizUkbKx7Knl/8NeO3t1BDhihNkrUpI4LZE/S
	 jKVa6xJCBmruETk32SZjlNQiXZX+1P9AqGDOclhfm9eCDmdCHEwq5LcQzbi3A8CSHd
	 TDbS2ujBdGcKSC9coLDpb7GsR2CdNXZPWQhUsHJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 636/699] coresight: etb10: restore atomic_t for shared reading state
Date: Tue, 21 Jul 2026 17:26:35 +0200
Message-ID: <20260721152410.097762617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fa09f08ede3db3050ae16ae1ed92c902d0cada23 ]

The etb10 miscdevice uses drvdata->reading as a shared exclusivity gate
for userspace buffer access. etb_open() claims that gate with
local_cmpxchg(), and etb_release() clears it with local_set().

That gate is shared per-device state rather than CPU-local state. A
running system can reach it whenever /dev/<etb> is opened, closed, and
reopened by different tasks while the device remains registered, so the
same drvdata->reading variable may be claimed on one CPU and later
cleared on another.

This code used to use atomic_t for the same gate, but commit
27b10da8fff2 ("coresight: etb10: moving to local atomic operations")
changed it to local_t even though the access pattern remained cross-task
and cross-CPU. Restore atomic_t together with atomic_cmpxchg() and
atomic_set() so the exclusivity gate again uses a primitive intended
for shared state.

The issue was found on Linux v6.18.21 by our static analysis tool while
scanning surviving local_t-on-shared-state sites, and then manually
reviewed against the live etb10 file-op path.

It was runtime-validated with a reproducible QEMU no-device KCSAN PoC
that kept the same report-local contract:

  1. use one shared struct etb_drvdata carrier and its
     drvdata->reading gate;
  2. call etb_open() and etb_release() sequentially on that gate to
     confirm the original claim/clear path;
  3. bind the open side to CPU0 and the release side to CPU1 for the
     same gate to show cross-CPU ownership;
  4. run bound workers that repeatedly race etb_open() and
     etb_release() on the same gate until KCSAN reports a target hit.

The harness recorded:

  L1 passed open=1 release=1
  reading_after_open=1 reading_after_release=0
  L2 passed open_cpu=0 release_cpu=1
  cross_cpu_release=1 reading_after=0 open_ret=0

Representative KCSAN excerpt from the no-device validation run:

  BUG: KCSAN: data-race in etb_open.constprop.0.isra.0 [vuln_msv]

  write to 0xffffffffc0003810 of 4 bytes by task 216 on cpu 1:
   etb_open.constprop.0.isra.0+0x38/0x80 [vuln_msv]
   l3_worker_thread_fn+0x4f/0xf0 [vuln_msv]
   kthread+0x17e/0x1c0
   ret_from_fork+0x22/0x30

  read to 0xffffffffc0003810 of 4 bytes by task 215 on cpu 0:
   etb_open.constprop.0.isra.0+0x18/0x80 [vuln_msv]
   l3_worker_thread_fn+0x4f/0xf0 [vuln_msv]
   kthread+0x17e/0x1c0
   ret_from_fork+0x22/0x30

  value changed: 0x00000000 -> 0x00000001

  Reported by Kernel Concurrency Sanitizer on:
  CPU: 0 PID: 215 Comm: etb10_l3_a Tainted: G           O       6.1.66 #2

This no-device harness is not a real ETB10 hardware end-to-end run, but
it preserves the same shared drvdata->reading gate and the same
etb_open()/etb_release() claim/clear contract. No real ETB10 hardware
was available for runtime testing.

Build-tested with:
  make olddefconfig
  make -j"$(nproc)" drivers/hwtracing/coresight/coresight-etb10.o

Fixes: 27b10da8fff2 ("coresight: etb10: moving to local atomic operations")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260528165201.319452-1-runyu.xiao@seu.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etb10.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etb10.c
+++ b/drivers/hwtracing/coresight/coresight-etb10.c
@@ -86,7 +86,7 @@ struct etb_drvdata {
 	struct coresight_device	*csdev;
 	struct miscdevice	miscdev;
 	spinlock_t		spinlock;
-	local_t			reading;
+	atomic_t		reading;
 	pid_t			pid;
 	u8			*buf;
 	u32			mode;
@@ -603,7 +603,7 @@ static int etb_open(struct inode *inode,
 	struct etb_drvdata *drvdata = container_of(file->private_data,
 						   struct etb_drvdata, miscdev);
 
-	if (local_cmpxchg(&drvdata->reading, 0, 1))
+	if (atomic_cmpxchg(&drvdata->reading, 0, 1))
 		return -EBUSY;
 
 	dev_dbg(&drvdata->csdev->dev, "%s: successfully opened\n", __func__);
@@ -641,7 +641,7 @@ static int etb_release(struct inode *ino
 {
 	struct etb_drvdata *drvdata = container_of(file->private_data,
 						   struct etb_drvdata, miscdev);
-	local_set(&drvdata->reading, 0);
+	atomic_set(&drvdata->reading, 0);
 
 	dev_dbg(&drvdata->csdev->dev, "%s: released\n", __func__);
 	return 0;



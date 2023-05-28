Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F96611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814FFC4339B;
	Sun, 28 May 2023 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302942;
	bh=SV7t7SkZKavclLUki4z6I4ES14b8SM3+NCFJ0vXHuoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDmrGrOeKu4I3vODIvPlwW0j/qNNS06JgjNRiEGLm/TvxiM/X49PVQ7Nc7VmcYpOD
	 myZkIKDJu9iJTGY+YdLPnkrtm9vXF70fKeY1RdcDopS+GlTP9jhVRH+ab8c/ONUDQK
	 X2WaHxWq+j39yJCx6XB9Jg8spjsDEVBOWNcjkhYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/211] null_blk: Always check queue mode setting from configfs
Date: Sun, 28 May 2023 20:09:42 +0100
Message-Id: <20230528190845.114494879@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 63f8793ee60513a09f110ea460a6ff2c33811cdb ]

Make sure to check device queue mode in the null_validate_conf() and
return error for NULL_Q_RQ as we don't allow legacy I/O path, without
this patch we get OOPs when queue mode is set to 1 from configfs,
following are repro steps :-

modprobe null_blk nr_devices=0
mkdir config/nullb/nullb0
echo 1 > config/nullb/nullb0/memory_backed
echo 4096 > config/nullb/nullb0/blocksize
echo 20480 > config/nullb/nullb0/size
echo 1 > config/nullb/nullb0/queue_mode
echo 1 > config/nullb/nullb0/power

Entering kdb (current=0xffff88810acdd080, pid 2372) on processor 42 Oops: (null)
due to oops @ 0xffffffffc041c329
CPU: 42 PID: 2372 Comm: sh Tainted: G           O     N 6.3.0-rc5lblk+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:null_add_dev.part.0+0xd9/0x720 [null_blk]
Code: 01 00 00 85 d2 0f 85 a1 03 00 00 48 83 bb 08 01 00 00 00 0f 85 f7 03 00 00 80 bb 62 01 00 00 00 48 8b 75 20 0f 85 6d 02 00 00 <48> 89 6e 60 48 8b 75 20 bf 06 00 00 00 e8 f5 37 2c c1 48 8b 75 20
RSP: 0018:ffffc900052cbde0 EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffff88811084d800 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888100042e00
RBP: ffff8881053d8200 R08: ffffc900052cbd68 R09: ffff888105db2000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000002
R13: ffff888104765200 R14: ffff88810eec1748 R15: ffff88810eec1740
FS:  00007fd445fd1740(0000) GS:ffff8897dfc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000060 CR3: 0000000166a00000 CR4: 0000000000350ee0
DR0: ffffffff8437a488 DR1: ffffffff8437a489 DR2: ffffffff8437a48a
DR3: ffffffff8437a48b DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nullb_device_power_store+0xd1/0x120 [null_blk]
 configfs_write_iter+0xb4/0x120
 vfs_write+0x2ba/0x3c0
 ksys_write+0x5f/0xe0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7fd4460c57a7
Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
RSP: 002b:00007ffd3792a4a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd4460c57a7
RDX: 0000000000000002 RSI: 000055b43c02e4c0 RDI: 0000000000000001
RBP: 000055b43c02e4c0 R08: 000000000000000a R09: 00007fd44615b4e0
R10: 00007fd44615b3e0 R11: 0000000000000246 R12: 0000000000000002
R13: 00007fd446198520 R14: 0000000000000002 R15: 00007fd446198700
 </TASK>

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Link: https://lore.kernel.org/r/20230416220339.43845-1-kch@nvidia.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 25db095e943b7..35b390a785dd4 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1738,6 +1738,11 @@ static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
 
 static int null_validate_conf(struct nullb_device *dev)
 {
+	if (dev->queue_mode == NULL_Q_RQ) {
+		pr_err("legacy IO path is no longer available\n");
+		return -EINVAL;
+	}
+
 	dev->blocksize = round_down(dev->blocksize, 512);
 	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
 
-- 
2.39.2




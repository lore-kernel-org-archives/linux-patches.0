Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD3F18658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E231EC433C9;
	Wed, 20 Sep 2023 11:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210633;
	bh=6Me187LBX6tVZLiyjI1qt1aT7Yv/voj0s9wazCnAepQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNmRxJQoqXbEz7fp27aqDjDmU8VBEkZzjGR6F+pYqc/bccjQ9ArfEQD6dHc3M7RDp
	 5Qh86wtZ9dKJsXC6FNJDmBN7Twkf3MJJ4kxxsEHY5Z/X7tNuh8DxKxKr6WB4Qm+7Lg
	 ihugLierssE4V+joAD32IBe3zElgrSg00SWyfnK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 147/211] md: fix warning for holder mismatch from export_rdev()
Date: Wed, 20 Sep 2023 13:29:51 +0200
Message-ID: <20230920112850.415621328@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 99892147f028d711f9d40fefad4f33632593864c ]

Commit a1d767191096 ("md: use mddev->external to select holder in
export_rdev()") fix the problem that 'claim_rdev' is used for
blkdev_get_by_dev() while 'rdev' is used for blkdev_put().

However, if mddev->external is changed from 0 to 1, then 'rdev' is used
for blkdev_get_by_dev() while 'claim_rdev' is used for blkdev_put(). And
this problem can be reporduced reliably by following:

New file: mdadm/tests/23rdev-lifetime

devname=${dev0##*/}
devt=`cat /sys/block/$devname/dev`
pid=""
runtime=2

clean_up_test() {
        pill -9 $pid
        echo clear > /sys/block/md0/md/array_state
}

trap 'clean_up_test' EXIT

add_by_sysfs() {
        while true; do
                echo $devt > /sys/block/md0/md/new_dev
        done
}

remove_by_sysfs(){
        while true; do
                echo remove > /sys/block/md0/md/dev-${devname}/state
        done
}

echo md0 > /sys/module/md_mod/parameters/new_array || die "create md0 failed"

add_by_sysfs &
pid="$pid $!"

remove_by_sysfs &
pid="$pid $!"

sleep $runtime
exit 0

Test cmd:

./test --save-logs --logdir=/tmp/ --keep-going --dev=loop --tests=23rdev-lifetime

Test result:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 960 at block/bdev.c:618 blkdev_put+0x27c/0x330
Modules linked in: multipath md_mod loop
CPU: 0 PID: 960 Comm: test Not tainted 6.5.0-rc2-00121-g01e55c376936-dirty #50
RIP: 0010:blkdev_put+0x27c/0x330
Call Trace:
 <TASK>
 export_rdev.isra.23+0x50/0xa0 [md_mod]
 mddev_unlock+0x19d/0x300 [md_mod]
 rdev_attr_store+0xec/0x190 [md_mod]
 sysfs_kf_write+0x52/0x70
 kernfs_fop_write_iter+0x19a/0x2a0
 vfs_write+0x3b5/0x770
 ksys_write+0x74/0x150
 __x64_sys_write+0x22/0x30
 do_syscall_64+0x40/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fix the problem by recording if 'rdev' is used as holder.

Fixes: a1d767191096 ("md: use mddev->external to select holder in export_rdev()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230825025532.1523008-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 15 ++++++++++++---
 drivers/md/md.h |  3 +++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fba2809cd384a..06a8ccdb5135d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2452,7 +2452,8 @@ static void export_rdev(struct md_rdev *rdev, struct mddev *mddev)
 	if (test_bit(AutoDetected, &rdev->flags))
 		md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
-	blkdev_put(rdev->bdev, mddev->external ? &claim_rdev : rdev);
+	blkdev_put(rdev->bdev,
+		   test_bit(Holder, &rdev->flags) ? rdev : &claim_rdev);
 	rdev->bdev = NULL;
 	kobject_put(&rdev->kobj);
 }
@@ -3632,6 +3633,7 @@ EXPORT_SYMBOL_GPL(md_rdev_init);
 static struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
 	struct md_rdev *rdev;
+	struct md_rdev *holder;
 	sector_t size;
 	int err;
 
@@ -3646,8 +3648,15 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	if (err)
 		goto out_clear_rdev;
 
+	if (super_format == -2) {
+		holder = &claim_rdev;
+	} else {
+		holder = rdev;
+		set_bit(Holder, &rdev->flags);
+	}
+
 	rdev->bdev = blkdev_get_by_dev(newdev, BLK_OPEN_READ | BLK_OPEN_WRITE,
-			super_format == -2 ? &claim_rdev : rdev, NULL);
+				       holder, NULL);
 	if (IS_ERR(rdev->bdev)) {
 		pr_warn("md: could not open device unknown-block(%u,%u).\n",
 			MAJOR(newdev), MINOR(newdev));
@@ -3684,7 +3693,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	return rdev;
 
 out_blkdev_put:
-	blkdev_put(rdev->bdev, super_format == -2 ? &claim_rdev : rdev);
+	blkdev_put(rdev->bdev, holder);
 out_clear_rdev:
 	md_rdev_clear(rdev);
 out_free_rdev:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1aef86bf3fc31..b0a0f5a5c7836 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -211,6 +211,9 @@ enum flag_bits {
 				 * check if there is collision between raid1
 				 * serial bios.
 				 */
+	Holder,			/* rdev is used as holder while opening
+				 * underlying disk exclusively.
+				 */
 };
 
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
-- 
2.40.1




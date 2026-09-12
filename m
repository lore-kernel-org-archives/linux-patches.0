Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B91D3D47BC;
	Sat, 12 Sep 2026 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225833; cv=none; b=WBFbLBU8d2+Uh5+162aAyJZIu7DAJil+Z4d7FoPIuCMpFJbJCndI22FmZgi2tXzKIFra9Cjy36q8M1JNlZDyVvJp0vo6jXsliAerhsLw/+PxeDgW0iR9ajjU9TPIMN62ZkWreqHr8zuINnJLNlChhthpHkV2Aqv52SWBDAlt7dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225833; c=relaxed/simple;
	bh=mnB90nrmeEYCeOr4+5FDVU0df6It375kYgWrgpdBY18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdZCq7OdYcNfsfO1/3P9CYvlRr8A6sg5FZiIPvLaIAey/Vbd1Z05kBiCWRCIM2bOpSncgViKeb8dbVegjvXBV+z5v6l6ZEhI4BxDMOy1pDLFT0JFuguVgv1c6fBqp5ULEGpuSyru4EagWmCEBI3Li+dEiGgcneTLIsHkTgJV0rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A7o4ewT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A7o4ewT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067ED1F000FF;
	Sat, 12 Sep 2026 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225826;
	bh=9zlxPCXyw4oT9mzPsd1vdAg3D176+pqmTncCggAFtgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2A7o4ewT19PthGQ3TSxxT/VzLL7wgp8EkiT/cmPYr/pwV64a8bpQ3xByen0R0pWFR
	 o7GEXrrmQ4hJkMekOwb+lcIuN8vyI8JF85Um/Iq5fkOiEDnu0vxPmPeTl7WOE4hI5O
	 fpqKV5p+JQ3ejWNLwzX2w9CnMWxA4NYDubLj+fzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1234/1424] null_blk: register configfs subsystem after creating default devices
Date: Sat, 12 Sep 2026 09:01:06 +0200
Message-ID: <20260912065634.916901368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit c9d293d6bb0575fcb1f3408129453187e2a28a4e ]

In null_init(), configfs_register_subsystem() currently runs before
register_blkdev(), so when null_blk is built as a module, a racing mkdir()
+ poweron from userspace can reach null_add_dev() while null_major is still
0. __add_disk() then hits WARN_ON(disk->minors) (major=0 with minors!=0)
and fails:

[root@fedora ~]# [ 2366.521436] WARNING: block/genhd.c:476 at __add_disk+0x8a7/0xde0,
[ 2366.523552] Modules linked in: null_blk(+) nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
[ 2366.529081] CPU: 26 UID: 0 PID: 1600 Comm: sh Not tainted 7.2.0-rc1+ #66 PREEMPT(full)
......
[ 2366.547251] Call Trace:
[ 2366.547575]  <TASK>
[ 2366.547831]  ? _raw_spin_lock+0x84/0xe0
[ 2366.548260]  add_disk_fwnode+0x114/0x560
[ 2366.548739]  null_add_dev+0x102d/0x1b80 [null_blk]
[ 2366.549310]  ? __pfx_null_add_dev+0x10/0x10 [null_blk]
[ 2366.549906]  ? mutex_lock+0xde/0x1c0
[ 2366.550361]  ? __pfx_mutex_lock+0x10/0x10
[ 2366.550827]  nullb_device_power_store+0x1e7/0x280 [null_blk]
[ 2366.551499]  ? __pfx_nullb_device_power_store+0x10/0x10 [null_blk]
[ 2366.552177]  ? __kmalloc_cache_noprof+0x1f5/0x470
[ 2366.552748]  ? configfs_write_iter+0x35c/0x4e0
[ 2366.553242]  configfs_write_iter+0x286/0x4e0
[ 2366.553787]  vfs_write+0x52d/0xd00
[ 2366.554169]  ? __pfx_vfs_write+0x10/0x10
[ 2366.554679]  ? __pfx___css_rstat_updated+0x10/0x10
[ 2366.555196]  ? fdget_pos+0x1cf/0x4c0
[ 2366.555649]  ksys_write+0xfc/0x1d0
......

Additionally, the err_dev path destroys all devices on nullb_list while
configfs is still registered. If a racing mkdir() + poweron puts a user
device on the list, null_destroy_dev()->null_free_dev() kfrees the user
device's nullb_device but /sys/kernel/config/nullb/<name> is still
reachable. Any userspace access to the item will trigger a UAF.

For simplicity, move configfs_register_subsystem() to the end to solve
the problems above.

Fixes: 3bf2bd20734e ("nullb: add configfs interface")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-3-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index c375caf1b2f8a..bec087daae9cd 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2328,15 +2328,9 @@ static int __init null_init(void)
 	config_group_init(&nullb_subsys.su_group);
 	mutex_init(&nullb_subsys.su_mutex);
 
-	ret = configfs_register_subsystem(&nullb_subsys);
-	if (ret)
-		return ret;
-
 	null_major = register_blkdev(0, "nullb");
-	if (null_major < 0) {
-		ret = null_major;
-		goto err_conf;
-	}
+	if (null_major < 0)
+		return null_major;
 
 	for (i = 0; i < nr_devices; i++) {
 		ret = null_create_dev();
@@ -2344,6 +2338,10 @@ static int __init null_init(void)
 			goto err_dev;
 	}
 
+	ret = configfs_register_subsystem(&nullb_subsys);
+	if (ret)
+		goto err_dev;
+
 	pr_info("module loaded\n");
 	return 0;
 
@@ -2353,8 +2351,6 @@ static int __init null_init(void)
 		null_destroy_dev(nullb);
 	}
 	unregister_blkdev(null_major, "nullb");
-err_conf:
-	configfs_unregister_subsystem(&nullb_subsys);
 	return ret;
 }
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638DB21E082;
	Wed, 19 Mar 2025 14:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395170; cv=none; b=JwrGAbZIosUVjHH/JutdxbSTY0Jp48Hu3jrzjeQ14f2OTkFlKOrnd2UTDu/lqz4Ybwb/5gJKHb1tr1xX0x9jmlFrR0SeL93iXoZFs8ml4O0bQRZv5zw8YQe4OcvyAcvb87P8HT3c00rjtGUnFbKUeikfZP1Nupva4j+ErH3lQr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395170; c=relaxed/simple;
	bh=glJpvshQcZ27C9BKugudcnC8SW+/8MSPGCTlys8/uwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcR29D+eAwfcaAzsc/DR1sy/tTPI8wjxV07ZmuqaHdRkcBMVp5yJnvLoVF41wZr2uJiStU9412A1PosfyIvkkKoMfkLCNxX8MJdNMAgU79SzzUoOPz1YzlIEm0g3MylwMH32/UMUo8R2w8e84fdSA/dcDm9EIz+HxKDxCRux+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjEZGCDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjEZGCDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F29C4CEE4;
	Wed, 19 Mar 2025 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395170;
	bh=glJpvshQcZ27C9BKugudcnC8SW+/8MSPGCTlys8/uwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjEZGCDV30WjMSJYFpMtBkA4AkJEdANyEcrhgxvVNSz8M0HNsSrzF2mQFkx6bhLOi
	 ypHfoBBK9gJq4I2HJZMWtV2u617sb1up1m6MmM0SrEVkFMsuYUV0bz1EzNmK/cljeY
	 GUDO7SItI+pxTJhwjN2T85+iKvYeMFl8nF/qizVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 003/166] zram: fix NULL pointer in comp_algorithm_show()
Date: Wed, 19 Mar 2025 07:29:34 -0700
Message-ID: <20250319143020.076417805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

commit f364cdeb38938f9d03061682b8ff3779dd1730e5 upstream.

LTP reported a NULL pointer dereference as followed:

 CPU: 7 UID: 0 PID: 5995 Comm: cat Kdump: loaded Not tainted 6.12.0-rc6+ #3
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __pi_strcmp+0x24/0x140
 lr : zcomp_available_show+0x60/0x100 [zram]
 sp : ffff800088b93b90
 x29: ffff800088b93b90 x28: 0000000000000001 x27: 0000000000400cc0
 x26: 0000000000000ffe x25: ffff80007b3e2388 x24: 0000000000000000
 x23: ffff80007b3e2390 x22: ffff0004041a9000 x21: ffff80007b3e2900
 x20: 0000000000000000 x19: 0000000000000000 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
 x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: ffff80007b3e2900 x9 : ffff80007b3cb280
 x8 : 0101010101010101 x7 : 0000000000000000 x6 : 0000000000000000
 x5 : 0000000000000040 x4 : 0000000000000000 x3 : 00656c722d6f7a6c
 x2 : 0000000000000000 x1 : ffff80007b3e2900 x0 : 0000000000000000
 Call trace:
  __pi_strcmp+0x24/0x140
  comp_algorithm_show+0x40/0x70 [zram]
  dev_attr_show+0x28/0x80
  sysfs_kf_seq_show+0x90/0x140
  kernfs_seq_show+0x34/0x48
  seq_read_iter+0x1d4/0x4e8
  kernfs_fop_read_iter+0x40/0x58
  new_sync_read+0x9c/0x168
  vfs_read+0x1a8/0x1f8
  ksys_read+0x74/0x108
  __arm64_sys_read+0x24/0x38
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x38/0x138
  el0t_64_sync_handler+0xc0/0xc8
  el0t_64_sync+0x188/0x190

The zram->comp_algs[ZRAM_PRIMARY_COMP] can be NULL in zram_add() if
comp_algorithm_set() has not been called.  User can access the zram device
by sysfs after device_add_disk(), so there is a time window to trigger the
NULL pointer dereference.  Move it ahead device_add_disk() to make sure
when user can access the zram device, it is ready.  comp_algorithm_set()
is protected by zram->init_lock in other places and no such problem.

Link: https://lkml.kernel.org/r/20241108100147.3776123-1-liushixin2@huawei.com
Fixes: 7ac07a26dea7 ("zram: preparation for multi-zcomp support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[This fix does not backport zram_comp_params_reset which was introduced after
 v6.6, in commit f2bac7ad187d ("zram: introduce zcomp_params structure")]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2247,6 +2247,8 @@ static int zram_add(void)
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
+
 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
 	/* zram devices sort of resembles non-rotational disks */
@@ -2281,8 +2283,6 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
-
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;



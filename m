Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F937348C55;
	Wed, 20 May 2026 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301035; cv=none; b=cY1HkxQeBdtvZcGp1vYyL4OHZ86yqTgQP7cUa8e1/aKahLmFfuNTMRL5xBkEnaM9IUoaEFMK7uAAbZe6fAx0iD3oD1wgEXWRECExkU2WnT0rYeky2efllar59Hd34LobJTigtwiyzFeL5Ri2o9BCASapDNE1wRjA19XiNfnyl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301035; c=relaxed/simple;
	bh=e/lENJURfKN8ZRllY/6qktSQQ/HI9zqIMUfpBqOMSkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoXd4wO3O/ulZgpJQbNaldZ32w41PMgWWIBKVjx+cGHdiOVPwuegTYRXv6aVyHI5T0W2hBsT12CWEsB0aosby7c85ecw3lKUC00nwj8477Z0ys/TYnYwQDYo6vfpPpnl/6TstLWvEovQlMAi9GBgYjz4WuZlwwLH/bbAIvFu8SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3Cn1uuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3Cn1uuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ADE1F000E9;
	Wed, 20 May 2026 18:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301033;
	bh=aOvbJF1oXQLU31IQN7TM+1tBr4x47EPHnVs5JCle1Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3Cn1uuOONXKpeMU6kJ3w4FWUefPZj3m+NERhxvqHeBOLjfsrmEj+SOlTc+NsO1H/
	 HkXVJfKuophB5TrunvkoVQQeaMsf1e9TI4TMb0tGvXCWQl+vofrHy8JJf9HPZtyG9e
	 7TdRGUln2AHcvFvcGFPDrVC2heGA3vbSXzHxI4EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/666] scsi: sg: Resolve soft lockup issue when opening /dev/sgX
Date: Wed, 20 May 2026 18:20:13 +0200
Message-ID: <20260520162119.972498364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit d06a310b45e153872033dd0cf19d5a2279121099 ]

The parameter def_reserved_size defines the default buffer size reserved
for each Sg_fd and should be restricted to a range between 0 and 1,048,576
(see https://tldp.org/HOWTO/SCSI-Generic-HOWTO/proc.html).  Although the
function sg_proc_write_dressz enforces this limit, it is possible to bypass
it by directly modifying the module parameter as shown below, which then
causes a soft lockup:

echo -1 > /sys/module/sg/parameters/def_reserved_size
exec 4<> /dev/sg0

watchdog: BUG: soft lockup - CPU#5 stuck for 26 seconds! [bash:537]
Modules loaded:
CPU: 5 UID: 0 PID: 537 Command: bash, kernel version 6.19.0-rc3+ #134,
PREEMPT disabled
Hardware: QEMU Standard PC (i440FX + PIIX, 1996), BIOS version
1.16.1-2.fc37 dated 04/01/2014
...
Call Trace:

  sg_build_reserve+0x5c/0xa0
  sg_add_sfp+0x168/0x270
  sg_open+0x16e/0x340
  chrdev_open+0xbe/0x230
  do_dentry_open+0x175/0x480
  vfs_open+0x34/0xf0
  do_open+0x265/0x3d0
  path_openat+0x110/0x290
  do_filp_open+0xc3/0x170
  do_sys_openat2+0x71/0xe0
  __x64_sys_openat+0x6d/0xa0
  do_syscall_64+0x62/0x310
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The fix is to use module_param_cb to validate and reject invalid values
assigned to def_reserved_size.

Fixes: 6460e75a104d ("[SCSI] sg: fixes for large page_size")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260127062044.3034148-3-yangerkun@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0100a2828f803..f85a52e9a7a7f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1622,10 +1622,35 @@ sg_remove_device(struct device *cl_dev)
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
-module_param_named(def_reserved_size, def_reserved_size, int,
-		   S_IRUGO | S_IWUSR);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
+static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
+{
+	int size, ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtoint(val, 0, &size);
+	if (ret)
+		return ret;
+
+	/* limit to 1 MB */
+	if (size < 0 || size > 1048576)
+		return -ERANGE;
+
+	def_reserved_size = size;
+	return 0;
+}
+
+static const struct kernel_param_ops def_reserved_size_ops = {
+	.set	= def_reserved_size_set,
+	.get	= param_get_int,
+};
+
+module_param_cb(def_reserved_size, &def_reserved_size_ops, &def_reserved_size,
+		   S_IRUGO | S_IWUSR);
+
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
 MODULE_LICENSE("GPL");
-- 
2.53.0




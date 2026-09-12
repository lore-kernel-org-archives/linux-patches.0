Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D7E399899;
	Sat, 12 Sep 2026 20:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243253; cv=none; b=HI0eYH01QYeXk6q3zRtehDBXv8Ij+dYNObVte8tSEIR4D5AQ28qWmGM4NHcKiZ63Ak4HqZ0r5T9x6FkFRXLZur9VJy+sYLziCKaXoKuF7/seeWGZW9dovD4/XyZS/t3mYRmJQu2nAxZQWIAoxsmKDH/gCmJ5bGZen4rk9jE8aK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243253; c=relaxed/simple;
	bh=QV2yz9ckfBWik576i6kosJvjkf43OvY943s+gvTHNw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQZdn5NwecB0Gm4VkBLcmGmIvF3EtCg+HoxSsWiIeloTNr6z23M84PFEniiD6kdHH21xsHKQKnzfokGe83svGcY38Xp9p+DAWs10ks8T67omnviXuKRv4s7D294Em5gaB1vpupDfT5hFZQk5W2Reg9WD5MOF64UKWMjomLW/kRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE+UxaZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE+UxaZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6861F000FF;
	Sat, 12 Sep 2026 20:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243251;
	bh=l/SjL+1haJJ2Niki3V+LEJ7xSHDq+3RTJ50nj5jACo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE+UxaZ3FKWY0anBAxC7jOBt0pAU1wHOJqZ8mTQi8IB4gwigAWMmSGu08ZtjsLMPS
	 rge5SkdRCgyQKJO6ZG+UH3M6X62MM7QlFmXLzh4Hh0j4AhXA/QD3Low2Yabbcnivun
	 G5P1P+GU4ZejkKuS7Rxs39ZZ4NYT3hAe+7X2xWfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 688/798] ubi: fastmap: Add fastmap control support for module parameter
Date: Sat, 12 Sep 2026 09:05:16 +0200
Message-ID: <20260912065532.870007494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: ZhaoLong Wang <wangzhaolong1@huawei.com>

[ Upstream commit 7af73882dd1cea5d32ac0cc9eda263635295de50 ]

The UBI driver can use the IOCTL to disable the fastmap after the
mainline 669d204469c4 ("ubi: fastmap: Add fastmap control support
for 'UBI_IOCATT' ioctl"). To destroy the fastmap on a old image,
we need to reattach the device in user space.

However, if the UBI driver build in kernel and the UBI volume is
the root partition, the UBI device cannot be reattached in user
space. To disable fastmap in this case, the UBI must provide the
kernel cmdline parameters to disable fastmap during attach.

This patch add 'enable_fm' as 5th module init parameter of mtd=xx to
control fastmap enable or not. When the value is 0, fastmap will not
create and existed fastmap will destroyed for the given ubi device.
Default value is 0.

To enable or disable fastmap during module loading, fm_autoconvert
must be set to non-zero.

+-----------------+---------------+---------------------------+
|        \        |  enable_fm=0  |  enable_fm=1              |
+-----------------+---------------+---------------------------+
|fm_autoconvert=Y |  disable fm   |  enable fm                |
+---------------------------------+---------------------------+
|fm_autoconvert=N |  disable fm   | Enable fastmap if fastmap |
|                 |               | exists on the old image   |
+-------------------------------------------------------------+

Example:
  # - Attach mtd1 to ubi1, disable fastmap, mtd2 to ubi2, enable
      fastmap.
  # modprobe ubi mtd=1,0,0,1,0 mtd=2,0,0,2,1 fm_autoconvert=1

  # - If 5th parameter is not specified, the value is 0, fastmap is
      disable
  # modprobe ubi mtd=1 fm_autoconvert=1

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216623
Signed-off-by: ZhaoLong Wang <wangzhaolong1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 5b0a6b554e12 ("ubi: Fix rollback for explicit UBI device numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 9656f6ba0ac11..ed87f33f3a0fa 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -35,7 +35,7 @@
 #define MTD_PARAM_LEN_MAX 64
 
 /* Maximum number of comma-separated items in the 'mtd=' parameter */
-#define MTD_PARAM_MAX_COUNT 4
+#define MTD_PARAM_MAX_COUNT 5
 
 /* Maximum value for the number of bad PEBs per 1024 PEBs */
 #define MAX_MTD_UBI_BEB_LIMIT 768
@@ -52,12 +52,14 @@
  *        string
  * @vid_hdr_offs: VID header offset
  * @max_beb_per1024: maximum expected number of bad PEBs per 1024 PEBs
+ * @enable_fm: enable fastmap when value is non-zero
  */
 struct mtd_dev_param {
 	char name[MTD_PARAM_LEN_MAX];
 	int ubi_num;
 	int vid_hdr_offs;
 	int max_beb_per1024;
+	int enable_fm;
 };
 
 /* Numbers of elements set in the @mtd_dev_param array */
@@ -1272,7 +1274,7 @@ static int __init ubi_init(void)
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, p->ubi_num,
 					 p->vid_hdr_offs, p->max_beb_per1024,
-					 false);
+					 p->enable_fm == 0 ? true : false);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			pr_err("UBI error: cannot attach mtd%d\n",
@@ -1452,7 +1454,7 @@ static int ubi_mtd_param_parse(const char *val, const struct kernel_param *kp)
 		int err = kstrtoint(token, 10, &p->max_beb_per1024);
 
 		if (err) {
-			pr_err("UBI error: bad value for max_beb_per1024 parameter: %s",
+			pr_err("UBI error: bad value for max_beb_per1024 parameter: %s\n",
 			       token);
 			return -EINVAL;
 		}
@@ -1463,13 +1465,25 @@ static int ubi_mtd_param_parse(const char *val, const struct kernel_param *kp)
 		int err = kstrtoint(token, 10, &p->ubi_num);
 
 		if (err) {
-			pr_err("UBI error: bad value for ubi_num parameter: %s",
+			pr_err("UBI error: bad value for ubi_num parameter: %s\n",
 			       token);
 			return -EINVAL;
 		}
 	} else
 		p->ubi_num = UBI_DEV_NUM_AUTO;
 
+	token = tokens[4];
+	if (token) {
+		int err = kstrtoint(token, 10, &p->enable_fm);
+
+		if (err) {
+			pr_err("UBI error: bad value for enable_fm parameter: %s\n",
+				token);
+			return -EINVAL;
+		}
+	} else
+		p->enable_fm = 0;
+
 	mtd_devs += 1;
 	return 0;
 }
@@ -1482,11 +1496,13 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|pa
 		      "Optional \"max_beb_per1024\" parameter specifies the maximum expected bad eraseblock per 1024 eraseblocks. (default value ("
 		      __stringify(CONFIG_MTD_UBI_BEB_LIMIT) ") if 0)\n"
 		      "Optional \"ubi_num\" parameter specifies UBI device number which have to be assigned to the newly created UBI device (assigned automatically by default)\n"
+		      "Optional \"enable_fm\" parameter determines whether to enable fastmap during attach. If the value is non-zero, fastmap is enabled. Default value is 0.\n"
 		      "\n"
 		      "Example 1: mtd=/dev/mtd0 - attach MTD device /dev/mtd0.\n"
 		      "Example 2: mtd=content,1984 mtd=4 - attach MTD device with name \"content\" using VID header offset 1984, and MTD device number 4 with default VID header offset.\n"
 		      "Example 3: mtd=/dev/mtd1,0,25 - attach MTD device /dev/mtd1 using default VID header offset and reserve 25*nand_size_in_blocks/1024 erase blocks for bad block handling.\n"
 		      "Example 4: mtd=/dev/mtd1,0,0,5 - attach MTD device /dev/mtd1 to UBI 5 and using default values for the other fields.\n"
+		      "example 5: mtd=1,0,0,5 mtd=2,0,0,6,1 - attach MTD device /dev/mtd1 to UBI 5 and disable fastmap; attach MTD device /dev/mtd2 to UBI 6 and enable fastmap.(only works when fastmap is enabled and fm_autoconvert=Y).\n"
 		      "\t(e.g. if the NAND *chipset* has 4096 PEB, 100 will be reserved for this UBI device).");
 #ifdef CONFIG_MTD_UBI_FASTMAP
 module_param(fm_autoconvert, bool, 0644);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2152E06E4;
	Sat, 12 Sep 2026 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231356; cv=none; b=MphCy7gqJ2K4GZg+ek1SV63ZU04K8bJ+aJmLFkF3EYlWZ+8WIGEr9TgszPq1xV34dbHBqFFCtH08R5BZGAb6JOYDrF2LZ6pDJDQ+OQR6obg0Tjl+lBSRVKf9PaOlYhRdkd1AQ6oBrN1+SWhNrs2+muz+w99UMbqMu90k3D+JvU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231356; c=relaxed/simple;
	bh=3rU7rZYl3S8LGhixTpzcmlYSW9wRJ+S4AY+iVWs9yIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpjvSKJNUOyNLLehRddbEhjKCIi3clDaKVtC8fOauPZUWa2cwm9jNE0iG3PM4RTNSwxhFj7oxjtU985r4Zwk5CqPLE3R0z9wXiOfp89zSSpgF+pglcawVhE9aDPjiUWdP8X62fSHSoLibCrx/WZrbYbz8Ab1oCOVqdyzsCFTxmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KschRa/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KschRa/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C01F000FF;
	Sat, 12 Sep 2026 16:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231355;
	bh=o9ZG2PH0cV7lzjdXTPK/+TYJYO7yqrmCLEodSmS7YAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KschRa/k75lHlV2inMO7zgvnTfO3G+Or4YiarF9Z0t5wiSEgPDtcB/MXdBcO6HYLD
	 Jcgu6LON/m6iL83gdKvAHWopfq7SA7McbgQQYYphCp4f9aS0NT2c/9M1LzEIf/Urlg
	 Ti7pi1NFp788y+m57a/x2A8qtOxZnqOVXXYmERUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0983/1191] ubi: fastmap: Add module parameter to control reserving filling pool PEBs
Date: Sat, 12 Sep 2026 09:01:51 +0200
Message-ID: <20260912065610.284640253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit d4c48e5b58f12835de779f5425ef741c4d0fb53e ]

Adding 6th module parameter in 'mtd=xxx' to control whether or not
reserving PEBs for filling pool/wl_pool.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 5b0a6b554e12 ("ubi: Fix rollback for explicit UBI device numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 26 ++++++++++++++++++++++----
 drivers/mtd/ubi/cdev.c  |  3 ++-
 drivers/mtd/ubi/ubi.h   |  2 +-
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index ecf8c5e780f51..a0f4f4be17c0a 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -35,7 +35,7 @@
 #define MTD_PARAM_LEN_MAX 64
 
 /* Maximum number of comma-separated items in the 'mtd=' parameter */
-#define MTD_PARAM_MAX_COUNT 5
+#define MTD_PARAM_MAX_COUNT 6
 
 /* Maximum value for the number of bad PEBs per 1024 PEBs */
 #define MAX_MTD_UBI_BEB_LIMIT 768
@@ -54,6 +54,7 @@
  * @vid_hdr_offs: VID header offset
  * @max_beb_per1024: maximum expected number of bad PEBs per 1024 PEBs
  * @enable_fm: enable fastmap when value is non-zero
+ * @need_resv_pool: reserve pool->max_size pebs when value is none-zero
  */
 struct mtd_dev_param {
 	char name[MTD_PARAM_LEN_MAX];
@@ -61,6 +62,7 @@ struct mtd_dev_param {
 	int vid_hdr_offs;
 	int max_beb_per1024;
 	int enable_fm;
+	int need_resv_pool;
 };
 
 /* Numbers of elements set in the @mtd_dev_param array */
@@ -826,6 +828,7 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * @vid_hdr_offset: VID header offset
  * @max_beb_per1024: maximum expected number of bad PEB per 1024 PEBs
  * @disable_fm: whether disable fastmap
+ * @need_resv_pool: whether reserve pebs to fill fm_pool
  *
  * This function attaches MTD device @mtd_dev to UBI and assign @ubi_num number
  * to the newly created UBI device, unless @ubi_num is %UBI_DEV_NUM_AUTO, in
@@ -841,7 +844,8 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * @ubi_devices_mutex.
  */
 int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
-		       int vid_hdr_offset, int max_beb_per1024, bool disable_fm)
+		       int vid_hdr_offset, int max_beb_per1024, bool disable_fm,
+		       bool need_resv_pool)
 {
 	struct ubi_device *ubi;
 	int i, err;
@@ -951,7 +955,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 		UBI_FM_MIN_POOL_SIZE);
 
 	ubi->fm_wl_pool.max_size = ubi->fm_pool.max_size / 2;
-	ubi->fm_pool_rsv_cnt = ubi->fm_pool.max_size;
+	ubi->fm_pool_rsv_cnt = need_resv_pool ? ubi->fm_pool.max_size : 0;
 	ubi->fm_disabled = (!fm_autoconvert || disable_fm) ? 1 : 0;
 	if (fm_debug)
 		ubi_enable_dbg_chk_fastmap(ubi);
@@ -1274,7 +1278,8 @@ static int __init ubi_init(void)
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, p->ubi_num,
 					 p->vid_hdr_offs, p->max_beb_per1024,
-					 p->enable_fm == 0);
+					 p->enable_fm == 0,
+					 p->need_resv_pool != 0);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			pr_err("UBI error: cannot attach mtd%d\n",
@@ -1483,6 +1488,18 @@ static int ubi_mtd_param_parse(const char *val, const struct kernel_param *kp)
 	} else
 		p->enable_fm = 0;
 
+	token = tokens[5];
+	if (token) {
+		int err = kstrtoint(token, 10, &p->need_resv_pool);
+
+		if (err) {
+			pr_err("UBI error: bad value for need_resv_pool parameter: %s\n",
+				token);
+			return -EINVAL;
+		}
+	} else
+		p->need_resv_pool = 0;
+
 	mtd_devs += 1;
 	return 0;
 }
@@ -1496,6 +1513,7 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|pa
 		      __stringify(CONFIG_MTD_UBI_BEB_LIMIT) ") if 0)\n"
 		      "Optional \"ubi_num\" parameter specifies UBI device number which have to be assigned to the newly created UBI device (assigned automatically by default)\n"
 		      "Optional \"enable_fm\" parameter determines whether to enable fastmap during attach. If the value is non-zero, fastmap is enabled. Default value is 0.\n"
+		      "Optional \"need_resv_pool\" parameter determines whether to reserve pool->max_size pebs during attach. If the value is non-zero, peb reservation is enabled. Default value is 0.\n"
 		      "\n"
 		      "Example 1: mtd=/dev/mtd0 - attach MTD device /dev/mtd0.\n"
 		      "Example 2: mtd=content,1984 mtd=4 - attach MTD device with name \"content\" using VID header offset 1984, and MTD device number 4 with default VID header offset.\n"
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index f43430b9c1e65..98aa00344b29b 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -1041,7 +1041,8 @@ static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
 		 */
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset,
-					 req.max_beb_per1024, !!req.disable_fm);
+					 req.max_beb_per1024, !!req.disable_fm,
+					 false);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0)
 			put_mtd_device(mtd);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 455d2018a5353..5cd4f30edd57c 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -944,7 +944,7 @@ int ubi_io_write_vid_hdr(struct ubi_device *ubi, int pnum,
 /* build.c */
 int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 		       int vid_hdr_offset, int max_beb_per1024,
-		       bool disable_fm);
+		       bool disable_fm, bool need_resv_pool);
 int ubi_detach_mtd_dev(int ubi_num, int anyway);
 struct ubi_device *ubi_get_device(int ubi_num);
 void ubi_put_device(struct ubi_device *ubi);
-- 
2.53.0




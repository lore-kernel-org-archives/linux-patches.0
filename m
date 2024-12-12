Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB10225A21;
	Thu, 12 Dec 2024 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025494; cv=none; b=VyWeO0J4guZ10/QqP4eO2hgvAVlmZU3Hi+d4rLhsScxUc2XGdgZ7y8/sucusu+n5DXB5R7FEMhn1op+44K2tC03w7nxFfyPn8fm5+FQoRu8RYbkUf30kVhLZycGWMIQb2nFsU9i3pHDLgnzl5iNHFMYknHCyTuuTuxDSa3XhFnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025494; c=relaxed/simple;
	bh=YfvyOV+8zuC+3c75+q8wELOjfEbhlzFhaARsHYgGBHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsqINbVdBl4n1CUMj/wjiFlXCRW7Dhq4w784uF1NQmZHyXOTfrg9KqGJ0yZFFxoen+sh9NvACjmM2YdD78Qis4LcLFkqd0Og/x3M2q9HuMmMumds+9IjMbgg761C0IlA4zQhCO4rxXK7fQRZHbAdYRGUIIZGHPuDrTtsZBnsTgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBh/kTTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBh/kTTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF659C4CECE;
	Thu, 12 Dec 2024 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025494;
	bh=YfvyOV+8zuC+3c75+q8wELOjfEbhlzFhaARsHYgGBHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBh/kTTaBzOY51Hf3wquy370gWxBdxn0zuzPO2LE6wnux83aQnZOLoOOk/fsyBptv
	 g92cT7qLduw3hRggxMUqKOb+8wL4d0zK64GDPLE0uQVuRbLIDfGi6QZj1RaLgsKL9f
	 2M9Szm0lckgkB6oX2jUverLkBMPN8SPjR5WOWrug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/321] ubi: fastmap: Fix duplicate slab cache names while attaching
Date: Thu, 12 Dec 2024 16:01:47 +0100
Message-ID: <20241212144237.451668948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit bcddf52b7a17adcebc768d26f4e27cf79adb424c ]

Since commit 4c39529663b9 ("slab: Warn on duplicate cache names when
DEBUG_VM=y"), the duplicate slab cache names can be detected and a
kernel WARNING is thrown out.
In UBI fast attaching process, alloc_ai() could be invoked twice
with the same slab cache name 'ubi_aeb_slab_cache', which will trigger
following warning messages:
 kmem_cache of name 'ubi_aeb_slab_cache' already exists
 WARNING: CPU: 0 PID: 7519 at mm/slab_common.c:107
          __kmem_cache_create_args+0x100/0x5f0
 Modules linked in: ubi(+) nandsim [last unloaded: nandsim]
 CPU: 0 UID: 0 PID: 7519 Comm: modprobe Tainted: G 6.12.0-rc2
 RIP: 0010:__kmem_cache_create_args+0x100/0x5f0
 Call Trace:
   __kmem_cache_create_args+0x100/0x5f0
   alloc_ai+0x295/0x3f0 [ubi]
   ubi_attach+0x3c3/0xcc0 [ubi]
   ubi_attach_mtd_dev+0x17cf/0x3fa0 [ubi]
   ubi_init+0x3fb/0x800 [ubi]
   do_init_module+0x265/0x7d0
   __x64_sys_finit_module+0x7a/0xc0

The problem could be easily reproduced by loading UBI device by fastmap
with CONFIG_DEBUG_VM=y.
Fix it by using different slab names for alloc_ai() callers.

Fixes: d2158f69a7d4 ("UBI: Remove alloc_ai() slab name from parameter list")
Fixes: fdf10ed710c0 ("ubi: Rework Fastmap attach base code")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/attach.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 10b2459f8951e..98fb59ed996f8 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1447,7 +1447,7 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	return err;
 }
 
-static struct ubi_attach_info *alloc_ai(void)
+static struct ubi_attach_info *alloc_ai(const char *slab_name)
 {
 	struct ubi_attach_info *ai;
 
@@ -1461,7 +1461,7 @@ static struct ubi_attach_info *alloc_ai(void)
 	INIT_LIST_HEAD(&ai->alien);
 	INIT_LIST_HEAD(&ai->fastmap);
 	ai->volumes = RB_ROOT;
-	ai->aeb_slab_cache = kmem_cache_create("ubi_aeb_slab_cache",
+	ai->aeb_slab_cache = kmem_cache_create(slab_name,
 					       sizeof(struct ubi_ainf_peb),
 					       0, 0, NULL);
 	if (!ai->aeb_slab_cache) {
@@ -1491,7 +1491,7 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info **ai)
 
 	err = -ENOMEM;
 
-	scan_ai = alloc_ai();
+	scan_ai = alloc_ai("ubi_aeb_slab_cache_fastmap");
 	if (!scan_ai)
 		goto out;
 
@@ -1557,7 +1557,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	int err;
 	struct ubi_attach_info *ai;
 
-	ai = alloc_ai();
+	ai = alloc_ai("ubi_aeb_slab_cache");
 	if (!ai)
 		return -ENOMEM;
 
@@ -1575,7 +1575,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		if (err > 0 || mtd_is_eccerr(err)) {
 			if (err != UBI_NO_FASTMAP) {
 				destroy_ai(ai);
-				ai = alloc_ai();
+				ai = alloc_ai("ubi_aeb_slab_cache");
 				if (!ai)
 					return -ENOMEM;
 
@@ -1614,7 +1614,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (ubi->fm && ubi_dbg_chk_fastmap(ubi)) {
 		struct ubi_attach_info *scan_ai;
 
-		scan_ai = alloc_ai();
+		scan_ai = alloc_ai("ubi_aeb_slab_cache_dbg_chk_fastmap");
 		if (!scan_ai) {
 			err = -ENOMEM;
 			goto out_wl;
-- 
2.43.0




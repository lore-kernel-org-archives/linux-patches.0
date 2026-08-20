Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB00537C925;
	Thu, 20 Aug 2026 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238772; cv=none; b=C43VKMA9Eyi0SuYg+YbFBSpVU4XxD19N+32Zzc/F4/Zgd1npBcWVCXdCmylp9ofNiLDQzzWLqje8Xw286EzW9gi06aoxuRivANCnjXyDyTnp3KQ07b8DpHAI0Bkn9ZKchYLYyhRzI7WXyYFy6vywYmNJVzd3qcl+EHDhrLk6ldY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238772; c=relaxed/simple;
	bh=+sxbeqKq3hcp3DnvrB0jvJS68/cJrSnq9/Ld7N65+44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaBGUWq9sNg7A/hbKFjSU7vgN5w5xSixYqVrd/LTdbhKCDh3iHLzhzT6n7dnHIVO57IhglE7MtkqAR8Ap0NcL9GwGnPLb5ketwvKzTesmpCcXuH9EULoJjfHKU78oSGsTrvNiHFuqQh49/DJE5OzvssdOKB9cpUzoze+WzpW/ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNsWmb15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNsWmb15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDE81F000E9;
	Thu, 20 Aug 2026 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238770;
	bh=f2xOplbiUp/mxSGcO5sN+khwUL6DksCH06UdOBpWlxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNsWmb15HnEUikKwtS3niUay/ikoPgxTuqDEri2VcMAI0m8e20AN7Wk9Gx23GNFyo
	 u1yhbU/MP1w+IMXxy6hNyorbPSGcj20tSVkh1ZEmwikppH3Oo0SxeM6vn7N5nNwrsg
	 hb47aDPhWruy7LX8/mBT6e2X4XqVesMjVEfCWmpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liyuan Pang <pangliyuan1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/217] ubi: fastmap: fix ubi->fm memory leak
Date: Thu, 20 Aug 2026 16:52:52 +0200
Message-ID: <20260820145237.692750245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liyuan Pang <pangliyuan1@huawei.com>

[ Upstream commit d133e30aabc7c8eb8206827f8fbe0f3679adb911 ]

The problem is that scan_fast() allocate memory for ubi->fm
and ubi->fm->e[x], but if the following attach process fails
in ubi_wl_init or ubi_read_volume_table, the whole attach
process will fail without executing ubi_wl_close to free the
memory under ubi->fm.

Fix this by add a new ubi_free_fastmap function in fastmap.c
to free the memory allocated for fm.

If SLUB_DEBUG and KUNIT are enabled, the following warning messages
will show:
ubi0: detaching mtd0
ubi0: mtd0 is detached
ubi0: default fastmap pool size: 200
ubi0: default fastmap WL pool size: 100
ubi0: attaching mtd0
ubi0: attached by fastmap
ubi0: fastmap pool size: 200
ubi0: fastmap WL pool size: 100
ubi0 error: ubi_wl_init [ubi]: no enough physical eraseblocks (4, need 203)
ubi0 error: ubi_attach_mtd_dev [ubi]: failed to attach mtd0, error -28
UBI error: cannot attach mtd0
=================================================================
BUG ubi_wl_entry_slab (Tainted: G    B      O L   ): Objects remaining in ubi_wl_entry_slab on __kmem_cache_shutdown()
-----------------------------------------------------------------------------

Slab 0xffff2fd23a40cd00 objects=22 used=1 fp=0xffff2fd1d0334fd8 flags=0x883fffc010200(slab|head|section=34|node=0|zone=1|lastcpupid=0x7fff)
CPU: 0 PID: 5884 Comm: insmod Tainted: G    B      O L    5.10.0 #1
Hardware name: LS1043A RDB Board (DT)
Call trace:
 dump_backtrace+0x0/0x198
 show_stack+0x18/0x28
 dump_stack+0xe8/0x15c
 slab_err+0x94/0xc0
 __kmem_cache_shutdown+0x1fc/0x39c
 kmem_cache_destroy+0x48/0x138
 ubi_init+0x1d4/0xf34 [ubi]
 do_one_initcall+0xb4/0x24c
 do_init_module+0x4c/0x1dc
 load_module+0x212c/0x2260
 __se_sys_finit_module+0xb4/0xd8
 __arm64_sys_finit_module+0x18/0x28
 el0_svc_common.constprop.0+0x78/0x1a0
 do_el0_svc+0x78/0x90
 el0_svc+0x20/0x38
 el0_sync_handler+0xf0/0x140
 normal+0x3d8/0x400
Object 0xffff2fd1d0334e68 @offset=3688
Allocated in ubi_scan_fastmap+0xf04/0xf40 [ubi] age=80 cpu=0 pid=5884
	__slab_alloc.isra.21+0x6c/0xb4
	kmem_cache_alloc+0x1e4/0x80c
	ubi_scan_fastmap+0xf04/0xf40 [ubi]
	ubi_attach+0x1f0/0x3a8 [ubi]
	ubi_attach_mtd_dev+0x810/0xbc8 [ubi]
	ubi_init+0x238/0xf34 [ubi]
	do_one_initcall+0xb4/0x24c
	do_init_module+0x4c/0x1dc
	load_module+0x212c/0x2260
	__se_sys_finit_module+0xb4/0xd8
	__arm64_sys_finit_module+0x18/0x28
	el0_svc_common.constprop.0+0x78/0x1a0
	do_el0_svc+0x78/0x90
	el0_svc+0x20/0x38
	el0_sync_handler+0xf0/0x140
	normal+0x3d8/0x400

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220744

Signed-off-by: Liyuan Pang <pangliyuan1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/attach.c     |  4 +++-
 drivers/mtd/ubi/fastmap-wl.c |  8 +-------
 drivers/mtd/ubi/ubi.h        | 12 ++++++++++++
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index adc47b87b38a..884171871d0e 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1600,7 +1600,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 
 	err = ubi_read_volume_table(ubi, ai);
 	if (err)
-		goto out_ai;
+		goto out_fm;
 
 	err = ubi_wl_init(ubi, ai);
 	if (err)
@@ -1642,6 +1642,8 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 out_vtbl:
 	ubi_free_all_volumes(ubi);
 	vfree(ubi->vtbl);
+out_fm:
+	ubi_free_fastmap(ubi);
 out_ai:
 	destroy_ai(ai);
 	return err;
diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 9bdb6525f128..e2bc1122bfd3 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -530,8 +530,6 @@ int ubi_is_erase_work(struct ubi_work *wrk)
 
 static void ubi_fastmap_close(struct ubi_device *ubi)
 {
-	int i;
-
 	return_unused_pool_pebs(ubi, &ubi->fm_pool);
 	return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
 
@@ -540,11 +538,7 @@ static void ubi_fastmap_close(struct ubi_device *ubi)
 		ubi->fm_anchor = NULL;
 	}
 
-	if (ubi->fm) {
-		for (i = 0; i < ubi->fm->used_blocks; i++)
-			kfree(ubi->fm->e[i]);
-	}
-	kfree(ubi->fm);
+	ubi_free_fastmap(ubi);
 }
 
 /**
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c792b9bcab9b..44803d3329f4 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -969,10 +969,22 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		     struct ubi_attach_info *scan_ai);
 int ubi_fastmap_init_checkmap(struct ubi_volume *vol, int leb_count);
 void ubi_fastmap_destroy_checkmap(struct ubi_volume *vol);
+static inline void ubi_free_fastmap(struct ubi_device *ubi)
+{
+	if (ubi->fm) {
+		int i;
+
+		for (i = 0; i < ubi->fm->used_blocks; i++)
+			kmem_cache_free(ubi_wl_entry_slab, ubi->fm->e[i]);
+		kfree(ubi->fm);
+		ubi->fm = NULL;
+	}
+}
 #else
 static inline int ubi_update_fastmap(struct ubi_device *ubi) { return 0; }
 static inline int ubi_fastmap_init_checkmap(struct ubi_volume *vol, int leb_count) { return 0; }
 static inline void ubi_fastmap_destroy_checkmap(struct ubi_volume *vol) {}
+static inline void ubi_free_fastmap(struct ubi_device *ubi) { }
 #endif
 
 /* block.c */
-- 
2.53.0




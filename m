Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA216156225;
	Wed,  5 Feb 2025 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768123; cv=none; b=JUmo1kSDzRKuysjVSS/ONKO/6QjwEvYhk8/12DHrP3OET2/kBktnfvE6gzDPw8cplH7Hf2uiBU8t63i2ju3uzurKOl+0Jp7vsh5joyvP0B8NIa161v8PHPLe2WyQcxR++Dl2ZHbHVNbC//1iRNGFp9n+eCv3KpBAaj1hLa6geKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768123; c=relaxed/simple;
	bh=EQFymjZYxTolKkPNl//Fkvb1xG7z+tNq6YyqoabItIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAZnfXmHjJB0+9oFgBgogJNyu7TIeYi96MSzx1sF7WiH3DdJ7VqxEeElqFhBQrBgbHCfMRIRThui/7IKDELHxped/dktACIXwH0gntNsU1FoKbM0f9WVsnyMZIpc7UwAxC5tLB1EmqYod9i/T3T+kjnsHB/7GJaN4XK7ft+mymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9GC+Vor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9GC+Vor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CBDC4CED1;
	Wed,  5 Feb 2025 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768123;
	bh=EQFymjZYxTolKkPNl//Fkvb1xG7z+tNq6YyqoabItIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9GC+VormSNFyTTOjWD/TnM99t6gcrJ2p35RgMceafC1bJpCN0piddNbXYSJbaagz
	 r4+odRQpfZCdLGPjVSW7kI//J0o9esKdQNigEePJmW+ry8Jet/iEqNvncR0G7KdRNf
	 qWTaiUNxYUdKisE4yoLbeDuyZZgO6pbMC524QpuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Lam <dennis.lamerice@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 501/623] ubi: Revert "ubi: wl: Close down wear-leveling before nand is suspended"
Date: Wed,  5 Feb 2025 14:44:03 +0100
Message-ID: <20250205134515.386716963@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 844c6fdc13cf3d9d251533631988a58f8356a8c8 ]

Commit 5580cdae05ae ("ubi: wl: Close down wear-leveling before nand is
suspended") added a reboot notification in UBI layer to shutdown the
wear-leveling subsystem, which imported an UAF problem[1]. Besides that,
the method also brings other potential UAF problems, for example:
       reboot             kworker
 ubi_wl_reboot_notifier
  ubi_wl_close
   ubi_fastmap_close
    kfree(ubi->fm)
                     update_fastmap_work_fn
		      ubi_update_fastmap
		       old_fm = ubi->fm
		       if (old_fm && old_fm->e[i]) // UAF!

Actually, the problem fixed by commit 5580cdae05ae ("ubi: wl: Close down
wear-leveling before nand is suspended") has been solved by commit
8cba323437a4 ("mtd: rawnand: protect access to rawnand devices while in
suspend"), which was discussed in [2]. So we can revert the commit
5580cdae05ae ("ubi: wl: Close down wear-leveling before nand is
suspended") directly.

[1] https://lore.kernel.org/linux-mtd/20241208175211.9406-2-dennis.lamerice@gmail.com/
[2] https://lore.kernel.org/all/9bf76f5d-12a4-46ff-90d4-4a7f0f47c381@axis.com/

Fixes: 5580cdae05ae ("ubi: wl: Close down wear-leveling before nand is suspended")
Reported-by: Dennis Lam <dennis.lamerice@gmail.com>
Closes: https://lore.kernel.org/linux-mtd/20241208175211.9406-2-dennis.lamerice@gmail.com/
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Acked-by: Mårten Lindahl <marten.lindahl@axis.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/ubi.h |  2 --
 drivers/mtd/ubi/wl.c  | 21 ---------------------
 2 files changed, 23 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 26cc53ad34ec7..c792b9bcab9bc 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -549,7 +549,6 @@ struct ubi_debug_info {
  * @peb_buf: a buffer of PEB size used for different purposes
  * @buf_mutex: protects @peb_buf
  * @ckvol_mutex: serializes static volume checking when opening
- * @wl_reboot_notifier: close all wear-leveling work before reboot
  *
  * @dbg: debugging information for this UBI device
  */
@@ -652,7 +651,6 @@ struct ubi_device {
 	void *peb_buf;
 	struct mutex buf_mutex;
 	struct mutex ckvol_mutex;
-	struct notifier_block wl_reboot_notifier;
 
 	struct ubi_debug_info dbg;
 };
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 4f6f339d8fb8a..fbd399cf65033 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -89,7 +89,6 @@
 #include <linux/crc32.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
-#include <linux/reboot.h>
 #include "ubi.h"
 #include "wl.h"
 
@@ -128,8 +127,6 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 				 struct ubi_wl_entry *e, struct rb_root *root);
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
-static int ubi_wl_reboot_notifier(struct notifier_block *n,
-				  unsigned long state, void *cmd);
 
 /**
  * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
@@ -1953,13 +1950,6 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (!ubi->ro_mode && !ubi->fm_disabled)
 		ubi_ensure_anchor_pebs(ubi);
 #endif
-
-	if (!ubi->wl_reboot_notifier.notifier_call) {
-		ubi->wl_reboot_notifier.notifier_call = ubi_wl_reboot_notifier;
-		ubi->wl_reboot_notifier.priority = 1; /* Higher than MTD */
-		register_reboot_notifier(&ubi->wl_reboot_notifier);
-	}
-
 	return 0;
 
 out_free:
@@ -2005,17 +1995,6 @@ void ubi_wl_close(struct ubi_device *ubi)
 	kfree(ubi->lookuptbl);
 }
 
-static int ubi_wl_reboot_notifier(struct notifier_block *n,
-				  unsigned long state, void *cmd)
-{
-	struct ubi_device *ubi;
-
-	ubi = container_of(n, struct ubi_device, wl_reboot_notifier);
-	ubi_wl_close(ubi);
-
-	return NOTIFY_DONE;
-}
-
 /**
  * self_check_ec - make sure that the erase counter of a PEB is correct.
  * @ubi: UBI device description object
-- 
2.39.5




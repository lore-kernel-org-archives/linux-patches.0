Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08373806B0;
	Fri,  7 Aug 2026 15:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116986; cv=none; b=olNEFzMkp0YhYaIH47gMpE5FIL39Qg3HLJ4lZZkRyJxByLJX5ZO4t31yVyGVoUBjL111Hf7mLypEEyehGCrdrolanvS3agiyrwPhkZ1HZ/qBGKlHTDySdieaTeBGDtNn9tsJ+uS8TXzjyOPnxgFa2zrvYjV3wb5zOq2AIi4Izow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116986; c=relaxed/simple;
	bh=GH3ykSyS0WQDaH8bZPSliZ9Kti8P+4A1f3ODZZA3acA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDvw5GOUNvOrIfEaNbzG33G9HUxvo1tnnqwi+ZWBwYWGvGOadGSJQ9C0IOBQv2oTolp9ubH/fx/jhC7/FRkSj1BPQHWur9R3lq/2R4kD8WgHFuKVHo/b9bl2J28lqs7+FgdX+zDY6907itcf/qoBeKJDdUraFeVqxHkMHdMlCYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Df+H0ZRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Df+H0ZRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028771F000E9;
	Fri,  7 Aug 2026 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116985;
	bh=lP8bRK6ZdZALvB0Ut7YYREr2goHJHHv2Kkfd9hxiynE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Df+H0ZRN89r+Z9LEF4M6GrlmvhOV4ltmINW/6fGLNRNC5Q2aIeCJun0i4tPlxGQqD
	 YPyBIBPgNhBuIZb11H8zu6BYSAzzuw5KtvZYHT5TQ4mv91ZV5ov0bsoiIhoqwPL/yT
	 HJ62vA0V6p8Z7iPKOu91EQk1yu+GAkKqag8JoqX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 158/438] scsi: mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit
Date: Fri,  7 Aug 2026 16:35:54 +0200
Message-ID: <20260807143431.402972074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit ccff8c92571500fcfed21281e33daaf645bf692f ]

mpi3mr_fault_uevent_emit() runs from the fault watchdog and reset paths
where host I/O may already be blocked. GFP_KERNEL allocations here, both
the local kzalloc_obj() and the ones inside kobject_uevent_env() itself,
can trigger reclaim that waits on that blocked I/O and deadlock.

Use memalloc_noio_save()/restore() to cover the whole call instead of
just the local allocation.

Fixes: ec54b348f274 ("scsi: mpi3mr: Record and report controller firmware faults")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260724164630.924288-1-chandrakanth.patil%40broadcom.com
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260724175231.935192-1-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 31b19ed1528e5..681868716ebdb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -9,6 +9,7 @@
 
 #include "mpi3mr.h"
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/sched/mm.h>
 
 static int
 mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u16 reset_reason);
@@ -1287,11 +1288,14 @@ static void mpi3mr_alloc_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
 static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
 {
 	struct kobj_uevent_env *env;
+	unsigned int noio_flag;
 	int ret;
 
+	noio_flag = memalloc_noio_save();
+
 	env = kzalloc_obj(*env);
 	if (!env)
-		return;
+		goto out_restore;
 
 	ret = add_uevent_var(env, "DRIVER=%s", mrioc->driver_name);
 	if (ret)
@@ -1326,7 +1330,8 @@ static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
 
 out_free:
 	kfree(env);
-
+out_restore:
+	memalloc_noio_restore(noio_flag);
 }
 
 /**
-- 
2.53.0




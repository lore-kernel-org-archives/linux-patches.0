Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F905326D63
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300980; cv=none; b=hMKDEC4ybd9JzqtKH5/o8NDGqL+Y7hIFDau3eSy5OHnyMqQdvH3ePY/DF5/mUsfpbFXqVKOGwxTyzsk8nsZ8ubFoYJYe/F7IcN9jPTQB2pPdJ9a5TYiwMnOyjdkkIEzcuPQ8pOl+ojnXUNrJkRIRuzLTyN2gL5wzk96qZUP2Qi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300980; c=relaxed/simple;
	bh=SbfuuVD8bjuM3QXr4hweJu2hSXe/cwklSkcZiE+ns/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbcM52COE8vNPIoWRgxTCClGM9W92N+OZxo3ji11uTTM9G+MHmcbZG0TewADm3D2HJnlchcbHfRKIcY3iMnbghYX7GwxUOeiDDhl85pRT3lpLs4vw7/GHZgyrX0j0koIeGnebkqDdwTgdd2VYWvlg6Nf9nvwJKcaRYx6hCjrhPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oalJK65h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oalJK65h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C516FC116D0;
	Sat, 28 Feb 2026 17:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300980;
	bh=SbfuuVD8bjuM3QXr4hweJu2hSXe/cwklSkcZiE+ns/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oalJK65hgnLYhcpRMKIRGd4Gpqc12sxO8Sptz+jG2cCHncE8A7N2jW0xibej6AXms
	 Xz6IxGOnfx4uVvRyPaWqqsUPm2V1LsOC8PNNNeMFWsE3TgHOz8WAx1oFtKLawDCRPe
	 ExDiV+LayS0TFfbLBbEm7Pebe7BtGR/6lGHYoK+3m88JvuEITops33UyIVlyeT9luv
	 LeqR0CgCeCYRBHdp1PsXk9Tp/IeL4Chf8QjL2OOwDnneYlDOwJvxW++nUodmv6Svkm
	 M2RRFr8UsJ3UhUtP2LYu6tfhTbbfgFLak39r8g9l6ZOklr2bPM+i4X2M7MZ2A0X9/+
	 90W8LLHCLnoJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/752] drm/panthor: Always wait after sending a command to an AS
Date: Sat, 28 Feb 2026 12:37:00 -0500
Message-ID: <20260228174750.1542406-109-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit d2c6fde56d451ca48a5e03428535ce3dbc8fc910 ]

There's currently no situation where we want to issue a command to an
AS and not wait for this command to complete. The wait is either
explicitly done (LOCK, UNLOCK) or it's missing (UPDATE). So let's
turn write_cmd() into as_send_cmd_and_wait() that has the wait after
a command is sent.

v2:
- New patch

v3:
- Collect R-b

v4:
- No changes

Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251128084841.3804658-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 0fd8ffec92dd0..5647a24741095 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -523,27 +523,29 @@ static int wait_ready(struct panthor_device *ptdev, u32 as_nr)
 	return ret;
 }
 
-static int write_cmd(struct panthor_device *ptdev, u32 as_nr, u32 cmd)
+static int as_send_cmd_and_wait(struct panthor_device *ptdev, u32 as_nr, u32 cmd)
 {
 	int status;
 
 	/* write AS_COMMAND when MMU is ready to accept another command */
 	status = wait_ready(ptdev, as_nr);
-	if (!status)
+	if (!status) {
 		gpu_write(ptdev, AS_COMMAND(as_nr), cmd);
+		status = wait_ready(ptdev, as_nr);
+	}
 
 	return status;
 }
 
-static void lock_region(struct panthor_device *ptdev, u32 as_nr,
-			u64 region_start, u64 size)
+static int lock_region(struct panthor_device *ptdev, u32 as_nr,
+		       u64 region_start, u64 size)
 {
 	u8 region_width;
 	u64 region;
 	u64 region_end = region_start + size;
 
 	if (!size)
-		return;
+		return 0;
 
 	/*
 	 * The locked region is a naturally aligned power of 2 block encoded as
@@ -566,7 +568,7 @@ static void lock_region(struct panthor_device *ptdev, u32 as_nr,
 
 	/* Lock the region that needs to be updated */
 	gpu_write64(ptdev, AS_LOCKADDR(as_nr), region);
-	write_cmd(ptdev, as_nr, AS_COMMAND_LOCK);
+	return as_send_cmd_and_wait(ptdev, as_nr, AS_COMMAND_LOCK);
 }
 
 static int mmu_hw_do_operation_locked(struct panthor_device *ptdev, int as_nr,
@@ -599,9 +601,7 @@ static int mmu_hw_do_operation_locked(struct panthor_device *ptdev, int as_nr,
 	 * power it up
 	 */
 
-	lock_region(ptdev, as_nr, iova, size);
-
-	ret = wait_ready(ptdev, as_nr);
+	ret = lock_region(ptdev, as_nr, iova, size);
 	if (ret)
 		return ret;
 
@@ -614,10 +614,7 @@ static int mmu_hw_do_operation_locked(struct panthor_device *ptdev, int as_nr,
 	 * at the end of the GPU_CONTROL cache flush command, unlike
 	 * AS_COMMAND_FLUSH_MEM or AS_COMMAND_FLUSH_PT.
 	 */
-	write_cmd(ptdev, as_nr, AS_COMMAND_UNLOCK);
-
-	/* Wait for the unlock command to complete */
-	return wait_ready(ptdev, as_nr);
+	return as_send_cmd_and_wait(ptdev, as_nr, AS_COMMAND_UNLOCK);
 }
 
 static int mmu_hw_do_operation(struct panthor_vm *vm,
@@ -646,7 +643,7 @@ static int panthor_mmu_as_enable(struct panthor_device *ptdev, u32 as_nr,
 	gpu_write64(ptdev, AS_MEMATTR(as_nr), memattr);
 	gpu_write64(ptdev, AS_TRANSCFG(as_nr), transcfg);
 
-	return write_cmd(ptdev, as_nr, AS_COMMAND_UPDATE);
+	return as_send_cmd_and_wait(ptdev, as_nr, AS_COMMAND_UPDATE);
 }
 
 static int panthor_mmu_as_disable(struct panthor_device *ptdev, u32 as_nr)
@@ -661,7 +658,7 @@ static int panthor_mmu_as_disable(struct panthor_device *ptdev, u32 as_nr)
 	gpu_write64(ptdev, AS_MEMATTR(as_nr), 0);
 	gpu_write64(ptdev, AS_TRANSCFG(as_nr), AS_TRANSCFG_ADRMODE_UNMAPPED);
 
-	return write_cmd(ptdev, as_nr, AS_COMMAND_UPDATE);
+	return as_send_cmd_and_wait(ptdev, as_nr, AS_COMMAND_UPDATE);
 }
 
 static u32 panthor_mmu_fault_mask(struct panthor_device *ptdev, u32 value)
-- 
2.51.0


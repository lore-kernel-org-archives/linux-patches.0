Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C3338E8BB;
	Sat, 17 Oct 2026 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253989; cv=none; b=UPApJMBlJFl5h1vEJ5Vqi30pxWFar2U2rc1Uh0veotdb3hXFJHQfQ5pnT1JomxVFOW5bBntfA0KN+3rMkA8CLSqif+9SMkcHUAJLj7O18zEbxYvqJGay0ppYwGTa74PpThJXH8Eebeicy/I4drC9QLa33aU8MuAm5Vtfd4NbJ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253989; c=relaxed/simple;
	bh=bopuIH336JGIO3yD5OA76Ae23digafbsc+ELAQLmuG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4Zu/RCr1pl3ZL8k0rA7F7myPfzOT+V64wmzSx0UUWylAnITHgJQZc1wB8iXcQRY2nfa29ohAy6SIoE++rM5680CznZ+K5jbKyiAtHfXCgqBMXLm5BEXhC5yZ0L5bDJmENGqFn0l+WAZLYectzWM7fZucEPnzggCR51a1SWCT9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4AYffCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4AYffCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4561E1F000C4;
	Sat, 17 Oct 2026 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253987;
	bh=BGOzjU2pKj0gCbrrHfHvaYZQJcwYc77Qr4c8SExMxBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4AYffCWLS7dUVE0bVx2zRCH/gjc9HhcaaeVFIL+9Y1rFZAGlWzJuD/0/xzNvncqS
	 rDg4dTeeEcwHwRf3zLL8c9xb1emiEcJFNFbFthnwEYCSw6cCGK2k814CaTaNfX5C2H
	 GrFE4BLG80SNG93uJrrPKwGuvLFseqSwwp6F7WJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Junhao He <hejunhao3@h-partners.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/869] coresight: tmc-etr: Fix race condition between sysfs and perf mode
Date: Sat, 17 Oct 2026 17:52:21 +0200
Message-ID: <20261017160044.767079317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit e6e43e82c79c97917cbe356c07e8a6f3f982ab53 ]

When trying to run perf and sysfs mode simultaneously, the WARN_ON()
in tmc_etr_enable_hw() is triggered sometimes:

 WARNING: CPU: 42 PID: 3911571 at drivers/hwtracing/coresight/coresight-tmc-etr.c:1060 tmc_etr_enable_hw+0xc0/0xd8 [coresight_tmc]
 [..snip..]
 Call trace:
  tmc_etr_enable_hw+0xc0/0xd8 [coresight_tmc] (P)
  tmc_enable_etr_sink+0x11c/0x250 [coresight_tmc] (L)
  tmc_enable_etr_sink+0x11c/0x250 [coresight_tmc]
  coresight_enable_path+0x1c8/0x218 [coresight]
  coresight_enable_sysfs+0xa4/0x228 [coresight]
  enable_source_store+0x58/0xa8 [coresight]
  dev_attr_store+0x20/0x40
  sysfs_kf_write+0x4c/0x68
  kernfs_fop_write_iter+0x120/0x1b8
  vfs_write+0x2c8/0x388
  ksys_write+0x74/0x108
  __arm64_sys_write+0x24/0x38
  el0_svc_common.constprop.0+0x64/0x148
  do_el0_svc+0x24/0x38
  el0_svc+0x3c/0x130
  el0t_64_sync_handler+0xc8/0xd0
  el0t_64_sync+0x1ac/0x1b0
 ---[ end trace 0000000000000000 ]---

Since the enablement of sysfs mode is separeted into two critical regions,
one for sysfs buffer allocation and another for hardware enablement, it's
possible to race with the perf mode. Fix this by double check whether
the perf mode's been used before enabling the hardware in sysfs mode.

 mode:
   [sysfs mode]                   [perf mode]
   tmc_etr_get_sysfs_buffer()
     spin_lock(&drvdata->spinlock)
     [sysfs buffer allocation]
     spin_unlock(&drvdata->spinlock)
                                  spin_lock(&drvdata->spinlock)
                                  tmc_etr_enable_hw()
                                    drvdata->etr_buf = etr_perf->etr_buf
                                  spin_unlock(&drvdata->spinlock)
   spin_lock(&drvdata->spinlock)
   tmc_etr_enable_hw()
     WARN_ON(drvdata->etr_buf) // WARN sicne etr_buf initialized at
                                  the perf side
   spin_unlock(&drvdata->spinlock)

With this fix, we retain the check for CS_MODE_PERF in get_etr_sysfs_buf.
This ensures we verify whether the perf mode's already running before we
actually allocate the buffer. Then we can save the time of
allocating/freeing the sysfs buffer if race with the perf mode.

Fixes: 296b01fd106e ("coresight: Refactor out buffer allocation function for ETR")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Junhao He <hejunhao3@h-partners.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260121101543.2017014-3-wangyushan12@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 25f0335e2db05..11ac1a8b9e7a2 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1233,6 +1233,19 @@ static int tmc_enable_etr_sink_sysfs(struct coresight_device *csdev)
 
 	raw_spin_lock_irqsave(&drvdata->spinlock, flags);
 
+	/*
+	 * Since the sysfs buffer allocation and the hardware enablement is not
+	 * in the same critical region, it's possible to race with the perf.
+	 */
+	if (coresight_get_mode(csdev) == CS_MODE_PERF) {
+		drvdata->sysfs_buf = NULL;
+		raw_spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+		/* Free allocated memory out side of the spinlock */
+		tmc_etr_free_sysfs_buf(sysfs_buf);
+		return -EBUSY;
+	}
+
 	/*
 	 * In sysFS mode we can have multiple writers per sink.  Since this
 	 * sink is already enabled no memory is needed and the HW need not be
-- 
2.53.0




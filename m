Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B6FBE0;
	Mon, 11 Dec 2023 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9JxBsXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035DAC433C7;
	Mon, 11 Dec 2023 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319668;
	bh=SF1MTG415DjpODXk6yecupSJGBCp9LDpUMTSnEequ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9JxBsXXVcDWjZFF62S1v4REgSH0ANeNjZ6sBILvYZdiI+9alBcNNHOcQAbiUTBED
	 b3xUXCm4hEGeCqFLA7DJTzgqfe4y+fB3cvvWoYx243LvqdJXS3aLy00POx+V3/iKU+
	 L7qcWBZuqCW2RyXNy/ibdtuyQJ5XcRDmi7/YoCj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/244] coresight: Fix crash when Perf and sysfs modes are used concurrently
Date: Mon, 11 Dec 2023 19:21:23 +0100
Message-ID: <20231211182054.462913614@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 287e82cf69aa264a52bc37591bd0eb407e20f85c ]

Partially revert the change in commit 6148652807ba ("coresight: Enable
and disable helper devices adjacent to the path") which changed the bare
call from source_ops(csdev)->enable() to coresight_enable_source() for
Perf sessions. It was missed that coresight_enable_source() is
specifically for the sysfs interface, rather than being a generic call.
This interferes with the sysfs reference counting to cause the following
crash:

  $ perf record -e cs_etm/@tmc_etr0/ -C 0 &
  $ echo 1 > /sys/bus/coresight/devices/tmc_etr0/enable_sink
  $ echo 1 > /sys/bus/coresight/devices/etm0/enable_source
  $ echo 0 > /sys/bus/coresight/devices/etm0/enable_source

  Unable to handle kernel NULL pointer dereference at virtual
  address 00000000000001d0
  Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
  ...
  Call trace:
   etm4_disable+0x54/0x150 [coresight_etm4x]
   coresight_disable_source+0x6c/0x98 [coresight]
   coresight_disable+0x74/0x1c0 [coresight]
   enable_source_store+0x88/0xa0 [coresight]
   dev_attr_store+0x20/0x40
   sysfs_kf_write+0x4c/0x68
   kernfs_fop_write_iter+0x120/0x1b8
   vfs_write+0x2dc/0x3b0
   ksys_write+0x70/0x108
   __arm64_sys_write+0x24/0x38
   invoke_syscall+0x50/0x128
   el0_svc_common.constprop.0+0x104/0x130
   do_el0_svc+0x40/0xb8
   el0_svc+0x2c/0xb8
   el0t_64_sync_handler+0xc0/0xc8
   el0t_64_sync+0x1a4/0x1a8
  Code: d53cd042 91002000 b9402a81 b8626800 (f940ead5)
  ---[ end trace 0000000000000000 ]---

This commit linked below also fixes the issue, but has unlocked updates
to the mode which could potentially race. So until we come up with a
more complete solution that takes all locking and interaction between
both modes into account, just revert back to the old behavior for Perf.

Reported-by: Junhao He <hejunhao3@huawei.com>
Closes: https://lore.kernel.org/linux-arm-kernel/20230921132904.60996-1-hejunhao3@huawei.com/
Fixes: 6148652807ba ("coresight: Enable and disable helper devices adjacent to the path")
Tested-by: Junhao He <hejunhao3@huawei.com>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231006131452.646721-1-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 5ca6278baff4f..89e8ed214ea49 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -493,7 +493,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 		goto fail_end_stop;
 
 	/* Finally enable the tracer */
-	if (coresight_enable_source(csdev, CS_MODE_PERF, event))
+	if (source_ops(csdev)->enable(csdev, event, CS_MODE_PERF))
 		goto fail_disable_path;
 
 	/*
@@ -587,7 +587,7 @@ static void etm_event_stop(struct perf_event *event, int mode)
 		return;
 
 	/* stop tracer */
-	coresight_disable_source(csdev, event);
+	source_ops(csdev)->disable(csdev, event);
 
 	/* tell the core */
 	event->hw.state = PERF_HES_STOPPED;
-- 
2.42.0




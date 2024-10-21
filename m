Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4BD1F1310;
	Mon, 21 Oct 2024 10:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507023; cv=none; b=Kv16GB+1RQXsCRNxsJej5FgiSwMOPSqF3DYbzoRCmUvHcMMgRc0v5JSiEUiOBpcAs/5Xp66WJFC3EabXhoLRTQIHEp9k7XhI+X2Ua6apA2fxlasgdMH6S2FmSA/7LutsWEBPYUD0R4W4HNxM3J+pFdi5BQvzu1k5ztJ8d0juIak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507023; c=relaxed/simple;
	bh=hBg3Of+Sj/Cqzh9nvM+opQoB18RamAk+5hSYltoD6Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJmiPZnfem3VAWhx6669KmHHmxO5fTrQG36mZC5XyXFt2kVFZ0b39CEGaJlqVa6fh/kN9ealDkvetqGF2QRR7kP/2zSR4Cs3ya9ckDwydJV+hMdoNKzmofnUgCfv1jk6DwXfxeIzLj358TIRjwIyOtpXkEpZjcOqdow+ENLHOu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RICkDwzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RICkDwzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F088C4CEC3;
	Mon, 21 Oct 2024 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507022;
	bh=hBg3Of+Sj/Cqzh9nvM+opQoB18RamAk+5hSYltoD6Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RICkDwzET7rZcKOccKF6QUez/X6XNUDDAQ+Q/dYDNXTbVge4VdoP57H2TlC5mRq6v
	 L4R+6oIx8OQ0L/bWCVnX9uHiv31AU++c9ghIL+GWHoqA2Jf+H9vjLmXPdkffKsOgaO
	 xOnyvxTkNh2z3UWMEiF3PtTPXh912dOjkIqi3wUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 064/124] scsi: ufs: core: Set SDEV_OFFLINE when UFS is shut down
Date: Mon, 21 Oct 2024 12:24:28 +0200
Message-ID: <20241021102259.209887057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: Seunghwan Baek <sh8267.baek@samsung.com>

commit 19a198b67767d952c8f3d0cf24eb3100522a8223 upstream.

There is a history of deadlock if reboot is performed at the beginning
of booting. SDEV_QUIESCE was set for all LU's scsi_devices by UFS
shutdown, and at that time the audio driver was waiting on
blk_mq_submit_bio() holding a mutex_lock while reading the fw binary.
After that, a deadlock issue occurred while audio driver shutdown was
waiting for mutex_unlock of blk_mq_submit_bio(). To solve this, set
SDEV_OFFLINE for all LUs except WLUN, so that any I/O that comes down
after a UFS shutdown will return an error.

[   31.907781]I[0:      swapper/0:    0]        1        130705007       1651079834      11289729804                0 D(   2) 3 ffffff882e208000 *             init [device_shutdown]
[   31.907793]I[0:      swapper/0:    0] Mutex: 0xffffff8849a2b8b0: owner[0xffffff882e28cb00 kworker/6:0 :49]
[   31.907806]I[0:      swapper/0:    0] Call trace:
[   31.907810]I[0:      swapper/0:    0]  __switch_to+0x174/0x338
[   31.907819]I[0:      swapper/0:    0]  __schedule+0x5ec/0x9cc
[   31.907826]I[0:      swapper/0:    0]  schedule+0x7c/0xe8
[   31.907834]I[0:      swapper/0:    0]  schedule_preempt_disabled+0x24/0x40
[   31.907842]I[0:      swapper/0:    0]  __mutex_lock+0x408/0xdac
[   31.907849]I[0:      swapper/0:    0]  __mutex_lock_slowpath+0x14/0x24
[   31.907858]I[0:      swapper/0:    0]  mutex_lock+0x40/0xec
[   31.907866]I[0:      swapper/0:    0]  device_shutdown+0x108/0x280
[   31.907875]I[0:      swapper/0:    0]  kernel_restart+0x4c/0x11c
[   31.907883]I[0:      swapper/0:    0]  __arm64_sys_reboot+0x15c/0x280
[   31.907890]I[0:      swapper/0:    0]  invoke_syscall+0x70/0x158
[   31.907899]I[0:      swapper/0:    0]  el0_svc_common+0xb4/0xf4
[   31.907909]I[0:      swapper/0:    0]  do_el0_svc+0x2c/0xb0
[   31.907918]I[0:      swapper/0:    0]  el0_svc+0x34/0xe0
[   31.907928]I[0:      swapper/0:    0]  el0t_64_sync_handler+0x68/0xb4
[   31.907937]I[0:      swapper/0:    0]  el0t_64_sync+0x1a0/0x1a4

[   31.908774]I[0:      swapper/0:    0]       49                0         11960702      11236868007                0 D(   2) 6 ffffff882e28cb00 *      kworker/6:0 [__bio_queue_enter]
[   31.908783]I[0:      swapper/0:    0] Call trace:
[   31.908788]I[0:      swapper/0:    0]  __switch_to+0x174/0x338
[   31.908796]I[0:      swapper/0:    0]  __schedule+0x5ec/0x9cc
[   31.908803]I[0:      swapper/0:    0]  schedule+0x7c/0xe8
[   31.908811]I[0:      swapper/0:    0]  __bio_queue_enter+0xb8/0x178
[   31.908818]I[0:      swapper/0:    0]  blk_mq_submit_bio+0x194/0x67c
[   31.908827]I[0:      swapper/0:    0]  __submit_bio+0xb8/0x19c

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: stable@vger.kernel.org
Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
Link: https://lore.kernel.org/r/20240829093913.6282-2-sh8267.baek@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10100,7 +10100,9 @@ static void ufshcd_wl_shutdown(struct de
 	shost_for_each_device(sdev, hba->host) {
 		if (sdev == hba->ufs_device_wlun)
 			continue;
-		scsi_device_quiesce(sdev);
+		mutex_lock(&sdev->state_mutex);
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		mutex_unlock(&sdev->state_mutex);
 	}
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 



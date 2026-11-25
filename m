Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626359;
	b=KxZ3sAZuaoF6Uz+WZiJuk4T3+cTyc9SL9WrIisYi9xP8xsWdVA3tVmCz2ly2hKF0Tx0t
	 3/RIXF2BQzifMRgmmnqFG9MXzRPfRDmSFUw61mINvHAHNE/oXg2Pkaiuc4WDyrZ2YU4Pm
	 y5xgW1auHqoyb584EANsTx12PT40rDrjiawtg1G4z6/E4BMq1fF3D7scY7oAacBqJROrM
	 eKNoacCRxjeFXxDtiViw4TVOmijo8PQkhwQ80VPEvd4OnsMs+c0ETegGOwMQhDGCWYKIT
	 qYEA20Q61RP3SR2eeFPqR5TS7IZBVrcfrHSgks+x/rhyfTTK0p1ypp91y57ygIBE2NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JVpMNwsU8pInO6Dz1F+69Jm5lkUAKxO2VE7aTcAuILA=;
	b=GiiE93Bgs1Jj5x5qiQKWMk20MONbuxF8b/YrLBks5hT3EbUv1YYs7g4/d5kAQk2B4oUx
	 nBbYQ+C5GX7LQSghqER2Q45Oy3SgOoVAnKm7DSk/kQj7iJthXJj/d1a8OHJQpzxFNLFHg
	 YnUBhgPlHLAW8z9R74+57hlmbY+AZCLtJqdEvWMuvQq3GFzc4kBP2zG2Ixt2xmzHB+pks
	 HycKTruCvq9kE4ahbi8JrapuDtObGoy5mZ9lD42fHm0g57uJ+RlVIAaOX4XLRSVQ25Vvp
	 AzfMWvm6CvGnsTHFNV24pYVlK4niqLpYddPrEOkb4Ke3/DeyCUd+v04NiGuLtI5wWXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJTOIRlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CAB606A323;
	Wed, 25 Nov 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJTOIRlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4736E1F000CA;
	Wed, 25 Nov 2026 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626358;
	bh=JVpMNwsU8pInO6Dz1F+69Jm5lkUAKxO2VE7aTcAuILA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJTOIRlK50p8KdpLCL5FVmyja9OEbgC4q4kx18W2I6UO9XJqqM0XYJ/2GVMLuzqtE
	 6bZ2NeS3WyPpNhpKXi4C+/LCiqr38EHdF9RlaDg8GYY66jEvlLWCpdGnDFeUbV+Vfd
	 M6WBQYnMd8JbIEBxUGdX/0bDON/Pv8iVvNQNmedY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daksh Sahni <swizzguy76@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 802/816] accel/ivpu: Defer recovery until probe completes
Date: Wed, 25 Nov 2026 15:39:10 +0100
Message-ID: <20261125143907.734673924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit dc61b19db1f77deb4c15bb71e64f46071447837c upstream.

An error IRQ that fires after ivpu_boot() enables interrupts queues
recovery_work during probe. If probe then fails, the device is torn
down while the work runs, and the work faults on the unmapped BARs:

  BUG: unable to handle page fault for address: ffffcfc6680200f4
  Workqueue: events_unbound ivpu_pm_recovery_work [intel_vpu]
  RIP: 0010:ivpu_hw_ip_ipc_rx_addr_get+0xc/0xb0 [intel_vpu]
  Call Trace:
   ivpu_wait_for_ready+0x155/0x220 [intel_vpu]
   ivpu_boot+0x9e/0x270 [intel_vpu]
   ivpu_resume+0xa4/0xd0 [intel_vpu]
   ivpu_pm_reset_complete+0x2c/0x90 [intel_vpu]
   ivpu_pm_recovery_work+0xf6/0x140 [intel_vpu]

If probe succeeds, the recovery runs concurrently with the rest of
probe, and its pm_runtime_disable() discards the initial autosuspend
request, leaving the NPU active until first use. Any recovery that
starts while the NPU is idle loses the pending autosuspend the same way.

Keep recovery_work disabled from ivpu_pm_init() until ivpu_pm_enable().
A trigger during probe still runs diagnostics and masks interrupts, and
ivpu_pm_enable() runs the deferred recovery before the initial
autosuspend request. A trigger racing with ivpu_pm_enable() can cause
a second, harmless recovery. Request autosuspend at the end of
ivpu_pm_reset_complete() so the NPU suspends again after every reset.

Fixes: 852be13f3bd3 ("accel/ivpu: Add PM support")
Cc: stable@vger.kernel.org # v6.10+
Reported-by: Daksh Sahni <swizzguy76@gmail.com>
Closes: https://lore.kernel.org/r/20261107174215.15818-1-swizzguy76@gmail.com
Tested-by: Daksh Sahni <swizzguy76@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20261110121534.3566028-1-karol.wachowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -140,8 +140,8 @@ static void ivpu_pm_reset_complete(struc
 	up_write(&vdev->pm->reset_lock);
 	atomic_set(&vdev->pm->reset_pending, 0);
 
-	pm_runtime_mark_last_busy(vdev->drm.dev);
 	pm_runtime_enable(vdev->drm.dev);
+	pm_request_autosuspend(vdev->drm.dev);
 }
 
 static void ivpu_pm_recovery_work(struct work_struct *work)
@@ -368,6 +368,7 @@ void ivpu_pm_init(struct ivpu_device *vd
 	atomic_set(&pm->reset_counter, 0);
 
 	INIT_WORK(&pm->recovery_work, ivpu_pm_recovery_work);
+	disable_work(&pm->recovery_work);
 	INIT_DELAYED_WORK(&pm->job_timeout_work, ivpu_job_timeout_work);
 
 	if (ivpu_disable_recovery)
@@ -392,6 +393,12 @@ void ivpu_pm_enable(struct ivpu_device *
 {
 	struct device *dev = vdev->drm.dev;
 
+	enable_work(&vdev->pm->recovery_work);
+	if (atomic_read(&vdev->pm->reset_pending)) {
+		queue_work(system_dfl_wq, &vdev->pm->recovery_work);
+		flush_work(&vdev->pm->recovery_work);
+	}
+
 	pm_runtime_allow(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623794;
	b=b4eJ3Hzcz3mBXJQzT6lMdwl7SfZTFNFqcHbD5A66ZMrLwOwMEwjcGaytNUS7vHFNNrG6
	 GY1eQHCL8yRpTrx/knmMhGU6gnj85Ok7TkMBneDQcW4e/wC0MbcbOloW4ic+x37RH1q0s
	 7Xvazu3h7/u9+F8SXqpmFJMtyPdLdBALmFXDGmGZb2HubewwD3Z9H7pu1c2lwXuemwa1R
	 0tclCWntCL2duBlgwXYIRdUs+PzDnLXPncKtZkt6Ro0i79eoyl/Bs1qfqXhLi7g3RJi2N
	 EgZ+DcUp5E2tHsw6IweXVI7iQiWHOirxoOgjYaWh3644d2KQYMVCFthsEaToo2MmEdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hk8LX8GlTn8jQyxkpjeP72gQNfyM+gklQyfVo73H0A0=;
	b=VKSgQ+qq2wiadmiXMLpBdlq4nO4/ku2okOJm84WOPxV154W5z62019rSO/5JWuyXRv+F
	 dpmTDbrhIs9XFy0tUVE8SSeOJhhXLLScgUuSOzC5I4Pm/Yg7HnFbxTMpBljTtaXfL3tYo
	 WBy+ItVKmrIfBGSVlEkhl6KarzCWaFs5763vvopudjvWHImSvSypq6Dya182F313xbzT8
	 /nRkEpX7N1Q30RHqHbDaZXHR71c71vkWhpExEbcWQszjYT+vc+tb84Wv3IeuXHDxA88Qt
	 EWKCPd+FjexlBy8GKbHXGKBotQrfrsou5bBOkbYc5xvofOne9f5vG3yKtVwzwFXe5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdZPz1Mv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335BC606A338;
	Wed, 25 Nov 2026 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdZPz1Mv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D56B1F000ED;
	Wed, 25 Nov 2026 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623793;
	bh=hk8LX8GlTn8jQyxkpjeP72gQNfyM+gklQyfVo73H0A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdZPz1MvgWU4j2SRpuC9Pqo9E1CPzOAwvMffX8VCBL9zdN40FOf/3Xov6vgEWOusw
	 p9XrAba1MXwud0uVRQBWILBkbPJqtVuw7s2FdXTeFqf5POj/iwbRU6FfeogwtF71T4
	 n2OHathakQS46dbNaMVyaZOZTUTFmuaQGQbdpRLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daksh Sahni <swizzguy76@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 971/990] accel/ivpu: Defer recovery until probe completes
Date: Wed, 25 Nov 2026 15:38:58 +0100
Message-ID: <20261125143844.728890917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -148,8 +148,8 @@ static void ivpu_pm_reset_complete(struc
 	up_write(&vdev->pm->reset_lock);
 	atomic_set(&vdev->pm->reset_pending, 0);
 
-	pm_runtime_mark_last_busy(vdev->drm.dev);
 	pm_runtime_enable(vdev->drm.dev);
+	pm_request_autosuspend(vdev->drm.dev);
 }
 
 static void ivpu_pm_recovery_work(struct work_struct *work)
@@ -403,6 +403,7 @@ void ivpu_pm_init(struct ivpu_device *vd
 	atomic_set(&pm->reset_counter, 0);
 
 	INIT_WORK(&pm->recovery_work, ivpu_pm_recovery_work);
+	disable_work(&pm->recovery_work);
 	INIT_DELAYED_WORK(&pm->job_timeout_work, ivpu_job_timeout_work);
 
 	if (ivpu_disable_recovery)
@@ -427,6 +428,12 @@ void ivpu_pm_enable(struct ivpu_device *
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



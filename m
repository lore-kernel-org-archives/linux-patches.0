Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD49134C1
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0DDC43391;
	Tue, 25 Jul 2023 10:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282199;
	bh=pFwe/pqEAna/s82laSAN18vkyZ87QG3lvq79eEPGKds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIW6EHtieKp5dWzXlpWKn1chvkjNMbxnqkKTQbluIISueXmlSleFD6+aQp7Q6a7VF
	 4CzpXEXO4y/Y2Z+rq8G6OVbLyhYyozTP6/YLxM3ib2mlGnkpC47Fp8XcalHJl8KDQF
	 51s5zLBLkKAPNzvG7v/JMHJczjpS42pYudgJb7ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 044/227] drm/amdgpu/vkms: relax timer deactivation by hrtimer_try_to_cancel
Date: Tue, 25 Jul 2023 12:43:31 +0200
Message-ID: <20230725104516.633125553@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

commit b42ae87a7b3878afaf4c3852ca66c025a5b996e0 upstream.

In below thousands of screen rotation loop tests with virtual display
enabled, a CPU hard lockup issue may happen, leading system to unresponsive
and crash.

do {
	xrandr --output Virtual --rotate inverted
	xrandr --output Virtual --rotate right
	xrandr --output Virtual --rotate left
	xrandr --output Virtual --rotate normal
} while (1);

NMI watchdog: Watchdog detected hard LOCKUP on cpu 1

? hrtimer_run_softirq+0x140/0x140
? store_vblank+0xe0/0xe0 [drm]
hrtimer_cancel+0x15/0x30
amdgpu_vkms_disable_vblank+0x15/0x30 [amdgpu]
drm_vblank_disable_and_save+0x185/0x1f0 [drm]
drm_crtc_vblank_off+0x159/0x4c0 [drm]
? record_print_text.cold+0x11/0x11
? wait_for_completion_timeout+0x232/0x280
? drm_crtc_wait_one_vblank+0x40/0x40 [drm]
? bit_wait_io_timeout+0xe0/0xe0
? wait_for_completion_interruptible+0x1d7/0x320
? mutex_unlock+0x81/0xd0
amdgpu_vkms_crtc_atomic_disable

It's caused by a stuck in lock dependency in such scenario on different
CPUs.

CPU1                                             CPU2
drm_crtc_vblank_off                              hrtimer_interrupt
    grab event_lock (irq disabled)                   __hrtimer_run_queues
        grab vbl_lock/vblank_time_block                  amdgpu_vkms_vblank_simulate
            amdgpu_vkms_disable_vblank                       drm_handle_vblank
                hrtimer_cancel                                         grab dev->event_lock

So CPU1 stucks in hrtimer_cancel as timer callback is running endless on
current clock base, as that timer queue on CPU2 has no chance to finish it
because of failing to hold the lock. So NMI watchdog will throw the errors
after its threshold, and all later CPUs are impacted/blocked.

So use hrtimer_try_to_cancel to fix this, as disable_vblank callback
does not need to wait the handler to finish. And also it's not necessary
to check the return value of hrtimer_try_to_cancel, because even if it's
-1 which means current timer callback is running, it will be reprogrammed
in hrtimer_start with calling enable_vblank to make it works.

v2: only re-arm timer when vblank is enabled (Christian) and add a Fixes
tag as well

v3: drop warn printing (Christian)

v4: drop superfluous check of blank->enabled in timer function, as it's
guaranteed in drm_handle_vblank (Christian)

Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
Cc: stable@vger.kernel.org
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -55,8 +55,9 @@ static enum hrtimer_restart amdgpu_vkms_
 		DRM_WARN("%s: vblank timer overrun\n", __func__);
 
 	ret = drm_crtc_handle_vblank(crtc);
+	/* Don't queue timer again when vblank is disabled. */
 	if (!ret)
-		DRM_ERROR("amdgpu_vkms failure on handling vblank");
+		return HRTIMER_NORESTART;
 
 	return HRTIMER_RESTART;
 }
@@ -81,7 +82,7 @@ static void amdgpu_vkms_disable_vblank(s
 {
 	struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
 
-	hrtimer_cancel(&amdgpu_crtc->vblank_timer);
+	hrtimer_try_to_cancel(&amdgpu_crtc->vblank_timer);
 }
 
 static bool amdgpu_vkms_get_vblank_timestamp(struct drm_crtc *crtc,



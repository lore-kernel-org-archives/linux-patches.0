Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B9914A08E;
	Thu,  5 Sep 2024 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529953; cv=none; b=VFTtDfv7AFSrCE4ZPMjzyE45IuLl5mDB6y9vbUStOpjhgkWT3NK7uQ4ANYiMRI+AFaJOJufJn63Up83bwHcwHoPuNk3ZmVMDaHK4H/vmiXpJCh6W/1QqqHsAp9004dtTRag+uMPRrosgBN1hd76ZfiTx6WOHtKiXiLqi/rJaM+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529953; c=relaxed/simple;
	bh=jRGT66/cciG3cUw8yxAGPcmxuiDoMXwttDIk5UlnfxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvvC/PG57uwlJ2pg4jaI5fOqp4fwdEQiVwwm3uxPOsyXzKPGclXRsRF+iJO2QSYzkEEFOcHmNe8kaiV2GnvjslEKDyMJfDutWNKfEhsVNaKKROBru6BbMuMl9k7qMXnMJPQfm3HSs2RR0Y5Z1Ga9EsjF77v2Ad1butEvKJS1Ry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3CMzh9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3CMzh9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBEFC4CEC3;
	Thu,  5 Sep 2024 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529953;
	bh=jRGT66/cciG3cUw8yxAGPcmxuiDoMXwttDIk5UlnfxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3CMzh9UsNxDMXbgOlAFL/KHqTNtFcQviiviV3TyG/DyQbpm6mwa6kZ3z5HYzfPvX
	 HCfEmGNkkIuLSEEdbvIqtPKTfj9kCKUjISj9GGH/JrIsUYFZcHFE7D+E51WH0xpvP2
	 8wHqrWsgREG+QfS21dsIWQL3lLs1edLnxTILKFbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Yudong Wang <yudong.wang@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	"Maarten Lankhorst,,," <maarten.lankhorst@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/132] drm/fb-helper: Dont schedule_work() to flush frame buffer during panic()
Date: Thu,  5 Sep 2024 11:39:48 +0200
Message-ID: <20240905093722.291777728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 833cd3e9ad8360785b6c23c82dd3856df00732d9 ]

Sometimes the system [1] hangs on x86 I/O machine checks. However, the
expected behavior is to reboot the system, as the machine check handler
ultimately triggers a panic(), initiating a reboot in the last step.

The root cause is that sometimes the panic() is blocked when
drm_fb_helper_damage() invoking schedule_work() to flush the frame buffer.
This occurs during the process of flushing all messages to the frame
buffer driver as shown in the following call trace:

  Machine check occurs [2]:
    panic()
      console_flush_on_panic()
        console_flush_all()
          console_emit_next_record()
            con->write()
              vt_console_print()
                hide_cursor()
                  vc->vc_sw->con_cursor()
                    fbcon_cursor()
                      ops->cursor()
                        bit_cursor()
                          soft_cursor()
                            info->fbops->fb_imageblit()
                              drm_fbdev_generic_defio_imageblit()
                                drm_fb_helper_damage_area()
                                  drm_fb_helper_damage()
                                    schedule_work() // <--- blocked here
    ...
    emergency_restart()  // wasn't invoked, so no reboot.

During panic(), except the panic CPU, all the other CPUs are stopped.
In schedule_work(), the panic CPU requires the lock of worker_pool to
queue the work on that pool, while the lock may have been token by some
other stopped CPU. So schedule_work() is blocked.

Additionally, during a panic(), since there is no opportunity to execute
any scheduled work, it's safe to fix this issue by skipping schedule_work()
on 'oops_in_progress' in drm_fb_helper_damage().

[1] Enable the kernel option CONFIG_FRAMEBUFFER_CONSOLE,
    CONFIG_DRM_FBDEV_EMULATION, and boot with the 'console=tty0'
    kernel command line parameter.

[2] Set 'panic_timeout' to a non-zero value before calling panic().

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Yudong Wang <yudong.wang@intel.com>
Tested-by: Yudong Wang <yudong.wang@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240703141737.75378-1-qiuxu.zhuo@intel.com
Signed-off-by: Maarten Lankhorst,,, <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 117237d3528bd..618b045230336 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -631,6 +631,17 @@ static void drm_fb_helper_add_damage_clip(struct drm_fb_helper *helper, u32 x, u
 static void drm_fb_helper_damage(struct drm_fb_helper *helper, u32 x, u32 y,
 				 u32 width, u32 height)
 {
+	/*
+	 * This function may be invoked by panic() to flush the frame
+	 * buffer, where all CPUs except the panic CPU are stopped.
+	 * During the following schedule_work(), the panic CPU needs
+	 * the worker_pool lock, which might be held by a stopped CPU,
+	 * causing schedule_work() and panic() to block. Return early on
+	 * oops_in_progress to prevent this blocking.
+	 */
+	if (oops_in_progress)
+		return;
+
 	drm_fb_helper_add_damage_clip(helper, x, y, width, height);
 
 	schedule_work(&helper->damage_work);
-- 
2.43.0




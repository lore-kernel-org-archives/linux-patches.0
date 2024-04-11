Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FBC1448F3;
	Thu, 11 Apr 2024 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830010; cv=none; b=E9PMSplxrbp7IbdvRS5fkCYgJ5XjQUSa8dvZ0j5F3FXm3NtPYx04Xoy+EiWIPsd2RHEfFs4353RiHX0yLdhUHP7HJl9QB/kU1pqltRSWqlMD5h4dzEaeGy0wRSTIWd6/73+iO7hSrChYUROaL1rjVD1hcRmzetpW1A1dafQIxeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830010; c=relaxed/simple;
	bh=56CFFldKwmpZQSFFaDBnviMGdUPwLMRPMn8JB5zjkXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJukGphJ03LrDDs1Q6CsmWzn/s1OStElTpXEnwMO8J/jh2SFbWh1hXlNlgYo9Zl1fzBG47w8831eLOLg5sy3eZDPbP6MHVY1kfg28SCgiUQdk2lx0ucf7drDaD1ErrPpnsBFqLsVRYKP2NtKS2D/f8/GwKgajrye3K/wOjzXmS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5D1jIhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5D1jIhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3ADFC433F1;
	Thu, 11 Apr 2024 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830010;
	bh=56CFFldKwmpZQSFFaDBnviMGdUPwLMRPMn8JB5zjkXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5D1jIhYbw556gAyiq0e3gTZ5l5odciVLHjpExRmCwSbZEYt9N3t0U/+mk6DBnCbI
	 VWLWbV9trcFk9Y9Dh6c5t8QysHl8wuwu1B8l+WYfgssJz/WH2AdNg9gM6Az+7nGxRB
	 y9jHVtQkL35FWM0rwqCB7r6rO8dzEY76WTxIV/wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guomengqi3@huawei.com
Subject: [PATCH 4.19 168/175] drm/vkms: call drm_atomic_helper_shutdown before drm_dev_put()
Date: Thu, 11 Apr 2024 11:56:31 +0200
Message-ID: <20240411095424.621519774@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Mengqi <guomengqi3@huawei.com>

commit 73a82b22963d ("drm/atomic: Fix potential use-after-free
in nonblocking commits") introduced drm_dev_get/put() to
drm_atomic_helper_shutdown(). And this cause problem in vkms driver exit
process.

vkms_exit()
  drm_dev_put()
    vkms_release()
      drm_atomic_helper_shutdown()
        drm_dev_get()
        drm_dev_put()
          vkms_release()    ------ use after free

Using 5.4 stable x86 image on qemu, below stacktrace can be triggered by
load and unload vkms.ko.

root:~ # insmod vkms.ko
[   76.957802] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   76.961490] [drm] Driver supports precise vblank timestamp query.
[   76.964416] [drm] Initialized vkms 1.0.0 20180514 for vkms on minor 0
root:~ # rmmod vkms.ko
[   79.650202] refcount_t: addition on 0; use-after-free.
[   79.650249] WARNING: CPU: 2 PID: 3533 at ../lib/refcount.c:25 refcount_warn_saturate+0xcf/0xf0
[   79.654241] Modules linked in: vkms(-)
[   79.654249] CPU: 2 PID: 3533 Comm: rmmod Not tainted 5.4.273 #4
[   79.654251] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[   79.654262] RIP: 0010:refcount_warn_saturate+0xcf/0xf0
...
[   79.654296] Call Trace:
[   79.654462]  ? __warn+0x80/0xd0
[   79.654473]  ? refcount_warn_saturate+0xcf/0xf0
[   79.654481]  ? report_bug+0xb6/0x130
[   79.654484]  ? refcount_warn_saturate+0xcf/0xf0
[   79.654489]  ? fixup_bug.part.12+0x13/0x30
[   79.654492]  ? do_error_trap+0x90/0xb0
[   79.654495]  ? do_invalid_op+0x31/0x40
[   79.654497]  ? refcount_warn_saturate+0xcf/0xf0
[   79.654504]  ? invalid_op+0x1e/0x30
[   79.654508]  ? refcount_warn_saturate+0xcf/0xf0
[   79.654516]  drm_atomic_state_init+0x68/0xb0
[   79.654543]  drm_atomic_state_alloc+0x43/0x60
[   79.654551]  drm_atomic_helper_disable_all+0x13/0x180
[   79.654562]  drm_atomic_helper_shutdown+0x5f/0xb0
[   79.654571]  vkms_release+0x18/0x40 [vkms]
[   79.654575]  vkms_exit+0x29/0xc00 [vkms]
[   79.654582]  __x64_sys_delete_module+0x155/0x220
[   79.654592]  do_syscall_64+0x43/0x120
[   79.654603]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[   79.654619] ---[ end trace ce0c02f57ea6bf73 ]---

It seems that the proper unload sequence is:
	drm_atomic_helper_shutdown();
	drm_dev_put();

Just put drm_atomic_helper_shutdown() before drm_dev_put()
should solve the problem.

Note that vkms exit code is refactored by commit 53d77aaa3f76
("drm/vkms: Use devm_drm_dev_alloc") in tags/v5.10-rc1.

So this bug only exists on 4.19 and 5.4.

Fixes: 380c7ceabdde ("drm/atomic: Fix potential use-after-free in nonblocking commits")
Fixes: 2ead1be54b22 ("drm/vkms: Fix connector leak at the module removal")
Signed-off-by: Guo Mengqi <guomengqi3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vkms/vkms_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -39,7 +39,6 @@ static void vkms_release(struct drm_devi
 	struct vkms_device *vkms = container_of(dev, struct vkms_device, drm);
 
 	platform_device_unregister(vkms->platform);
-	drm_atomic_helper_shutdown(&vkms->drm);
 	drm_mode_config_cleanup(&vkms->drm);
 	drm_dev_fini(&vkms->drm);
 }
@@ -137,6 +136,7 @@ static void __exit vkms_exit(void)
 	}
 
 	drm_dev_unregister(&vkms_device->drm);
+	drm_atomic_helper_shutdown(&vkms_device->drm);
 	drm_dev_put(&vkms_device->drm);
 
 	kfree(vkms_device);



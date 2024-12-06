Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E7C10E0;
	Fri,  6 Dec 2024 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496428; cv=none; b=bcF7/3eETGeNFb4Y3so1ZKb67ME5kmeQz8adfkGbJW4GZSJ95ywmLNqXjhAMarIcqRhSYWg4Gqlzm9+m4UxfAVOD1GtZNS8PgFwat0Qblk9Weqh+g6aFHYlvAQ/3enY89LryJqtGy6lV6KX0KvPJwsbamxGTlsY9N0Fy/nQeG3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496428; c=relaxed/simple;
	bh=FodJZGUeAT3AkfhCzc07DHjM9G83KayMbUEAXYxWCyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxsC8SWA/NscGKNMKy1TBiRkuWHmY5tUHmXBqszgxBzcasR9+zcYZDuGiT03Ly3DIwHCtJ1wTEEKPrQNukfaTxqw9B5SBJ7KBiQO6hUIueY9XzPVePTkoUuIf9OjvhgQKGv1M1+eXuvpf09Em4li10hwfjYQ5yI1NsrctbKQH28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gn31h1c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gn31h1c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC4CC4CED1;
	Fri,  6 Dec 2024 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496427;
	bh=FodJZGUeAT3AkfhCzc07DHjM9G83KayMbUEAXYxWCyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gn31h1c8aMNe0skOcE9T/UTkyHP6FFM7mKwJoK0C5ti2YO4ojuTqINBJ9/8LNcfpT
	 dNARS/3ZZ8O+6QP3kNSfoT1OuhRzQgf5nEzYPNa4JB+kRdAWQZDa9hjnij/VXfqxIN
	 rRg50Esrj83s9OR56jVaIFHf2JvOM9XeAA5idphI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 6.12 119/146] drm/panic: Fix uninitialized spinlock acquisition with CONFIG_DRM_PANIC=n
Date: Fri,  6 Dec 2024 15:37:30 +0100
Message-ID: <20241206143532.237160837@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

commit 319e53f155907cf2c6dabc16ec9dce0179bc04d1 upstream.

It turns out that if you happen to have a kernel config where
CONFIG_DRM_PANIC is disabled and spinlock debugging is enabled, along with
KMS being enabled - we'll end up trying to acquire an uninitialized
spin_lock with drm_panic_lock() when we try to do a commit:

  rvkms rvkms.0: [drm:drm_atomic_commit] committing 0000000068d2ade1
  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  CPU: 4 PID: 1347 Comm: modprobe Not tainted 6.10.0-rc1Lyude-Test+ #272
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20240524-3.fc40 05/24/2024
  Call Trace:
   <TASK>
   dump_stack_lvl+0x77/0xa0
   assign_lock_key+0x114/0x120
   register_lock_class+0xa8/0x2c0
   __lock_acquire+0x7d/0x2bd0
   ? __vmap_pages_range_noflush+0x3a8/0x550
   ? drm_atomic_helper_swap_state+0x2ad/0x3a0
   lock_acquire+0xec/0x290
   ? drm_atomic_helper_swap_state+0x2ad/0x3a0
   ? lock_release+0xee/0x310
   _raw_spin_lock_irqsave+0x4e/0x70
   ? drm_atomic_helper_swap_state+0x2ad/0x3a0
   drm_atomic_helper_swap_state+0x2ad/0x3a0
   drm_atomic_helper_commit+0xb1/0x270
   drm_atomic_commit+0xaf/0xe0
   ? __pfx___drm_printfn_info+0x10/0x10
   drm_client_modeset_commit_atomic+0x1a1/0x250
   drm_client_modeset_commit_locked+0x4b/0x180
   drm_client_modeset_commit+0x27/0x50
   __drm_fb_helper_restore_fbdev_mode_unlocked+0x76/0x90
   drm_fb_helper_set_par+0x38/0x40
   fbcon_init+0x3c4/0x690
   visual_init+0xc0/0x120
   do_bind_con_driver+0x409/0x4c0
   do_take_over_console+0x233/0x280
   do_fb_registered+0x11f/0x210
   fbcon_fb_registered+0x2c/0x60
   register_framebuffer+0x248/0x2a0
   __drm_fb_helper_initial_config_and_unlock+0x58a/0x720
   drm_fbdev_generic_client_hotplug+0x6e/0xb0
   drm_client_register+0x76/0xc0
   _RNvXs_CsHeezP08sTT_5rvkmsNtB4_5RvkmsNtNtCs1cdwasc6FUb_6kernel8platform6Driver5probe+0xed2/0x1060 [rvkms]
   ? _RNvMs_NtCs1cdwasc6FUb_6kernel8platformINtB4_7AdapterNtCsHeezP08sTT_5rvkms5RvkmsE14probe_callbackBQ_+0x2b/0x70 [rvkms]
   ? acpi_dev_pm_attach+0x25/0x110
   ? platform_probe+0x6a/0xa0
   ? really_probe+0x10b/0x400
   ? __driver_probe_device+0x7c/0x140
   ? driver_probe_device+0x22/0x1b0
   ? __device_attach_driver+0x13a/0x1c0
   ? __pfx___device_attach_driver+0x10/0x10
   ? bus_for_each_drv+0x114/0x170
   ? __device_attach+0xd6/0x1b0
   ? bus_probe_device+0x9e/0x120
   ? device_add+0x288/0x4b0
   ? platform_device_add+0x75/0x230
   ? platform_device_register_full+0x141/0x180
   ? rust_helper_platform_device_register_simple+0x85/0xb0
   ? _RNvMs2_NtCs1cdwasc6FUb_6kernel8platformNtB5_6Device13create_simple+0x1d/0x60
   ? _RNvXs0_CsHeezP08sTT_5rvkmsNtB5_5RvkmsNtCs1cdwasc6FUb_6kernel6Module4init+0x11e/0x160 [rvkms]
   ? 0xffffffffc083f000
   ? init_module+0x20/0x1000 [rvkms]
   ? kernfs_xattr_get+0x3e/0x80
   ? do_one_initcall+0x148/0x3f0
   ? __lock_acquire+0x5ef/0x2bd0
   ? __lock_acquire+0x5ef/0x2bd0
   ? __lock_acquire+0x5ef/0x2bd0
   ? put_cpu_partial+0x51/0x1d0
   ? lock_acquire+0xec/0x290
   ? put_cpu_partial+0x51/0x1d0
   ? lock_release+0xee/0x310
   ? put_cpu_partial+0x51/0x1d0
   ? fs_reclaim_acquire+0x69/0xf0
   ? lock_acquire+0xec/0x290
   ? fs_reclaim_acquire+0x69/0xf0
   ? kfree+0x22f/0x340
   ? lock_release+0xee/0x310
   ? kmalloc_trace_noprof+0x48/0x340
   ? do_init_module+0x22/0x240
   ? kmalloc_trace_noprof+0x155/0x340
   ? do_init_module+0x60/0x240
   ? __se_sys_finit_module+0x2e0/0x3f0
   ? do_syscall_64+0xa4/0x180
   ? syscall_exit_to_user_mode+0x108/0x140
   ? do_syscall_64+0xb0/0x180
   ? vma_end_read+0xd0/0xe0
   ? do_user_addr_fault+0x309/0x640
   ? clear_bhb_loop+0x45/0xa0
   ? clear_bhb_loop+0x45/0xa0
   ? clear_bhb_loop+0x45/0xa0
   ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Fix this by stubbing these macros out when this config option isn't
enabled, along with fixing the unused variable warning that introduces.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: e2a1cda3e0c7 ("drm/panic: Add drm panic locking")
Cc: <stable@vger.kernel.org> # v6.10+
Link: https://patchwork.freedesktop.org/patch/msgid/20240916230103.611490-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_helper.c |  2 +-
 include/drm/drm_panic.h             | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 43cdf39019a4..5186d2114a50 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -3015,7 +3015,7 @@ int drm_atomic_helper_swap_state(struct drm_atomic_state *state,
 				  bool stall)
 {
 	int i, ret;
-	unsigned long flags;
+	unsigned long flags = 0;
 	struct drm_connector *connector;
 	struct drm_connector_state *old_conn_state, *new_conn_state;
 	struct drm_crtc *crtc;
diff --git a/include/drm/drm_panic.h b/include/drm/drm_panic.h
index 54085d5d05c3..f4e1fa9ae607 100644
--- a/include/drm/drm_panic.h
+++ b/include/drm/drm_panic.h
@@ -64,6 +64,8 @@ struct drm_scanout_buffer {
 
 };
 
+#ifdef CONFIG_DRM_PANIC
+
 /**
  * drm_panic_trylock - try to enter the panic printing critical section
  * @dev: struct drm_device
@@ -149,4 +151,16 @@ struct drm_scanout_buffer {
 #define drm_panic_unlock(dev, flags) \
 	raw_spin_unlock_irqrestore(&(dev)->mode_config.panic_lock, flags)
 
+#else
+
+static inline bool drm_panic_trylock(struct drm_device *dev, unsigned long flags)
+{
+	return true;
+}
+
+static inline void drm_panic_lock(struct drm_device *dev, unsigned long flags) {}
+static inline void drm_panic_unlock(struct drm_device *dev, unsigned long flags) {}
+
+#endif
+
 #endif /* __DRM_PANIC_H__ */
-- 
2.47.1




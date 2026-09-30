Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7F14F4036;
	Wed, 30 Sep 2026 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787781; cv=none; b=VVc6QvtGWmadXQPXtZGsfVD5rX7bpmnJahiS0NJMTnRxfZ9XUSCOPWuAbRmuQsCkXxIWPpjPadSpDkm2uIsjnoFV9cOFC38eOKJjDF62Fx198nwk4H3r212pYOkUbRxwq10tVZuOgXCUu4rdvhYFmn2bo2PIAEP2dAJFEyk2ofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787781; c=relaxed/simple;
	bh=E0aNrKE8XftUhLj+dbnAXC4uzX29JSBRj1bq+7jKv3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDRP9lpjpUG2lMAVis/gMP/Ol/Mrgxr99I5IqlfqRtVCbS+QMdpqSDxqIMDYNrdF/RqKpLlSxw3N234KJbAwmupL56WIYajZ+dCV/n78ObbEYLrE475RdM2rheGmjjt+99pYdaCHaP4qK7UTMu26O0L5n4rx9/btOuAoxGN4Ldc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIaBdZDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIaBdZDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56511F000FF;
	Wed, 30 Sep 2026 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787780;
	bh=14pZSIaZxQhDydzZ0c2zg/cg8mg9+PMahsg6Ppe3FpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIaBdZDZ1baAzt+Yq6DzgZanYapv1WlNmHn1ss7V9Fu1mJAOwBu4rg2sTE+YbRyYd
	 eIEwzT5rt1jWXZaKooZ5hKimceu48vahKRYa2/Sog6Hr5VrQ6ElbcFIrGI2Sjuza/a
	 0Ot/9pMlLUYT6wFW/O9KkcZT6BNSwl1DXWsm8wnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 7.2 306/457] drm/virtio: fix memory leak of fence event on execbuffer failure
Date: Wed, 30 Sep 2026 17:26:51 +0200
Message-ID: <20260930152352.633940767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit b74aad23d99b279bb34d135795f39a6d8ecdc075 upstream.

virtio_gpu_execbuffer_ioctl() reserves a DRM event with
drm_event_reserve_init() when VIRTGPU_EXECBUF_RING_IDX selects a ring that
userspace has enabled polling for. virtio_gpu_init_submit() does this
before the BO handles, the command buffer, the syncobj arrays and the
in-fence are processed, so every later error path runs with the event
already pending, including plain argument validation failures such as an
invalid bo_handle or an in-syncobj that carries no fence.

On those paths, virtio_gpu_cleanup_submit() drops the out-fence without
cancelling the event. The fence is freed without ever having been emitted,
taking the only driver-side pointer to the event with it. Closing the DRM
file does not help. drm_events_release() unlinks pending events but
deliberately leaves the freeing to the driver's later drm_send_event(),
which never runs for an orphaned event, so the allocation is leaked
permanently.

Found when fuzzing the virtio driver with Syzkaller:

	BUG: memory leak
	unreferenced object 0xffff88802c176e80 (size 96):
	comm "syz.1.367", pid 10561, jiffies 4294960122
	hex dump (first 32 bytes):
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
		c8 6e 17 2c 80 88 ff ff 00 00 00 00 00 00 00 00  .n.,............
	backtrace (crc e1973c6b):
		kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
		slab_post_alloc_hook mm/slub.c:4597 [inline]
		slab_alloc_node mm/slub.c:4917 [inline]
		__kmalloc_cache_noprof+0x49d/0x6f0 mm/slub.c:5485
		_kmalloc_noprof include/linux/slab.h:988 [inline]
		_kzalloc_noprof include/linux/slab.h:1309 [inline]
		virtio_gpu_fence_event_create drivers/gpu/drm/virtio/virtgpu_submit.c:282 [inline]
		virtio_gpu_init_submit drivers/gpu/drm/virtio/virtgpu_submit.c:398 [inline]
		virtio_gpu_execbuffer_ioctl+0xbbf/0x1aa0 drivers/gpu/drm/virtio/virtgpu_submit.c:505
		drm_ioctl_kernel+0x1f4/0x3e0 drivers/gpu/drm/drm_ioctl.c:817
		drm_ioctl+0x5f4/0xc70 drivers/gpu/drm/drm_ioctl.c:914
		vfs_ioctl fs/ioctl.c:51 [inline]
		__do_sys_ioctl fs/ioctl.c:597 [inline]
		__se_sys_ioctl fs/ioctl.c:583 [inline]
		__x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
		do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
		do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
		entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix by cancelling and freeing the DRM event on the execbuffer error path
before dropping the fence. Clear the fence's event pointer after
cancellation so it does not retain a dangling pointer.

Fixes: cd7f5ca33585 ("drm/virtio: implement context init: add virtio_gpu_fence_event")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Assisted-by: Codex:gpt-5.6-luna
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/D320EAB5680C1411+20260908121323.2405044-1-peiyang_he@smail.nju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_submit.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/virtio/virtgpu_submit.c
+++ b/drivers/gpu/drm/virtio/virtgpu_submit.c
@@ -538,6 +538,10 @@ int virtio_gpu_execbuffer_ioctl(struct d
 	virtio_gpu_process_post_deps(&submit);
 	virtio_gpu_complete_submit(&submit);
 cleanup:
+	if (ret && submit.out_fence && submit.out_fence->e) {
+		drm_event_cancel_free(dev, &submit.out_fence->e->base);
+		submit.out_fence->e = NULL;
+	}
 	virtio_gpu_cleanup_submit(&submit);
 
 	return ret;



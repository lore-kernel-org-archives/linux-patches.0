Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624267;
	b=tLtWaNEFcfa9gFqUzlQj6v+0cmUtiA8S+/7f/29iFF1cNH75XRdDq+A1akpNDzlfTu9e
	 NlH9STlPYlzTgdwrQsdvqQWKAQOpjFkzTV/s/fvHy5gRplJbMHO+erpbWR67xo368L/el
	 mAYNtSpWhvb6Zptknifn2XqgF6jDgPfXcgX2c+7MYoLvOVI92VGTOMEG/eKbQabkKnMca
	 U5iK4ni8KtSDGprBZ5O4+u7pywcmn2qr0rCXPVTAlTEwBLpgsW/cxwrgWpqXFGP3I6lOW
	 mMhiqTEmkBOatiOxmVobZ/9Zxhl/hWeFGTeYIS8AGe4m3ablsnIjU4C7aoJhjJPX86w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DiHljBqf7fwPU5iHbQXrloG3LTbjvhVE0Zc5qTEUKOc=;
	b=G6Lay73Tqv+M7elscED1l+Cc0a/4Q44HMq5CDupopUueIkzxc+/t5lBz/bl8BAAX6/yE
	 6KI4GbzyW/RJGfP4g7ksrACn0u8S1avkzxUn9+Fl0teCPPQRIBS4PCjy5Lx4yAZF3fZEn
	 D9nGc644pAoSFKGU8UvaDPbVH6sFuYPmHI2NL40Fd/pfNscwm4l9W3QIW1TM0TAzW0her
	 lh/Tw3Wv3/Pui8DMdL/pNpuUxl6ai8W1VvQ0EmUXjwcGo6umBMhAQND6dOqqDP3+0nUAV
	 ehPdNgjd2TOjyfJFEsdHXYwHBn4jypWvUyPDo/ScoRFnbNgqhd2nCk0PVz++PuzfQRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JMRPg/br";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC8A606A336;
	Wed, 25 Nov 2026 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMRPg/br
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8671F000F2;
	Wed, 25 Nov 2026 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624267;
	bh=DiHljBqf7fwPU5iHbQXrloG3LTbjvhVE0Zc5qTEUKOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMRPg/brv9mNZhojgDbaFpBv5rAC5nQtdR2U8b+g4DQIxou30F4yXj0l6N3pPlhCy
	 Xe3wx1mF12opNGchf4KxZORDxk0cqoZN0k7UjCbVY5PoIuh8gfQQywdTRi8qOCM5Jp
	 4Y43F3YGfVCh0GwHEC/RJFY4P+GaEI/XSz/djx4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/816] vhost-vdpa: drop the parents vq callback before the call fd is released
Date: Wed, 25 Nov 2026 15:28:07 +0100
Message-ID: <20261125143852.419184230@linuxfoundation.org>
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

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit c9c1c1b7b31fc8b9a5d6c04f5f0ae647d081a39d ]

VHOST_SET_VRING_CALL releases the previous call eventfd inside
vhost_vring_ioctl() -- it swaps the new context into vq->call_ctx.ctx
and then eventfd_ctx_put()s the old one, which is a synchronous
kfree(). The parent vdpa device is only told about the change
afterwards, when vhost_vdpa_vring_ioctl() reaches ops->set_vq_cb().

Parent drivers cache the pointer handed to them in
vdpa_callback::trigger and do not take a reference on it, so
throughout that window the parent holds a dangling eventfd_ctx and may
signal it. The documentation added with the field describes what
signalling it means but says nothing about how long it stays valid.

This is the same hazard that "vhost_vdpa: assign irq bypass producer
token correctly" addressed for the irq bypass producer token, by
moving vhost_vdpa_unsetup_vq_irq() ahead of the vhost_vring_ioctl()
call. The producer token was only one of the two consumers of that
pointer; the one the parent keeps via ->set_vq_cb() was left behind
the free.

With VDUSE the window is directly reachable from userspace, because
the device emulation daemon can inject an interrupt at any time from a
different fd, and neither side shares a lock with the other: VDUSE
takes vq->irq_lock, vhost takes vhost_dev.mutex + vq->mutex.

  BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x76/0xe0
  Write of size 4 at addr ffff8881084e8788 by task vduse_uaf/2987

  _raw_spin_lock_irqsave+0x76/0xe0
  eventfd_signal_mask+0x69/0x120
  vduse_dev_ioctl+0x337/0x1a60     <- vduse_vq_signal_irqfd(), inlined
  __x64_sys_ioctl+0x120/0x170      <- VDUSE_VQ_INJECT_IRQ

  Allocated by task 2986:
   do_eventfd+0x50/0x200
   __x64_sys_eventfd2+0x2e/0x40

  kmalloc-64, freed 64-byte region [ffff8881084e8780, ffff8881084e87c0)

One thread loops VHOST_SET_VRING_CALL on /dev/vhost-vdpa-N with a
fresh eventfd and then unbinds it, while another loops
VDUSE_VQ_INJECT_IRQ on /dev/vduse/<name>. This reproduces in 5 out of
5 ten-second runs on v7.1.6 and 3 out of 3 on v7.2-rc6. With the patch
there are no reports in 3 out of 3 runs on either, while the same
workload still gets ~30000 interrupts per run delivered into live
eventfds, so the path is still being exercised.

Tell the parent to drop the callback before vhost_vring_ioctl() can
free the eventfd, mirroring what is already done for the bypass
producer, and restore it if the ioctl fails -- on failure the swap
never happened, the old context is still installed, and leaving the
parent without a callback would silently drop that vq's interrupts.

Clearing the callback only stops a parent from starting to use the
context; a handler that already loaded it can still be running. For
parents with a real interrupt, wait for it with synchronize_irq() on
the vq's irq. VDUSE does not implement get_vq_irq, so that case stays
covered by the teardown above.

Fixes: 5e68470f4e80 ("vdpa: Add eventfd for the vdpa callback")
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260918040436.47982-1-yuz08559@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2e0dbfa0a141f..9e881c4d25ba3 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -765,13 +765,46 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			if (ops->get_status(vdpa) &
 			    VIRTIO_CONFIG_S_DRIVER_OK)
 				vhost_vdpa_unsetup_vq_irq(v, idx);
+			/*
+			 * The parent caches call_ctx.ctx in cb.trigger without
+			 * holding a reference, so it has to stop using it
+			 * before vhost_vring_ioctl() drops the last one.
+			 */
+			cb.callback = NULL;
+			cb.private = NULL;
+			cb.trigger = NULL;
+			ops->set_vq_cb(vdpa, idx, &cb);
+
+			/*
+			 * A parent interrupt handler that loaded the callback
+			 * before that store can still be running, so wait for
+			 * it to finish with the context too.
+			 */
+			if (ops->get_vq_irq) {
+				int irq = ops->get_vq_irq(vdpa, idx);
+
+				if (irq >= 0)
+					synchronize_irq(irq);
+			}
 		}
 		break;
 	}
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
-	if (r)
+	if (r) {
+		/*
+		 * A failure here means the swap never happened and the old
+		 * context is still installed, so give the parent back the
+		 * callback that was torn down above.
+		 */
+		if (cmd == VHOST_SET_VRING_CALL && vq->call_ctx.ctx) {
+			cb.callback = vhost_vdpa_virtqueue_cb;
+			cb.private = vq;
+			cb.trigger = vq->call_ctx.ctx;
+			ops->set_vq_cb(vdpa, idx, &cb);
+		}
 		return r;
+	}
 
 	switch (cmd) {
 	case VHOST_SET_VRING_ADDR:
-- 
2.53.0




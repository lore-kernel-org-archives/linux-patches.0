Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656A4ED1AF;
	Thu, 17 Sep 2026 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659720; cv=none; b=cIVRM5FNSGyByLNwPqqTYlpwQtotdwoqx9ODk/wLwovr72wVZmeQhmEmwXKM8ZeQi7726YIXW7efR/ACb7t5IsUZhpK/Z19HIxI06E6yWMv86srRWGnw2X4mr3IYJTwRdWRKlPhyvb0PrTTTeOYI3wJxgunA9S3AKK0UU6zd6K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659720; c=relaxed/simple;
	bh=YvWkNq1S+2P2vyCNiJJSckm5B/nNzyE/HnMmdTPWgMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTQAOJbNxRr8oaJfpcj0e+a9Bbxp8D+xSH2+aLhTPJd8mf4FSVjnwnnynqe78DDP5kLsNEjJ56S8qDdG5l8WNgFX8F75sOnlV3RzO5EfnX2TRcsr+kVZcFBGorYtRPux1G+KCMSZCO+ePDaa/xRt5so74kb2qGGvr5TVZMQM2SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELWPIgl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELWPIgl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C22C1F0089A;
	Thu, 17 Sep 2026 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659702;
	bh=IoILOzx+PArbooRXiEX61sVqJS5/UW8cGV5QXKmPDGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELWPIgl+wGAcxc9ZGuFBinvmmbzmvGyoXjHcOrghhWyk4zGm3wLxpmZFon4N8BqDq
	 HmnMg1YYigUOF2kOj5NEcfzSt8DKGcrD6+qJqkpK7hjag2OGH+atnvPq9QFPnr29Is
	 3P96VxZMjCNNikkoCL2DEhI7CxsIdSENWmoLkwxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 346/733] vhost-vdpa: protect config_ctx from being freed under the config callback
Date: Thu, 17 Sep 2026 16:10:54 +0100
Message-ID: <20260917151400.184601849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit 62be4e3e5f5f947fbf765b914cebdc478f715d12 ]

vhost_vdpa_config_cb() loads v->config_ctx and signals it without taking
a reference and without holding any lock:

	struct eventfd_ctx *config_ctx = v->config_ctx;

	if (config_ctx)
		eventfd_signal(config_ctx);

VHOST_VDPA_SET_CONFIG_CALL replaces that field and drops what is normally
the last reference to the old context:

	swap(ctx, v->config_ctx);

	if (ctx)
		eventfd_ctx_put(ctx);

eventfd_ctx_put() drops the last kref and frees the context immediately,
with no RCU grace period, so a callback that has already loaded the
pointer goes on to dereference freed memory.  The two sides share no
lock: the ioctl runs under vhost_dev.mutex, while the parent invokes the
callback from its own interrupt or workqueue context.

This is not the reopen refcount underflow fixed by commit f6bbf0010ba0
("vhost-vdpa: fix use-after-free of v->config_ctx"), which was about
vhost_vdpa_config_put() leaving a stale pointer behind.  Here the pointer
is maintained correctly and it is the read side that is unprotected.

With VDUSE as the parent this is reachable from userspace with access to
/dev/vduse (root by default).  VDUSE_DEV_INJECT_CONFIG_IRQ queues
dev->inject, and vduse_dev_irq_inject() runs the callback under VDUSE's
own dev->irq_lock, which vhost does not hold.  vduse_dev_reset() does
flush_work(&dev->inject), but VHOST_VDPA_SET_CONFIG_CALL never goes
through reset, so an inject already in flight is not waited for.  A
process that injects config interrupts on the VDUSE fd while another
thread swaps the call fd on the vhost-vdpa fd hits it in seconds:

  BUG: KASAN: slab-use-after-free in native_queued_spin_lock_slowpath
  Read of size 4 at addr ffff888107d21808 by task kworker/u17:1/2993
  Workqueue: vduse-irq vduse_dev_irq_inject
  Call Trace:
   native_queued_spin_lock_slowpath+0x97/0x5b0
   _raw_spin_lock_irqsave+0xd4/0xe0
   eventfd_signal_mask+0x69/0x120
   vhost_vdpa_config_cb+0x34/0x50
   vduse_dev_irq_inject+0x46/0x60
   process_one_work+0x468/0x950

  Allocated by task 2992:
   do_eventfd+0x50/0x200
   __x64_sys_eventfd2+0x2e/0x40

  Freed by task 2992:
   eventfd_ctx_put+0xb9/0xc0
   vhost_vdpa_unlocked_ioctl+0x116c/0x2190

Add a spinlock covering every access to config_ctx, so the callback
either signals a context that is still alive or observes NULL, and the
put happens only once no callback can reach the old value.

Clearing the parent's callback before the put would not be enough: of the
in-tree set_config_cb() implementations only VDUSE takes a lock, the rest
store the pointer unlocked, so that would not order against an in-flight
invocation.

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260807100025.19750-3-yuz08559@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3e5165b7c094e..a31786796d4ce 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -62,6 +62,8 @@ struct vhost_vdpa {
 	int virtio_id;
 	int minor;
 	struct eventfd_ctx *config_ctx;
+	/* Serialises vhost_vdpa_config_cb() against config_ctx being replaced. */
+	spinlock_t config_lock;
 	int in_batch;
 	struct vdpa_iova_range range;
 	u32 batch_asid;
@@ -195,10 +197,12 @@ static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
 static irqreturn_t vhost_vdpa_config_cb(void *private)
 {
 	struct vhost_vdpa *v = private;
-	struct eventfd_ctx *config_ctx = v->config_ctx;
+	unsigned long flags;
 
-	if (config_ctx)
-		eventfd_signal(config_ctx);
+	spin_lock_irqsave(&v->config_lock, flags);
+	if (v->config_ctx)
+		eventfd_signal(v->config_ctx);
+	spin_unlock_irqrestore(&v->config_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -528,15 +532,22 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
 
 static void vhost_vdpa_config_put(struct vhost_vdpa *v)
 {
-	if (v->config_ctx) {
-		eventfd_ctx_put(v->config_ctx);
-		v->config_ctx = NULL;
-	}
+	struct eventfd_ctx *ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&v->config_lock, flags);
+	ctx = v->config_ctx;
+	v->config_ctx = NULL;
+	spin_unlock_irqrestore(&v->config_lock, flags);
+
+	if (ctx)
+		eventfd_ctx_put(ctx);
 }
 
 static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 {
 	struct vdpa_callback cb;
+	unsigned long flags;
 	int fd;
 	struct eventfd_ctx *ctx;
 
@@ -549,8 +560,14 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	spin_lock_irqsave(&v->config_lock, flags);
 	swap(ctx, v->config_ctx);
+	spin_unlock_irqrestore(&v->config_lock, flags);
 
+	/*
+	 * The callback can no longer reach the old context, so this is the
+	 * last reference to it.
+	 */
 	if (ctx)
 		eventfd_ctx_put(ctx);
 
@@ -1639,6 +1656,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	}
 
 	atomic_set(&v->opened, 0);
+	spin_lock_init(&v->config_lock);
 	v->minor = minor;
 	v->vdpa = vdpa;
 	v->nvqs = vdpa->nvqs;
-- 
2.53.0




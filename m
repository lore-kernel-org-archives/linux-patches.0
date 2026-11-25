Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624264;
	b=Lq1NDA+yPjHgiyceC9Pu4o8Az6ZzMK7lPw1jyCarjpPrsmQlQpgV0WFQHghuywFk84kn
	 qmug1wSXw+u72luUdr6hEh7RBOaYYwXLRzGmlhRj1cYTY5mLu8rYoGHoO43pEydY5QewL
	 JbuUP83CucjS+Q3m0UEw+DZ1g30a+CaQUWGRHf/03se6IqivqRBpNVRLKKI2MxYb1RmOb
	 wVycL4kQsE6nPASf/ofoCGhXC39jJ/AgPcMzlbLsCfEds0o6rx4WQhqebqmMxvZGh2WEs
	 tkeHqhGv/755wiu+BH7vYhgN0mbSHSEBs0Uov4IHShd/PuxJM9KEAN7f7+51ccm21OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CAKYIx00le0eBHngr5FQK9S4gEHBYoHtZRF6BuT39MY=;
	b=mHHFg4jDCzsYX71i+sJM2hN0il5dEg5It3BMCIMsclZRyyKW+g7FDioyJ3CaSwiPS7wG
	 gUawyPLRINSp/cfDn1GKKxMjykmSgeH9yYYI5yAX7k4yOllTlARrjOZKqTBvjY/RvyxAq
	 LshE3tsOGWlMZBvBDEnYi++TnJoGj5VwnUPPXybd0n4KhIqLWkoI5G4wNZrpozM3eVj1W
	 PAqtsubbfv6mIg/aLK+TTrcH6PltAG/gleKAnGotZyKqXsPM+Icv2Q9hRTL57bIpzcrTU
	 bs0+OMhUWGQ/UFkazGozfbP9dOJLxkwJtpXb0V9aLfVe9joofOX1egs63yyFr63wTpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IQPcq/FT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C987606A685;
	Wed, 25 Nov 2026 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQPcq/FT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7301F000C4;
	Wed, 25 Nov 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624264;
	bh=CAKYIx00le0eBHngr5FQK9S4gEHBYoHtZRF6BuT39MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQPcq/FTlKJuv8O0jrxXoeC/jQXOBDJq2GK3Gu/+WS419FIgA/y0DMXuJN8Tnz8Ir
	 gvyPAoWGiizC4BLYKhjOxFgtJswnijnevFLPe+xI5z1ww2ZBaDJWhkc7Tj4RoNBwA0
	 9Ovbpl3B+9ZlEUOBdj2ZSlb9us/XrpqtEmrd8RFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/816] irqbypass: Take ownership of producer/consumer token tracking
Date: Wed, 25 Nov 2026 15:28:06 +0100
Message-ID: <20261125143852.397072263@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2b521d86ee80a436a92445b8206d38d75aeb39ea ]

Move ownership of IRQ bypass token tracking into irqbypass.ko, and
explicitly require callers to pass an eventfd_ctx structure instead of a
completely opaque token.  Relying on producers and consumers to set the
token appropriately is error prone, and hiding the fact that the token must
be an eventfd_ctx pointer (for all intents and purposes) unnecessarily
obfuscates the code and makes it more brittle.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Link: https://lore.kernel.org/r/20250516230734.2564775-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: c9c1c1b7b31f ("vhost-vdpa: drop the parent's vq callback before the call fd is released")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c                |  4 +--
 drivers/vfio/pci/vfio_pci_intrs.c |  9 +++----
 drivers/vhost/vdpa.c              |  8 +++---
 include/linux/irqbypass.h         | 35 +++++++++++++-----------
 virt/kvm/eventfd.c                |  7 +++--
 virt/lib/irqbypass.c              | 44 ++++++++++++++++++++-----------
 6 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee3b528ec1e27..5068282e20705 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12850,8 +12850,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 0);
 	if (ret)
-		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
-		       " fails: %d\n", irqfd->consumer.token, ret);
+		printk(KERN_INFO "irq bypass consumer (eventfd %p) unregistration"
+		       " fails: %d\n", irqfd->consumer.eventfd, ret);
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index ed86747749e53..d867bced40bb7 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -512,15 +512,12 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto out_put_eventfd_ctx;
 
-	ctx->producer.token = trigger;
 	ctx->producer.irq = irq;
-	ret = irq_bypass_register_producer(&ctx->producer);
+	ret = irq_bypass_register_producer(&ctx->producer, trigger);
 	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
-		"irq bypass producer (token %p) registration fails: %d\n",
-		ctx->producer.token, ret);
-
-		ctx->producer.token = NULL;
+		"irq bypass producer (eventfd %p) registration fails: %d\n",
+		trigger, ret);
 	}
 	ctx->trigger = trigger;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d467422559cdc..2e0dbfa0a141f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -225,10 +225,10 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	vq->call_ctx.producer.irq = irq;
-	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
+	ret = irq_bypass_register_producer(&vq->call_ctx.producer, vq->call_ctx.ctx);
 	if (unlikely(ret))
-		dev_info(&v->dev, "vq %u, irq bypass producer (token %p) registration fails, ret =  %d\n",
-			 qid, vq->call_ctx.producer.token, ret);
+		dev_info(&v->dev, "vq %u, irq bypass producer (eventfd %p) registration fails, ret =  %d\n",
+			 qid, vq->call_ctx.ctx, ret);
 }
 
 static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
@@ -765,7 +765,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			if (ops->get_status(vdpa) &
 			    VIRTIO_CONFIG_S_DRIVER_OK)
 				vhost_vdpa_unsetup_vq_irq(v, idx);
-			vq->call_ctx.producer.token = NULL;
 		}
 		break;
 	}
@@ -806,7 +805,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.callback = vhost_vdpa_virtqueue_cb;
 			cb.private = vq;
 			cb.trigger = vq->call_ctx.ctx;
-			vq->call_ctx.producer.token = vq->call_ctx.ctx;
 			if (ops->get_status(vdpa) &
 			    VIRTIO_CONFIG_S_DRIVER_OK)
 				vhost_vdpa_setup_vq_irq(v, idx);
diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 9bdb2a7818418..1b57d15ac4cf2 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -10,6 +10,7 @@
 
 #include <linux/list.h>
 
+struct eventfd_ctx;
 struct irq_bypass_consumer;
 
 /*
@@ -18,20 +19,20 @@ struct irq_bypass_consumer;
  * The IRQ bypass manager is a simple set of lists and callbacks that allows
  * IRQ producers (ex. physical interrupt sources) to be matched to IRQ
  * consumers (ex. virtualization hardware that allows IRQ bypass or offload)
- * via a shared token (ex. eventfd_ctx).  Producers and consumers register
- * independently.  When a token match is found, the optional @stop callback
- * will be called for each participant.  The pair will then be connected via
- * the @add_* callbacks, and finally the optional @start callback will allow
- * any final coordination.  When either participant is unregistered, the
- * process is repeated using the @del_* callbacks in place of the @add_*
- * callbacks.  Match tokens must be unique per producer/consumer, 1:N pairings
- * are not supported.
+ * via a shared eventfd_ctx.  Producers and consumers register independently.
+ * When a producer and consumer are paired, i.e. an eventfd match is found, the
+ * optional @stop callback will be called for each participant.  The pair will
+ * then be connected via the @add_* callbacks, and finally the optional @start
+ * callback will allow any final coordination.  When either participant is
+ * unregistered, the process is repeated using the @del_* callbacks in place of
+ * the @add_* callbacks.  eventfds must be unique per producer/consumer, 1:N
+ * pairings are not supported.
  */
 
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
- * @token: opaque token to match between producer and consumer (non-NULL)
+ * @eventfd: eventfd context used to match producers and consumers
  * @irq: Linux IRQ number for the producer device
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
  * @del_consumer: Disconnect the IRQ producer from an IRQ consumer (optional)
@@ -44,7 +45,7 @@ struct irq_bypass_consumer;
  */
 struct irq_bypass_producer {
 	struct list_head node;
-	void *token;
+	struct eventfd_ctx *eventfd;
 	int irq;
 	int (*add_consumer)(struct irq_bypass_producer *,
 			    struct irq_bypass_consumer *);
@@ -57,7 +58,7 @@ struct irq_bypass_producer {
 /**
  * struct irq_bypass_consumer - IRQ bypass consumer definition
  * @node: IRQ bypass manager private list management
- * @token: opaque token to match between producer and consumer (non-NULL)
+ * @eventfd: eventfd context used to match producers and consumers
  * @add_producer: Connect the IRQ consumer to an IRQ producer
  * @del_producer: Disconnect the IRQ consumer from an IRQ producer
  * @stop: Perform any quiesce operations necessary prior to add/del (optional)
@@ -70,7 +71,7 @@ struct irq_bypass_producer {
  */
 struct irq_bypass_consumer {
 	struct list_head node;
-	void *token;
+	struct eventfd_ctx *eventfd;
 	int (*add_producer)(struct irq_bypass_consumer *,
 			    struct irq_bypass_producer *);
 	void (*del_producer)(struct irq_bypass_consumer *,
@@ -79,9 +80,11 @@ struct irq_bypass_consumer {
 	void (*start)(struct irq_bypass_consumer *);
 };
 
-int irq_bypass_register_producer(struct irq_bypass_producer *);
-void irq_bypass_unregister_producer(struct irq_bypass_producer *);
-int irq_bypass_register_consumer(struct irq_bypass_consumer *);
-void irq_bypass_unregister_consumer(struct irq_bypass_consumer *);
+int irq_bypass_register_producer(struct irq_bypass_producer *producer,
+				 struct eventfd_ctx *eventfd);
+void irq_bypass_unregister_producer(struct irq_bypass_producer *producer);
+int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
+				 struct eventfd_ctx *eventfd);
+void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer);
 
 #endif /* IRQBYPASS_H */
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c9c9ccdb0e7ec..43ecb8293e9b9 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -442,15 +442,14 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 	if (kvm_arch_has_irq_bypass()) {
-		irqfd->consumer.token = (void *)irqfd->eventfd;
 		irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
 		irqfd->consumer.del_producer = kvm_arch_irq_bypass_del_producer;
 		irqfd->consumer.stop = kvm_arch_irq_bypass_stop;
 		irqfd->consumer.start = kvm_arch_irq_bypass_start;
-		ret = irq_bypass_register_consumer(&irqfd->consumer);
+		ret = irq_bypass_register_consumer(&irqfd->consumer, irqfd->eventfd);
 		if (ret)
-			pr_info("irq bypass consumer (token %p) registration fails: %d\n",
-				irqfd->consumer.token, ret);
+			pr_info("irq bypass consumer (eventfd %p) registration fails: %d\n",
+				irqfd->eventfd, ret);
 	}
 #endif
 
diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28fda42e471bb..cce0111b1fd4e 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -77,17 +77,19 @@ static void __disconnect(struct irq_bypass_producer *prod,
 /**
  * irq_bypass_register_producer - register IRQ bypass producer
  * @producer: pointer to producer structure
+ * @eventfd: pointer to the eventfd context associated with the producer
  *
  * Add the provided IRQ producer to the list of producers and connect
- * with any matching token found on the IRQ consumers list.
+ * with any matching eventfd found on the IRQ consumers list.
  */
-int irq_bypass_register_producer(struct irq_bypass_producer *producer)
+int irq_bypass_register_producer(struct irq_bypass_producer *producer,
+				 struct eventfd_ctx *eventfd)
 {
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 	int ret;
 
-	if (!producer->token)
+	if (WARN_ON_ONCE(producer->eventfd))
 		return -EINVAL;
 
 	might_sleep();
@@ -98,14 +100,14 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == producer->token) {
+		if (tmp->eventfd == eventfd) {
 			ret = -EBUSY;
 			goto out_err;
 		}
 	}
 
 	list_for_each_entry(consumer, &consumers, node) {
-		if (consumer->token == producer->token) {
+		if (consumer->eventfd == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
 				goto out_err;
@@ -113,6 +115,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 		}
 	}
 
+	producer->eventfd = eventfd;
 	list_add(&producer->node, &producers);
 
 	mutex_unlock(&lock);
@@ -137,7 +140,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 
-	if (!producer->token)
+	if (!producer->eventfd)
 		return;
 
 	might_sleep();
@@ -148,21 +151,23 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token != producer->token)
+		if (tmp->eventfd != producer->eventfd)
 			continue;
 
 		list_for_each_entry(consumer, &consumers, node) {
-			if (consumer->token == producer->token) {
+			if (consumer->eventfd == producer->eventfd) {
 				__disconnect(producer, consumer);
 				break;
 			}
 		}
 
+		producer->eventfd = NULL;
 		list_del(&producer->node);
 		module_put(THIS_MODULE);
 		break;
 	}
 
+	WARN_ON_ONCE(producer->eventfd);
 	mutex_unlock(&lock);
 
 	module_put(THIS_MODULE);
@@ -172,18 +177,22 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 /**
  * irq_bypass_register_consumer - register IRQ bypass consumer
  * @consumer: pointer to consumer structure
+ * @eventfd: pointer to the eventfd context associated with the consumer
  *
  * Add the provided IRQ consumer to the list of consumers and connect
- * with any matching token found on the IRQ producer list.
+ * with any matching eventfd found on the IRQ producer list.
  */
-int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
+int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
+				 struct eventfd_ctx *eventfd)
 {
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
 	int ret;
 
-	if (!consumer->token ||
-	    !consumer->add_producer || !consumer->del_producer)
+	if (WARN_ON_ONCE(consumer->eventfd))
+		return -EINVAL;
+
+	if (!consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
 	might_sleep();
@@ -194,14 +203,14 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->token == consumer->token || tmp == consumer) {
+		if (tmp->eventfd == eventfd) {
 			ret = -EBUSY;
 			goto out_err;
 		}
 	}
 
 	list_for_each_entry(producer, &producers, node) {
-		if (producer->token == consumer->token) {
+		if (producer->eventfd == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
 				goto out_err;
@@ -209,6 +218,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 		}
 	}
 
+	consumer->eventfd = eventfd;
 	list_add(&consumer->node, &consumers);
 
 	mutex_unlock(&lock);
@@ -233,7 +243,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
 
-	if (!consumer->token)
+	if (!consumer->eventfd)
 		return;
 
 	might_sleep();
@@ -248,17 +258,19 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 			continue;
 
 		list_for_each_entry(producer, &producers, node) {
-			if (producer->token == consumer->token) {
+			if (producer->eventfd == consumer->eventfd) {
 				__disconnect(producer, consumer);
 				break;
 			}
 		}
 
+		consumer->eventfd = NULL;
 		list_del(&consumer->node);
 		module_put(THIS_MODULE);
 		break;
 	}
 
+	WARN_ON_ONCE(consumer->eventfd);
 	mutex_unlock(&lock);
 
 	module_put(THIS_MODULE);
-- 
2.53.0




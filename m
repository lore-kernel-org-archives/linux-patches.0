Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF723594D;
	Thu, 17 Apr 2025 18:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916099; cv=none; b=bAgyAWf7A+nmJLNmgt583/8T6BX8lRhTLOFbauu7kds50EBUHYEudyzCPPgz1nl0oQbXisU2n2mi4r3qkZPjHB0wFi2xgRLd4bH8IgP94B/KLnrtI/Uw0Oj0vhub/gczEKKZbZfJptYCnqp64hWKRLprIU12fbnYPz9r4WQywcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916099; c=relaxed/simple;
	bh=p9SZJLBu/G1uHNLVsMtaNvIFkSp3wdza3jcvjCdUVfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYvv703KVrdP7veF1jEGvOh7iY+JgWImPyq+JnZAuu+j9ZEV9dya1gnKBi451RxXQwDRHClLZ+j4JmswXDwGxCD6l7Y5RnImTrN4sjpXobv93f1G3zQQx2ZD1sBQdtuR5ueT9wlNF2bGjr7uEr7pHQ1OYQKNqBRYwOo8YJzH3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDGpcctC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDGpcctC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF61FC4CEE7;
	Thu, 17 Apr 2025 18:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916099;
	bh=p9SZJLBu/G1uHNLVsMtaNvIFkSp3wdza3jcvjCdUVfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDGpcctCnI6wxzvR8GElQ4vqCLRJlTUS5CmXUVzekBy2SL89nhof3Z7rFd4CnUCWp
	 Npt5BEzE5bm0FxWbRoLPFk7pcQZ1xv5teZKSVknAzpBTaxG2d2tluObzs63ipozAzC
	 uepJoicfIvql7GOvVgdZFemyKIac0fwOlqHLjveQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 342/393] KVM: Allow building irqbypass.ko as as module when kvm.ko is a module
Date: Thu, 17 Apr 2025 19:52:31 +0200
Message-ID: <20250417175121.356480502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sean Christopherson <seanjc@google.com>

commit 459a35111b0a890172a78d51c01b204e13a34a18 upstream.

Convert HAVE_KVM_IRQ_BYPASS into a tristate so that selecting
IRQ_BYPASS_MANAGER follows KVM={m,y}, i.e. doesn't force irqbypass.ko to
be built-in.

Note, PPC allows building KVM as a module, but selects HAVE_KVM_IRQ_BYPASS
from a boolean Kconfig, i.e. KVM PPC unnecessarily forces irqbpass.ko to
be built-in.  But that flaw is a longstanding PPC specific issue.

Fixes: 61df71ee992d ("kvm: move "select IRQ_BYPASS_MANAGER" to common code")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250315024623.2363994-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    2 +-
 virt/kvm/Kconfig         |    2 +-
 virt/kvm/eventfd.c       |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2330,7 +2330,7 @@ static inline bool kvm_is_visible_memslo
 struct kvm_vcpu *kvm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -75,7 +75,7 @@ config KVM_COMPAT
        depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
 
 config HAVE_KVM_IRQ_BYPASS
-       bool
+       tristate
        select IRQ_BYPASS_MANAGER
 
 config HAVE_KVM_VCPU_ASYNC_IOCTL
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -149,7 +149,7 @@ irqfd_shutdown(struct work_struct *work)
 	/*
 	 * It is now safe to release the object's resources
 	 */
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 	irq_bypass_unregister_consumer(&irqfd->consumer);
 #endif
 	eventfd_ctx_put(irqfd->eventfd);
@@ -274,7 +274,7 @@ static void irqfd_update(struct kvm *kvm
 	write_seqcount_end(&irqfd->irq_entry_sc);
 }
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 void __attribute__((weak)) kvm_arch_irq_bypass_stop(
 				struct irq_bypass_consumer *cons)
 {
@@ -425,7 +425,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct
 	if (events & EPOLLIN)
 		schedule_work(&irqfd->inject);
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 	if (kvm_arch_has_irq_bypass()) {
 		irqfd->consumer.token = (void *)irqfd->eventfd;
 		irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
@@ -618,14 +618,14 @@ void kvm_irq_routing_update(struct kvm *
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 		/* Under irqfds.lock, so can read irq_entry safely */
 		struct kvm_kernel_irq_routing_entry old = irqfd->irq_entry;
 #endif
 
 		irqfd_update(kvm, irqfd);
 
-#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+#if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 		if (irqfd->producer &&
 		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
 			int ret = kvm_arch_update_irqfd_routing(



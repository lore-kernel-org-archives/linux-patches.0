Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614EF7E110;
	Tue, 29 Apr 2025 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946082; cv=none; b=gi1Gzsc1/Md1dIxJl/Rl19s8hqWOfsrfcwp4BksQcV/YyIJTCNYzXXOuopODU1dr92CtzboVhzxTtnUsC1lDLztEz734CzTzwDOJRpyFWMjIFz2GFk6GsQaFT07bIV1yC7R5w2q4nOqQ5jiMquBQXDj0Jw4SjiRqOmlIQAZzU1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946082; c=relaxed/simple;
	bh=htguMVFjqEQelzRcwhMNuOQ3OrPpZYLa5XbQIQCoQh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEcdcet2VrUXiVv+6YPU+CI6PV6bsGmCttqU/4OHH6XJSi2WQry7EZLT1z/wAkZfPQ3gH9VJ9a8meDGOd4+GqdxOLSNbHrWV9HcJ3YQOVgHpIpdLIicjnI8AjhFLldZyQ5+Lkp4B5mYxGeFmzwchrf8nZaVmbi1Q8TUaYHEhbic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOJwQMJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOJwQMJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A30C4CEE3;
	Tue, 29 Apr 2025 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946082;
	bh=htguMVFjqEQelzRcwhMNuOQ3OrPpZYLa5XbQIQCoQh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOJwQMJVOhoFOEHrlPIeXT0OX4g9kTHJOGb4dfffiPmRO3NdMNzNuI/UyIbCGuBPD
	 1wLoQdtymCIzmPgZxJ9Bj7HOdgz2z3DI6KhawFN3CBoJk4FrtswNFsMURIu77w0f7q
	 GlI2hHJ2yYvYg6JCMisEuseiNG0AZOiNOi5VXzdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.14 147/311] KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
Date: Tue, 29 Apr 2025 18:39:44 +0200
Message-ID: <20250429161127.056447434@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f1fb088d9cecde5c3066d8ff8846789667519b7d upstream.

Take irqfds.lock when adding/deleting an IRQ bypass producer to ensure
irqfd->producer isn't modified while kvm_irq_routing_update() is running.
The only lock held when a producer is added/removed is irqbypass's mutex.

Fixes: 872768800652 ("KVM: x86: select IRQ_BYPASS_MANAGER")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13565,15 +13565,22 @@ int kvm_arch_irq_bypass_add_producer(str
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 	int ret;
 
-	irqfd->producer = prod;
 	kvm_arch_start_assignment(irqfd->kvm);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = prod;
+
 	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 1);
 	if (ret)
 		kvm_arch_end_assignment(irqfd->kvm);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	return ret;
 }
 
@@ -13583,9 +13590,9 @@ void kvm_arch_irq_bypass_del_producer(st
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -13593,12 +13600,18 @@ void kvm_arch_irq_bypass_del_producer(st
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
 	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 



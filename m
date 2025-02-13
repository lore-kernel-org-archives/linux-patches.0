Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1236726B09E;
	Thu, 13 Feb 2025 15:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459598; cv=none; b=u9OWhDQB1apjAPiRlDNULQ7vmrCAd+AUBqP4gD8JCXPzBf7pThDFGs1Sd6sPeOhhi6gy9ggF14AenT075q+TWwKgh4sV4slpF9E1glqCXMwlR3a7eBqCR/5lqER5XBqBF7g845Jh7KFVxRGoSp2InIWqhxZEjRsTwB5EVb/IQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459598; c=relaxed/simple;
	bh=zAmhossX3c38Vf8KXUw/7IuyOlKtMWg8H31/Yqb6NXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaHRoR610J+9VIfHTpUmwTBi72ixXMgKf4LSA3ctUF3NyGbWgx5NtSEtuQzX+AxnLex189y1RwJfU25bY6nm7tr0EuF9jTkzzc7Dex1fSovPpqMXTdAV9ko1GxNv4CbElRmI9pXwvdltvlV7ET5W54dmg+Ii+N269jZGcAkNQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUU4Si79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUU4Si79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7162AC4CEE4;
	Thu, 13 Feb 2025 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459597;
	bh=zAmhossX3c38Vf8KXUw/7IuyOlKtMWg8H31/Yqb6NXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUU4Si797ktlRKnxDWvfDKZDoK6LJpHaVmsGAchDhYnsvQPH5EoM0BEER5sqYgi9g
	 nJRE7jhbi1mr5EFYmZ62ln+uau9QfKkFDQikC1GrhVuh4VC6DyI7Zaoxeqyohdbjtl
	 nb+3RgluCRcXYc3ZGnmh1PcXiimA2MDjQcG+vDOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.13 279/443] KVM: x86/mmu: Ensure NX huge page recovery thread is alive before waking
Date: Thu, 13 Feb 2025 15:27:24 +0100
Message-ID: <20250213142451.374857535@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 43fb96ae78551d7bfa4ecca956b258f085d67c40 upstream.

When waking a VM's NX huge page recovery thread, ensure the thread is
actually alive before trying to wake it.  Now that the thread is spawned
on-demand during KVM_RUN, a VM without a recovery thread is reachable via
the related module params.

  BUG: kernel NULL pointer dereference, address: 0000000000000040
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:vhost_task_wake+0x5/0x10
  Call Trace:
   <TASK>
   set_nx_huge_pages+0xcc/0x1e0 [kvm]
   param_attr_store+0x8a/0xd0
   module_attr_store+0x1a/0x30
   kernfs_fop_write_iter+0x12f/0x1e0
   vfs_write+0x233/0x3e0
   ksys_write+0x60/0xd0
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f3b52710104
   </TASK>
  Modules linked in: kvm_intel kvm
  CR2: 0000000000000040

Fixes: 931656b9e2ff ("kvm: defer huge page recovery vhost task to later")
Cc: stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250124234623.3609069-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7090,6 +7090,19 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
+{
+	/*
+	 * The NX recovery thread is spawned on-demand at the first KVM_RUN and
+	 * may not be valid even though the VM is globally visible.  Do nothing,
+	 * as such a VM can't have any possible NX huge pages.
+	 */
+	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
+
+	if (nx_thread)
+		vhost_task_wake(nx_thread);
+}
+
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
@@ -7150,7 +7163,7 @@ static int set_nx_huge_pages(const char
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7279,7 +7292,7 @@ static int set_nx_huge_pages_recovery_pa
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7415,14 +7428,20 @@ static void kvm_mmu_start_lpage_recovery
 {
 	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
 	struct kvm *kvm = container_of(ka, struct kvm, arch);
+	struct vhost_task *nx_thread;
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
-	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
-		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
-		kvm, "kvm-nx-lpage-recovery");
+	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker,
+				      kvm_nx_huge_page_recovery_worker_kill,
+				      kvm, "kvm-nx-lpage-recovery");
+
+	if (!nx_thread)
+		return;
+
+	vhost_task_start(nx_thread);
 
-	if (kvm->arch.nx_huge_page_recovery_thread)
-		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+	/* Make the task visible only once it is fully started. */
+	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
 }
 
 int kvm_mmu_post_init_vm(struct kvm *kvm)



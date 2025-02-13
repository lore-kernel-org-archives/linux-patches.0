Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F288F202C22;
	Thu, 13 Feb 2025 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457928; cv=none; b=tgwPn/30oT0cZ/6O1aZBGDdfg3fHRV9WbOB0fl03FOmKLtgU0Uh7Vy8rGidRbgBUF0tFOakiq076DRfFmsCInOrti2aooeUtG2ktSwHpJyNy6i/UkMIm0Nak625krDsQt2OkCn2IhAILPtdmMkUkMP8gEr2LG2hHRQ3OZ0xZqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457928; c=relaxed/simple;
	bh=wlwwH0nYVRgWRiRJXrs1hFmUk+Xsil9AtgYM+ZcYtGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkPUotyyRtxlFpxcBhuZqnGB7zn2fTLK75MsPJf6waCb3awbjpsuMQcT+lvHMrhx9fnuiT4IfGOjIe3uGlL7U8KmRueD5/nw1RZWPSBUD3BPTgEAf7GJT2HE9hzw7yqsAGh9ePG3zCQDiOPa9PB/p6EBlef8xL1ZJgjSJtBW5YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ3eehIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ3eehIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58965C4CED1;
	Thu, 13 Feb 2025 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457927;
	bh=wlwwH0nYVRgWRiRJXrs1hFmUk+Xsil9AtgYM+ZcYtGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ3eehIOHyDZ37sYEr3qh61ydmsiHUva7/suGA5Mv64wz2q8BU6yF3ZG6gByT/v3R
	 0D5RT+rvRVARKERcg6v1B8hPXgYSpFEJyhW7fapTNzMnRLpX7VFD7t9u3JyjNzbF9T
	 c+qly0Ovbo7Op/f3an67L1f2KnFJzvqLCntZoLow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 253/422] KVM: x86/mmu: Ensure NX huge page recovery thread is alive before waking
Date: Thu, 13 Feb 2025 15:26:42 +0100
Message-ID: <20250213142446.304553795@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
@@ -7227,6 +7227,19 @@ static void mmu_destroy_caches(void)
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
@@ -7287,7 +7300,7 @@ static int set_nx_huge_pages(const char
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7433,7 +7446,7 @@ static int set_nx_huge_pages_recovery_pa
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7569,14 +7582,20 @@ static void kvm_mmu_start_lpage_recovery
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAA612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26ABC433EF;
	Mon,  3 Apr 2023 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531798;
	bh=OAIX/DHhrSjFYgeSurC166WtWZ6dlzXU/rH0jdiHhDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjtoDJEGwWXZ1iCZS7Dm3oROjiRjbCg6J0ANzSyXsxnE42LXqY+vl23s23x+h5JED
	 7sERd9TvRoniR33pRkQ37LI5gNWfUzO6kFTWuCKHLETZY2sVdaCFFAf/W7QcLUUvVd
	 s/Qx6n6LntoPfnLdjqJjFfsUwpFtwcTDUgPQzR0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/173] KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
Date: Mon,  3 Apr 2023 16:07:06 +0200
Message-Id: <20230403140414.628275549@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit baff59ccdc657d290be51b95b38ebe5de40036b4 ]

Allocating cpumask dynamically in zalloc_cpumask_var() is not ideal.
Allocation is somewhat slow and can (in theory and when CPUMASK_OFFSTACK)
fail. kvm_make_all_cpus_request_except() already disables preemption so
we can use pre-allocated per-cpu cpumasks instead.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210903075141.403071-8-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last thing during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 34931443dafac..d96a076aef0dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,6 +154,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 						   unsigned long start, unsigned long end)
 {
@@ -327,14 +329,15 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
 	struct kvm_vcpu *vcpu;
-	cpumask_var_t cpus;
+	struct cpumask *cpus;
 	bool called;
 	int i, me;
 
-	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
-
 	me = get_cpu();
 
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_clear(cpus);
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu == except)
 			continue;
@@ -344,7 +347,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
 	put_cpu();
 
-	free_cpumask_var(cpus);
 	return called;
 }
 
@@ -5002,9 +5004,17 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_3;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
+					    GFP_KERNEL, cpu_to_node(cpu))) {
+			r = -ENOMEM;
+			goto out_free_4;
+		}
+	}
+
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free;
+		goto out_free_5;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
@@ -5030,7 +5040,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 out_unreg:
 	kvm_async_pf_deinit();
-out_free:
+out_free_5:
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
+out_free_4:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5050,8 +5063,12 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	int cpu;
+
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
-- 
2.39.2




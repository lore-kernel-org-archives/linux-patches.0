Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC14234A310;
	Tue, 26 Aug 2025 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215189; cv=none; b=UW9oD1Gb2anYgNq/XRaC5Nj42enWEDaDK0Pm+8UQnHlORiB7wqEH8p9zBhM05ttkeXLWCEbBBmRDjB21nF7jP23QV2zziLlWNnyWDGAVaHU/ebJ8p7MTqI/Wf8Azx8LR8dd10I+MaIlJA0u8DGUBdevZdC8/5e8bzuXa/0VM+ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215189; c=relaxed/simple;
	bh=VzQjxg1iCSQMGUOemscLHQXB8/XwDXrxkF3ndHjXVb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcvTg5fmYTsMNm/WCXATDVYpWAnfZd1PABUmvu2FP+ZdnWqcdQeKS3oV7P2UCqxmghPx4IwGeRtn6EbvJv3O8vjmLu0otypInX6nPZoiNEc3VI8lofAe+FnXwj8aabmS4K+SOrIwfJMzVfNUYmmhkqOn62F7/6DHbtYtvnEyMqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qq6oelki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qq6oelki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A9C4CEF1;
	Tue, 26 Aug 2025 13:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215188;
	bh=VzQjxg1iCSQMGUOemscLHQXB8/XwDXrxkF3ndHjXVb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qq6oelkiurnl5f2GOY8OUc2JHJEu+xFkqu2jmmnqFeb6mhkt6/r5xvM648Iimrq3Q
	 /Rj6KaZQw1ax8cBzaQ8HppMfwMYZrHXVmAoCy/AR+92WuYxVFEEkdPWEQ6XUhf8wS0
	 QCBpYtNbLpI3XAQcvk96ag8dmGMlq/y31iIvSlmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/482] x86/reboot: Harden virtualization hooks for emergency reboot
Date: Tue, 26 Aug 2025 13:10:43 +0200
Message-ID: <20250826110940.463498815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5e408396c60cd0f0b53a43713016b6d6af8d69e0 ]

Provide dedicated helpers to (un)register virt hooks used during an
emergency crash/reboot, and WARN if there is an attempt to overwrite
the registered callback, or an attempt to do an unpaired unregister.

Opportunsitically use rcu_assign_pointer() instead of RCU_INIT_POINTER(),
mainly so that the set/unset paths are more symmetrical, but also because
any performance gains from using RCU_INIT_POINTER() are meaningless for
this code.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/r/20230721201859.2307736-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: a0ee1d5faff1 ("KVM: VMX: Flush shadow VMCS on emergency reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/reboot.h |    5 +++--
 arch/x86/kernel/reboot.c      |   30 ++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c        |    6 ++----
 3 files changed, 29 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,9 @@ void __noreturn machine_real_restart(uns
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-typedef void crash_vmclear_fn(void);
-extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
+typedef void (cpu_emergency_virt_cb)(void);
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -794,17 +794,35 @@ void machine_crash_shutdown(struct pt_re
  *
  * protected by rcu.
  */
-crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
-EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
+static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
+
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
+
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
 static inline void cpu_crash_vmclear_loaded_vmcss(void)
 {
-	crash_vmclear_fn *do_vmclear_operation = NULL;
+	cpu_emergency_virt_cb *callback;
 
 	rcu_read_lock();
-	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
-	if (do_vmclear_operation)
-		do_vmclear_operation();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
 	rcu_read_unlock();
 }
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8602,8 +8602,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
+	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8677,8 +8676,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
-			   crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_check_vmcs12_offsets();
 



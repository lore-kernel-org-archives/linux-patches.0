Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B58228C9D;
	Tue, 26 Aug 2025 13:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215191; cv=none; b=kGSoT+YqVtNB+eLvV8QAJFJEU88NWx2qnG91oy6hsGKlvJamPRQWV8yGhe0w9TrratlfSxsi9yKZbRLe7thLqesvBp1klrlsvF0eDw8od+mKyN1Vzx8pU2wr8F6W5Nn8hlbWbW5f1tCinOu5V5WH66upbG6liOGmNjMNsHZfKsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215191; c=relaxed/simple;
	bh=UebivGrFeHpwxQBtZXbGmdRdzbOZmfW+1Y15h2AURd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0cMfWnFdRi/7VTFmo29+4ABiVSUEpQ25T2nuqO2CWbP+x79TK14nslQpjIrqel6Uat/4FtNUkgicng5+nb6uuVgvbbeKJzR+UnFlNkRl1i2rftyo/P0Cnf3ZA2tz2Gjr42FH4gHp06cIqvK9pKzkvaI6DvaBjYicajf65be+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnNCvK01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnNCvK01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD399C4CEF1;
	Tue, 26 Aug 2025 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215191;
	bh=UebivGrFeHpwxQBtZXbGmdRdzbOZmfW+1Y15h2AURd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnNCvK01UPzlfNhdZtyN1pqMHaWqPMAFBt3TrleuT3Qzn5gU3eDFz1lFjiS1YPIGW
	 amNe3/puhf5cc2bFN4iDfKzZ9ouUXLAxgMDIP4dbaFEwpgKJHmTpGVapw0z61hDkKF
	 gauvNayJkXrhAO7/up6YMf64DyGGfcGlBWMUbUb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 391/482] x86/reboot: KVM: Handle VMXOFF in KVMs reboot callback
Date: Tue, 26 Aug 2025 13:10:44 +0200
Message-ID: <20250826110940.488300898@linuxfoundation.org>
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

[ Upstream commit 119b5cb4ffd0166f3e98e9ee042f5046f7744f28 ]

Use KVM VMX's reboot/crash callback to do VMXOFF in an emergency instead
of manually and blindly doing VMXOFF.  There's no need to attempt VMXOFF
if a hypervisor, i.e. KVM, isn't loaded/active, i.e. if the CPU can't
possibly be post-VMXON.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/r/20230721201859.2307736-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: a0ee1d5faff1 ("KVM: VMX: Flush shadow VMCS on emergency reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/virtext.h |   10 ----------
 arch/x86/kernel/reboot.c       |   29 +++++++++--------------------
 arch/x86/kvm/vmx/vmx.c         |    8 +++++---
 3 files changed, 14 insertions(+), 33 deletions(-)

--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -70,16 +70,6 @@ static inline void __cpu_emergency_vmxof
 		cpu_vmxoff();
 }
 
-/** Disable VMX if it is supported and enabled on the current CPU
- */
-static inline void cpu_emergency_vmxoff(void)
-{
-	if (cpu_has_vmx())
-		__cpu_emergency_vmxoff();
-}
-
-
-
 
 /*
  * SVM functions:
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -787,13 +787,7 @@ void machine_crash_shutdown(struct pt_re
 }
 #endif
 
-/*
- * This is used to VMCLEAR all VMCSs loaded on the
- * processor. And when loading kvm_intel module, the
- * callback function pointer will be assigned.
- *
- * protected by rcu.
- */
+/* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
@@ -815,17 +809,6 @@ void cpu_emergency_unregister_virt_callb
 }
 EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
-static inline void cpu_crash_vmclear_loaded_vmcss(void)
-{
-	cpu_emergency_virt_cb *callback;
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-}
-
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
@@ -836,9 +819,15 @@ int crashing_cpu = -1;
  */
 void cpu_emergency_disable_virtualization(void)
 {
-	cpu_crash_vmclear_loaded_vmcss();
+	cpu_emergency_virt_cb *callback;
+
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
 
-	cpu_emergency_vmxoff();
+	/* KVM_AMD doesn't yet utilize the common callback. */
 	cpu_emergency_svm_disable();
 }
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -707,7 +707,7 @@ static int vmx_set_guest_uret_msr(struct
 	return ret;
 }
 
-static void crash_vmclear_local_loaded_vmcss(void)
+static void vmx_emergency_disable(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -715,6 +715,8 @@ static void crash_vmclear_local_loaded_v
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
+
+	__cpu_emergency_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -8602,7 +8604,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8676,7 +8678,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
 	vmx_check_vmcs12_offsets();
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BD774E25;
	Tue, 23 Jan 2024 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975472; cv=none; b=Gmqy4FP2mYzk+ACmrORk6sdwPooCcsuF/nR5ourWA7HKx2jHiwujnnWnd/pqA7gIF6332FwtYyZLxajNVebaJgt7ttAzm0Zi7mdcWuaP0CL2jVLX14NF4YvZsz30iPDU49+j/kVV/BgC79d1xDspQYTKStiQUj/LEs2cs7jrUyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975472; c=relaxed/simple;
	bh=ICJIwfV03NizNxS4B0g8Tk5JaciqrC2UOE4I13CUzMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucBOUPP/+OxdDjavDT47T9AGagguQC4DNAQwTMuxVoVR+kRQiKJfB6YH3IjKgNo+kv8x7n9jEGh1sA5WwRykXzvAfF7E8bsgHTwhYHbmss6cyIuKue7ajG3J4lMIJ+5d/Pz9Xfw0JQqm9+k3JTunHgoVATmnRXvp4UevDh2zxu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS/iKrAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS/iKrAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E198C43390;
	Tue, 23 Jan 2024 02:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975472;
	bh=ICJIwfV03NizNxS4B0g8Tk5JaciqrC2UOE4I13CUzMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS/iKrAToAwkPUcV/DWJXdOHAmnxz5KP3b7YO10JMOMmeij+IUnmYDgeauFqZ26w6
	 fSvYFl/2VC/8GN/1911a0ZHli8wlJ9Pm5OVUk/iSrf2qL/kdDQBvaFG68/RVvLlk5i
	 BsCLd3Aan7/a90q7r7RagXSXA9Zd2jW+XHnYuCUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 6.6 427/583] x86/kvm: Do not try to disable kvmclock if it was not enabled
Date: Mon, 22 Jan 2024 15:57:58 -0800
Message-ID: <20240122235825.049243504@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit 1c6d984f523f67ecfad1083bb04c55d91977bb15 upstream.

kvm_guest_cpu_offline() tries to disable kvmclock regardless if it is
present in the VM. It leads to write to a MSR that doesn't exist on some
configurations, namely in TDX guest:

	unchecked MSR access error: WRMSR to 0x12 (tried to write 0x0000000000000000)
	at rIP: 0xffffffff8110687c (kvmclock_disable+0x1c/0x30)

kvmclock enabling is gated by CLOCKSOURCE and CLOCKSOURCE2 KVM paravirt
features.

Do not disable kvmclock if it was not enabled.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: c02027b5742b ("x86/kvm: Disable kvmclock on all CPUs on shutdown")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Message-Id: <20231205004510.27164-6-kirill.shutemov@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvmclock.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -24,8 +24,8 @@
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
-static int msr_kvm_system_time __ro_after_init = MSR_KVM_SYSTEM_TIME;
-static int msr_kvm_wall_clock __ro_after_init = MSR_KVM_WALL_CLOCK;
+static int msr_kvm_system_time __ro_after_init;
+static int msr_kvm_wall_clock __ro_after_init;
 static u64 kvm_sched_clock_offset __ro_after_init;
 
 static int __init parse_no_kvmclock(char *arg)
@@ -195,7 +195,8 @@ static void kvm_setup_secondary_clock(vo
 
 void kvmclock_disable(void)
 {
-	native_write_msr(msr_kvm_system_time, 0, 0);
+	if (msr_kvm_system_time)
+		native_write_msr(msr_kvm_system_time, 0, 0);
 }
 
 static void __init kvmclock_init_mem(void)
@@ -294,7 +295,10 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
 		msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW;
 		msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW;
-	} else if (!kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
+	} else if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
+		msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
+		msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
+	} else {
 		return;
 	}
 



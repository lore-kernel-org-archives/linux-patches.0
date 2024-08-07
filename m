Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E31680BF8;
	Wed,  7 Aug 2024 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043268; cv=none; b=qwvOzX+jDLcKUS/Gn/Qeof5eogvYuWeCcbXi6IzyzZ++4u41iIOv19CFeyr3Z+A3YRiM+7PSDymaNFB0xmmA5S/fNMcHZXOW5QWneKf5JYfdrlNq5gxt6z0aTkDaIMhHOTTiao/vFUH1/mUb7PKzE9neS50QyS5YMB/nRjPKfSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043268; c=relaxed/simple;
	bh=GoqT0FGJ6Ao+se/mieFsgLYD2yshn3D+qcsx3fwIZr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHMsUmbHqfWTd8013nfV4yqBR4toReYS4/JMNBlzJ3WJO8oYuFkWBjt+6x26VPBqs8p2vhGV8Iotlj3cfsA2YOXAMj/Vj/5vfyBtXjC6Znimv+xqxvmKe3S2V2te1Ftu8sFsTulyXujqiSQSkqzJum3GBbnI7D7Cx8iXJR7/vwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rj6xNqCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rj6xNqCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DC8C32781;
	Wed,  7 Aug 2024 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043268;
	bh=GoqT0FGJ6Ao+se/mieFsgLYD2yshn3D+qcsx3fwIZr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rj6xNqCQyCdc0Q70HGjZlGpMDkTixdCg/TQPIzBtEa/zIOybrnBNhJBZid64+w/U6
	 kITMKNN0sFSODXXp5xM5xhqvGqYv3a0OeAo3qFiALD8w/cnzKRqHwuoUCWOzAyOHM/
	 i3X13xhDh3J04P+m2AXCUcfvygvC17NkAXAZKfIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/121] KVM: nVMX: Add a helper to get highest pending from Posted Interrupt vector
Date: Wed,  7 Aug 2024 16:59:21 +0200
Message-ID: <20240807150020.289991630@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d83c36d822be44db4bad0c43bea99c8908f54117 ]

Add a helper to retrieve the highest pending vector given a Posted
Interrupt descriptor.  While the actual operation is straightforward, it's
surprisingly easy to mess up, e.g. if one tries to reuse lapic.c's
find_highest_vector(), which doesn't work with PID.PIR due to the APIC's
IRR and ISR component registers being physically discontiguous (they're
4-byte registers aligned at 16-byte intervals).

To make PIR handling more consistent with respect to IRR and ISR handling,
return -1 to indicate "no interrupt pending".

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240607172609.3205077-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c      |  5 +++--
 arch/x86/kvm/vmx/posted_intr.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d1b4a85def0a6..5f85375f75b48 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -12,6 +12,7 @@
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
+#include "posted_intr.h"
 #include "sgx.h"
 #include "trace.h"
 #include "vmx.h"
@@ -3830,8 +3831,8 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
 		return 0;
 
-	max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
-	if (max_irr != 256) {
+	max_irr = pi_find_highest_vector(vmx->nested.pi_desc);
+	if (max_irr > 0) {
 		vapic_page = vmx->nested.virtual_apic_map.hva;
 		if (!vapic_page)
 			goto mmio_needed;
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 6b2a0226257ea..1715d2ab07be5 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __KVM_X86_VMX_POSTED_INTR_H
 #define __KVM_X86_VMX_POSTED_INTR_H
+
+#include <linux/find.h>
 #include <asm/posted_intr.h>
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
@@ -12,4 +14,12 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
 void vmx_pi_start_assignment(struct kvm *kvm);
 
+static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
+{
+	int vec;
+
+	vec = find_last_bit((unsigned long *)pi_desc->pir, 256);
+	return vec < 256 ? vec : -1;
+}
+
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
-- 
2.43.0




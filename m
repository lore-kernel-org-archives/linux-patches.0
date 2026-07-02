Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D5A342523;
	Thu,  2 Jul 2026 16:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009973; cv=none; b=mJgaBGqYbmJpCKq8pQL5rlpKzhfcGftZT2O0rldLqaqBSTIuyfNWhgpkM3Gq1X3l+7wphZcaBfBSON4kCjhb5/juTYSLO2/HZPEcundEyiByt/jhdVVmNav6MsJaXWFFJaZ+YAGPmpAUEFNF5eG7OhgD6Nr+nRMeyFvOoO8CcFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009973; c=relaxed/simple;
	bh=tEZuOmFc4PYo6NJp6MItgctjIgr3W73mEVvlZ1F1LhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENYrBQYZdI7cEeR7dyGr5BGrF/i/5HIbGHxXo5plxf0Zle/POI5U4GUFMKCtkq7WCNtNHQ0BqwHD81N1gdvWNNkIBAy0NrBGf0QsTvTr1sexERCa75Mhpq/iOMBtZ6ZbwCy9TXAsOpGLo3SeBA4KaCV3JXiHy14Ow6TQQEC2swY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xpv0fPJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xpv0fPJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71421F000E9;
	Thu,  2 Jul 2026 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009972;
	bh=sccGH+bM2jgJjbatt6ptB71ayzEeib2JYY6H7Bvk8KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xpv0fPJXyytTJ67wvi4gr1GCb2PEhXBNJQwwWPTYeoCoqYHZTfYwX71mttUH8vZEV
	 XAr1XZAqBdaEyQNBme1+lsfiLiJBE6VsGl2jOCmKU1jYpeRoUp7uRZPJlPWV71sGO0
	 XMBRqG1TYqGmLvnq4y5hkfwqKJu3UdmsbxIBkZw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/129] KVM: nVMX: Add a helper to get highest pending from Posted Interrupt vector
Date: Thu,  2 Jul 2026 18:18:57 +0200
Message-ID: <20260702155112.539597314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit d83c36d822be44db4bad0c43bea99c8908f54117 upstream.

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
[ Nicholas Dudar: backport to 6.1.y. 6.1.y defines struct pi_desc in
  posted_intr.h and predates the move to <asm/posted_intr.h>, so the helper
  and the <linux/find.h> include go in posted_intr.h. ]
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c      |  5 +++--
 arch/x86/kvm/vmx/posted_intr.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bdc462944cb082..7d8e18dbe8531b 100644
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
@@ -3818,8 +3819,8 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
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
index 26992076552ef1..88cea0dac7204b 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_VMX_POSTED_INTR_H
 #define __KVM_X86_VMX_POSTED_INTR_H
 
+#include <linux/find.h>
+
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
 
@@ -103,4 +105,12 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
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
2.53.0




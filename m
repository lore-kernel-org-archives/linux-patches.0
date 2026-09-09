Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5BA592204;
	Wed,  9 Sep 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964000; cv=none; b=p2+XIuhCEzvoil5gBMH2RNAnbHVgjKDcbOWWbt0ljs896/+ZNxTRKTDClt8fL0CehEHMYjapLMGdHD7yduRKrRKaNhJTTkhtyTPRd8Phx4Gz99+1v4iP6XXz2ZUy6ZazCojhfYDYnxteIb5aKNvq10+ocJMUgLQYOTDyfVnSHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964000; c=relaxed/simple;
	bh=X52YRIBky3X3hOJ78drFkP5uWg3Aov+Kvbr3pyeVOzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpTJNtmlXAYIJFNrXS/gkKG/FVkKU7oKs/4yvUqMzeE9sRWQ8Nk+B3pGmVJ1PYPMSDC/JRpQ7EGRNysuQf65ltpQUuEKgAifRIsHynpTrmlOx+UfCGsLt3G123ZBEWiKk2o5X5NvwQgWFbMNPVhjyhvssgPLKAThL2A2tIY27Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFA07tiK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFA07tiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BF71F00A3A;
	Wed,  9 Sep 2026 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963999;
	bh=FmVxc9AXSiAhlDSVawi7IHdJuiBt15bnnSlG3nZJpik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFA07tiKup9ndvdgqTiOi++PZsdutuJ8hZAIA3J8p2tMybkAWABBnejwoUh8WBRjv
	 6vpw0+lah+DaVZ0ORRcCCPHRvsWXBSOMLWIJexi1QJzwgXjAeDkp5VlwMKkTGNXVue
	 I6QIUXvuIHUaFrPjfVldynkWw+P7T/DivZ0hxlkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Anushree Mathur <anushree.mathur@linux.ibm.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 229/583] KVM: PPC: Book3S HV: Validate arch_compat against host compatibility mode
Date: Wed,  9 Sep 2026 15:38:34 +0200
Message-ID: <20260909134246.090328448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit 884ea0283f4effac97ee8f451464a7d1be480d7c upstream.

On IBM POWER systems, newer processor generations can operate in
compatibility modes corresponding to earlier generations. This becomes
relevant for nested virtualization, where nested KVM guests may need to
run with a specific processor compatibility level.

Currently, when running a nested KVM guest (L2) inside a Power11 pSeries
logical partition (L1) booted in Power10 compatibility mode, the guest
fails to boot while setting 'arch_compat'. This happens because the CPU
class is derived from the hardware PVR (via mfspr()), which reflects the
physical processor generation (Power11), rather than the effective
compatibility mode (Power10).

As a result, userspace may request a Power11 arch_compat for the L2
guest. However, the L1 partition, running in Power10 compatibility, has
only negotiated support up to Power10 with the Power Hypervisor (L0).
When H_GUEST_SET_STATE is invoked with a Power11 Logical PVR, the
hypervisor rejects the request, leading to a late guest boot failure:

  KVM-NESTEDv2: couldn't set guest wide elements
  [..KVM reg dump..]

This situation should be detected earlier and rejected by KVM. Without
proper validation, if userspace ignores the error, the guest may continue
to boot in Power11 raw mode on a Power10 compatibility host, which should
not be allowed.

Introduce a validation mechanism that detects unsupported arch_compat
values early in the guest initialization path. When an unsupported
arch_compat is requested (e.g., Power11 on a Power10 compatibility mode
host), kvmppc_set_arch_compat() uses cpu_has_feature(CPU_FTR_P11_PVR) to
detect the mismatch and sets arch_compat to PVR_ARCH_INVALID (0xffffffff).
This sentinel value is architecturally safe: PAPR specifies that valid
logical PVR values must have 0x0f as the first byte, ensuring 0xffffffff
lies permanently outside the specification-defined range. Setting this
value triggers kvmppc_sanity_check() to mark the vCPU as invalid by
setting vcpu->arch.sane to false. On the next vCPU run, kvmppc_vcpu_run_hv()
checks this flag and returns -EINVAL, preventing the guest from running
with an invalid processor compatibility configuration.

With this, when a Power11 arch_compat is requested on a Power10
compatibility mode host, the guest fails early during boot with:

  error: kvm run failed Invalid argument

This provides a much clearer failure mode compared to the previous
behavior where the guest could boot in Power11 raw mode (if userspace
ignored the error) or fail late during H_GUEST_SET_STATE.

Suggested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Tested-by: Anushree Mathur <anushree.mathur@linux.ibm.com>
Acked-by: Gautam Menghani <gautam@linux.ibm.com>
Cc: stable@vger.kernel.org # v6.13+
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260714175432.86388-1-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/reg.h |   12 ++++++++++++
 arch/powerpc/kvm/book3s_hv.c   |   15 ++++++++++++++-
 arch/powerpc/kvm/powerpc.c     |    6 ++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -1357,6 +1357,18 @@
 #define PVR_ARCH_31	0x0f000006
 #define PVR_ARCH_31_P11	0x0f000007
 
+/*
+ * Kernel-internal sentinel for invalid processor compatibility modes.
+ * PAPR specifies that the first byte of a valid logical PVR value is
+ * 0x0f. So 0xffffffff lies permanently outside the PAPR-defined range
+ * and is safe to repurpose. KVM stores it in vcpu->arch.arch_compat
+ * when userspace requests an unsupported compatibility mode (e.g.,
+ * Power11 PVR on a Power11 host booted in Power10 compat).
+ * kvmppc_sanity_check() detects this and prevents the vCPU from
+ * running with an unsupported arch_compat.
+ */
+#define PVR_ARCH_INVALID	0xffffffff
+
 /* Macros for setting and retrieving special purpose registers */
 #ifndef __ASSEMBLER__
 
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -447,7 +447,19 @@ static int kvmppc_set_arch_compat(struct
 			guest_pcr_bit = PCR_ARCH_300;
 			break;
 		case PVR_ARCH_31:
+			guest_pcr_bit = PCR_ARCH_31;
+			break;
 		case PVR_ARCH_31_P11:
+			/*
+			 * Need to check this for ISA 3.1, as Power10 and
+			 * Power11 share the same PCR. For any subsequent ISA
+			 * versions, this will be taken care of by the guest vs
+			 * host PCR comparison below.
+			 */
+			if (!cpu_has_feature(CPU_FTR_P11_PVR)) {
+				arch_compat = PVR_ARCH_INVALID;
+				goto out;
+			}
 			guest_pcr_bit = PCR_ARCH_31;
 			break;
 		default:
@@ -470,6 +482,7 @@ static int kvmppc_set_arch_compat(struct
 			return -EINVAL;
 	}
 
+out:
 	spin_lock(&vc->lock);
 	vc->arch_compat = arch_compat;
 	kvmhv_nestedv2_mark_dirty(vcpu, KVMPPC_GSID_LOGICAL_PVR);
@@ -480,7 +493,7 @@ static int kvmppc_set_arch_compat(struct
 	vc->pcr = (host_pcr_bit - guest_pcr_bit) | PCR_MASK;
 	spin_unlock(&vc->lock);
 
-	return 0;
+	return kvmppc_sanity_check(vcpu);
 }
 
 static void kvmppc_dump_regs(struct kvm_vcpu *vcpu)
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -258,6 +258,12 @@ int kvmppc_sanity_check(struct kvm_vcpu
 	if (!vcpu->arch.pvr)
 		goto out;
 
+#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE)
+	if (vcpu->arch.vcore &&
+	    vcpu->arch.vcore->arch_compat == PVR_ARCH_INVALID)
+		goto out;
+#endif
+
 	/* PAPR only works with book3s_64 */
 	if ((vcpu->arch.cpu_type != KVM_CPU_3S_64) && vcpu->arch.papr_enabled)
 		goto out;



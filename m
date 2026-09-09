Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0288566C6E;
	Wed,  9 Sep 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962449; cv=none; b=lThP5GtNJz6cQvhYjcQx4ZLwa5k6ZH0yUl3BiEuRbmAXOxGGHdJRe/YUqjw3cgP2/UAIcxM3bJnSItavCMtrSCylyetPcuSbeIr84LjVxSRoiqeoDaV4cIOEaToGXB1PscAxONSRimchVIXWoWuqnx3V4nKjBZME+jMn1NbWJ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962449; c=relaxed/simple;
	bh=SganwFeFU7GcAO0kf04YfxaaxZNXJs0gw7bWWTo+weA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeRwB60mQiMTRCWR3IfD2G/uD05Wge2DJ4f7PpNu2+osbGj20IWDFhgJXL3D0ERaDJjFXf7YvJQMF9YBo8pZbHbh5lRl9rTt11Bzquf6gh751JpIEc8U4i2zcLwcY2W4UKTg9kU2hLHKqF1SN6rxtfvh2TM9jkXmVjsNfJBCxI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S96jDHEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S96jDHEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362181F00A3A;
	Wed,  9 Sep 2026 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962447;
	bh=AIOaxbfdYXVRqeFR8MjDI9QSKc9umztCrYbhjy9PIrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S96jDHEaiAtTKjdS2Axpiqm7X+PVRgmIXrtWcCABgik5oqaWt8n0+4W5X+Tda8SK3
	 DNo52ZTZ4c4R/TUSSG/WHEW5keR+arXgSrfNsYabWwIxvFjqFWlxq4TsYwAFVhCSyj
	 8vWz18gPVyvOXNUpQoJmbyT3fUqeIsIyrYk87u1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 292/556] KVM: nVMX: Always flush vpid02 on first use
Date: Wed,  9 Sep 2026 15:39:32 +0200
Message-ID: <20260909134240.960979024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit f0772389413dce9657c7d6950abf3edbbd511356 upstream.

Make sure vpid02 is always flushed on first use by setting last_vpid=0
when allocating vpid02.  nested_vmx_transition_tlb_flush() will always
detect a VPID change on first VM-Enter after VMXON, because VPID=0 in
vmcs12 is not allowed if L1 enables VPID.

This avoids using stale TLB entries from a previous lifetime of the
VPID, that might have been associated with a different vCPU (or a
completely different VM).

Note that last_vpid is already being initialized as 0 when the vCPU is
created, but it is not reset when vpid02 is freed on VMXOFF. Hence, the
problem can only occur if L1 does VMXOFF -> VMXON, runs an L2, and KVM
happens to reuse a VPID that has TLB entries on the physical CPU.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://patch.msgid.link/20260616214652.2157032-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1326,6 +1326,9 @@ static void nested_vmx_transition_tlb_fl
 	 * is the VPID incorporated into the MMU context.  I.e. KVM must assume
 	 * that the new vpid12 has never been used and thus represents a new
 	 * guest ASID that cannot have entries in the TLB.
+	 *
+	 * Note, last_vpid is initialized as 0, so the first nested VM-Enter
+	 * after VMXON will always flush the TLB to avoid using stale entries.
 	 */
 	if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
@@ -5432,6 +5435,13 @@ static int enter_vmx_operation(struct kv
 
 	vmx->nested.vpid02 = allocate_vpid();
 
+	/*
+	 * Clear last_vpid to ensure that the VPID is flushed on the first
+	 * nested VM-Enter. Otherwise, stale TLB entries from a previous life of
+	 * the VPID (e.g. different vCPU or even different VM) could be used.
+	 */
+	vmx->nested.last_vpid = 0;
+
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
 



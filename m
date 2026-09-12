Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A8390CBE;
	Sat, 12 Sep 2026 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213596; cv=none; b=ARlOAj5N1k3vOQx5XzRqMRtn0WgCN2McJrjogiCl2H8mmVih5bOh1FIvsRX3KyvWdmqazjrLee82hVYfvJPcZ2+foIFF7WUM+eZJGpk4DhywX3NfHswb6SefqzwyaPg+LK1Qi6JFuauuqDc8pyob/XVxarVbEtbfwXfdx1n8k/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213596; c=relaxed/simple;
	bh=bPmM4uY6GhAO+gNmOqPUgtuji3Y1Pl+kPfb+W7oaTm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhWtxCPSBxHtDqmvZv/D6s7qmANoxmHQHt+uXpM3kDxfq9TKdn9IWSw00zXwL/8iYESAYZ7yCCJAplQryJTc9PP56Q+4DJPIeLcAT+wJUkPm4Cetw+g+dX/cCf/fpgxb17R0hdYb6lYVLRRfIMIIOO1g7YrC75j5VTN5K+0alg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2s65/BJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2s65/BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43861F000FF;
	Sat, 12 Sep 2026 11:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213594;
	bh=OdXNlRtPbxdyTZ0bNPZcpevYR/ecA1KHq4RLYSBwgwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2s65/BJwii4JuGb7UCzTKySsM/UjNxbKlYIzdY8syoMpMvHOZffvnxbVn7HZw0H4
	 GvcquJIW391YRE7Kyo1MNsXwLsmSlVbRAvd/HUf1YnqRA35F7RmTRQz0ZNt9nKPY27
	 47/6w+XdmgfBUuYm0aA1CXXOk53sgfzxbvuYNMXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0155/1376] KVM: nVMX: Always flush vpid02 on first use
Date: Sat, 12 Sep 2026 08:43:01 +0200
Message-ID: <20260912065611.004593165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1235,6 +1235,9 @@ static void nested_vmx_transition_tlb_fl
 	 * is the VPID incorporated into the MMU context.  I.e. KVM must assume
 	 * that the new vpid12 has never been used and thus represents a new
 	 * guest ASID that cannot have entries in the TLB.
+	 *
+	 * Note, last_vpid is initialized as 0, so the first nested VM-Enter
+	 * after VMXON will always flush the TLB to avoid using stale entries.
 	 */
 	if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
@@ -5343,6 +5346,13 @@ static int enter_vmx_operation(struct kv
 
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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF753A7;
	Fri,  6 Dec 2024 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497648; cv=none; b=gkaRcqyVuwmLoUQddPWSkYLxRcbWjT/1AFUutawqpqa+oZxnVbHiQkpvj1cDQfebpZ0hyVO7aBDbKBKFFx8EPxe6nbV9c2Nh4r/Bqb/1ZlqnxzE4AfUf/AgKNqYdx1q1TkuK1z910/kDfeGfaeF9LzwATjYowtP1bHMJ6D4Zo9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497648; c=relaxed/simple;
	bh=lZNT04nyYIVLbZZEM/U39L0nltq7BDkhJGir1n1WCGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfICClNOJCaRZxxKegApgon3Dpkw3NKrE/xCT/83MGwThN5XiLEwRYkgP8EkxYjfI0WOLzdPwFs3jRdzh8ZmEawKgbxCT79JB9DJAW7szckyuF+6VqqR79gIBh9ZgTKNjLtlL9UjCclcZotQCcQxeUZwIlDebyvuUyf6ubWko9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEJiwWph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEJiwWph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DCAC4CED1;
	Fri,  6 Dec 2024 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497647;
	bh=lZNT04nyYIVLbZZEM/U39L0nltq7BDkhJGir1n1WCGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEJiwWph5Pik6rbzfphYQfJz9adAb9QQJFrEYHb6MMRMYV0pdDWff4A8ZL/Mc94ky
	 0EPf44yT5S6wfdwlFomGSZGOFxuJdfceTO5nOqLZFDVafWRYe/XY7oN4YFCnliBUT3
	 h7+sWT9t9xAMI9M09qbK175HMdy/i/ru4WxI5f+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/676] KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests
Date: Fri,  6 Dec 2024 15:32:18 +0100
Message-ID: <20241206143705.805232696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Gautam Menghani <gautam@linux.ibm.com>

[ Upstream commit 0d3c6b28896f9889c8864dab469e0343a0ad1c0c ]

commit 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
introduced an optimization to use only vcpu->doorbell_request for SMT
emulation for Power9 and above guests, but the code for nested guests
still relies on the old way of handling doorbells, due to which an L2
guest (see [1]) cannot be booted with XICS with SMT>1. The command to
repro this issue is:

// To be run in L1

qemu-system-ppc64 \
	-drive file=rhel.qcow2,format=qcow2 \
	-m 20G \
	-smp 8,cores=1,threads=8 \
	-cpu  host \
	-nographic \
	-machine pseries,ic-mode=xics -accel kvm

Fix the plumbing to utilize vcpu->doorbell_request instead of vcore->dpdes
for nested KVM guests on P9 and above.

[1] Terminology
1. L0 : PowerNV linux running with HV privileges
2. L1 : Pseries KVM guest running on top of L0
2. L2 : Nested KVM guest running on top of L1

Fixes: 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241109063301.105289-3-gautam@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c        |  9 +++++++++
 arch/powerpc/kvm/book3s_hv_nested.c | 14 ++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1bb00c7215440..14511e457ade1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4090,6 +4090,15 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	}
 	hvregs.hdec_expiry = time_limit;
 
+	/*
+	 * hvregs has the doorbell status, so zero it here which
+	 * enables us to receive doorbells when H_ENTER_NESTED is
+	 * in progress for this vCPU
+	 */
+
+	if (vcpu->arch.doorbell_request)
+		vcpu->arch.doorbell_request = 0;
+
 	/*
 	 * When setting DEC, we must always deal with irq_work_raise
 	 * via NMI vs setting DEC. The problem occurs right as we
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 377d0b4a05eeb..49144129da420 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -32,7 +32,7 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	hr->pcr = vc->pcr | PCR_MASK;
-	hr->dpdes = vc->dpdes;
+	hr->dpdes = vcpu->arch.doorbell_request;
 	hr->hfscr = vcpu->arch.hfscr;
 	hr->tb_offset = vc->tb_offset;
 	hr->dawr0 = vcpu->arch.dawr0;
@@ -105,7 +105,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
-	hr->dpdes = vc->dpdes;
+	hr->dpdes = vcpu->arch.doorbell_request;
 	hr->purr = vcpu->arch.purr;
 	hr->spurr = vcpu->arch.spurr;
 	hr->ic = vcpu->arch.ic;
@@ -143,7 +143,7 @@ static void restore_hv_regs(struct kvm_vcpu *vcpu, const struct hv_guest_state *
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	vc->pcr = hr->pcr | PCR_MASK;
-	vc->dpdes = hr->dpdes;
+	vcpu->arch.doorbell_request = hr->dpdes;
 	vcpu->arch.hfscr = hr->hfscr;
 	vcpu->arch.dawr0 = hr->dawr0;
 	vcpu->arch.dawrx0 = hr->dawrx0;
@@ -170,7 +170,13 @@ void kvmhv_restore_hv_return_state(struct kvm_vcpu *vcpu,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
-	vc->dpdes = hr->dpdes;
+	/*
+	 * This L2 vCPU might have received a doorbell while H_ENTER_NESTED was being handled.
+	 * Make sure we preserve the doorbell if it was either:
+	 *   a) Sent after H_ENTER_NESTED was called on this vCPU (arch.doorbell_request would be 1)
+	 *   b) Doorbell was not handled and L2 exited for some other reason (hr->dpdes would be 1)
+	 */
+	vcpu->arch.doorbell_request = vcpu->arch.doorbell_request | hr->dpdes;
 	vcpu->arch.hfscr = hr->hfscr;
 	vcpu->arch.purr = hr->purr;
 	vcpu->arch.spurr = hr->spurr;
-- 
2.43.0




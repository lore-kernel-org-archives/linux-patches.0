Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404561F76D9;
	Tue,  3 Dec 2024 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238961; cv=none; b=ZIfAoPtVbBjjf886P+X40M9KWX4zWL64+sEud4C4A7t/gwq3+sMRf3rCLRTO6/iqtNIR2PKWzpbynad3nidqGAyiVPLFOiBZ5CPzCDTVVJdpY8t4AW7YyF0wZ7SDVsy93hFNXWQ88AmMZ+bmky43SqHvfRHYOl1W5lB+Ndjz32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238961; c=relaxed/simple;
	bh=T2BMUvY382bbht+/hlh8dmU1Rxi9QzISPZlj4K+VnfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5F9EceezbdGR7ulm9kAPzh6OA12OATgI2TyVV9rF9DoKNwxagmT2AtLyoLf1uo/rVD25PTylznkkszrcb2xkQsRcpVSTYwtstno6C0q/RMMS0KCz8Jg+SgTY6UfOainRFNrrRt29sTVKmafc6R8z7QV5I2ykxSv0LjFC7KPTe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0wuRn8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0wuRn8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0F8C4CECF;
	Tue,  3 Dec 2024 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238960;
	bh=T2BMUvY382bbht+/hlh8dmU1Rxi9QzISPZlj4K+VnfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0wuRn8SmB8gU678qU/1wbatftEtGk8Hr7m2+gdE03vRo4UkGcrd7l+nJ4jYL9k0I
	 N09nISH3Pvzg+kj1Ynt2oKsIffrn81l+qsrK0wSElagzIQcoC/c7Hz3yP6hUdZyQWg
	 Kz9juBELQQ9np90ojMICbmRyVsHr5tgNCu1qn05s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 457/817] KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests
Date: Tue,  3 Dec 2024 15:40:29 +0100
Message-ID: <20241203144013.713881519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0ed5c5c7a350d..ccc9a8431b944 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4303,6 +4303,15 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
index 05f5220960c63..125440a606ee3 100644
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




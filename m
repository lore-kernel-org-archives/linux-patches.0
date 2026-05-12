Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F463EDE51;
	Tue, 12 May 2026 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609666; cv=none; b=F+5vPdawxMgDiCqXts+DD6wr5rtKmgF9jlrxL/oVHocMQrgIsyYqSY+UiJszQaTsdk6+3438kgq4dDPuQQUwtckU0CVNU+9ZVwqq5LdziV1kvhrsWqmVJpocS/+l1Lpyaoc7uDkPy99Wj7J74FtEBcUdQKcEsAEgu8bGNwICF/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609666; c=relaxed/simple;
	bh=l8GKSY/DiflY8hnZ48XALXS2l33t097u2mxwCy2wBbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bELWcxh4saEmsB+AXDAhIwhmHMTyi1yxalWXhALsTeFFSmeucLxcEUDqmRvZvFX+1XWj5vHoxDrYe3DyYhyXWMWV/iMqO40RtheE4CnLeNVfWlDrr9lVzkEz7HB1EV+Z64pbTaPvHqywfjRdMQSre+ApbSEmbmUpU3SgV+M7T8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvkHB7jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvkHB7jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409AFC2BCF6;
	Tue, 12 May 2026 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609666;
	bh=l8GKSY/DiflY8hnZ48XALXS2l33t097u2mxwCy2wBbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvkHB7jte+RZgzirdNXotFRytOml+EycKcM/xz72An2JDs5Jow5BlkjM7ZgP+V+1S
	 EMwsMeO0j2mqIVufhZLB81scUmct69rIhx/k/DPCu7xmMwCnFl+k0nJfSeQRtJ8lHN
	 5UFiEyNXd1D5kNO7QGiLw+4cggzNO4PZm9aaeom4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Simner <ben.simner@cl.cam.ac.uk>,
	Will Deacon <willdeacon@google.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 283/307] KVM: arm64: Fix pin leak and publication ordering in __pkvm_init_vcpu()
Date: Tue, 12 May 2026 19:41:18 +0200
Message-ID: <20260512173946.100563933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

commit 73b9c1e5da84cd69b1a86e374e450817cd051371 upstream.

Two bugs exist in the vCPU initialisation path:

1. If a check fails after hyp_pin_shared_mem() succeeds, the cleanup
   path jumps to 'unlock' without calling unpin_host_vcpu() or
   unpin_host_sve_state(), permanently leaking pin references on the
   host vCPU and SVE state pages.

   Extract a register_hyp_vcpu() helper that performs the checks and
   the store. When register_hyp_vcpu() returns an error, call
   unpin_host_vcpu() and unpin_host_sve_state() inline before falling
   through to the existing 'unlock' label.

2. register_hyp_vcpu() publishes the new vCPU pointer into
   'hyp_vm->vcpus[]' with a bare store, allowing a concurrent caller
   of pkvm_load_hyp_vcpu() to observe a partially initialised vCPU
   object.

   Ensure the store uses smp_store_release() and the load uses
   smp_load_acquire(). While 'vm_table_lock' currently serialises the
   store and the load, these barriers ensure the reader sees the fully
   initialised 'hyp_vcpu' object even if there were a lockless path or
   if the lock's own ordering guarantees were insufficient for nested
   object initialization.

Fixes: 49af6ddb8e5c ("KVM: arm64: Add infrastructure to create and track pKVM instances at EL2")
Reported-by: Ben Simner <ben.simner@cl.cam.ac.uk>
Co-developed-by: Will Deacon <willdeacon@google.com>
Signed-off-by: Will Deacon <willdeacon@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260424084908.370776-6-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -258,7 +258,8 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu
 	if (!hyp_vm || hyp_vm->kvm.created_vcpus <= vcpu_idx)
 		goto unlock;
 
-	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
+	/* Pairs with smp_store_release() in register_hyp_vcpu(). */
+	hyp_vcpu = smp_load_acquire(&hyp_vm->vcpus[vcpu_idx]);
 	if (!hyp_vcpu)
 		goto unlock;
 
@@ -803,12 +804,30 @@ err_unpin_kvm:
  *	     the page-aligned size of 'struct pkvm_hyp_vcpu'.
  * Return 0 on success, negative error code on failure.
  */
+static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
+			      struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	unsigned int idx = hyp_vcpu->vcpu.vcpu_idx;
+
+	if (idx >= hyp_vm->kvm.created_vcpus)
+		return -EINVAL;
+
+	if (hyp_vm->vcpus[idx])
+		return -EINVAL;
+
+	/*
+	 * Ensure the hyp_vcpu is initialised before publishing it to
+	 * the vCPU-load path via 'hyp_vm->vcpus[]'.
+	 */
+	smp_store_release(&hyp_vm->vcpus[idx], hyp_vcpu);
+	return 0;
+}
+
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct pkvm_hyp_vm *hyp_vm;
-	unsigned int idx;
 	int ret;
 
 	hyp_vcpu = map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
@@ -827,18 +846,11 @@ int __pkvm_init_vcpu(pkvm_handle_t handl
 	if (ret)
 		goto unlock;
 
-	idx = hyp_vcpu->vcpu.vcpu_idx;
-	if (idx >= hyp_vm->kvm.created_vcpus) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	if (hyp_vm->vcpus[idx]) {
-		ret = -EINVAL;
-		goto unlock;
+	ret = register_hyp_vcpu(hyp_vm, hyp_vcpu);
+	if (ret) {
+		unpin_host_vcpu(host_vcpu);
+		unpin_host_sve_state(hyp_vcpu);
 	}
-
-	hyp_vm->vcpus[idx] = hyp_vcpu;
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 



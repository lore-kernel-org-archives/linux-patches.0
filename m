Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827214;
	b=gAAjbxFfz+F9GOke3zJPmSpw5J2R83B2C91eqBgmyyUMiaBHsDcMQ52aoaOw/enaWXGv
	 rPr8FbM2R9KcxzZklWP/LkqGH8UlhrJzUlMUVcSZuru4dZRPNqbhPZsnzw8r9QjmD1zK4
	 qfInqMEcHmijabey8VnAZNy20aFqNqlZUcAFOu6X+xvfLXhYgdE62ATKFp5ZSPgVtpcWG
	 LyWpCJsIrVNzAS/0oOxNV6dOampng4D8eoG09wSQ/wkIG0aHFOTcVi8KeSr8uyz7LK33B
	 Y/f0yDQD8yCl1sx8L6wI98TZS0ZmKr+sU9zb9rOyAobsBHG3BR8oD1SYWveEeUUbxow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xX1GIC4ADiihQuO/xEP+PuoyZYz3T50mRAqRI4+VRCk=;
	b=xhc0lTh+G22A9lrKCtIDtfy4HgrciGBWxVewTnKWmdERikGBsuh6Ad1vREsrBrRYoWEB
	 49d8LkdEnRN+kT4PtaTotby1EbdbSoIRmefcWTsThvGEhqZBgcPDrFQq63LxFIsszeIOT
	 EhhHjkqA3kN+VEO10p+SbYecvy6Vnsd5j8tDtOsUCo2/pX9H6byVbnw7vKCgrW2IJOhst
	 vJXZ6b6yenhBV4HabUm3Ey4KendqOXnK+35Shh3IP+C/E5McZVnE669tQeZLsXz54gG33
	 HtIAG9FsPRLp8sEZqEhYVqdnaq0eLp6F4a5vfKxQd3QJIIhyJZE+fkSsiSNtUwYWxgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FCx3jDfU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4768E606B3B1;
	Wed,  4 Nov 2026 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FCx3jDfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA121F00A02;
	Wed,  4 Nov 2026 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827214;
	bh=xX1GIC4ADiihQuO/xEP+PuoyZYz3T50mRAqRI4+VRCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCx3jDfUsBZUB4/oDLH3fnmtq7wJKUnJaugC81K+/cAvJL5GI9pc+bJx05FUHmltI
	 +/6ypWaoYPcdC+1IcOOOs9YuWMdjHYLGwLs3ZwwCJ1EWApmQDpFJbhsE5BuZtc4kIw
	 IRvUllXKxRGAa+csL4bPrZJxdYZi6q7prxz7FeEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.3 224/547] KVM: PPC: Book3S HV: Add SRCU protection for virtual-mode HPT hcalls
Date: Wed,  4 Nov 2026 16:06:48 -0500
Message-ID: <20261104211044.518629694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit 61a39797bb136243c48b46e2586d8a9e2cea6a89 upstream.

The virtual-mode HPT hcall handlers (H_ENTER, H_REMOVE, H_BULK_REMOVE,
H_CLEAR_REF, H_CLEAR_MOD) call into book3s_hv_rm_mmu.c, which accesses
memslots via kvm_memslots_raw().  kvm_memslots_raw() uses
rcu_dereference_raw_check() to bypass SRCU lockdep annotation checking.
This is safe in real mode because the entire guest entry/exit is wrapped
in srcu_read_lock/unlock inside kvmppc_run_core() and
kvmhv_run_single_vcpu().

However, since commit 6165d5dd99db ("KVM: PPC: Book3S HV: add virtual
mode handlers for HPT hcalls and page faults"), these same handlers are
also executed in virtual mode via kvmppc_pseries_do_hcall(), which runs
after SRCU has already been released on guest exit.

A concurrent KVM_SET_USER_MEMORY_REGION deletion or move can therefore
call synchronize_srcu_expedited() — which does not wait for this thread —
and then kfree(slot) and vfree(slot->arch.rmap) while the hcall handler
still holds a raw pointer to the memslot.  lock_rmap() then writes to
freed vmalloc memory, leading to use-after-free and memory corruption.
Because kvm_memslots_raw() suppresses lockdep checks, this race is
entirely silent.

Fix this by factoring out the 7 HPT hcall handlers (H_REMOVE, H_ENTER,
H_READ, H_CLEAR_MOD, H_CLEAR_REF, H_PROTECT, H_BULK_REMOVE) into a
helper function, kvmppc_pseries_do_hpt_hcall(), and wrapping its call
site in srcu_read_lock(&kvm->srcu) / srcu_read_unlock(&kvm->srcu, idx).
Targeting only the HPT hcalls avoids wrapping non-HPT hcalls that sleep
(such as H_CONFER, H_REGISTER_VPA, H_PAGE_INIT) or handlers that already
acquire SRCU internally (such as H_RTAS).

Fixes: 6165d5dd99db ("KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page faults")
Cc: stable@vger.kernel.org # v5.14+
Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260928122837.8782-2-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |   70 +++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1159,6 +1159,38 @@ static long kvmppc_h_rpt_invalidate(stru
 	return H_SUCCESS;
 }
 
+static long kvmppc_pseries_do_hpt_hcall(struct kvm_vcpu *vcpu, unsigned long req)
+{
+	switch (req) {
+	case H_REMOVE:
+		return kvmppc_h_remove(vcpu, kvmppc_get_gpr(vcpu, 4),
+				       kvmppc_get_gpr(vcpu, 5),
+				       kvmppc_get_gpr(vcpu, 6));
+	case H_ENTER:
+		return kvmppc_h_enter(vcpu, kvmppc_get_gpr(vcpu, 4),
+				      kvmppc_get_gpr(vcpu, 5),
+				      kvmppc_get_gpr(vcpu, 6),
+				      kvmppc_get_gpr(vcpu, 7));
+	case H_READ:
+		return kvmppc_h_read(vcpu, kvmppc_get_gpr(vcpu, 4),
+				     kvmppc_get_gpr(vcpu, 5));
+	case H_CLEAR_MOD:
+		return kvmppc_h_clear_mod(vcpu, kvmppc_get_gpr(vcpu, 4),
+					  kvmppc_get_gpr(vcpu, 5));
+	case H_CLEAR_REF:
+		return kvmppc_h_clear_ref(vcpu, kvmppc_get_gpr(vcpu, 4),
+					  kvmppc_get_gpr(vcpu, 5));
+	case H_PROTECT:
+		return kvmppc_h_protect(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5),
+					kvmppc_get_gpr(vcpu, 6));
+	case H_BULK_REMOVE:
+		return kvmppc_h_bulk_remove(vcpu);
+	}
+
+	return H_FUNCTION;
+}
+
 int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1174,47 +1206,15 @@ int kvmppc_pseries_do_hcall(struct kvm_v
 
 	switch (req) {
 	case H_REMOVE:
-		ret = kvmppc_h_remove(vcpu, kvmppc_get_gpr(vcpu, 4),
-					kvmppc_get_gpr(vcpu, 5),
-					kvmppc_get_gpr(vcpu, 6));
-		if (ret == H_TOO_HARD)
-			return RESUME_HOST;
-		break;
 	case H_ENTER:
-		ret = kvmppc_h_enter(vcpu, kvmppc_get_gpr(vcpu, 4),
-					kvmppc_get_gpr(vcpu, 5),
-					kvmppc_get_gpr(vcpu, 6),
-					kvmppc_get_gpr(vcpu, 7));
-		if (ret == H_TOO_HARD)
-			return RESUME_HOST;
-		break;
 	case H_READ:
-		ret = kvmppc_h_read(vcpu, kvmppc_get_gpr(vcpu, 4),
-					kvmppc_get_gpr(vcpu, 5));
-		if (ret == H_TOO_HARD)
-			return RESUME_HOST;
-		break;
 	case H_CLEAR_MOD:
-		ret = kvmppc_h_clear_mod(vcpu, kvmppc_get_gpr(vcpu, 4),
-					kvmppc_get_gpr(vcpu, 5));
-		if (ret == H_TOO_HARD)
-			return RESUME_HOST;
-		break;
 	case H_CLEAR_REF:
-		ret = kvmppc_h_clear_ref(vcpu, kvmppc_get_gpr(vcpu, 4),
-					kvmppc_get_gpr(vcpu, 5));
-		if (ret == H_TOO_HARD)
-			return RESUME_HOST;
-		break;
 	case H_PROTECT:
-		ret = kvmppc_h_protect(vcpu, kvmppc_get_gpr(vcpu, 4),
-					kvmppc_get_gpr(vcpu, 5),
-					kvmppc_get_gpr(vcpu, 6));
-		if (ret == H_TOO_HARD)
-			return RESUME_HOST;
-		break;
 	case H_BULK_REMOVE:
-		ret = kvmppc_h_bulk_remove(vcpu);
+		idx = srcu_read_lock(&kvm->srcu);
+		ret = kvmppc_pseries_do_hpt_hcall(vcpu, req);
+		srcu_read_unlock(&kvm->srcu, idx);
 		if (ret == H_TOO_HARD)
 			return RESUME_HOST;
 		break;



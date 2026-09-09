Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE4158599D;
	Wed,  9 Sep 2026 14:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963925; cv=none; b=FW3BMZ1dsum56BP2K0qYrhiKHLh8FKJRNt1DcnF/10OCPHKF/16b9b4ubyU35Vrx9rUAaNn/qNGiFCOrFew0orpa9f9QBrKqL7SZptI3lQ2iy2SU9P8a8/YHfqsow1PPNNXCWPoihPwina08w05QI5x9liyPsR7a8K8C9mghY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963925; c=relaxed/simple;
	bh=4T6RY53Vbsl3gSyC40JwKIrfnvBWg+cIlnclfNzBhSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYe5vSJakh8id5N80fEChhsd2ePFbtkzylEgs4Q/Df0rVio9cO1bkwzvJBeiXGDBw9z2guaJBtc1U7Ton2UdABzgWoAPZyQsbUzs9KXYLf6f+7SDb9qkkz0w4oLVni6uW0xnzNUc91J0gBKPekBuaQKUPTj0fnK25kzu3V2lYSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLwNWesX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLwNWesX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786781F00A3D;
	Wed,  9 Sep 2026 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963924;
	bh=Q2FzWdqKcnx3Wtpu/+KC3WnQytLhwZHjVuo+KfIw2oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLwNWesXKXA3vKZaZfUpNXOi65og6yo+E4xEps4h0vZDU10U1f5icI1J7yYET8QED
	 KRa3A4ve4Tja8hlFvcJrjWxncOYE5/PYqgoD56v2/lHXGUOd0AMNUNj44p+08AiwxA
	 BZ2kh1rzeTDDgmOjChm1m5eGCJ0qKnzZ/awP2EH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.18 246/583] KVM: s390: Free guest debug data on vcpu destroy
Date: Wed,  9 Sep 2026 15:38:51 +0200
Message-ID: <20260909134246.654211344@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit e7f698b09d4a7c36b299acf680fc50fe868e2bcd upstream.

kvm_s390_clear_bp_data() is only called from
kvm_arch_vcpu_ioctl_set_guest_debug(), i.e. when user space changes or
disables debugging. A vCPU that is destroyed while hardware breakpoints
are still armed - the normal case when the VMM just exits or crashes -
leaks hw_bp_info, hw_wp_info and all old_data buffers, since generic KVM
frees the vCPU right after kvm_arch_vcpu_destroy().

That is bounded by MAX_BP_COUNT entries, so roughly 8 KiB per vCPU, but
it is unbounded over VM lifetimes. The allocations are
GFP_KERNEL_ACCOUNT, so the charge also outlives the exiting process and
pins dying memcgs.

Fix by clearing the debug data on vCPU destruction. Calling it
unconditionally is fine: struct kvm_vcpu is zero allocated, so for a vCPU
that never enabled debugging the counters are 0 and the pointers NULL.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-8-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3488,6 +3488,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
 	kvm_s390_clear_local_irqs(vcpu);
 	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_s390_clear_bp_data(vcpu);
 	if (!kvm_is_ucontrol(vcpu->kvm))
 		sca_del_vcpu(vcpu);
 	kvm_s390_update_topology_change_report(vcpu->kvm, 1);



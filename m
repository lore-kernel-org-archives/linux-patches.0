Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B95736308F;
	Sat, 12 Sep 2026 19:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242046; cv=none; b=nrJdOmo8SP+YmL4Z7r2lvbFL1VOOGxwORX31jdDriKZ9B3hNw07JS7xaGs5nOH/sYt7iPGrToXc6JTH2AIwd/96SOGzgGpIGDMRHc6XVa+ut5seXp4ldX9FEeXvdnW7TW8u3hN48/dnuOoxDmDU5ooNlur30MmHoXWVYFDTc9r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242046; c=relaxed/simple;
	bh=cJsjwM63CYREcINmyEX8MyndWCrWSWx7KVuCXsIsnzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcLO9knP2TpGAIAPnXEQfEhG2ctoMk48sxGv3q22d7i0/YcOuHrefiHEwtq49vUMxbJksa5y3/zoYMnu5EKYBMqrS486cYNY6lhuxle7tOJcZ22YxD65VFpyydUMX9aTT+Jv/IUqjdZ720rDw6Zoj36nKgvwnGHFgYI6E2YXk7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bz8Erkau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bz8Erkau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD711F00893;
	Sat, 12 Sep 2026 19:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242044;
	bh=fAaN267l3FM+/rScYJvwuTbfGxD9Eq5+GpZqDkm+bg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bz8ErkauDgskbtP9qZrvFIdMgt09UvlPeJ0CZ14TLRAt3nSjWS26qSrfqhUX2UjB4
	 Bdj/0OXG1Sobq7VmIYA2dl16TJBkjIw5eV0aCDMYfuIkAUcka/n13M7FqgTb6wnuMr
	 Ccpd1r7A0qTybh/PCMJp6dpe9Vq/UMoWnPeLIiTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.10 266/798] KVM: s390: Free guest debug data on vcpu destroy
Date: Sat, 12 Sep 2026 08:58:14 +0200
Message-ID: <20260912065523.254755876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2775,6 +2775,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
 	kvm_s390_clear_local_irqs(vcpu);
 	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_s390_clear_bp_data(vcpu);
 	if (!kvm_is_ucontrol(vcpu->kvm))
 		sca_del_vcpu(vcpu);
 



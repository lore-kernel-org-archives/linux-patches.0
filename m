Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE9020B3E;
	Tue, 23 Apr 2024 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908535; cv=none; b=OZVsunO20dzGufA5ON16OWzcAkWE+8WhNWfN9deqqV4x6muePF5lAhFWmrdcJYKibhrBB3cKTiPa2CQrcREw7pV+MJToZeRpdYw8Pl2ngQM5aH6F/j0WjC/iJeg33l8S//1lpkhppfbMveP071Z2FNLtnteDcdGuZubFEP4zIyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908535; c=relaxed/simple;
	bh=G9okE7Rpv31JyTuKttTfHfftOK0/1gULf43CXxFn2Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exoovItWX88FDaKAm2xJcLH1Cdaz6gfEr3djKMXAqC4LmLarpc7ripkdCIMt0jICj8+sA/+7adeQvIaU2MivtYwfQqcJyV1mzNgywficPPVWQGqcYbbYYxiL26XVINlbY4X//POs9BTFFvbfkn7/cqhYdl4pK6SYUd5rxGbtwmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lymFTJnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lymFTJnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054CAC116B1;
	Tue, 23 Apr 2024 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908535;
	bh=G9okE7Rpv31JyTuKttTfHfftOK0/1gULf43CXxFn2Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lymFTJnQn1j0RE3mOoLb2mpJ6xU4GWGuX2IONXZObX1nuuPtqJ9YrFw+YoCEk0QMj
	 LSQZO9PnnXoJhS0itBwtvP7nfGZOOfNe8LB3gsfAG2S1Ac0l7H6B/SxapmNZ997mpy
	 H0KGSqCW/nt72QhVsYN1eZV4nXKkEugyJ9Mwhg1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.8 128/158] KVM: x86/pmu: Do not mask LVTPC when handling a PMI on AMD platforms
Date: Tue, 23 Apr 2024 14:39:10 -0700
Message-ID: <20240423213900.056351465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

commit 49ff3b4aec51e3abfc9369997cc603319b02af9a upstream.

On AMD and Hygon platforms, the local APIC does not automatically set
the mask bit of the LVTPC register when handling a PMI and there is
no need to clear it in the kernel's PMI handler.

For guests, the mask bit is currently set by kvm_apic_local_deliver()
and unless it is cleared by the guest kernel's PMI handler, PMIs stop
arriving and break use-cases like sampling with perf record.

This does not affect non-PerfMonV2 guests because PMIs are handled in
the guest kernel by x86_pmu_handle_irq() which always clears the LVTPC
mask bit irrespective of the vendor.

Before:

  $ perf record -e cycles:u true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.001 MB perf.data (1 samples) ]

After:

  $ perf record -e cycles:u true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.002 MB perf.data (19 samples) ]

Fixes: a16eb25b09c0 ("KVM: x86: Mask LVTPC when handling a PMI")
Cc: stable@vger.kernel.org
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
[sean: use is_intel_compatible instead of !is_amd_or_hygon()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240405235603.1173076-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2771,7 +2771,8 @@ int kvm_apic_local_deliver(struct kvm_la
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
 
 		r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
-		if (r && lvt_type == APIC_LVTPC)
+		if (r && lvt_type == APIC_LVTPC &&
+		    guest_cpuid_is_intel_compatible(apic->vcpu))
 			kvm_lapic_set_reg(apic, APIC_LVTPC, reg | APIC_LVT_MASKED);
 		return r;
 	}



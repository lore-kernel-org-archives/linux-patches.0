Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98973148318;
	Tue, 23 Apr 2024 21:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908748; cv=none; b=ZrRYLJMxSwe+tE0PFd39NjoDKFj8XFE1uk14knNCYW2F/tnDUOUg6/xuViWpeoLkfLdBy+wQugh1/LPjKlWJ3oa8J9Aw9xIkq2P9h99nKo+fY5DzMU36y+N/3PzBSQ3xK8OdPE7e/cjrhzzSariwhpEyM9vyEgnca5j9OCBijPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908748; c=relaxed/simple;
	bh=UncSxT57T4TWWSalXaD8l1DfjvA8uhjXWPgCjZ7TwRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXZLxFAbEVDgHH2DlUh0VUIFtCS3fokhtRfz1hlmnU1WldMXCb7GpEhyl5PMmDSR38ZCMF7uInAutI2VIqVxLGQTaJ66a8rzQiGDfe3Rff4/HY/6v3ynTzYmleJUHWtZb0EqqibAK/Ua/I11q6bVc2XSB8+cDaWvpXdBxkHYKCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4Y6H7Bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4Y6H7Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C9C32783;
	Tue, 23 Apr 2024 21:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908748;
	bh=UncSxT57T4TWWSalXaD8l1DfjvA8uhjXWPgCjZ7TwRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4Y6H7BhDz0rMW9HxvIH4nW3RiAwtV+BrHlGpFqUp+vTr6eBJrdUkCDA1WxPdY1Pe
	 VB5N7kgayuLl0zD82Mci2t16Kg98dVEn0Q1t+QJcxT6rZ+Ha09821Gqg0fWpSmK6tF
	 ybyO0i0wfq6pHYQN8CEgLTirqaDxrZlHOc0BOhyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 123/141] KVM: x86/pmu: Do not mask LVTPC when handling a PMI on AMD platforms
Date: Tue, 23 Apr 2024 14:39:51 -0700
Message-ID: <20240423213857.200762395@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2548,7 +2548,8 @@ int kvm_apic_local_deliver(struct kvm_la
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
 
 		r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
-		if (r && lvt_type == APIC_LVTPC)
+		if (r && lvt_type == APIC_LVTPC &&
+		    guest_cpuid_is_intel_compatible(apic->vcpu))
 			kvm_lapic_set_reg(apic, APIC_LVTPC, reg | APIC_LVT_MASKED);
 		return r;
 	}



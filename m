Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3291A6827;
	Mon,  4 May 2026 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904121; cv=none; b=p7gW5U0zkt1W3FrPpkC37FOFN6yfqT9DOQAKKz73ADhvPVnV11I9PyTX0SJSN1HgYmyxqbnVTxbo4r3PLy6YOhSF8Kp0R4T9lRK5scfZ/jG6WQT/QUy1fMwjfMPkRH60vwpL3y0XJEXEKSBl14khpFeRwmfl+mm2Rj8uUkhWzGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904121; c=relaxed/simple;
	bh=yTvwx7/94r6ZDtWyAXagOBHD9Y33xYubwXeZZjH2CGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlhP0azNnInPo7ucRDswehWy2WLVcE7PdD/GPMxx/Q2pvM9Bttx6PYixPn/p8sz0MXLD91fc4hLdZIYG28APQlvZNFU+sgaS4pqVkMjmx7GcJP/KZ7OqPKwlY/0Xi7D9GC0Bt7CaRRe2Go8Bk/Q1pHhbWgA7VGgGBN/J42DXtT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSkBvYhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSkBvYhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5152C2BCC4;
	Mon,  4 May 2026 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904121;
	bh=yTvwx7/94r6ZDtWyAXagOBHD9Y33xYubwXeZZjH2CGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSkBvYhsRznSDV+l4xAtf/PKVSM94TirYLHIiPdJDgV7wbgbfwMgHMRic0rSU4LCp
	 KpiRRgp5QK85mZjhcZDVe1s5gY8xTRUk5q6khuBQ1sn1nsiZX3S1EoUFaXQATpSAmk
	 h4UEh03PqQH4Y54erLys49iBNyJUYyDTVhe2+kzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 190/275] KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE
Date: Mon,  4 May 2026 15:52:10 +0200
Message-ID: <20260504135150.137370388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit e0b6f031d64c086edd563e7af9c0c0a2261dd2a4 upstream.

KVM currenty fails a nested VMRUN and injects VMEXIT_INVALID (aka
SVM_EXIT_ERR) if L1 sets NP_ENABLE and the host does not support NPTs.
On first glance, it seems like the check should actually be for
guest_cpu_cap_has(X86_FEATURE_NPT) instead, as it is possible for the
host to support NPTs but the guest CPUID to not advertise it.

However, the consistency check is not architectural to begin with. The
APM does not mention VMEXIT_INVALID if NP_ENABLE is set on a processor
that does not have X86_FEATURE_NPT. Hence, NP_ENABLE should be ignored
if X86_FEATURE_NPT is not available for L1, so sanitize it when copying
from the VMCB12 to KVM's cache.

Apart from the consistency check, NP_ENABLE in VMCB12 is currently
ignored because the bit is actually copied from VMCB01 to VMCB02, not
from VMCB12.

Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-15-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -335,9 +335,6 @@ static bool __nested_vmcb_check_controls
 	if (CC(control->asid == 0))
 		return false;
 
-	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
-		return false;
-
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
 					   MSRPM_SIZE)))
 		return false;
@@ -419,6 +416,11 @@ void __nested_copy_vmcb_control_to_cache
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		to->intercepts[i] = from->intercepts[i];
 
+	/* Always clear SVM_NESTED_CTL_NP_ENABLE if the guest cannot use NPTs */
+	to->nested_ctl          = from->nested_ctl;
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
+		to->nested_ctl &= ~SVM_NESTED_CTL_NP_ENABLE;
+
 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
 	to->tsc_offset          = from->tsc_offset;
@@ -432,7 +434,6 @@ void __nested_copy_vmcb_control_to_cache
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->nested_ctl          = from->nested_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;



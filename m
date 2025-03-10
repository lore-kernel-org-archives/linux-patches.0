Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905C81C5F1B;
	Mon, 10 Mar 2025 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628500; cv=none; b=juF0SShTjhDPyH/H1sEweBqnmyXWN5UAwXJMwzHk91QwWmwCultKsJM+sTysx9NAxHtgeDZgfXv4xbxkweKBVXsXy55MxB1BIZv5noy6XmvylrkMgKFKbGQPgQVYv9J7Un80NLJBtRZsO/QGVp9M5Uc/ZG8EzankJFB77cFmeHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628500; c=relaxed/simple;
	bh=A6JH6h6keg6SoZgGy/axY9I/l6a2jhzADSpa78U+QcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFpObXxhcI3LTvPNonzlQBAaW2sBpPbewEyGGF6KrGr3Kze3PSposp59Om0PJO/yLbcTUZKpBa2FHVnhvYMo/2MDiwNL1xPz+W4H/uCkVFK0thbMDyskHcVEb1p0xRZXUWt+e2xcG1xUPoWFAlUnDbi4dHi+1lcbRDZBULPfjvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spt36e7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spt36e7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB82EC4CEE5;
	Mon, 10 Mar 2025 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628500;
	bh=A6JH6h6keg6SoZgGy/axY9I/l6a2jhzADSpa78U+QcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spt36e7Gcwd1IKNzI/oIFosFuV8JuLoOULTbQ3ekSphoNDg3IgTg4v0AgxpCUNFf7
	 8CS2VJ8HWMki0OwmYMAvEGGU03+CUt78sIcrCC3Yv2pw2Ram2e5ISewDuqecCpi+IE
	 FDsSXq6901QfwR/ZpV+S+2vyAZZynYH0Bduxa1p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 079/109] KVM: SVM: Drop DEBUGCTL[5:2] from guests effective value
Date: Mon, 10 Mar 2025 18:07:03 +0100
Message-ID: <20250310170430.706450816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit ee89e8013383d50a27ea9bf3c8a69eed6799856f upstream.

Drop bits 5:2 from the guest's effective DEBUGCTL value, as AMD changed
the architectural behavior of the bits and broke backwards compatibility.
On CPUs without BusLockTrap (or at least, in APMs from before ~2023),
bits 5:2 controlled the behavior of external pins:

  Performance-Monitoring/Breakpoint Pin-Control (PBi)—Bits 5:2, read/write.
  Software uses thesebits to control the type of information reported by
  the four external performance-monitoring/breakpoint pins on the
  processor. When a PBi bit is cleared to 0, the corresponding external pin
  (BPi) reports performance-monitor information. When a PBi bit is set to
  1, the corresponding external pin (BPi) reports breakpoint information.

With the introduction of BusLockTrap, presumably to be compatible with
Intel CPUs, AMD redefined bit 2 to be BLCKDB:

  Bus Lock #DB Trap (BLCKDB)—Bit 2, read/write. Software sets this bit to
  enable generation of a #DB trap following successful execution of a bus
  lock when CPL is > 0.

and redefined bits 5:3 (and bit 6) as "6:3 Reserved MBZ".

Ideally, KVM would treat bits 5:2 as reserved.  Defer that change to a
feature cleanup to avoid breaking existing guest in LTS kernels.  For now,
drop the bits to retain backwards compatibility (of a sort).

Note, dropping bits 5:2 is still a guest-visible change, e.g. if the guest
is enabling LBRs *and* the legacy PBi bits, then the state of the PBi bits
is visible to the guest, whereas now the guest will always see '0'.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   12 ++++++++++++
 arch/x86/kvm/svm/svm.h |    2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3039,6 +3039,18 @@ static int svm_set_msr(struct kvm_vcpu *
 				    __func__, data);
 			break;
 		}
+
+		/*
+		 * AMD changed the architectural behavior of bits 5:2.  On CPUs
+		 * without BusLockTrap, bits 5:2 control "external pins", but
+		 * on CPUs that support BusLockDetect, bit 2 enables BusLockTrap
+		 * and bits 5:3 are reserved-to-zero.  Sadly, old KVM allowed
+		 * the guest to set bits 5:2 despite not actually virtualizing
+		 * Performance-Monitoring/Breakpoint external pins.  Drop bits
+		 * 5:2 for backwards compatibility.
+		 */
+		data &= ~GENMASK(5, 2);
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -539,7 +539,7 @@ static inline bool is_x2apic_msrpm_offse
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
+#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
 
 extern bool dump_invalid_vmcb;
 



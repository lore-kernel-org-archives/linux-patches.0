Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BDF1DE89C;
	Mon, 10 Mar 2025 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628164; cv=none; b=T0i93Mdt408igO6AVNTQenChSeqEMFTCGe5bPfM6US+3atZbkHzTFu57Wb+AUxrvEkoplJy51Uaei15KGmUM/J7yLb3BOGRG1ox523sOG6DPrsyzOOuminqrETcb3jNgrhESAFZfrEZLS2js5p6AyfJA/AWaDAja3GydG+jrdo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628164; c=relaxed/simple;
	bh=Vf1evhxe7wgfXxDGC9hYs2rN9gZKShP42Rd17QblQ0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9VUrRGSokoSpjnDyJaH+TQJ59Wr1lrdaq2seCCn74NG+pnbOLcvkiMFJy/40Zo4B65A2JohAtnRWpqIP9ATsXJoo1EbP05V9nApWECrhSvUkBTu/VpAa1ec/sp4m32eqpjOQjJM7tGZgpzzJjk7pK/FuEkx3mkcbU3Xb6UKStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/GNGj3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/GNGj3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34BCC4CEE5;
	Mon, 10 Mar 2025 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628164;
	bh=Vf1evhxe7wgfXxDGC9hYs2rN9gZKShP42Rd17QblQ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/GNGj3XUpoUOj8gRfSoDzrlycFe4Jur34SVvQIg4bnkDflOzIN/zxakVe/6W7tqY
	 EVT2HWB+Mh2Aq/ULtU7LKnOHi5nAeIsSZ19UpX0xBoo3w6eOvDSCnhYjoLyzzOYFYX
	 BePCHHumEwor41ES6O/NyqTAMR27PJOM796YmkZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 110/145] KVM: SVM: Drop DEBUGCTL[5:2] from guests effective value
Date: Mon, 10 Mar 2025 18:06:44 +0100
Message-ID: <20250310170439.201487722@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3156,6 +3156,18 @@ static int svm_set_msr(struct kvm_vcpu *
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
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
@@ -533,7 +533,7 @@ static inline bool is_vnmi_enabled(struc
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
+#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
 
 extern bool dump_invalid_vmcb;
 



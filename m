Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D984F14600E;
	Tue, 23 Apr 2024 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908663; cv=none; b=dKqFWiKhN1TapGKAZg7b9ncB1qnfLCrQ2hmXiyyqQRL8GOestS+ACGN9IzpSkO6tzuPPGJKCyxn/WIArzNoZUb0dTQ4CpgWD7H8B+AX7nqKsaQDoil+FTXRvPBZ9do5naXcedGcQKcgjHV6xzNoFS5lupOUeK5C20+eNewOu9K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908663; c=relaxed/simple;
	bh=gS3D2npwwP/w7QJPFVLhjNWhlF7nYQfBK2xBC+k5/Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dp0eA0CAqTUKF6UTgVHWPO6PTXRHdAgaXmxf3evfdjXsWfNHrl6VuAtypCa2ueHYA7XDB/B5ZK1o3J8Dm/HvgapPIWn3zfgnhOrb7kZjQc4R8bxcmRW/amKEZewEMpyQK0TW7C+9CdBxHnClbimnVDURM4MNSAsoUT+8Rz3ztts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5QCyTIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5QCyTIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD846C32782;
	Tue, 23 Apr 2024 21:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908663;
	bh=gS3D2npwwP/w7QJPFVLhjNWhlF7nYQfBK2xBC+k5/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5QCyTIovpK58fexTsyddvh04iVKL0EJx7mwlRAN1t29D+r42FlVTKR0pHHMsXOku
	 Pefh9T43x4f4KRe19GLNgINZk3CnSbD62a3VsMrXFhvtRkwe87G9AhiZNSAhq0qMWM
	 DuPy2ZjDq8vd0eX1H+K5jAIA4YT5mwDxSqV6tggo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 133/158] arm64/head: Disable MMU at EL2 before clearing HCR_EL2.E2H
Date: Tue, 23 Apr 2024 14:39:30 -0700
Message-ID: <20240423213900.026781590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 34e526cb7d46726b2ae5f83f2892d00ebb088509 upstream.

Even though the boot protocol stipulates otherwise, an exception has
been made for the EFI stub, and entering the core kernel with the MMU
enabled is permitted. This allows a substantial amount of cache
maintenance to be elided, wich is significant when fast boot times are
critical (e.g., for booting micro-VMs)

Once the initial ID map has been populated, the MMU is disabled as part
of the logic sequence that puts all system registers into a known state.
Any code that needs to execute within the window where the MMU is off is
cleaned to the PoC explicitly, which includes all of HYP text when
entering at EL2.

However, the current sequence of initializing the EL2 system registers
is not safe: HCR_EL2 is set to its nVHE initial state before SCTLR_EL2
is reprogrammed, and this means that a VHE-to-nVHE switch may occur
while the MMU is enabled. This switch causes some system registers as
well as page table descriptors to be interpreted in a different way,
potentially resulting in spurious exceptions relating to MMU
translation.

So disable the MMU explicitly first when entering in EL2 with the MMU
and caches enabled.

Fixes: 617861703830 ("efi: arm64: enter with MMU and caches enabled")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org> # 6.3.x
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240415075412.2347624-6-ardb+git@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/head.S |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -569,6 +569,11 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	adr_l	x1, __hyp_text_end
 	adr_l	x2, dcache_clean_poc
 	blr	x2
+
+	mov_q	x0, INIT_SCTLR_EL2_MMU_OFF
+	pre_disable_mmu_workaround
+	msr	sctlr_el2, x0
+	isb
 0:
 	mov_q	x0, HCR_HOST_NVHE_FLAGS
 	msr	hcr_el2, x0



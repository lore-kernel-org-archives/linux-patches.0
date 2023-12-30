Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C2479C2;
	Sat, 30 Dec 2023 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGmBdEwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D70BC433C8;
	Sat, 30 Dec 2023 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938028;
	bh=+S0cHqtYKJlMvD0y92fUKSiJ2jvPG5U3zlEkzMKu7xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGmBdEwVXUkiNTjr1y1g6JW2ZOZS6NyLS3AoomJ9WjaeRQJpQTOgyeSpnDdx4K2iv
	 cl6DMmY1/JJVYFMpqeU7XAEH5DlyTFlJgqwkj+XnMf5XKceF0kgYccLY5im0vcc4Md
	 G0utGDcTYbEP6Z+WrKNWP9Nv8Nu4uZfgfNfYykQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lindee <chris.lindee@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 6.6 155/156] x86/smpboot/64: Handle X2APIC BIOS inconsistency gracefully
Date: Sat, 30 Dec 2023 12:00:09 +0000
Message-ID: <20231230115817.363828119@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 69a7386c1ec25476a0c78ffeb59de08a2a08f495 upstream.

Chris reported that a Dell PowerEdge T340 system stopped to boot when upgrading
to a kernel which contains the parallel hotplug changes.  Disabling parallel
hotplug on the kernel command line makes it boot again.

It turns out that the Dell BIOS has x2APIC enabled and the boot CPU comes up in
X2APIC mode, but the APs come up inconsistently in xAPIC mode.

Parallel hotplug requires that the upcoming CPU reads out its APIC ID from the
local APIC in order to map it to the Linux CPU number.

In this particular case the readout on the APs uses the MMIO mapped registers
because the BIOS failed to enable x2APIC mode. That readout results in a page
fault because the kernel does not have the APIC MMIO space mapped when X2APIC
mode was enabled by the BIOS on the boot CPU and the kernel switched to X2APIC
mode early. That page fault can't be handled on the upcoming CPU that early and
results in a silent boot failure.

If parallel hotplug is disabled the system boots because in that case the APIC
ID read is not required as the Linux CPU number is provided to the AP in the
smpboot control word. When the kernel uses x2APIC mode then the APs are
switched to x2APIC mode too slightly later in the bringup process, but there is
no reason to do it that late.

Cure the BIOS bogosity by checking in the parallel bootup path whether the
kernel uses x2APIC mode and if so switching over the APs to x2APIC mode before
the APIC ID readout.

Fixes: 0c7ffa32dbd6 ("x86/smpboot/64: Implement arch_cpuhp_init_parallel_bringup() and enable it")
Reported-by: Chris Lindee <chris.lindee@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Tested-by: Chris Lindee <chris.lindee@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/CA%2B2tU59853R49EaU_tyvOZuOTDdcU0RshGyydccp9R1NX9bEeQ@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/head_64.S |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -256,6 +256,22 @@ SYM_INNER_LABEL(secondary_startup_64_no_
 	testl	$X2APIC_ENABLE, %eax
 	jnz	.Lread_apicid_msr
 
+#ifdef CONFIG_X86_X2APIC
+	/*
+	 * If system is in X2APIC mode then MMIO base might not be
+	 * mapped causing the MMIO read below to fault. Faults can't
+	 * be handled at that point.
+	 */
+	cmpl	$0, x2apic_mode(%rip)
+	jz	.Lread_apicid_mmio
+
+	/* Force the AP into X2APIC mode. */
+	orl	$X2APIC_ENABLE, %eax
+	wrmsr
+	jmp	.Lread_apicid_msr
+#endif
+
+.Lread_apicid_mmio:
 	/* Read the APIC ID from the fix-mapped MMIO space. */
 	movq	apic_mmio_base(%rip), %rcx
 	addq	$APIC_ID, %rcx



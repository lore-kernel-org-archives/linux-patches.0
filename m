Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F42221D5B0;
	Tue, 17 Mar 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768341; cv=none; b=BzNshwbLOkkgEtLDUxewvFwCiZKn8d2OhvgkgYCkuWYi2d7gbafgPnf9P8Y208Apc8HJ1B7fJiUIrIFDPFxC7EvShi8ChDm78ihsNA93Zv17nx0L4oZUuujIvHZsczuBXOOmtsbwdy+5I0KbDY95GYGaP5z0hU858lW8RH0Zrxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768341; c=relaxed/simple;
	bh=KJR401HqCDifkeGfh9amWEqwn9XbIGaV/3/rf9wWxVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJB6VyUrLBVmDki+AL91Vp0qkFqFcJT2Lu/YGade2P3pCH1rj0MSHqeQW9khGolXU0cUW0PCBCEtMYB54HJKpsTISnR2yOyvSCdAdvIhc3SEljXtmmoJ8Tu4RovEM7pnUPcdjJy8gyxeZpt7xQGZIqwU48gTLd6yuzJ/BLRM3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1sgn6ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1sgn6ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE64DC4CEF7;
	Tue, 17 Mar 2026 17:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768341;
	bh=KJR401HqCDifkeGfh9amWEqwn9XbIGaV/3/rf9wWxVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1sgn6rygFCXCxkJ4WoeV0tsKF8/ULsRB+pAMBKoYGH5ZPCZGydD1xzty8jt1Uw5S
	 wSewxWf7+3YifiFs6k6GuE1jvAbG7SYhT2NSbC8K50Rsdb4Jzr2wR7iNWxf4JJrPj2
	 EIalwo2RSzR3evfZr83N3+Znx+XRXEMK4PUsZ3dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Bukte <rahul.bukte@sony.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [PATCH 6.18 280/333] x86/apic: Disable x2apic on resume if the kernel expects so
Date: Tue, 17 Mar 2026 17:35:09 +0100
Message-ID: <20260317163009.776995911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Shashank Balaji <shashank.mahadasyam@sony.com>

commit 8cc7dd77a1466f0ec58c03478b2e735a5b289b96 upstream.

When resuming from s2ram, firmware may re-enable x2apic mode, which may have
been disabled by the kernel during boot either because it doesn't support IRQ
remapping or for other reasons. This causes the kernel to continue using the
xapic interface, while the hardware is in x2apic mode, which causes hangs.
This happens on defconfig + bare metal + s2ram.

Fix this in lapic_resume() by disabling x2apic if the kernel expects it to be
disabled, i.e. when x2apic_mode = 0.

The ACPI v6.6 spec, Section 16.3 [1] says firmware restores either the
pre-sleep configuration or initial boot configuration for each CPU, including
MSR state:

  When executing from the power-on reset vector as a result of waking from an
  S2 or S3 sleep state, the platform firmware performs only the hardware
  initialization required to restore the system to either the state the
  platform was in prior to the initial operating system boot, or to the
  pre-sleep configuration state. In multiprocessor systems, non-boot
  processors should be placed in the same state as prior to the initial
  operating system boot.

  (further ahead)

  If this is an S2 or S3 wake, then the platform runtime firmware restores
  minimum context of the system before jumping to the waking vector. This
  includes:

	CPU configuration. Platform runtime firmware restores the pre-sleep
	configuration or initial boot configuration of each CPU (MSR, MTRR,
	firmware update, SMBase, and so on). Interrupts must be disabled (for
	IA-32 processors, disabled by CLI instruction).

	(and other things)

So at least as per the spec, re-enablement of x2apic by the firmware is
allowed if "x2apic on" is a part of the initial boot configuration.

  [1] https://uefi.org/specs/ACPI/6.6/16_Waking_and_Sleeping.html#initialization

  [ bp: Massage. ]

Fixes: 6e1cb38a2aef ("x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping")
Co-developed-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260306-x2apic-fix-v2-1-bee99c12efa3@sony.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/apic.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1890,6 +1890,7 @@ void __init check_x2apic(void)
 
 static inline void try_to_enable_x2apic(int remap_mode) { }
 static inline void __x2apic_enable(void) { }
+static inline void __x2apic_disable(void) { }
 #endif /* !CONFIG_X86_X2APIC */
 
 void __init enable_IR_x2apic(void)
@@ -2452,6 +2453,11 @@ static void lapic_resume(void)
 	if (x2apic_mode) {
 		__x2apic_enable();
 	} else {
+		if (x2apic_enabled()) {
+			pr_warn_once("x2apic: re-enabled by firmware during resume. Disabling\n");
+			__x2apic_disable();
+		}
+
 		/*
 		 * Make sure the APICBASE points to the right address
 		 *



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67A83B0ACC;
	Mon, 23 Mar 2026 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282712; cv=none; b=AGT5mSAwt4paWyMgrEzuvkwDVGzFeqsA/iMNf7GQGQUPS5qqTPQgvaVOgUaGQ7/kW8wkJYpeOZKQM/7UxYeKz7k6/XZJQPfNyYDw0i+QdhjgPRJ428nTFg37UyvyFNwvVanixoqxsgzQ0E3xphsjmcmg7o8G80ndtcn2cG7CcD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282712; c=relaxed/simple;
	bh=8cdX4srIcJpFwR9ZkoUTfkcV1UIENY9H7pqtkQfvLoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXhuEc5bqLqSrq97VrlwicAd0c1Y83FuV9M+6z1400P1D7J2ZFsB73FO8VgAFj13gtoWrKcvdpH44jtkrJpY3tr/GBorVb/1Z9UHz8zQ0RMTZtaz20KOwFiN2DS3LQTZjfH7d/1MvJIj2UliTiwx2OYOEQOpDtpGOv32BxrcqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoBo0BlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoBo0BlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E211C4CEF7;
	Mon, 23 Mar 2026 16:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282712;
	bh=8cdX4srIcJpFwR9ZkoUTfkcV1UIENY9H7pqtkQfvLoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoBo0BlZ0am9zxXuEsLwiz8Bn97toJr5Y4l4oIiUkIrLjjMMeMQSHwznP0zrsmFtN
	 FAQyM72yM9p2pvnm66zoPEJlpNFDq1j27cuZa9MX6vkDILt80mmJYG2B4sn7Y7zxeY
	 uIdq1fvgEkILNFMxAeuP8CZH2dAUWDHMTgFjrbqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Bukte <rahul.bukte@sony.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [PATCH 6.1 258/481] x86/apic: Disable x2apic on resume if the kernel expects so
Date: Mon, 23 Mar 2026 14:44:00 +0100
Message-ID: <20260323134531.440422618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1958,6 +1958,7 @@ void __init check_x2apic(void)
 
 static inline void try_to_enable_x2apic(int remap_mode) { }
 static inline void __x2apic_enable(void) { }
+static inline void __x2apic_disable(void) { }
 #endif /* !CONFIG_X86_X2APIC */
 
 void __init enable_IR_x2apic(void)
@@ -2778,6 +2779,11 @@ static void lapic_resume(void)
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



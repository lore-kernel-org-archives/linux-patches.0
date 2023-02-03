Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410481FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B439C433D2;
	Fri,  3 Feb 2023 10:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419807;
	bh=8JDGmsW+EDZdp4zJlrpTtfRQzLAL6ptwiShdtutgHTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXWRJTmz1qV/5v/EMSZEDuiqMM3cmYcMIHtBv+OiwB7LnANpQWy+5hhcOQZEnu5V6
	 hFZ6a8EUcr3O9UcEm7II9o1Q6vX9TC87VzKcEtaNuBbkHpfX3oHbUYBPdjidtNy5IZ
	 2sL0FrLDYrgfcT3vZii/Eg302/mzkAICLYNY4KLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH 5.10 7/9] ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems
Date: Fri,  3 Feb 2023 11:13:36 +0100
Message-Id: <20230203101006.716757022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Hansen <dave.hansen@intel.com>

commit e400ad8b7e6a1b9102123c6240289a811501f7d9 upstream.

Old, circa 2002 chipsets have a bug: they don't go idle when they are
supposed to.  So, a workaround was added to slow the CPU down and
ensure that the CPU waits a bit for the chipset to actually go idle.
This workaround is ancient and has been in place in some form since
the original kernel ACPI implementation.

But, this workaround is very painful on modern systems.  The "inl()"
can take thousands of cycles (see Link: for some more detailed
numbers and some fun kernel archaeology).

First and foremost, modern systems should not be using this code.
Typical Intel systems have not used it in over a decade because it is
horribly inferior to MWAIT-based idle.

Despite this, people do seem to be tripping over this workaround on
AMD system today.

Limit the "dummy wait" workaround to Intel systems.  Keep Modern AMD
systems from tripping over the workaround.  Remotely modern Intel
systems use intel_idle instead of this code and will, in practice,
remain unaffected by the dummy wait.

Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/all/20220921063638.2489-1-kprateek.nayak@amd.com/
Link: https://lkml.kernel.org/r/20220922184745.3252932-1-dave.hansen@intel.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -536,10 +536,27 @@ static void wait_for_freeze(void)
 	/* No delay is needed if we are in guest */
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return;
+	/*
+	 * Modern (>=Nehalem) Intel systems use ACPI via intel_idle,
+	 * not this code.  Assume that any Intel systems using this
+	 * are ancient and may need the dummy wait.  This also assumes
+	 * that the motivating chipset issue was Intel-only.
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
 #endif
-	/* Dummy wait op - must do something useless after P_LVL2 read
-	   because chipsets cannot guarantee that STPCLK# signal
-	   gets asserted in time to freeze execution properly. */
+	/*
+	 * Dummy wait op - must do something useless after P_LVL2 read
+	 * because chipsets cannot guarantee that STPCLK# signal gets
+	 * asserted in time to freeze execution properly
+	 *
+	 * This workaround has been in place since the original ACPI
+	 * implementation was merged, circa 2002.
+	 *
+	 * If a profile is pointing to this instruction, please first
+	 * consider moving your system to a more modern idle
+	 * mechanism.
+	 */
 	inl(acpi_gbl_FADT.xpm_timer_block.address);
 }
 



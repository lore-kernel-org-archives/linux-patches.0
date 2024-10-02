Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB501D04B4;
	Wed,  2 Oct 2024 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876931; cv=none; b=AuLlXqy5xcbM7JNwE3skwqPVuBTNEmJDsF43x9S3ipwkKlAzAfNe0vxkb4AJMMhliY9Cu5BGyaH1d0wCsqSxvMC5VGBqvHx57I30h0rIRZtogXCExCY7Tuscf8xgrVTeeeOObnL+MQtGNHdaOeKketYpAfPrnt3jjI8AGtmXaxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876931; c=relaxed/simple;
	bh=1KF965zJf81slKAocD0SANNNtlhzvvUPAA089qZSthE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxTnAYedqdPS6VcP7aGftpHF2Rj/dWh7uoHipcd7zLE4u6itvhiRFe4HZ2MzCcgf7+rWPHQ3xh19aEXMmCNOQr0slLVBmzwyQV6wg8vRI0abNJP88/NvJdrzvc8ZGP5yNCGSMkI9Nv0ilbtMFA0D4tKBR4se7EMTob8K3BW2PFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLFDqDYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLFDqDYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EE9C4CECD;
	Wed,  2 Oct 2024 13:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876931;
	bh=1KF965zJf81slKAocD0SANNNtlhzvvUPAA089qZSthE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLFDqDYdAdcEIKcQ9FctprtjWBI1F1LvN1KXC8m7swHzDPPeLtJHHgT0YJEfU+lHO
	 AKUjv5aX4p/BI1ww9lgUoc4hHMiWZmTWnGz5AXrX00uYKLrBVI6VGHTzz1UmCZcALZ
	 sVecN7uo6Bb2sYz5lWjCDdxaK177uPHZbSN0iIfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 609/695] intel_idle: fix ACPI _CST matching for newer Xeon platforms
Date: Wed,  2 Oct 2024 15:00:07 +0200
Message-ID: <20241002125846.824679795@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 4c411cca33cf1c21946b710b2eb59aca9f646703 upstream.

Background
~~~~~~~~~~

The driver uses 'use_acpi = true' in C-state custom table for all Xeon
platforms. The meaning of this flag is as follows.

 1. If a C-state from the custom table is defined in ACPI _CST (matched
    by the mwait hint), then enable this C-state.

 2. Otherwise, disable this C-state, unless the C-sate definition in the
    custom table has the 'CPUIDLE_FLAG_ALWAYS_ENABLE' flag set, in which
    case enabled it.

The goal is to honor BIOS C6 settings - If BIOS disables C6, disable it
by default in the OS too (but it can be enabled via sysfs).

This works well on Xeons that expose only one flavor of C6. This are all
Xeons except for the newest Granite Rapids (GNR) and Sierra Forest (SRF).

The problem
~~~~~~~~~~~

GNR and SRF have 2 flavors of C6: C6/C6P on GNR, C6S/C6SP on SRF. The
the "P" flavor allows for the package C6, while the "non-P" flavor
allows only for core/module C6.

As far as this patch is concerned, both GNR and SRF platforms are
handled the same way. Therefore, further discussion is focused on GNR,
but it applies to SRF as well.

On Intel Xeon platforms, BIOS exposes only 2 ACPI C-states: C1 and C2.
Well, depending on BIOS settings, C2 may be named as C3. But there still
will be only 2 states - C1 and C3. But this is a non-essential detail,
so further discussion is focused on the ACPI C1 and C2 case.

On pre-GNR/SRF Xeon platforms, ACPI C1 is mapped to C1 or C1E, and ACPI
C2 is mapped to C6. The 'use_acpi' flag works just fine:

 * If ACPI C2 enabled, enable C6.
 * Otherwise, disable C6.

However, on GNR there are 2 flavors of C6, so BIOS maps ACPI C2 to
either C6 or C6P, depending on the user settings. As a result, due to
the 'use_acpi' flag, 'intel_idle' disables least one of the C6 flavors.

BIOS                   | OS                         | Verdict
----------------------------------------------------|---------
ACPI C2 disabled       | C6 disabled, C6P disabled  | OK
ACPI C2 mapped to C6   | C6 enabled,  C6P disabled  | Not OK
ACPI C2 mapped to C6P  | C6 disabled, C6P enabled   | Not OK

The goal of 'use_acpi' is to honor BIOS ACPI C2 disabled case, which
works fine. But if ACPI C2 is enabled, the goal is to enable all flavors
of C6, not just one of the flavors. This was overlooked when enabling
GNR/SRF platforms.

In other words, before GNR/SRF, the ACPI C2 status was binary - enabled
or disabled. But it is not binary on GNR/SRF, however the goal is to
continue treat it as binary.

The fix
~~~~~~~

Notice, that current algorithm matches ACPI and custom table C-states
by the mwait hint. However, mwait hint consists of the 'state' and
'sub-state' parts, and all C6 flavors have the same state value of 0x20,
but different sub-state values.

Introduce new C-state table flag - CPUIDLE_FLAG_PARTIAL_HINT_MATCH and
add it to both C6 flavors of the GNR/SRF platforms.

When matching ACPI _CST and custom table C-states, match only the start
part if the C-state has CPUIDLE_FLAG_PARTIAL_HINT_MATCH, other wise
match both state and sub-state parts (as before).

With this fix, GNR C-states enabled/disabled status looks like this.

BIOS                   | OS
----------------------------------------------------
ACPI C2 disabled       | C6 disabled, C6P disabled
ACPI C2 mapped to C6   | C6 enabled, C6P enabled
ACPI C2 mapped to C6P  | C6 enabled, C6P enabled

Possible alternative
~~~~~~~~~~~~~~~~~~~~

The alternative would be to remove 'use_acpi' flag for GNR and SRF.
This would be a simpler solution, but it would violate the principle of
least surprise - users of Xeon platforms are used to the fact that
intel_idle honors C6 enabled/disabled flag. It is more consistent user
experience if GNR/SRF continue doing so.

How tested
~~~~~~~~~~

Tested on GNR and SRF platform with all the 3 BIOS configurations: ACPI
C2 disabled, mapped to C6/C6S, mapped to C6P/C6SP.

Tested on Ice lake Xeon and Sapphire Rapids Xeon platforms with ACPI C2
enabled and disabled, just to verify that the patch does not break older
Xeons.

Fixes: 92813fd5b156 ("intel_idle: add Sierra Forest SoC support")
Fixes: 370406bf5738 ("intel_idle: add Granite Rapids Xeon support")
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Link: https://patch.msgid.link/20240913165143.4140073-1-dedekind1@gmail.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/idle/intel_idle.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -121,6 +121,12 @@ static unsigned int mwait_substates __in
 #define CPUIDLE_FLAG_INIT_XSTATE	BIT(17)
 
 /*
+ * Ignore the sub-state when matching mwait hints between the ACPI _CST and
+ * custom tables.
+ */
+#define CPUIDLE_FLAG_PARTIAL_HINT_MATCH	BIT(18)
+
+/*
  * MWAIT takes an 8-bit "hint" in EAX "suggesting"
  * the C-state (top nibble) and sub-state (bottom nibble)
  * 0x00 means "MWAIT(C1)", 0x10 means "MWAIT(C2)" etc.
@@ -1043,7 +1049,8 @@ static struct cpuidle_state gnr_cstates[
 		.name = "C6",
 		.desc = "MWAIT 0x20",
 		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED |
-					   CPUIDLE_FLAG_INIT_XSTATE,
+					   CPUIDLE_FLAG_INIT_XSTATE |
+					   CPUIDLE_FLAG_PARTIAL_HINT_MATCH,
 		.exit_latency = 170,
 		.target_residency = 650,
 		.enter = &intel_idle,
@@ -1052,7 +1059,8 @@ static struct cpuidle_state gnr_cstates[
 		.name = "C6P",
 		.desc = "MWAIT 0x21",
 		.flags = MWAIT2flg(0x21) | CPUIDLE_FLAG_TLB_FLUSHED |
-					   CPUIDLE_FLAG_INIT_XSTATE,
+					   CPUIDLE_FLAG_INIT_XSTATE |
+					   CPUIDLE_FLAG_PARTIAL_HINT_MATCH,
 		.exit_latency = 210,
 		.target_residency = 1000,
 		.enter = &intel_idle,
@@ -1354,7 +1362,8 @@ static struct cpuidle_state srf_cstates[
 	{
 		.name = "C6S",
 		.desc = "MWAIT 0x22",
-		.flags = MWAIT2flg(0x22) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x22) | CPUIDLE_FLAG_TLB_FLUSHED |
+					   CPUIDLE_FLAG_PARTIAL_HINT_MATCH,
 		.exit_latency = 270,
 		.target_residency = 700,
 		.enter = &intel_idle,
@@ -1362,7 +1371,8 @@ static struct cpuidle_state srf_cstates[
 	{
 		.name = "C6SP",
 		.desc = "MWAIT 0x23",
-		.flags = MWAIT2flg(0x23) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x23) | CPUIDLE_FLAG_TLB_FLUSHED |
+					   CPUIDLE_FLAG_PARTIAL_HINT_MATCH,
 		.exit_latency = 310,
 		.target_residency = 900,
 		.enter = &intel_idle,
@@ -1738,7 +1748,7 @@ static void __init intel_idle_init_cstat
 	}
 }
 
-static bool __init intel_idle_off_by_default(u32 mwait_hint)
+static bool __init intel_idle_off_by_default(unsigned int flags, u32 mwait_hint)
 {
 	int cstate, limit;
 
@@ -1755,7 +1765,15 @@ static bool __init intel_idle_off_by_def
 	 * the interesting states are ACPI_CSTATE_FFH.
 	 */
 	for (cstate = 1; cstate < limit; cstate++) {
-		if (acpi_state_table.states[cstate].address == mwait_hint)
+		u32 acpi_hint = acpi_state_table.states[cstate].address;
+		u32 table_hint = mwait_hint;
+
+		if (flags & CPUIDLE_FLAG_PARTIAL_HINT_MATCH) {
+			acpi_hint &= ~MWAIT_SUBSTATE_MASK;
+			table_hint &= ~MWAIT_SUBSTATE_MASK;
+		}
+
+		if (acpi_hint == table_hint)
 			return false;
 	}
 	return true;
@@ -1765,7 +1783,10 @@ static bool __init intel_idle_off_by_def
 
 static inline bool intel_idle_acpi_cst_extract(void) { return false; }
 static inline void intel_idle_init_cstates_acpi(struct cpuidle_driver *drv) { }
-static inline bool intel_idle_off_by_default(u32 mwait_hint) { return false; }
+static inline bool intel_idle_off_by_default(unsigned int flags, u32 mwait_hint)
+{
+	return false;
+}
 #endif /* !CONFIG_ACPI_PROCESSOR_CSTATE */
 
 /**
@@ -2092,7 +2113,7 @@ static void __init intel_idle_init_cstat
 
 		if ((disabled_states_mask & BIT(drv->state_count)) ||
 		    ((icpu->use_acpi || force_use_acpi) &&
-		     intel_idle_off_by_default(mwait_hint) &&
+		     intel_idle_off_by_default(state->flags, mwait_hint) &&
 		     !(state->flags & CPUIDLE_FLAG_ALWAYS_ENABLE)))
 			state->flags |= CPUIDLE_FLAG_OFF;
 



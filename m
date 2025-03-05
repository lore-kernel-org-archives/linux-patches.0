Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B249719C542;
	Wed,  5 Mar 2025 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198824; cv=none; b=FnYNL+xRo4H4qBr+NzYNRHaiOcrgplSDqBcqh/DBgAIiMOKh94zUS4zLt4ZPKtu8XZ0PHsYlmtIV1XG1RkHxoR90INen6kcVr2topqsIzH4Tv0Bwy3L9kHlPkjxbhuXvNn5cY0qzkIIBw2iT1WsasAUZZddJnUo9QMQKGcLsuoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198824; c=relaxed/simple;
	bh=V2sPvQkWwA/5YwS842WyaFjut5vZNKn7pifMfcjho04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiFQiOKjI9ZL+LsN9C+NABNrtRcdDzdczBwMm41+yOybcAZ/rn7ZkJOYBtVl/4537+kKQorJbnALIWBbQt+LXpDF9B2hN5OVY0O362NGa+9bFoSYMpZCkbTXqwwOk2FIN5UJpAvjX9ABjO8VfIAIBI/Mq9sOD129USRP+pA+Ots=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJUg1SMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJUg1SMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A853C4CED1;
	Wed,  5 Mar 2025 18:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198824;
	bh=V2sPvQkWwA/5YwS842WyaFjut5vZNKn7pifMfcjho04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJUg1SMy/mXLAbhNN8EuSS/xlLD8blouTawLQ8JJ3a0RxyUTfk7m/nZjvN5QPpqsi
	 oiUCGSaOPsApXxB0P6PCSL3mK6orhvdGzkC9g6OW6G2L3LYGEDTTJ2Y+Jc9JXWAqGu
	 K79duV9n9fkxo33+cr21PtLg6iynYvYh2LabuRms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fab Stz <fabstz-it@yahoo.fr>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.13 128/157] intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly
Date: Wed,  5 Mar 2025 18:49:24 +0100
Message-ID: <20250305174510.450793221@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c157d351460bcf202970e97e611cb6b54a3dd4a4 upstream.

The Intel idle driver is preferred over the ACPI processor idle driver,
but fails to implement the work around for Core2 generation CPUs, where
the TSC stops in C2 and deeper C-states. This causes stalls and boot
delays, when the clocksource watchdog does not catch the unstable TSC
before the CPU goes deep idle for the first time.

The ACPI driver marks the TSC unstable when it detects that the CPU
supports C2 or deeper and the CPU does not have a non-stop TSC.

Add the equivivalent work around to the Intel idle driver to cure that.

Fixes: 18734958e9bf ("intel_idle: Use ACPI _CST for processor models without C-state tables")
Reported-by: Fab Stz <fabstz-it@yahoo.fr>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Fab Stz <fabstz-it@yahoo.fr>
Cc: All applicable <stable@vger.kernel.org>
Closes: https://lore.kernel.org/all/10cf96aa-1276-4bd4-8966-c890377030c3@yahoo.fr
Link: https://patch.msgid.link/87bjupfy7f.ffs@tglx
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/idle/intel_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -55,6 +55,7 @@
 #include <asm/intel-family.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/tsc.h>
 #include <asm/fpu/api.h>
 
 #define INTEL_IDLE_VERSION "0.5.1"
@@ -1797,6 +1798,9 @@ static void __init intel_idle_init_cstat
 		if (intel_idle_state_needs_timer_stop(state))
 			state->flags |= CPUIDLE_FLAG_TIMER_STOP;
 
+		if (cx->type > ACPI_STATE_C1 && !boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+			mark_tsc_unstable("TSC halts in idle");
+
 		state->enter = intel_idle;
 		state->enter_s2idle = intel_idle_s2idle;
 	}



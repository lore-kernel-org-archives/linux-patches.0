Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DDA539A;
	Wed,  5 Mar 2025 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197846; cv=none; b=YXPJpKPokXnoQZWOIG/cpWJ4U8aUnciOIpykz7SIzS2M9E4iMLqclUJ207/HTV+86zl3nXQkrIiZEpV69SkbGzPeV4FHGTPaHcdwStNBqIn24rFxfMuQYxZKXLjOPo1C9ZTFR67pBWBbmpQvRmcAwgtATEbRMzwj6ldEy6k9nOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197846; c=relaxed/simple;
	bh=Hc6+M8eJMYrYbMRU5x8wojBzVPjGyOA/QzzX4eBEunc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0ix9zUprUQ27XIcA/lVzZPN/GBA090veFToxbv7lCGLu0SU/0xE7kjkvwUMYlAGNj2YfztOM61bnd61Jfc2sddSnRSWKFxRA9VRt0G9dzskiys4L2Ro70Kljjba5jdivskwm6CV09OBxHBI+dewT+bDVpu7g/eyJQt2rWDb7cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yn/I63Yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yn/I63Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D4BC4CED1;
	Wed,  5 Mar 2025 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197846;
	bh=Hc6+M8eJMYrYbMRU5x8wojBzVPjGyOA/QzzX4eBEunc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn/I63Yn4SvVcxkvT0Jk3WfclCU17n2AdUvo2zBsZztySfu5VzS8DFGIXX/PVvVVc
	 7uSlA8p5lDgTwBU0jE6lCGAlt0oTaayInb8XYG0jyDdWxeFlSjyGJA7dVXVuOt79Hi
	 MLpQqZTOFNodsL6XQP4EUUxXge2B+XGRo+QqVzIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 121/142] x86/microcode: Add per CPU control field
Date: Wed,  5 Mar 2025 18:49:00 +0100
Message-ID: <20250305174505.189508492@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit ba3aeb97cb2c53025356f31c5a0a294385194115 upstream

Add a per CPU control field to ucode_ctrl and define constants for it
which are going to be used to control the loading state machine.

In theory this could be a global control field, but a global control does
not cover the following case:

 15 primary CPUs load microcode successfully
  1 primary CPU fails and returns with an error code

With global control the sibling of the failed CPU would either try again or
the whole operation would be aborted with the consequence that the 15
siblings do not invoke the apply path and end up with inconsistent software
state. The result in dmesg would be inconsistent too.

There are two additional fields added and initialized:

ctrl_cpu and secondaries. ctrl_cpu is the CPU number of the primary thread
for now, but with the upcoming uniform loading at package or system scope
this will be one CPU per package or just one CPU. Secondaries hands the
control CPU a CPU mask which will be required to release the secondary CPUs
out of the wait loop.

Preparatory change for implementing a properly split control flow for
primary and secondary CPUs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115903.319959519@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -252,8 +252,19 @@ static struct platform_device	*microcode
  *   requirement can be relaxed in the future. Right now, this is conservative
  *   and good.
  */
+enum sibling_ctrl {
+	/* Spinwait with timeout */
+	SCTRL_WAIT,
+	/* Invoke the microcode_apply() callback */
+	SCTRL_APPLY,
+	/* Proceed without invoking the microcode_apply() callback */
+	SCTRL_DONE,
+};
+
 struct microcode_ctrl {
+	enum sibling_ctrl	ctrl;
 	enum ucode_state	result;
+	unsigned int		ctrl_cpu;
 };
 
 static DEFINE_PER_CPU(struct microcode_ctrl, ucode_ctrl);
@@ -398,7 +409,7 @@ static int load_late_stop_cpus(void)
  */
 static bool setup_cpus(void)
 {
-	struct microcode_ctrl ctrl = { .result = -1, };
+	struct microcode_ctrl ctrl = { .ctrl = SCTRL_WAIT, .result = -1, };
 	unsigned int cpu;
 
 	for_each_cpu_and(cpu, cpu_present_mask, &cpus_booted_once_mask) {
@@ -408,7 +419,12 @@ static bool setup_cpus(void)
 				return false;
 			}
 		}
-		/* Initialize the per CPU state */
+
+		/*
+		 * Initialize the per CPU state. This is core scope for now,
+		 * but prepared to take package or system scope into account.
+		 */
+		ctrl.ctrl_cpu = cpumask_first(topology_sibling_cpumask(cpu));
 		per_cpu(ucode_ctrl, cpu) = ctrl;
 	}
 	return true;



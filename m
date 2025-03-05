Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B546219067C;
	Wed,  5 Mar 2025 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197908; cv=none; b=ObU60TX/lxekZsgeJ3d7S6yFX2LtnkThuGg+tN0g/foXNyx2OQfXZXFwE8zmgUWJxjFEiyLwSQ4wO34wrepTnK3+rhENLOtcc1HJ9529+Pj7OSxdh/m3g/YL6oPkijt8ANo6qzvHAm/8olDMqwxu6hklBNG6N4QQrrInCa8vyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197908; c=relaxed/simple;
	bh=6srE4pLpWDZ72nPOLoOVFOtYUaAQgi6FnDTXjda6QcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smRN7JuDT/uYWJ6MNNoyVEUiBM1+xw1+jqPxPYyOJDulysGUg5hHSfh/469aYthuifdePbC9jKChypWkilJ/Qb1xuZv8BnauZhYL6ZuAfQt5JUz+8PQVLz9rvHK3SGArgRC9RFqyXPRg+rNXVE64rpwbmGe5tqTD4Uw1ukfyM58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRll03cU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRll03cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A12C4CED1;
	Wed,  5 Mar 2025 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197908;
	bh=6srE4pLpWDZ72nPOLoOVFOtYUaAQgi6FnDTXjda6QcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRll03cU1vRFIK46Oi35Kp1VShOx5HismO3xlRyf1Bj4vkWks7/uhBP/dX+pG43Te
	 Vf786AFG4v0RxCqQy//p0R6AzTYrNJ4OpiSpX7YBwPIKWP154NaoalNTWzX3ZFiR3Z
	 PUuxw1W1L8vANQyKVFl91ypQwJPgEvqiXP1zm5YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 109/142] x86/microcode: Remove pointless apply() invocation
Date: Wed,  5 Mar 2025 18:48:48 +0100
Message-ID: <20250305174504.709560169@linuxfoundation.org>
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

commit b48b26f992a3828b4ae274669f99ce68451d4904 upstream

Microcode is applied on the APs during early bringup. There is no point
in trying to apply the microcode again during the hotplug operations and
neither at the point where the microcode device is initialized.

Collect CPU info and microcode revision in setup_online_cpu() for now.
This will move to the CPU hotplug callback later.

  [ bp: Leave the starting notifier for the following scenario:

    - boot, late load, suspend to disk, resume

    without the starting notifier, only the last core manages to update the
    microcode upon resume:

    # rdmsr -a 0x8b
    10000bf
    10000bf
    10000bf
    10000bf
    10000bf
    10000dc <----

    This is on an AMD F10h machine.

    For the future, one should check whether potential unification of
    the CPU init path could cover the resume path too so that this can
    be simplified even more.

  tglx: This is caused by the odd handling of APs which try to find the
  microcode blob in builtin or initrd instead of caching the microcode
  blob during early init before the APs are brought up. Will be cleaned
  up in a later step. ]

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20231017211723.018821624@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -493,17 +493,6 @@ static void microcode_fini_cpu(int cpu)
 		microcode_ops->microcode_fini_cpu(cpu);
 }
 
-static enum ucode_state microcode_init_cpu(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	memset(uci, 0, sizeof(*uci));
-
-	microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig);
-
-	return microcode_ops->apply_microcode(cpu);
-}
-
 /**
  * microcode_bsp_resume - Update boot CPU microcode during resume.
  */
@@ -558,14 +547,14 @@ static int mc_cpu_down_prep(unsigned int
 static void setup_online_cpu(struct work_struct *work)
 {
 	int cpu = smp_processor_id();
-	enum ucode_state err;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	err = microcode_init_cpu(cpu);
-	if (err == UCODE_ERROR) {
-		pr_err("Error applying microcode on CPU%d\n", cpu);
-		return;
-	}
+	memset(uci, 0, sizeof(*uci));
 
+	microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig);
+	cpu_data(cpu).microcode = uci->cpu_sig.rev;
+	if (!cpu)
+		boot_cpu_data.microcode = uci->cpu_sig.rev;
 	mc_cpu_online(cpu);
 }
 



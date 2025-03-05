Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F6F539A;
	Wed,  5 Mar 2025 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197850; cv=none; b=V/a24xPAcEDDV97ay7xPFi9RBKiwNBn4fxyziI0xZghHW2t9o/mDJMQ03jLaelrtXmOfDd7RuM+qVrgIBcI5DseFAsWOTFHX0XU6mCY2G1i9zx6EfN4F9vo003FBOZmEyKIkAFMbX0eFpIE9Nfi7FHk26IZfBDGZA8lL1ZxYkrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197850; c=relaxed/simple;
	bh=WcoydfJDze9JkYRsp7cU4BAYkzyhsGp89Z21ehco/vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJT3hB4SlO/lQcC1KOIczbYINZeILL67/OcxPtreX8Yqqdfs3+65KdEMYrBfisQRxb0sXifHbQMbwfzu1MR6i6UwoUSXC7k6FM22obrab/fSS4hz/GbLatQplpE4rTzzQHBdJ3NvuOmUpdl2djJmpC7yD30ZpkSeTCbZmvCBtGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiqbVHok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiqbVHok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8DAC4CED1;
	Wed,  5 Mar 2025 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197850;
	bh=WcoydfJDze9JkYRsp7cU4BAYkzyhsGp89Z21ehco/vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiqbVHokBaKTCLJUUEfLDbZ+JxAQHcfFFUNI+eG5VxXCHhIr1HtowT4KNxh5rdh++
	 I+jHT5BO6mJDyJvUHqVOD//+rHcdwXc+h5mf4RZZvPxZ4Ww9qjH+V59wyo+wWl7wHC
	 9F41rm5i7o9pSrGpQU0OrINQH4d1Ec3AT4vWMMAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 122/142] x86/microcode: Provide new control functions
Date: Wed,  5 Mar 2025 18:49:01 +0100
Message-ID: <20250305174505.228883201@linuxfoundation.org>
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

commit 6067788f04b1020b316344fe34746f96d594a042 upstream

The current all in one code is unreadable and really not suited for
adding future features like uniform loading with package or system
scope.

Provide a set of new control functions which split the handling of the
primary and secondary CPUs. These will replace the current rendezvous
all in one function in the next step. This is intentionally a separate
change because diff makes an complete unreadable mess otherwise.

So the flow separates the primary and the secondary CPUs into their own
functions which use the control field in the per CPU ucode_ctrl struct.

   primary()			secondary()
    wait_for_all()		 wait_for_all()
    apply_ucode()		 wait_for_release()
    release()			 apply_ucode()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115903.377922731@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c |   84 +++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -290,6 +290,90 @@ static bool wait_for_cpus(atomic_t *cnt)
 	return false;
 }
 
+static bool wait_for_ctrl(void)
+{
+	unsigned int timeout;
+
+	for (timeout = 0; timeout < USEC_PER_SEC; timeout++) {
+		if (this_cpu_read(ucode_ctrl.ctrl) != SCTRL_WAIT)
+			return true;
+		udelay(1);
+		if (!(timeout % 1000))
+			touch_nmi_watchdog();
+	}
+	return false;
+}
+
+static __maybe_unused void load_secondary(unsigned int cpu)
+{
+	unsigned int ctrl_cpu = this_cpu_read(ucode_ctrl.ctrl_cpu);
+	enum ucode_state ret;
+
+	/* Initial rendezvous to ensure that all CPUs have arrived */
+	if (!wait_for_cpus(&late_cpus_in)) {
+		pr_err_once("load: %d CPUs timed out\n", atomic_read(&late_cpus_in) - 1);
+		this_cpu_write(ucode_ctrl.result, UCODE_TIMEOUT);
+		return;
+	}
+
+	/*
+	 * Wait for primary threads to complete. If one of them hangs due
+	 * to the update, there is no way out. This is non-recoverable
+	 * because the CPU might hold locks or resources and confuse the
+	 * scheduler, watchdogs etc. There is no way to safely evacuate the
+	 * machine.
+	 */
+	if (!wait_for_ctrl())
+		panic("Microcode load: Primary CPU %d timed out\n", ctrl_cpu);
+
+	/*
+	 * If the primary succeeded then invoke the apply() callback,
+	 * otherwise copy the state from the primary thread.
+	 */
+	if (this_cpu_read(ucode_ctrl.ctrl) == SCTRL_APPLY)
+		ret = microcode_ops->apply_microcode(cpu);
+	else
+		ret = per_cpu(ucode_ctrl.result, ctrl_cpu);
+
+	this_cpu_write(ucode_ctrl.result, ret);
+	this_cpu_write(ucode_ctrl.ctrl, SCTRL_DONE);
+}
+
+static __maybe_unused void load_primary(unsigned int cpu)
+{
+	struct cpumask *secondaries = topology_sibling_cpumask(cpu);
+	enum sibling_ctrl ctrl;
+	enum ucode_state ret;
+	unsigned int sibling;
+
+	/* Initial rendezvous to ensure that all CPUs have arrived */
+	if (!wait_for_cpus(&late_cpus_in)) {
+		this_cpu_write(ucode_ctrl.result, UCODE_TIMEOUT);
+		pr_err_once("load: %d CPUs timed out\n", atomic_read(&late_cpus_in) - 1);
+		return;
+	}
+
+	ret = microcode_ops->apply_microcode(cpu);
+	this_cpu_write(ucode_ctrl.result, ret);
+	this_cpu_write(ucode_ctrl.ctrl, SCTRL_DONE);
+
+	/*
+	 * If the update was successful, let the siblings run the apply()
+	 * callback. If not, tell them it's done. This also covers the
+	 * case where the CPU has uniform loading at package or system
+	 * scope implemented but does not advertise it.
+	 */
+	if (ret == UCODE_UPDATED || ret == UCODE_OK)
+		ctrl = SCTRL_APPLY;
+	else
+		ctrl = SCTRL_DONE;
+
+	for_each_cpu(sibling, secondaries) {
+		if (sibling != cpu)
+			per_cpu(ucode_ctrl.ctrl, sibling) = ctrl;
+	}
+}
+
 static int load_cpus_stopped(void *unused)
 {
 	int cpu = smp_processor_id();



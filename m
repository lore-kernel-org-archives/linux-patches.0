Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5B153816;
	Wed, 21 Feb 2024 13:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521258; cv=none; b=dkLsHOQsrw080DeeoVRKv99fwbxBvb8F0mazefijm/GcYyj63ruiUkNZa5l+xtPMqqHN4ynYWcRIN17rggH0uHaNcVB/ZccUUpbNVVqC/YozsUEZ4ksfYr1DS+yZAyX8p4eSER4RHMfKJIUtQVsg7IIXyNQ3hoe9zvvwE9R2XvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521258; c=relaxed/simple;
	bh=hMLZc7bZWZGoXAU+2PiHGUd0WaJCv5Uy5oWKD7HDTek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNDjsQZcbv76zvJyruGJowXBDOj3frYrJlhRxAk3RCayPthjOu02PZHp+cJNBcbJGlg0/Pe6DWPVbJKNKwrByH1PigKMXgspTHt95gDtVQtpvtEEoTG+Iz0Bbf6KBcwCf3cCQ0NcqU9tF10Wfk+k2+NPJpjSp8j70r4fB/xtdEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJgnjptm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJgnjptm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96823C433F1;
	Wed, 21 Feb 2024 13:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521258;
	bh=hMLZc7bZWZGoXAU+2PiHGUd0WaJCv5Uy5oWKD7HDTek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJgnjptmkaWbcgJz7rqYx2vzIbq5sA9SNHQRzSkwhF67Glsy2xaytw/ZgQQfUfXZl
	 gs0JhA3KwhvdAmRipT8l1w63iQTtpZUk/yW9kGQvjlL0uONrd4vtwltGrtQ7lpEO/X
	 zXhHly4jnpN29aW6InU7tm4S0QEW9bf3OuztPdMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 046/202] mips: Call lose_fpu(0) before initializing fcr31 in mips_set_personality_nan
Date: Wed, 21 Feb 2024 14:05:47 +0100
Message-ID: <20240221125933.300934214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit 59be5c35850171e307ca5d3d703ee9ff4096b948 upstream.

If we still own the FPU after initializing fcr31, when we are preempted
the dirty value in the FPU will be read out and stored into fcr31,
clobbering our setting.  This can cause an improper floating-point
environment after execve().  For example:

    zsh% cat measure.c
    #include <fenv.h>
    int main() { return fetestexcept(FE_INEXACT); }
    zsh% cc measure.c -o measure -lm
    zsh% echo $((1.0/3)) # raising FE_INEXACT
    0.33333333333333331
    zsh% while ./measure; do ; done
    (stopped in seconds)

Call lose_fpu(0) before setting fcr31 to prevent this.

Closes: https://lore.kernel.org/linux-mips/7a6aa1bbdbbe2e63ae96ff163fab0349f58f1b9e.camel@xry111.site/
Fixes: 9b26616c8d9d ("MIPS: Respect the ISA level in FCSR handling")
Cc: stable@vger.kernel.org
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/elf.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -15,6 +15,7 @@
 
 #include <asm/cpu-features.h>
 #include <asm/cpu-info.h>
+#include <asm/fpu.h>
 
 /* Whether to accept legacy-NaN and 2008-NaN user binaries.  */
 bool mips_use_nan_legacy;
@@ -311,6 +312,11 @@ void mips_set_personality_nan(struct arc
 	struct cpuinfo_mips *c = &boot_cpu_data;
 	struct task_struct *t = current;
 
+	/* Do this early so t->thread.fpu.fcr31 won't be clobbered in case
+	 * we are preempted before the lose_fpu(0) in start_thread.
+	 */
+	lose_fpu(0);
+
 	t->thread.fpu.fcr31 = c->fpu_csr31;
 	switch (state->nan_2008) {
 	case 0:



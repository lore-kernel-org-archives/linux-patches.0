Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6AF161B54;
	Mon, 29 Jan 2024 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548354; cv=none; b=TByEVdZlZ6BB9RZSlKo7pIRRo5qpPt4kQXG2+h18nRyfY15v19TtagUDk6ypgX10nUBj6dUFH884nPYmSgrOA0MzYzn42Pi3VkeE7eVmNY2g71+xFPvh5Bw1OCgezfvQ5BpKaHDkkEmf7oSgXdZElP5DsNcDS7HjKileFfQFgFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548354; c=relaxed/simple;
	bh=jItDdHDuYmcp6LcWaQXCyDiQl6Rsg0y0LzPLlUUI/xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmGDwwDylZ7aYt04u05dW3rmnJ7ZpYATctYiTEeTYYIqx5tvYyZ7z7x8pv4KwsfUXKiGNkzfW31KWFeNKHGahI0JxAOw4IV8dmCi3U0PpKUuRWNK8qKU4BQJUWyhXsXvXsrhIJzmLBIjwv4yVVNeyjFIIU+XlmaagG9UMsDOKLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guR+4ylE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guR+4ylE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E948FC433F1;
	Mon, 29 Jan 2024 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548354;
	bh=jItDdHDuYmcp6LcWaQXCyDiQl6Rsg0y0LzPLlUUI/xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guR+4ylEfG0Ls/asTAIrfCs5ccRPknOAqkH3TlGCyru39lxgTUDVOnlT3xXBvX9op
	 TIBnW0l48n2CxbVrEjNyrPgS/+YvN+3ZvFm72VZSoJHUTa/zECt1afasD5XxQdCTsa
	 9GuaPZJw2MUk+wXDgYr3uzlZ2cTZrTQ0R509UQE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.7 342/346] mips: Call lose_fpu(0) before initializing fcr31 in mips_set_personality_nan
Date: Mon, 29 Jan 2024 09:06:13 -0800
Message-ID: <20240129170026.566969298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -11,6 +11,7 @@
 
 #include <asm/cpu-features.h>
 #include <asm/cpu-info.h>
+#include <asm/fpu.h>
 
 #ifdef CONFIG_MIPS_FP_SUPPORT
 
@@ -309,6 +310,11 @@ void mips_set_personality_nan(struct arc
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



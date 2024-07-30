Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C72F17D8BB;
	Tue, 30 Jul 2024 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358724; cv=none; b=Ak21klQMSAXNRxByNsgIRUjZTc6WFOA+aLFi0YWmoAHCWpbNMUtwmM7693G1KucqZFGErXKpx9uQJueT6iHHOzHFr6NMGfDWSe4KO9q8vBlNd8IfudVsEuMqlehNqZiMtIzDY7t6DXhBNtwiNbD0BStri/zBibw5hu3oOg3/zRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358724; c=relaxed/simple;
	bh=99dEi/2mbzWmp4qnrK5PWd9NIjH3UKn68s+yA4ztFZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgS56rfLb4gMrtCidu/jtVmtBiUpqpDWmrrks4DjvsrWv2G1q0ldtrxl9H4kaShDR8TDArOHjAoBDcQAfjjPxOgM4mvsFBQq0/mRpEX3GQUCm4D2wuqd07niItHqxTGk8bkabrwO3wfboFVFlE/MO7Dc/g34wDz8u3b3MTIBsx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAxJ3bMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAxJ3bMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF94AC32782;
	Tue, 30 Jul 2024 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358724;
	bh=99dEi/2mbzWmp4qnrK5PWd9NIjH3UKn68s+yA4ztFZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAxJ3bMMx/08vWCD7ZaqjzAwWsdF6Kr/Tonhn4YUvdKIuy7n1KYL6HyfUlnoI8g/x
	 /x3JNkiCGuBtapHCB4nB+P52HLRKT64Z8F/gq5Z5tJHp3DhvkjGk/iu+JZ/8xgWpMi
	 K1M7U2sV/82EzJyt4VQ6Mccwa1dYatNkyD85Vdvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Andy Chiu <andy.chiu@sifive.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 388/809] riscv: smp: fail booting up smp if inconsistent vlen is detected
Date: Tue, 30 Jul 2024 17:44:24 +0200
Message-ID: <20240730151739.996302648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andy.chiu@sifive.com>

[ Upstream commit 38a94c46660f5612c6ef37ec9754ec1543b038cd ]

Currently we only support Vector for SMP platforms, that is, all SMP
cores have the same vlenb. If we happen to detect a mismatching vlen, it
is better to just fail bootting it up to prevent further race/scheduling
issues.

Also, move .Lsecondary_park forward and chage `tail smp_callin` into a
regular call in the early assembly. So a core would be parked right
after a return from smp_callin. Note that a successful smp_callin
does not return.

Fixes: 7017858eb2d7 ("riscv: Introduce riscv_v_vsize to record size of Vector context")
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Closes: https://lore.kernel.org/linux-riscv/20240228-vicinity-cornstalk-4b8eb5fe5730@spud/
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Yunhui Cui <cuiyunhui@bytedance.com>
Link: https://lore.kernel.org/r/20240510-zve-detection-v5-2-0711bdd26c12@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/head.S    | 19 ++++++++++++-------
 arch/riscv/kernel/smpboot.c | 14 +++++++++-----
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 4236a69c35cb3..a00f7523cb91f 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -165,9 +165,20 @@ secondary_start_sbi:
 #endif
 	call .Lsetup_trap_vector
 	scs_load_current
-	tail smp_callin
+	call smp_callin
 #endif /* CONFIG_SMP */
 
+.align 2
+.Lsecondary_park:
+	/*
+	 * Park this hart if we:
+	 *  - have too many harts on CONFIG_RISCV_BOOT_SPINWAIT
+	 *  - receive an early trap, before setup_trap_vector finished
+	 *  - fail in smp_callin(), as a successful one wouldn't return
+	 */
+	wfi
+	j .Lsecondary_park
+
 .align 2
 .Lsetup_trap_vector:
 	/* Set trap vector to exception handler */
@@ -181,12 +192,6 @@ secondary_start_sbi:
 	csrw CSR_SCRATCH, zero
 	ret
 
-.align 2
-.Lsecondary_park:
-	/* We lack SMP support or have too many harts, so park this hart */
-	wfi
-	j .Lsecondary_park
-
 SYM_CODE_END(_start)
 
 SYM_CODE_START(_start_kernel)
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index 1319b29ce3b59..19baf0d574d35 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -214,6 +214,15 @@ asmlinkage __visible void smp_callin(void)
 	struct mm_struct *mm = &init_mm;
 	unsigned int curr_cpuid = smp_processor_id();
 
+	if (has_vector()) {
+		/*
+		 * Return as early as possible so the hart with a mismatching
+		 * vlen won't boot.
+		 */
+		if (riscv_v_setup_vsize())
+			return;
+	}
+
 	/* All kernel threads share the same mm context.  */
 	mmgrab(mm);
 	current->active_mm = mm;
@@ -226,11 +235,6 @@ asmlinkage __visible void smp_callin(void)
 	numa_add_cpu(curr_cpuid);
 	set_cpu_online(curr_cpuid, true);
 
-	if (has_vector()) {
-		if (riscv_v_setup_vsize())
-			elf_hwcap &= ~COMPAT_HWCAP_ISA_V;
-	}
-
 	riscv_user_isa_enable();
 
 	/*
-- 
2.43.0




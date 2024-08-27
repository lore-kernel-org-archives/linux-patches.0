Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AE917C96;
	Tue, 27 Aug 2024 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772127; cv=none; b=SyCLQiMH6Qc7TKr0n5JTxAr0H7R6yw8+Dafi2vp+g9vjey2a/pe3vbcsmLU/9Nn1EMnIgi1HEhmB0IF95ViCjqIunaZk0up94H7r/F4LjLWRCrxaukM5TE4HvFuhZyBWRpyZGTQD+qcQ2w4SHoR4oYvn7cZcUrOILWs/fMDJvsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772127; c=relaxed/simple;
	bh=uwtb2RjtuDDwgPEln2LDeOHgsqlldx9o32pkgFj8l7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUKNzBVTQamxq67sOPwYHFGhVv4U6OwWvr6bBM8L0mWUMMWTfVNuzocg1YZXy/LujgEkHAXZUs5kbU/qqIijBj8Uj+OnJphUfG+UqKQ4CthcdKl+V7pEn7lx7wcpsgoF/P7Dpwu/423wFYB7ukdw12Wheer+Dagl7IaYim4O5sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1acMpI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1acMpI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E1DC4FE09;
	Tue, 27 Aug 2024 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772126;
	bh=uwtb2RjtuDDwgPEln2LDeOHgsqlldx9o32pkgFj8l7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1acMpI2FqKYZu7Q1ulLsVs983UiFRoTYFrAYCgtlMdHHjSRvIM44wbQ/WM4fqPvM
	 07qR7RPOmeYOeaJJGmK99XU7ffod1ueSrrlxI9l1MrqPky14HyLMbC/eemc71HjA0+
	 xUoQbqCoYQiQn1SESXFcWNjNmivIBYLQiOpaAGlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/321] s390/smp,mcck: fix early IPI handling
Date: Tue, 27 Aug 2024 16:37:09 +0200
Message-ID: <20240827143842.849906075@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 4a1725281fc5b0009944b1c0e1d2c1dc311a09ec ]

Both the external call as well as the emergency signal submask bits in
control register 0 are set before any interrupt handler is registered.

Change the order and first register the interrupt handler and only then
enable the interrupts by setting the corresponding bits in control
register 0.

This prevents that the second part of the machine check handler for
early machine check handling is not executed: the machine check handler
sends an IPI to the CPU it runs on. If the corresponding interrupts are
enabled, but no interrupt handler is present, the interrupt is ignored.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c | 12 +++---------
 arch/s390/kernel/smp.c   |  4 ++--
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 9693c8630e73f..b3cb256ec6692 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -237,15 +237,9 @@ static inline void save_vector_registers(void)
 #endif
 }
 
-static inline void setup_control_registers(void)
+static inline void setup_low_address_protection(void)
 {
-	unsigned long reg;
-
-	__ctl_store(reg, 0, 0);
-	reg |= CR0_LOW_ADDRESS_PROTECTION;
-	reg |= CR0_EMERGENCY_SIGNAL_SUBMASK;
-	reg |= CR0_EXTERNAL_CALL_SUBMASK;
-	__ctl_load(reg, 0, 0);
+	__ctl_set_bit(0, 28);
 }
 
 static inline void setup_access_registers(void)
@@ -304,7 +298,7 @@ void __init startup_init(void)
 	save_vector_registers();
 	setup_topology();
 	sclp_early_detect();
-	setup_control_registers();
+	setup_low_address_protection();
 	setup_access_registers();
 	lockdep_on();
 }
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 0031325ce4bc9..436dbf4d743d8 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1007,12 +1007,12 @@ void __init smp_fill_possible_mask(void)
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	/* request the 0x1201 emergency signal external interrupt */
 	if (register_external_irq(EXT_IRQ_EMERGENCY_SIG, do_ext_call_interrupt))
 		panic("Couldn't request external interrupt 0x1201");
-	/* request the 0x1202 external call external interrupt */
+	ctl_set_bit(0, 14);
 	if (register_external_irq(EXT_IRQ_EXTERNAL_CALL, do_ext_call_interrupt))
 		panic("Couldn't request external interrupt 0x1202");
+	ctl_set_bit(0, 13);
 }
 
 void __init smp_prepare_boot_cpu(void)
-- 
2.43.0




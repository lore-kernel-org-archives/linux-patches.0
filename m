Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C817E00C;
	Sun,  1 Sep 2024 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209436; cv=none; b=kgTlwBQCPtZ5yu4VmLVW6Rw3R0sXpYpAtJCH8GzTFtQOQDXYMU0G9xx8Qd2EyerxHbG9j4Ew4eBclLcJBpA6SGWFXzjEVeDJTpvsRsBoGldULhk+9ScPGTKTHkKYzVzmw3UWXRG4LTOxMiRNaipTeMSWCOoTBc/0X/tcAUur4zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209436; c=relaxed/simple;
	bh=m2XyC+hQosY1ynU7U+HJwfylcM0jbbNm8fl5tOSManc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0KbuTRUvpohUdFurGafC5n4Uz6egvdOy8rz0L2LGqd1pr9qj/PuccxRCGRrKJ4R2vRKDlw8oaax49CjmAr8CQwnKZQ4qsms59QfSz+tm1eVwNWCcYFt0dGuwfeoQEMysoWZidYkQe6GiWvaIdSOBNpDvnXEd63cYuBVzRAFF+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltQvri3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltQvri3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66C1C4CEC3;
	Sun,  1 Sep 2024 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209436;
	bh=m2XyC+hQosY1ynU7U+HJwfylcM0jbbNm8fl5tOSManc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltQvri3Tgvj19bTpHbdnMMmbqQXTaaIk6Tpp58SSSFbjBSsyvPXvA51XIBNNjLj2C
	 LQxfM1+TqyrtJ3as9u3afs5X/OLeySALVb8kLHs1RHaT31yEcLfcru0ge+EFrIv9se
	 wX3t7n8kCDrsq/a4YT5kP4AmdGM5/aD+KPcE4UY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/151] s390/smp,mcck: fix early IPI handling
Date: Sun,  1 Sep 2024 18:16:36 +0200
Message-ID: <20240901160815.459161741@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 985e1e7553336..bac1be43d36cb 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -252,15 +252,9 @@ static inline void save_vector_registers(void)
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
@@ -313,7 +307,7 @@ void __init startup_init(void)
 	save_vector_registers();
 	setup_topology();
 	sclp_early_detect();
-	setup_control_registers();
+	setup_low_address_protection();
 	setup_access_registers();
 	lockdep_on();
 }
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 5674792726cd9..2e0c3b0a5a58a 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -982,12 +982,12 @@ void __init smp_fill_possible_mask(void)
 
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




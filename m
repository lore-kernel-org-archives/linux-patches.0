Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290AF44C93;
	Sun,  1 Sep 2024 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209970; cv=none; b=DWS7lUOZHlZJG0zomGoB6ZR937186uZuBhA1Q6rbX2GSaYXUgJe3Vm3Yuu3Sg2XNFw0QlYggOKHQHp3iQ6YAIeZWTNvhiwOnbnilGiopgWOTZbG2u8IPjxiaUwwbNlpczyK/PtBHCyJuI/z/bwDo+gs5Bo1aU89weWwQCoSaQ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209970; c=relaxed/simple;
	bh=h61EiXhiFvGdX172GOBA6xIKn0Q7OKcNdWs6S6OtRNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE3wkp6XhGLa3iXkwiigblAt/u0cYYpf6VzLt7cDSCJSj28cx7x0PrzwcY8ry2dDJ1mr2lhb+X7Zl1Lpnkgo13Ws+kaPPL2lMP0XJlNaY2O7PJ8kFvI+M4IviAvq9itkBhFKEi9WouKGbPatk3LPBNc9PodAKjxHr46qr30INvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhPf2lWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhPf2lWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854CDC4CEC3;
	Sun,  1 Sep 2024 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209970;
	bh=h61EiXhiFvGdX172GOBA6xIKn0Q7OKcNdWs6S6OtRNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhPf2lWcBQjhDQC9O0lFe9CEPIuySj+IFcfSp5RHv/njRR0BqM56UGWOF4p4WGzJ+
	 AK4QauRSU9nce4o/zZfSgLIXi9ytbl27HGVDcOg2zdbmGy0/nNC4N6sIkVsAo2ut0r
	 8kCivx9dNuZg/kjkIYJhmVlzJdzE8bDhe8DxmcbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/215] s390/smp,mcck: fix early IPI handling
Date: Sun,  1 Sep 2024 18:16:01 +0200
Message-ID: <20240901160825.207108294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9857cb0467268..9898582f44da8 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -250,15 +250,9 @@ static inline void save_vector_registers(void)
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
@@ -311,7 +305,7 @@ void __init startup_init(void)
 	save_vector_registers();
 	setup_topology();
 	sclp_early_detect();
-	setup_control_registers();
+	setup_low_address_protection();
 	setup_access_registers();
 	lockdep_on();
 }
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 35af70ed58fc7..48f67a69d119b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1003,12 +1003,12 @@ void __init smp_fill_possible_mask(void)
 
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




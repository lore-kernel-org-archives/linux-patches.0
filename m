Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D548B7C080;
	Mon,  8 Apr 2024 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582182; cv=none; b=tzP/uKGAGx0zW8ypRi4x59o7wPns9d04Uk6ivx8hGeRuffegaXK0wyS4/RGwgRSMhItHJLkoO5rqz3rNEG5rUCDd3nlhgJvFnXimBQYwVkiQjXbT34pCvAQMBGD/8yupSOFTuIA1ZuHVIjXl9ST0ZqTqzAi1JnhS6d00rWGdaMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582182; c=relaxed/simple;
	bh=L4p8N32dkw3ikXBZIGVDKjn52DioWltro1h7fASP1IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RwT++f2aAWoCtHHbvhr5yjADjeckzbLIUcAmn4aWO+edH9zxqW+P5qfa6Iq02iGVPimNDN4XTmCVQACddkx0r7VIOlRWRziT18nSMCGvkPIE9H4+qStwoepuHL6b4uSuznTDMfag1Ldx94RRT2BW1tP1AqRKxYdne5IPykb5JtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKtM568G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKtM568G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F3C433C7;
	Mon,  8 Apr 2024 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582182;
	bh=L4p8N32dkw3ikXBZIGVDKjn52DioWltro1h7fASP1IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKtM568G7Eh1F8qK2Y5hN86tCsP+E+b0XRf+CN0tx+UAKm789vL2hQ0ObKoOh2rnI
	 vwT/HUcCqSl+nAmr0uVDVTuG1zbmOa/6NRNVzdzLpGnVpQ6Z3hggB4RPR81aHVRMiW
	 SvZ3T16j8eTGyFIdjcmLSgd7f8z1xDz7sGTZ8hLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.6 070/252] RISC-V: KVM: Fix APLIC in_clrip[x] read emulation
Date: Mon,  8 Apr 2024 14:56:09 +0200
Message-ID: <20240408125308.807060879@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

commit 8e936e98718f005c986be0bfa1ee6b355acf96be upstream.

The reads to APLIC in_clrip[x] registers returns rectified input values
of the interrupt sources.

A rectified input value of an interrupt source is defined by the section
"4.5.2 Source configurations (sourcecfg[1]–sourcecfg[1023])" of the
RISC-V AIA specification as:

    rectified input value = (incoming wire value) XOR (source is inverted)

Update the riscv_aplic_input() implementation to match the above.

Cc: stable@vger.kernel.org
Fixes: 74967aa208e2 ("RISC-V: KVM: Add in-kernel emulation of AIA APLIC")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20240321085041.1955293-3-apatel@ventanamicro.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/aia_aplic.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index 5e842b92dc46..b467ba5ed910 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -197,16 +197,31 @@ static void aplic_write_enabled(struct aplic *aplic, u32 irq, bool enabled)
 
 static bool aplic_read_input(struct aplic *aplic, u32 irq)
 {
-	bool ret;
-	unsigned long flags;
+	u32 sourcecfg, sm, raw_input, irq_inverted;
 	struct aplic_irq *irqd;
+	unsigned long flags;
+	bool ret = false;
 
 	if (!irq || aplic->nr_irqs <= irq)
 		return false;
 	irqd = &aplic->irqs[irq];
 
 	raw_spin_lock_irqsave(&irqd->lock, flags);
-	ret = (irqd->state & APLIC_IRQ_STATE_INPUT) ? true : false;
+
+	sourcecfg = irqd->sourcecfg;
+	if (sourcecfg & APLIC_SOURCECFG_D)
+		goto skip;
+
+	sm = sourcecfg & APLIC_SOURCECFG_SM_MASK;
+	if (sm == APLIC_SOURCECFG_SM_INACTIVE)
+		goto skip;
+
+	raw_input = (irqd->state & APLIC_IRQ_STATE_INPUT) ? 1 : 0;
+	irq_inverted = (sm == APLIC_SOURCECFG_SM_LEVEL_LOW ||
+			sm == APLIC_SOURCECFG_SM_EDGE_FALL) ? 1 : 0;
+	ret = !!(raw_input ^ irq_inverted);
+
+skip:
 	raw_spin_unlock_irqrestore(&irqd->lock, flags);
 
 	return ret;
-- 
2.44.0




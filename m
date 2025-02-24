Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA641547E9;
	Mon, 24 Feb 2025 15:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409242; cv=none; b=rsAACoPCkF6ZIlZsL0DryZdso0MRul6YpYH3ChL5uKb8bacGl53uxDJBoQq2riJpf09SFbUwzGzFlPW5SshK9kF2UamJGGipiE+SAp/zR5oP7nYvmIRGw90AT09uRevkGaCCN3cK7gpyE5Gjq69GtWcHQasdc7X1dW/k64Sq3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409242; c=relaxed/simple;
	bh=eES5mwExC2LhIGqIRRDLg5BtnY7sZKtZIFDvbua1mxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX5cZw9BSY+LkUjgzWPm5Ljwk1RNY9GRLztiQheEvy4tzWuAo1R2Lp1Ng3O5Vj8zwFgKywh/1jiCt7WjrW9PMolPKJ7pk0LP9OdIdEBfJcX2ocs2UlviQT5iHqvMkfYb4H6ChFMSaNeqMyopUnROQyV3nYcKG8Ulf8iMhKPybPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqqOVufw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqqOVufw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D401CC4CED6;
	Mon, 24 Feb 2025 15:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409242;
	bh=eES5mwExC2LhIGqIRRDLg5BtnY7sZKtZIFDvbua1mxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqqOVufwLPm41jkou9pR0jnWnZS0jnQpNQveRzx6V34/4dCD3Y+Ys5UirovWDuRZT
	 DsqztRCT8xMpC93/oZs0OqqgPf8Qh+G3NIf4Xnc1rEZnfDAv1zPuuMD0Tij/dRi13+
	 TpWJPhPtafsoRJixg8OwyQDFpb/RBUvpA8U5Mqqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Fritz <chf.fritz@googlemail.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 128/138] irqchip/gic-v3: Fix rk3399 workaround when secure interrupts are enabled
Date: Mon, 24 Feb 2025 15:35:58 +0100
Message-ID: <20250224142609.502207449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 4cb77793842a351b39a030f77caebace3524840e upstream.

Christoph reports that their rk3399 system dies since commit 773c05f417fa1
("irqchip/gic-v3: Work around insecure GIC integrations").

It appears that some rk3399 have secure payloads, and that the firmware
sets SCR_EL3.FIQ==1. Obivously, disabling security in that configuration
leads to even more problems.

Revisit the workaround by:

  - making it rk3399 specific
  - checking whether Group-0 is available, which is a good proxy
    for SCR_EL3.FIQ being 0
  - either apply the workaround if Group-0 is available, or disable
    pseudo-NMIs if not

Note that this doesn't mean that the secure side is able to receive
interrupts, as all interrupts are made non-secure anyway.

Clearly, nobody ever tested secure interrupts on this platform.

Fixes: 773c05f417fa1 ("irqchip/gic-v3: Work around insecure GIC integrations")
Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Christoph Fritz <chf.fritz@googlemail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250215185241.3768218-1-maz@kernel.org
Closes: https://lore.kernel.org/r/b1266652fb64857246e8babdf268d0df8f0c36d9.camel@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c |   53 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)

--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -44,6 +44,7 @@ static u8 dist_prio_nmi __ro_after_init
 #define FLAGS_WORKAROUND_GICR_WAKER_MSM8996	(1ULL << 0)
 #define FLAGS_WORKAROUND_CAVIUM_ERRATUM_38539	(1ULL << 1)
 #define FLAGS_WORKAROUND_ASR_ERRATUM_8601001	(1ULL << 2)
+#define FLAGS_WORKAROUND_INSECURE		(1ULL << 3)
 
 #define GIC_IRQ_TYPE_PARTITION	(GIC_IRQ_TYPE_LPI + 1)
 
@@ -83,6 +84,8 @@ static DEFINE_STATIC_KEY_TRUE(supports_d
 #define GIC_LINE_NR	min(GICD_TYPER_SPIS(gic_data.rdists.gicd_typer), 1020U)
 #define GIC_ESPI_NR	GICD_TYPER_ESPIS(gic_data.rdists.gicd_typer)
 
+static bool nmi_support_forbidden;
+
 /*
  * There are 16 SGIs, though we only actually use 8 in Linux. The other 8 SGIs
  * are potentially stolen by the secure side. Some code, especially code dealing
@@ -163,21 +166,27 @@ static void __init gic_prio_init(void)
 {
 	bool ds;
 
-	ds = gic_dist_security_disabled();
-	if (!ds) {
-		u32 val;
+	cpus_have_group0 = gic_has_group0();
 
-		val = readl_relaxed(gic_data.dist_base + GICD_CTLR);
-		val |= GICD_CTLR_DS;
-		writel_relaxed(val, gic_data.dist_base + GICD_CTLR);
-
-		ds = gic_dist_security_disabled();
-		if (ds)
-			pr_warn("Broken GIC integration, security disabled");
+	ds = gic_dist_security_disabled();
+	if ((gic_data.flags & FLAGS_WORKAROUND_INSECURE) && !ds) {
+		if (cpus_have_group0) {
+			u32 val;
+
+			val = readl_relaxed(gic_data.dist_base + GICD_CTLR);
+			val |= GICD_CTLR_DS;
+			writel_relaxed(val, gic_data.dist_base + GICD_CTLR);
+
+			ds = gic_dist_security_disabled();
+			if (ds)
+				pr_warn("Broken GIC integration, security disabled\n");
+		} else {
+			pr_warn("Broken GIC integration, pNMI forbidden\n");
+			nmi_support_forbidden = true;
+		}
 	}
 
 	cpus_have_security_disabled = ds;
-	cpus_have_group0 = gic_has_group0();
 
 	/*
 	 * How priority values are used by the GIC depends on two things:
@@ -209,7 +218,7 @@ static void __init gic_prio_init(void)
 	 * be in the non-secure range, we program the non-secure values into
 	 * the distributor to match the PMR values we want.
 	 */
-	if (cpus_have_group0 & !cpus_have_security_disabled) {
+	if (cpus_have_group0 && !cpus_have_security_disabled) {
 		dist_prio_irq = __gicv3_prio_to_ns(dist_prio_irq);
 		dist_prio_nmi = __gicv3_prio_to_ns(dist_prio_nmi);
 	}
@@ -1922,6 +1931,18 @@ static bool gic_enable_quirk_arm64_29416
 	return true;
 }
 
+static bool gic_enable_quirk_rk3399(void *data)
+{
+	struct gic_chip_data *d = data;
+
+	if (of_machine_is_compatible("rockchip,rk3399")) {
+		d->flags |= FLAGS_WORKAROUND_INSECURE;
+		return true;
+	}
+
+	return false;
+}
+
 static bool rd_set_non_coherent(void *data)
 {
 	struct gic_chip_data *d = data;
@@ -1997,6 +2018,12 @@ static const struct gic_quirk gic_quirks
 		.init   = rd_set_non_coherent,
 	},
 	{
+		.desc	= "GICv3: Insecure RK3399 integration",
+		.iidr	= 0x0000043b,
+		.mask	= 0xff000fff,
+		.init	= gic_enable_quirk_rk3399,
+	},
+	{
 	}
 };
 
@@ -2004,7 +2031,7 @@ static void gic_enable_nmi_support(void)
 {
 	int i;
 
-	if (!gic_prio_masking_enabled())
+	if (!gic_prio_masking_enabled() || nmi_support_forbidden)
 		return;
 
 	rdist_nmi_refs = kcalloc(gic_data.ppi_nr + SGI_NR,



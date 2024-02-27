Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3E1419A6;
	Tue, 27 Feb 2024 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042085; cv=none; b=sqUB4iEajZLM592wQCzrIh50mR9dvK7zq6widcuSszzkU4YQ9CqTDAUJRER8Kh+c3SN+ywIR1vGusHcDZMGXEwglLTLb9UCt0mI4PcSp9DSumZXpwxMEIBBFYlABcH4UUlC3zy7mD37dVLPrreLT2vK9Y+MM1GSWg0LE8wrv3jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042085; c=relaxed/simple;
	bh=mmwJekYvedMH6NUdYVUGFOwYMDdRgwabtdt/JGD3GZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNagdfnoXXDIaklCW9H8iEDxLPfM6CvY0nIM4YDb5/Aydq2zsxGbDW/IaUjFSyoJJ1IjuFsDBa4dvTZVog7zJzFJoyNjPP/6cLvXa0PbpuO541n697XIKU29vUCDmJXolY9yz+WXprqyjuRad0sem8tMJZiBp5lN1mbV16ISwGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy/xUx4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy/xUx4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E676EC433F1;
	Tue, 27 Feb 2024 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042085;
	bh=mmwJekYvedMH6NUdYVUGFOwYMDdRgwabtdt/JGD3GZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sy/xUx4GbGRHVe+DwgQKOWVsKGfIIRb+N8+sqDxtPa05HLds8nKG3QoHMAU/1aWF8
	 fhbKcFJRMRK7h/D9cO5zWXzG1obIGailQQgb9NY/C6MNP417XBD/JraOE3On8Z/rZp
	 LXh7zKN/7QO6282VWRTEqG8g2z59fk1xxgx20I1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Cherian <gcherian@marvell.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 173/299] irqchip/gic-v3-its: Do not assume vPE tables are preallocated
Date: Tue, 27 Feb 2024 14:24:44 +0100
Message-ID: <20240227131631.408116624@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit ec4308ecfc887128a468f03fb66b767559c57c23 upstream.

The GIC/ITS code is designed to ensure to pick up any preallocated LPI
tables on the redistributors, as enabling LPIs is a one-way switch. There
is no such restriction for vLPIs, and for GICv4.1 it is expected to
allocate a new vPE table at boot.

This works as intended when initializing an ITS, however when setting up a
redistributor in cpu_init_lpis() the early return for preallocated RD
tables skips straight past the GICv4 setup. This all comes to a head when
trying to kexec() into a new kernel, as the new kernel silently fails to
set up GICv4, leading to a complete loss of SGIs and LPIs for KVM VMs.

Slap a band-aid on the problem by ensuring its_cpu_init_lpis() always
initializes GICv4 on the way out, even if the other RD tables were
preallocated.

Fixes: 6479450f72c1 ("irqchip/gic-v4: Fix occasional VLPI drop")
Reported-by: George Cherian <gcherian@marvell.com>
Co-developed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240219185809.286724-2-oliver.upton@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3181,6 +3181,7 @@ static void its_cpu_init_lpis(void)
 	val |= GICR_CTLR_ENABLE_LPIS;
 	writel_relaxed(val, rbase + GICR_CTLR);
 
+out:
 	if (gic_rdists->has_vlpis && !gic_rdists->has_rvpeid) {
 		void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
 
@@ -3216,7 +3217,6 @@ static void its_cpu_init_lpis(void)
 
 	/* Make sure the GIC has seen the above */
 	dsb(sy);
-out:
 	gic_data_rdist()->flags |= RD_LOCAL_LPI_ENABLED;
 	pr_info("GICv3: CPU%d: using %s LPI pending table @%pa\n",
 		smp_processor_id(),



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C65D78B61;
	Tue, 27 Feb 2024 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043514; cv=none; b=KO896msQvwfc2tp05f640R0P5IM/hIxjGkeIRGLXqM/Im10F53E5VAP4aSvGzQQvrHI+pwkj3KhkyurBtBzj7pdFNaZT8N/2Jb+2Okqq3aPHVXHKIjaWargiLUQ9PFRODwX90nlai46a4wzfyYsD46rIwIhDKOJ3kWlBvb0AjJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043514; c=relaxed/simple;
	bh=c48MLmMz8M0vFaIZoWI5ozEe+dMZx2CB2wYo7ZddTKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKzMckOOo0HZuaxB0eirNoiNbWgf0IGUHvJSKucFMIrodmsbJQp1bfX5XizPsFjllIHJjLmRJkvR36vLAeGdKTvgKrWGCdVtibTWt3rWBO0ZveT/L6vJBYTCs9fwmCC6WnoVjLp8uLUFNvhtIe9R316LlmyOjtABSrnmStH3OK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geGgQQ8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geGgQQ8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE977C433F1;
	Tue, 27 Feb 2024 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043514;
	bh=c48MLmMz8M0vFaIZoWI5ozEe+dMZx2CB2wYo7ZddTKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geGgQQ8McbvyfAcFe8NjiefHsqHyNX04e8BjNxGHJEMpg2801BFvC3WZlz7g+K4jF
	 d45rDTEyBxWB6eXUBvplPYAM6X3NW7NolgvFU8KMUpj0cgpMsTq7t8pmSrypTPKNYa
	 dd888lmJo1Ss6RPwO974hrYqTA2MAGiiQK4S7YMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Cherian <gcherian@marvell.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 107/195] irqchip/gic-v3-its: Do not assume vPE tables are preallocated
Date: Tue, 27 Feb 2024 14:26:08 +0100
Message-ID: <20240227131613.999700324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
@@ -3161,6 +3161,7 @@ static void its_cpu_init_lpis(void)
 	val |= GICR_CTLR_ENABLE_LPIS;
 	writel_relaxed(val, rbase + GICR_CTLR);
 
+out:
 	if (gic_rdists->has_vlpis && !gic_rdists->has_rvpeid) {
 		void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
 
@@ -3196,7 +3197,6 @@ static void its_cpu_init_lpis(void)
 
 	/* Make sure the GIC has seen the above */
 	dsb(sy);
-out:
 	gic_data_rdist()->flags |= RD_LOCAL_LPI_ENABLED;
 	pr_info("GICv3: CPU%d: using %s LPI pending table @%pa\n",
 		smp_processor_id(),



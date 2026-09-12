Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF973AFD15;
	Sat, 12 Sep 2026 09:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204834; cv=none; b=LbFUf0l5rdRDWQKWS33ehWMWDY9At966w5JHVdDib9jv/eLreGW+YNmUBbMMLlo07XqnSPnQPZFI1vvjm++5JW7Zf4kCoQfexu7CbcgrfRuOyjoWhrCyeWF6AWBi/2Eid7sNNIWRAFzrFT7ncPIWqLKJ83bSn68X66BcoYHnOmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204834; c=relaxed/simple;
	bh=gRgmVVDx1xG+7cZroVmKwB2kP+XHznAzqKUqVTy/R1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE3wZRG0LwY4alc1t0Hk/cVGsTI3BUgpQ1eeDVMrr1DXiPjFSQ/79TXtad0gY/EEyOSOHtElw0gMZunRNko3wXlAp7RiVKUrBJmcR1YkatL/mL55OoCd4wLlyZEoY8ZWTEktePirHtuzMlLFwq+D4Y6F2m4EeQJ1OqyEf4IXoVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmvU2MdV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmvU2MdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277D61F000FF;
	Sat, 12 Sep 2026 09:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204833;
	bh=hb7/BLOSHowT6XpuIGtX24N9mv4ePuy/XTUWvHlQ7/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmvU2MdVKFs8x8C0gSXkuwUx5DZl2OLaTcx8G8/JK/sRQq17apKZ2z1Sl4i2+aVg3
	 sIEtgandDwzM3MCX0DwZvfhMC8dVJFmO3A/sFNfm695jbChDWQ1dvwDCGVxMkzuKKh
	 NtnqJ/xhGCHYgyijJ/6bOnll00sjfhkqwYskqhDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1651/1815] irqchip/gic-v5: Use logical cpu 0 irs_data for dynamic IST allocation
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065727.754034533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 9dfcc2187282816d42b9f8aa2b689c732ebbcc01 ]

In set-ups with a 2-level IST, L1 table entries are created dynamically
when LPIs are allocated.

The L1 allocation and mapping, implemented in gicv5_irs_iste_alloc() is
carried out in preemtible context and can be carried out on any IRS in
the system.

Current code indexes the per_cpu_irs_data per cpu array using
smp_processor_id() to retrieve the IRS that is local to the core
executing gicv5_irs_iste_alloc().

Since that's preemptible context, the core executing that function can
change on preemption. Given that every IRS in the system is equivalent
to each core, this is not really an issue in that even if the thread
is preempted and resumed on a different cpu, the table allocation and
mapping to an IRS would work seamlessly regardless.

On the other hand, smp_processor_id() spits a legitimate splat on
DEBUG_PREEMPT kernels when used in preemtible context and this should
be fixed.

Given that all IRSes are equivalent from a core perspective in terms of
IST initialization, always choose as a policy the IRS local to logical
cpu 0, preventing the smp_processor_id() splat.

Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-6-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index 86da9f82a7b0c..b3feb6340b59e 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -199,7 +199,7 @@ int gicv5_irs_iste_alloc(const u32 lpi)
 	if (!gicv5_global_data.ist.l2)
 		return 0;
 
-	irs_data = per_cpu(per_cpu_irs_data, smp_processor_id());
+	irs_data = per_cpu(per_cpu_irs_data, 0);
 	if (!irs_data)
 		return -ENOENT;
 
-- 
2.53.0




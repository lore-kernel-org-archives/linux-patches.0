Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33644F4CF5;
	Tue, 13 Oct 2026 12:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894247; cv=none; b=JMiZpvVmQPp/S/VfxdJVI7+kPjpeHbFVpQ1M/1XKYxdwgjme3e4AJHJTdNRjZAzfb2sGr0b0qxN9C4h3KzHOJpZtf9NnYmb1h0O5AhZz6ojhetOm4l7K8Yi7KQ9+3UbAlrLS7TkhhXTGd1XYbVkyUQD05lTQX36TiHtp9NofjuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894247; c=relaxed/simple;
	bh=jIHYrxD8ce4Y85PUH6e6p8pbCxs5CIjt3L65vnbUzOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BAH2Gmds8JH2XCb0NTqBWL/l2d8Pq2zqf43o8ESqe5c2diPBRLr2DP4sYn/lSGdtIzVo3iDaSZM+QV5hncRwtKvzO/r0+Mie3AQxiEJo95GU6ex/84Z2SGj35x17aXAGhWaKxYVHLcdM0a3gp6u1mwI/1TAijvHezshzPNpV+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+ObcXEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+ObcXEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AE51F000FF;
	Tue, 13 Oct 2026 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894245;
	bh=BPgSc5nVQHJSU1Ukp2+Rfaiz6cmEQGALcIDo/4jl4XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+ObcXEi2YxFE1rZm9h/nyf5wovwW9gF/UXZd9LM5tTamff2pxR9dgsXFyxJGzlz1
	 8jL7xW7STzukQn/xWDMbrRfv5AaHzlbQgZGATdNHxOSZ3LSPxyTamR89YModF5opMu
	 IDGPQT4Z4sSinfMBhL/IB8Gp7VuG6grjAlgbTDJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/621] powerpc/xive: propagate IPI init errors to prevent use-after-free
Date: Tue, 13 Oct 2026 13:38:12 +0200
Message-ID: <20261013112932.622885758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit 411a3c016e7a95f5fa105a0587e07d0647a77727 ]

When xive_init_ipis() fails (e.g. irq_domain_alloc_irqs() fails),
the error path frees the global xive_ipis array.  However,
xive_smp_probe() previously ignored this failure and proceeded to
call xive_setup_cpu_ipi(), which dereferences the already-freed
xive_ipis pointer -- a use-after-free.

Now that xive_smp_probe() returns int (previous patch), propagate
the error from xive_init_ipis() and xive_setup_cpu_ipi() through
xive_smp_probe().  Check the return value in both pnv_smp_probe()
and pSeries_smp_probe() so that IPI setup is aborted cleanly on
failure, avoiding the use-after-free.

Fixes: 243e25112d06 ("powerpc/xive: Native exploitation of the XIVE interrupt controller")
Fixes: cbc06f051c52 ("powerpc/xive: Do not skip CPU-less nodes when creating the IPIs")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727104215.184786-4-gouhao@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/smp.c |  8 +++++---
 arch/powerpc/platforms/pseries/smp.c |  8 +++++---
 arch/powerpc/sysdev/xive/common.c    | 10 ++++++----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 8f41ef364fc6f..b1201dbafcaf6 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -332,10 +332,12 @@ static void pnv_cause_ipi(int cpu)
 
 static void __init pnv_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	if (cpu_has_feature(CPU_FTR_DBELL)) {
 		ic_cause_ipi = smp_ops->cause_ipi;
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index db99725e752bd..14cd0634eeca8 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -194,10 +194,12 @@ static int pseries_cause_nmi_ipi(int cpu)
 
 static __init void pSeries_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	/* No doorbell facility, must use the interrupt controller for IPIs */
 	if (!cpu_has_feature(CPU_FTR_DBELL))
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 92597aae4debc..b74cee368c044 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1276,15 +1276,17 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 
 int __init xive_smp_probe(void)
 {
+	int ret;
+
 	smp_ops->cause_ipi = xive_cause_ipi;
 
 	/* Register the IPI */
-	xive_init_ipis();
+	ret = xive_init_ipis();
+	if (ret < 0)
+		return ret;
 
 	/* Allocate and setup IPI for the boot CPU */
-	xive_setup_cpu_ipi(smp_processor_id());
-
-	return 0;
+	return xive_setup_cpu_ipi(smp_processor_id());
 }
 
 #endif /* CONFIG_SMP */
-- 
2.53.0




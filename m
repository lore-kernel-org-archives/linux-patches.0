Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9587A3C0601;
	Sat, 17 Oct 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260340; cv=none; b=HyBBtXN1x6ptFMhIElxyXwTo1fLgmQyM2bRbS7yPhmQMk852KOjzg39gWmiIaxlzj0uQ2FFjivgIEk+xpnKeIaCEY6Ry2v1pntuxYSC8ihIx+ml95Y/xS2iMbo73SykPPuIm1SpfrPUrnGA2HVVM1LsOIhvB7TGNIc0zuXHfNCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260340; c=relaxed/simple;
	bh=lFQJ1RC5v4dmzP80xJXIXrYlDqY5xIXA4IEDLf9Dj8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PI3XR/Sal5AaDIqMl8x4jm0QarVx4GgLsO14F/H1qQIlFHy+DcT3skT3RJpN20SgMCRycnM2bwtexFE7HuXNw26sOMHV7wDIcWeyofJjjgfF9ckOeUWGxyB97uEJ5ikws0QsCybdLRnPHb4zyqqgNNCZhqT8xioXojn/AhBW4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NccAdwdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NccAdwdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BD71F000C4;
	Sat, 17 Oct 2026 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260338;
	bh=ZvS8OrV6QiDZvM8DmZ8MFCiycSRMCvmRuRy/WrnFtT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NccAdwdzSfijcaGR+0HWvgrZoTWWmjdRywBhSS+RSuc0UsjJOQbPd1Ih+4GbZiQX3
	 oj7CATUtd5XSPFigCATHv1PAqD6hud31FLHC9un69Qn1bxDPR3CZwupieQYk1k2sIi
	 GQhH08X8Bjtgo2n7+1dYOXhezWq5eirKBjpsfw24=
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
Subject: [PATCH 6.6 1513/1674] powerpc/xive: propagate IPI init errors to prevent use-after-free
Date: Sat, 17 Oct 2026 18:03:05 +0200
Message-ID: <20261017160509.960199251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e1a25398f98c..4887f9176aa4b 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -329,10 +329,12 @@ static void pnv_cause_ipi(int cpu)
 
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
index c597711ef20a2..0d9b0b901807e 100644
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
index 5f6a05380e955..a5da09c1895f7 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1272,15 +1272,17 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 
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




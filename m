Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216834;
	b=f39NDwtZOx+BI1Tx3WkOC8QzNPlRoFQMjAd4t9z+cJ2yhq9LGTmkDBP+t/oVb4O1tp3t
	 GOQ6zBykz4XtqDAt2WowLx69O9DZLP00Q9h4YXolLdq94/1LzMWhotH5J/U+d/HVD7vsz
	 72LvxsqPsm+6GhfqUQtRN71NHq1D7R0jHOStKe0psoUJmugZUUHXoPnE8K6x5Lv8ZxwxB
	 sSP6Jd3W5fvfC7NU5xTj1mTINBL1m0eMT6U2gfT+WYEQ8oJGEjM2t3WBQ69uAyiCRELNU
	 6o6HzQ3+qU7GF2NwitUrfBYRjLe7F+URt5q0JLkPbr9EnyPEBTX8j9Ws8d6IQpdNvzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6D0cp0nHA4FOKOxL72mN5cQjdbwA4EGwr3NcDRkBnh8=;
	b=38UUwyjut24ZkxEj6Zzmo1+V4My0fBUTuZUjJCOPWkfBfDYxDi3p7poABSfABcyScdk/
	 mlYERgXlE1PmJPL7Mz/O+Z3gpGtT5XtpaBA4n+QhLoeSIWppDnRT2L5oiEWdrJhtCbfgK
	 ieCR63Mq8UHj83zT4Hm/eOWn/CiQHZiVtjGMWBQ5wyIUNae8vnCrnoQQGqFIDejwIH8DJ
	 waF9BqiweHedSKJwbk/V36BJxobhJMxfMfUsTPEhOAqHEs7/WCXDLQEipmbrMhoLHLqCQ
	 YwMHNX9Tv3e4qlJ+lb+ymWYB0X0XfkQfXHWcSY4dV3CCkbIDUD+3rFA7u7OEhhbTKWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyQoDLep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094F5606A31A;
	Wed, 28 Oct 2026 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyQoDLep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607741F01825;
	Wed, 28 Oct 2026 19:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216833;
	bh=6D0cp0nHA4FOKOxL72mN5cQjdbwA4EGwr3NcDRkBnh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyQoDLep83wVkenAa2n/mOZgxzC3enIA6c3ZWsTkSqZvDvRoX7qltSjHKhk4N2QdU
	 grbgNZ4/U/MvSfxHufliLy13FUkWBlP4CQTjx8HIVn6Rg44+uBSaajI4270wmErPGH
	 O9TNpARGLxtj84UvG1GOAb3QVKuu3VQYbC+BK1nY=
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
Subject: [PATCH 6.1 1651/1887] powerpc/xive: propagate IPI init errors to prevent use-after-free
Date: Wed, 28 Oct 2026 18:02:27 +0100
Message-ID: <20261028170537.033777690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd2174edfa1dc..52afd1427d1e8 100644
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




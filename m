Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0B6355F49;
	Sat, 17 Oct 2026 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253493; cv=none; b=gK816bZ75bkeaKB+gsE62iCG2fgiT8Tur4+gkAjDfNJf4Cc5xVJa30Mb5EpGu/JSgsRf44CgrWFwGFpqvQegYJatNx0CPMa04oCmP9RMB5pTI791gs+cliqAoy2qMfawXQ+eCtsGEc9wW14cbNmnP7t9Ib5Fa1Nxe+ErNUQmuSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253493; c=relaxed/simple;
	bh=GVB44WrJwqgbe/xQVi3/Q6rpd5HUBY51X/kjiibyDvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+Ie942cMTtzGB+2ZOc2dmv7bEE8XuuB8NI00cxZBexNFRooYU6XndLPAy6XFhAZl1AWfB6pAOYK7/WfdNjXD6WbBB7vzTdqILiDoop0Gr/+dTM4uSUwWym/AF0ceSjPLeIFHmSFO+nhi3JRjqcTcaGDE2QM+SgnVCz8kWLO/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbjeGIyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbjeGIyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D061F000C4;
	Sat, 17 Oct 2026 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253492;
	bh=LUC1CXgl0VTjXM5NRz8FU9EAZKy4HACNOwHI9gXPmrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbjeGIybZ16J+CU0w2qHCscNe3wgR8fSo4topb2NKZFNW/bNA0x7GETvI4a8DI4tU
	 sdfuAyrOlDwwzA6FYDu0yXXERrXCq/pOcs8FQICpqIYUv56MBfNxXRTuPiuRVdgjRe
	 T2nsp0b56O9w8dBN0jCeSUpdaf1HbmgvczN+cvbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/869] crypto: hisilicon/hpre - enable all clusters clock gating
Date: Sat, 17 Oct 2026 17:49:37 +0200
Message-ID: <20261017160040.530018276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit c62db61a416ff832481bccdfdee146f5272864b3 ]

Currently, the driver enables clock gating for only one cluster.
However, the new hardware has three clusters. Therefore, clock
gating needs to be enabled based on the number of clusters on the
current hardware.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 9228facb3081 ("crypto: hisilicon/qm - request reserved interrupt for virtual function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 40 +++++++++++++++--------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index a11fe5e276773..6eeaa00e07b25 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -593,6 +593,8 @@ static void hpre_close_sva_prefetch(struct hisi_qm *qm)
 
 static void hpre_enable_clock_gate(struct hisi_qm *qm)
 {
+	unsigned long offset;
+	u8 clusters_num, i;
 	u32 val;
 
 	if (qm->ver < QM_HW_V3)
@@ -606,17 +608,23 @@ static void hpre_enable_clock_gate(struct hisi_qm *qm)
 	val |= HPRE_PEH_CFG_AUTO_GATE_EN;
 	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
 
-	val = readl(qm->io_base + HPRE_CLUSTER_DYN_CTL);
-	val |= HPRE_CLUSTER_DYN_CTL_EN;
-	writel(val, qm->io_base + HPRE_CLUSTER_DYN_CTL);
-
-	val = readl_relaxed(qm->io_base + HPRE_CORE_SHB_CFG);
-	val |= HPRE_CORE_GATE_EN;
-	writel(val, qm->io_base + HPRE_CORE_SHB_CFG);
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
+	for (i = 0; i < clusters_num; i++) {
+		offset = (unsigned long)i * HPRE_CLSTR_ADDR_INTRVL;
+		val = readl(qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+		val |= HPRE_CLUSTER_DYN_CTL_EN;
+		writel(val, qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+
+		val = readl(qm->io_base + offset + HPRE_CORE_SHB_CFG);
+		val |= HPRE_CORE_GATE_EN;
+		writel(val, qm->io_base + offset + HPRE_CORE_SHB_CFG);
+	}
 }
 
 static void hpre_disable_clock_gate(struct hisi_qm *qm)
 {
+	unsigned long offset;
+	u8 clusters_num, i;
 	u32 val;
 
 	if (qm->ver < QM_HW_V3)
@@ -630,13 +638,17 @@ static void hpre_disable_clock_gate(struct hisi_qm *qm)
 	val &= ~HPRE_PEH_CFG_AUTO_GATE_EN;
 	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
 
-	val = readl(qm->io_base + HPRE_CLUSTER_DYN_CTL);
-	val &= ~HPRE_CLUSTER_DYN_CTL_EN;
-	writel(val, qm->io_base + HPRE_CLUSTER_DYN_CTL);
-
-	val = readl_relaxed(qm->io_base + HPRE_CORE_SHB_CFG);
-	val &= ~HPRE_CORE_GATE_EN;
-	writel(val, qm->io_base + HPRE_CORE_SHB_CFG);
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
+	for (i = 0; i < clusters_num; i++) {
+		offset = (unsigned long)i * HPRE_CLSTR_ADDR_INTRVL;
+		val = readl(qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+		val &= ~HPRE_CLUSTER_DYN_CTL_EN;
+		writel(val, qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+
+		val = readl(qm->io_base + offset + HPRE_CORE_SHB_CFG);
+		val &= ~HPRE_CORE_GATE_EN;
+		writel(val, qm->io_base + offset + HPRE_CORE_SHB_CFG);
+	}
 }
 
 static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
-- 
2.53.0




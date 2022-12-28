Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B851863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ADFC433EF;
	Wed, 28 Dec 2022 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239132;
	bh=XeAp9TEdnP6tQoBJs/3ny64rb6tsYa+aXZzc+UqTKrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dcQn4EEmMq4U2+T2z3vOyjmuH5KhQCpUKDjsh7Pbuz6W83mpriXIs4gf/5ch1eC7
	 YNtsDHJeoUMWz1D1GE+OHc0bO4IRaJ9pYdPH/EN1wHua2OviXWTsqWXw0WB3uMpx+L
	 L2gEB1Jtkl9jDyJLNTLQoqX6E+sQy4z/4zSS3h1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Thomson <git@johnthomson.fastmail.com.au>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/731] mips: ralink: mt7621: soc queries and tests as functions
Date: Wed, 28 Dec 2022 15:33:41 +0100
Message-Id: <20221228144259.854193032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit b4767d4c072583dec987225b6fe3f5524a735f42 ]

Move the SoC register value queries and tests to specific functions,
to remove repetition of logic
No functional changes intended

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/mt7621.c | 86 +++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index af66886f1366..6b4c291d6d1b 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -66,7 +66,57 @@ void __init ralink_of_remap(void)
 		panic("Failed to remap core resources");
 }
 
-static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
+static unsigned int __init mt7621_get_soc_name0(void)
+{
+	return __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME0);
+}
+
+static unsigned int __init mt7621_get_soc_name1(void)
+{
+	return __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME1);
+}
+
+static bool __init mt7621_soc_valid(void)
+{
+	if (mt7621_get_soc_name0() == MT7621_CHIP_NAME0 &&
+			mt7621_get_soc_name1() == MT7621_CHIP_NAME1)
+		return true;
+	else
+		return false;
+}
+
+static const char __init *mt7621_get_soc_id(void)
+{
+	if (mt7621_soc_valid())
+		return "MT7621";
+	else
+		return "invalid";
+}
+
+static unsigned int __init mt7621_get_soc_rev(void)
+{
+	return __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_REV);
+}
+
+static unsigned int __init mt7621_get_soc_ver(void)
+{
+	return (mt7621_get_soc_rev() >> CHIP_REV_VER_SHIFT) & CHIP_REV_VER_MASK;
+}
+
+static unsigned int __init mt7621_get_soc_eco(void)
+{
+	return (mt7621_get_soc_rev() & CHIP_REV_ECO_MASK);
+}
+
+static const char __init *mt7621_get_soc_revision(void)
+{
+	if (mt7621_get_soc_rev() == 1 && mt7621_get_soc_eco() == 1)
+		return "E2";
+	else
+		return "E1";
+}
+
+static void soc_dev_init(struct ralink_soc_info *soc_info)
 {
 	struct soc_device *soc_dev;
 	struct soc_device_attribute *soc_dev_attr;
@@ -77,12 +127,7 @@ static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
 
 	soc_dev_attr->soc_id = "mt7621";
 	soc_dev_attr->family = "Ralink";
-
-	if (((rev >> CHIP_REV_VER_SHIFT) & CHIP_REV_VER_MASK) == 1 &&
-	    (rev & CHIP_REV_ECO_MASK) == 1)
-		soc_dev_attr->revision = "E2";
-	else
-		soc_dev_attr->revision = "E1";
+	soc_dev_attr->revision = mt7621_get_soc_revision();
 
 	soc_dev_attr->data = soc_info;
 
@@ -95,11 +140,6 @@ static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
 
 void __init prom_soc_init(struct ralink_soc_info *soc_info)
 {
-	unsigned char *name = NULL;
-	u32 n0;
-	u32 n1;
-	u32 rev;
-
 	/* Early detection of CMP support */
 	mips_cm_probe();
 	mips_cpc_probe();
@@ -122,27 +162,23 @@ void __init prom_soc_init(struct ralink_soc_info *soc_info)
 		__sync();
 	}
 
-	n0 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME0);
-	n1 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME1);
-
-	if (n0 == MT7621_CHIP_NAME0 && n1 == MT7621_CHIP_NAME1) {
-		name = "MT7621";
+	if (mt7621_soc_valid())
 		soc_info->compatible = "mediatek,mt7621-soc";
-	} else {
-		panic("mt7621: unknown SoC, n0:%08x n1:%08x\n", n0, n1);
-	}
+	else
+		panic("mt7621: unknown SoC, n0:%08x n1:%08x\n",
+				mt7621_get_soc_name0(),
+				mt7621_get_soc_name1());
 	ralink_soc = MT762X_SOC_MT7621AT;
-	rev = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_REV);
 
 	snprintf(soc_info->sys_type, RAMIPS_SYS_TYPE_LEN,
 		"MediaTek %s ver:%u eco:%u",
-		name,
-		(rev >> CHIP_REV_VER_SHIFT) & CHIP_REV_VER_MASK,
-		(rev & CHIP_REV_ECO_MASK));
+		mt7621_get_soc_id(),
+		mt7621_get_soc_ver(),
+		mt7621_get_soc_eco());
 
 	soc_info->mem_detect = mt7621_memory_detect;
 
-	soc_dev_init(soc_info, rev);
+	soc_dev_init(soc_info);
 
 	if (!register_cps_smp_ops())
 		return;
-- 
2.35.1




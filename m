Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66918801A;
	Tue, 30 Jul 2024 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358651; cv=none; b=gzfpqFdoFNQozkkDf1fyUGwiiaA0gf7sCx3QyBhfo4sIGBEL/v5tO6+v3VoEpoANsiBmSn3zOyb5f8jJM2S0FWVZnkgD0RoSSg6aSgYWLxyBk6OJhmMgJWmU8JhFcm4dSHWjibBF6hQKPz0mzGOyZSKDrqY1f27notW2tmOC/Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358651; c=relaxed/simple;
	bh=hcE8Q87pnKE7knxxiCxAntOFPkd+S62rkW8Ay2jfuSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5wodbb26rxi8p+VaN7Dw6K34uc/129sHXPVTH05iagYKEbz1tv+3Acbp8w27Uj/H3+Ky/o4GHM/RGIGncdup8gbQjgWTM0oPUf+JDBEYF/NXH6WIHyHMZ56E+mkE4zar1hCy5USNfRxM7LmTxpqdom76dOv3XKTLvstMl38WUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI/BepNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI/BepNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF77C32782;
	Tue, 30 Jul 2024 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358651;
	bh=hcE8Q87pnKE7knxxiCxAntOFPkd+S62rkW8Ay2jfuSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XI/BepNCuGteBB09/cjrh2rSPSy6FQlJUnCDR2vW/tDSVYmi+Je6vHWUO+lJDgcpj
	 vvaz85LxeNphpjp3/WCEBA/XaEEtNLpUVW1xnkIqO0ORjU9IqiopRzu/tW9gnUMDp5
	 9LCZ2cZn74uSCwJyJkUAJpqQpHa5ZU/TxybupCUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 410/440] MIPS: SMP-CPS: Fix address for GCR_ACCESS register for CM3 and later
Date: Tue, 30 Jul 2024 17:50:43 +0200
Message-ID: <20240730151631.808281374@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit a263e5f309f32301e1f3ad113293f4e68a82a646 ]

When the CM block migrated from CM2.5 to CM3.0, the address offset for
the Global CSR Access Privilege register was modified. We saw this in
the "MIPS64 I6500 Multiprocessing System Programmer's Guide," it is
stated that "the Global CSR Access Privilege register is located at
offset 0x0120" in section 5.4. It is at least the same for I6400.

This fix allows to use the VP cores in SMP mode if the reset values
were modified by the bootloader.

Based on the work of Vladimir Kondratiev
<vladimir.kondratiev@mobileye.com> and the feedback from Jiaxun Yang
<jiaxun.yang@flygoat.com>.

Fixes: 197e89e0984a ("MIPS: mips-cm: Implement mips_cm_revision")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mips-cm.h | 4 ++++
 arch/mips/kernel/smp-cps.c      | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mips-cm.h b/arch/mips/include/asm/mips-cm.h
index 23c67c0871b17..696b40beb774f 100644
--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -228,6 +228,10 @@ GCR_ACCESSOR_RO(32, 0x0d0, gic_status)
 GCR_ACCESSOR_RO(32, 0x0f0, cpc_status)
 #define CM_GCR_CPC_STATUS_EX			BIT(0)
 
+/* GCR_ACCESS - Controls core/IOCU access to GCRs */
+GCR_ACCESSOR_RW(32, 0x120, access_cm3)
+#define CM_GCR_ACCESS_ACCESSEN			GENMASK(7, 0)
+
 /* GCR_L2_CONFIG - Indicates L2 cache configuration when Config5.L2C=1 */
 GCR_ACCESSOR_RW(32, 0x130, l2_config)
 #define CM_GCR_L2_CONFIG_BYPASS			BIT(20)
diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
index bcd6a944b8397..739997e6fd655 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -230,7 +230,10 @@ static void boot_core(unsigned int core, unsigned int vpe_id)
 	write_gcr_co_reset_ext_base(CM_GCR_Cx_RESET_EXT_BASE_UEB);
 
 	/* Ensure the core can access the GCRs */
-	set_gcr_access(1 << core);
+	if (mips_cm_revision() < CM_REV_CM3)
+		set_gcr_access(1 << core);
+	else
+		set_gcr_access_cm3(1 << core);
 
 	if (mips_cpc_present()) {
 		/* Reset the core */
-- 
2.43.0




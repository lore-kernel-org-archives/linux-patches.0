Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70DD19F460;
	Thu, 15 Aug 2024 13:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728758; cv=none; b=PSEIMvZDERkAEdX2DXNpsrLzgJLT4c8W2436MudTbmm8cX9T+HPYWUgGHBuOlUIpk0owdA0+B880sq7DLqWKU6mdgA9+v+jBaIGZHqAroUsnEu7l4Ggi0PjhMGG4wl8hGFoT0ZEDKWv3yRrZVTMtriDeYNR0pLdk4sV5rlPtijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728758; c=relaxed/simple;
	bh=jQv7VBnAZ4AkFd8Te7yARLH/YvmHBOFZT3okMAt3BA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agEhqw+DmeMk2IVqUvIEW0W7KaVvNLnsBUPP/uTNKJFQESkqGBEGbas64N1G2NXDPhBfDZR6/260MiHXAJECK9wZDOEtyOLAUiwW9iGE8WMw67WfoH9JXjLFVig8OMUcaAo0SZWOunm/dQ/mOQ29bMGEWDN6g3ci1TWApTJWCmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD8Dm2H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD8Dm2H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D20EC4AF0A;
	Thu, 15 Aug 2024 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728758;
	bh=jQv7VBnAZ4AkFd8Te7yARLH/YvmHBOFZT3okMAt3BA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iD8Dm2H8ES1W9liMoy+tQSWqe9ykyXj3z+sqS/cJIdNAFHJsigUcNgQfV+puKppm+
	 EEt4/l4wx2HzbsQ4SswpURh88p4jwhHdX2eZtCQr7C96bp2ezJqIa2q6vgGRrxkXoT
	 ll21j161oTFJAx1ECkcNG6VffRl+bIvQf/0ceM9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/196] MIPS: SMP-CPS: Fix address for GCR_ACCESS register for CM3 and later
Date: Thu, 15 Aug 2024 15:23:37 +0200
Message-ID: <20240815131855.910154325@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 890e51b159e06..11a3d5120e2b5 100644
--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -232,6 +232,10 @@ GCR_ACCESSOR_RO(32, 0x0d0, gic_status)
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
index 03f1026ad1484..1861b20e978d0 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -233,7 +233,10 @@ static void boot_core(unsigned int core, unsigned int vpe_id)
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




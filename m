Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1EF34F462;
	Wed, 20 May 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298313; cv=none; b=mo97onQeXwvg3BlEXgdWDqg99JGX1WT3KUsL12EptVKN4v0bjx0vQsaCLK28Z3TYQv+LFo/EFe3j8VxmXI8tdHG4lGIqrH81so/PdE7KpdS0ymWPqiwsD8QH9SHyfwcNm/4Ea/jKOFgfkZ/eEPooHOksLldpNYYzxMYiM2vSG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298313; c=relaxed/simple;
	bh=MrCxFlWzrSGBaTEOk68cFNkaXLXyVwJhG5MBiPCI2fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q15hHQD4b8hRcefi21zR3JYVdidTJBsZpmc9vwiq6RniUv2HiUBmUpFPml/oPC4lgymqgGoM0M4/OKhFS7LBHHVrIVqKc8sfAF7JKkwIXmbNYhoTv4R4MMweoh4BaQPJ+dVCwhESeu/dsueskCFAynT6Q/J1i5RsBPRDiy88mbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHf9QUbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHf9QUbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8F51F000E9;
	Wed, 20 May 2026 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298312;
	bh=HOtWqhPlDwmFrM1EglSu0EJ2933SkoBpSJbdSmpqCuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHf9QUbzvnCyrsJ9pvr+2tKy0Sq1siX0ds3xCrr8GUA7IxP1FRAkBDKPftjaTmI98
	 BQ2D6PpkLBhdYVx15/bSj6Wp5QC5cSwzxaKyQ07OXBNGztpQ9Y398MAyr9tHsTmgRS
	 28M5ejJtD52MjRLNaTv3wkkXpIz85DtV3pDSsfnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/957] memory: tegra30-emc: Fix dll_change check
Date: Wed, 20 May 2026 18:14:07 +0200
Message-ID: <20260520162142.423890306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 0a93f2355cf4922ad2399dbef5ea1049fef116d4 ]

The code checking whether the specified memory timing enables DLL
in the EMRS register was reversed. DLL is enabled if bit A0 is low.
Fix the check.

Fixes: e34212c75a68 ("memory: tegra: Introduce Tegra30 EMC driver")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Link: https://patch.msgid.link/20260126-fix-emc-dllchange-v1-2-47ad3bb63262@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra30-emc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/tegra/tegra30-emc.c b/drivers/memory/tegra/tegra30-emc.c
index 921dce1b8bc63..4981b7fa0f780 100644
--- a/drivers/memory/tegra/tegra30-emc.c
+++ b/drivers/memory/tegra/tegra30-emc.c
@@ -554,14 +554,14 @@ static int emc_prepare_timing_change(struct tegra_emc *emc, unsigned long rate)
 	emc->emc_cfg = readl_relaxed(emc->regs + EMC_CFG);
 	emc_dbg = readl_relaxed(emc->regs + EMC_DBG);
 
-	if (emc->dll_on == !!(timing->emc_mode_1 & 0x1))
+	if (emc->dll_on == !(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_NONE;
-	else if (timing->emc_mode_1 & 0x1)
+	else if (!(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_ON;
 	else
 		dll_change = DLL_CHANGE_OFF;
 
-	emc->dll_on = !!(timing->emc_mode_1 & 0x1);
+	emc->dll_on = !(timing->emc_mode_1 & 0x1);
 
 	if (timing->data[80] && !readl_relaxed(emc->regs + EMC_ZCAL_INTERVAL))
 		emc->zcal_long = true;
-- 
2.53.0




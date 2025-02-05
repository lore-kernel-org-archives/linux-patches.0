Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603D17BEC5;
	Wed,  5 Feb 2025 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766625; cv=none; b=cgER4Pai7Dc9pFMrHSwqY9U1Y/0ippbkpo2VpeDcBlUy17dH2NCZLnfpWZSql/gad4uYsonH+YxdqcabVQFDVt7C7WbcFNC2aV0jqlZdUQgqKRfhcK8YjjiA3+f/NgddqIe5s899vMxL70WscIix1S5N0P055eBTp6K98DcG/fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766625; c=relaxed/simple;
	bh=NfLB/sSwpbSkpsaWMs4IUwMcprpSyUo+C+2XIxl9iX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krCRfs9hO8PAtB3b+GDI613d08XGMvTeB5+QhxgCqofALxs13f/omv0bJFcXbNc+aEJCxZvTs3vuBLOiLRIOG16XxH7CwYsCtknqx8yo9kjXkRz7mU8i3SWsOEAcGoGs//UBSK63JV+E7Dn0ANC6gZdon7fQ98oNGJ/lgBhTcjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXzhdEbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXzhdEbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6C7C4CED1;
	Wed,  5 Feb 2025 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766625;
	bh=NfLB/sSwpbSkpsaWMs4IUwMcprpSyUo+C+2XIxl9iX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXzhdEbEAtmBNYFEE5rpD4iGLhbO1ENQqGtc9zeppmphAuNd30jD/o7FYniJF2bMk
	 xZAGuehbGFhb7JlaMk754ouTjTJY0B55aznPLhY8OlODGxFhpjFpVxnQKDYXLwoXf2
	 3XiT5orImAdFdDfBtY5/qRKFtm0qi270fjI1Q7GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 293/623] ASoC: Intel: avs: Do not readq() u32 registers
Date: Wed,  5 Feb 2025 14:40:35 +0100
Message-ID: <20250205134507.440630296@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bca0fa5f6b5e96c03daac1ed62b1e5c5057a2048 ]

Register reporting ROM status is 4-bytes wide.

Fixes: 092cf7b26a48 ("ASoC: Intel: avs: Code loading over HDA")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250109122216.3667847-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/loader.c b/sound/soc/intel/avs/loader.c
index 890efd2f1feab..37de077a99838 100644
--- a/sound/soc/intel/avs/loader.c
+++ b/sound/soc/intel/avs/loader.c
@@ -308,7 +308,7 @@ avs_hda_init_rom(struct avs_dev *adev, unsigned int dma_id, bool purge)
 	}
 
 	/* await ROM init */
-	ret = snd_hdac_adsp_readq_poll(adev, spec->sram->rom_status_offset, reg,
+	ret = snd_hdac_adsp_readl_poll(adev, spec->sram->rom_status_offset, reg,
 				       (reg & 0xF) == AVS_ROM_INIT_DONE ||
 				       (reg & 0xF) == APL_ROM_FW_ENTERED,
 				       AVS_ROM_INIT_POLLING_US, APL_ROM_INIT_TIMEOUT_US);
-- 
2.39.5




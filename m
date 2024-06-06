Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0704196C9F;
	Thu,  6 Jun 2024 14:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682973; cv=none; b=QiGkm+XkWbHB12QyElnD1fAwDOXam9MYX1FNvH1W+MM1OViR/FN9Z3sjMaojPgkf3BpC5alhteYg0dqIwOPKW8bHBeCVELGKm4Kqu67o1cA6s+i9oHEWWgR0XwgU6jONVbVdH/nvsfXPunBg40EUfbgJgwxU7Vivq4ViK/MDHxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682973; c=relaxed/simple;
	bh=VGYAHgpZEY3gYm4BP+KFAWwzbnJSlLmCyxj8DotQjJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7LJM4pzIim7e0AT8yRr7mDEm83BXit9s6VD1IYqJlLfJCGULE8HXJd9UoIPH3BymBKRvY7p2O4IO9LEGX9LDfxVagN24zvHyMEhY760+ZxvQic4BnmkQLaeG1PTteJTnwHgDjmCp1GuE5pvyWTd7S6rv2+NZduxRiYbQuoK/S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QC4qw7Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QC4qw7Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756DCC2BD10;
	Thu,  6 Jun 2024 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682973;
	bh=VGYAHgpZEY3gYm4BP+KFAWwzbnJSlLmCyxj8DotQjJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QC4qw7Zv9xUv2yqgeHwFPBKx9d9F8SDv//XBR1i9cE35Yxqcm7eNZAkCEr2tCA4uu
	 9X/nmumqBETNs2sBcKIGoIImDpTIuKkvlUJ/1DWT30lQKg1Dq8dflvl0GZlvQgdtDR
	 M4hxtMdIScKfb8+ZFDWXLpuI5Zrc/tBVlq40E3OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 149/374] mmc: sdhci_am654: Write ITAPDLY for DDR52 timing
Date: Thu,  6 Jun 2024 16:02:08 +0200
Message-ID: <20240606131656.916569433@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit d465234493bb6ad1b9c10a0c9ef9881b8d85081a ]

For DDR52 timing, DLL is enabled but tuning is not carried
out, therefore the ITAPDLY value in PHY CTRL 4 register is
not correct. Fix this by writing ITAPDLY after enabling DLL.

Fixes: a161c45f2979 ("mmc: sdhci_am654: Enable DLL only for some speed modes")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240320223837.959900-3-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index d8c9821b0b663..cfb614d0b42b4 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -300,6 +300,7 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (timing > MMC_TIMING_UHS_SDR25 && clock >= CLOCK_TOO_SLOW_HZ) {
 		sdhci_am654_setup_dll(host, clock);
 		sdhci_am654->dll_enable = true;
+		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing]);
 	} else {
 		sdhci_am654_setup_delay_chain(sdhci_am654, timing);
 		sdhci_am654->dll_enable = false;
-- 
2.43.0




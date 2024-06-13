Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1FC1877;
	Thu, 13 Jun 2024 12:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282410; cv=none; b=OyPc4AlWFC+vu0he6kBj0cvpPlmNgpW/WDPy1seQJpy2yf/8WcjHkpshrLQYBEzmroSFYF6k91y7z25V3aZLh1hVkpzx6BOvrGo6cJJAbry94UThitTkIsDgv94cRO1HqvjAiSrFOq1Prp6qw5dOFFYjlh0SFwh4/rbKm0YUOO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282410; c=relaxed/simple;
	bh=7H8NmuZq7eHl5WBdeEWk91vSu0MDz7+YNSuhziRiAZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZE269yap2AhYqSySXsUgu+xEYZJyxIinJMylgJh7akvkZuvT10PXUftZDG5DQXDoyOED807u6U5FtdPoIrCRH3BQbKDPUpmixcx56omQd7ZW1LoqTQlGxOB44jRG80tBdJJ+xlXzvcicxaW8s+GVc1ZJqiF5jzvcM3RcOmEsZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw/YZfs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw/YZfs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F91C2BBFC;
	Thu, 13 Jun 2024 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282410;
	bh=7H8NmuZq7eHl5WBdeEWk91vSu0MDz7+YNSuhziRiAZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw/YZfs6ZjlpEROK4WOy+PYW/QvLSCqZeb1MoRitn8K+irZ+Rard4dI1pDZKe/Ai4
	 qHKlTIklQdY4xb6qWCGk5f6Vny1YCo+ck+YE4nI3ZkExbbB45ZnAkt25B1FgRgvIpn
	 RBEmBvwOLTmd2gPRBpiB9UaxOFnxorpPQcaSrE7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/402] mmc: sdhci_am654: Write ITAPDLY for DDR52 timing
Date: Thu, 13 Jun 2024 13:33:27 +0200
Message-ID: <20240613113311.899044203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec77cf4d5dcdc..e68fce4413c8a 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -304,6 +304,7 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (timing > MMC_TIMING_UHS_SDR25 && clock >= CLOCK_TOO_SLOW_HZ) {
 		sdhci_am654_setup_dll(host, clock);
 		sdhci_am654->dll_enable = true;
+		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing]);
 	} else {
 		sdhci_am654_setup_delay_chain(sdhci_am654, timing);
 		sdhci_am654->dll_enable = false;
-- 
2.43.0




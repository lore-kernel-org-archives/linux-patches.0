Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FDA23A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBEDC433D6;
	Fri, 28 Oct 2022 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958799;
	bh=cK5nILkac9i7f+IDVLLL2ORlIOk1OBsI6IOA+4/1puI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW+CPlkz9yLdJgFS9RSthCmudgF4oINErh0DIkvEgaANTaEQlp1nzfOAxURg301cL
	 F0Dmf+DYaKHT73KIHC1USAPaj4CZipl7je3H+gLWGXa3HQxEXS755l2erX3y8/ga8/
	 AHiSxEeYZ0YctQDTe4GZQdNUaew6BtRHWsy28RPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniruddha TVS Rao <anrao@nvidia.com>,
	Prathamesh Shete <pshete@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Thierry Reding <treding@nvidia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/73] mmc: sdhci-tegra: Use actual clock rate for SW tuning correction
Date: Fri, 28 Oct 2022 14:03:53 +0200
Message-Id: <20221028120234.816876368@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit b78870e7f41534cc719c295d1f8809aca93aeeab ]

Ensure tegra_host member "curr_clk_rate" holds the actual clock rate
instead of requested clock rate for proper use during tuning correction
algorithm. Actual clk rate may not be the same as the requested clk
frequency depending on the parent clock source set. Tuning correction
algorithm depends on certain parameters which are sensitive to current
clk rate. If the host clk is selected instead of the actual clock rate,
tuning correction algorithm may end up applying invalid correction,
which could result in errors

Fixes: ea8fc5953e8b ("mmc: tegra: update hw tuning process")
Signed-off-by: Aniruddha TVS Rao <anrao@nvidia.com>
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221006130622.22900-4-pshete@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index d50b691f6c44..67211fc42d24 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -760,7 +760,7 @@ static void tegra_sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	 */
 	host_clk = tegra_host->ddr_signaling ? clock * 2 : clock;
 	clk_set_rate(pltfm_host->clk, host_clk);
-	tegra_host->curr_clk_rate = host_clk;
+	tegra_host->curr_clk_rate = clk_get_rate(pltfm_host->clk);
 	if (tegra_host->ddr_signaling)
 		host->max_clk = host_clk;
 	else
-- 
2.35.1




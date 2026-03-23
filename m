Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E5C3B6BEE;
	Mon, 23 Mar 2026 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279726; cv=none; b=VJkfcXJmH8SJGia4krI+iqU3hH9cHtmf3v9GRsDDL5A4KeAhymwDneYBYTROIfvy+6T0sBAtQ/U9v/aP8fD7JJl7++xeEA6i2mF4idbVGymSjsB9ZZwNvkkOTZgfXqhjZS4H9bHyescpKGkYosSMlyEjYRthMgAo6b1GNiuy9vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279726; c=relaxed/simple;
	bh=ttJ0dsMFz6795NWBRWFWzErIByBxwBx586eTgHmlbSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ie7zwGBWWzfqSjhrrJNxfCwG4LE6rdERLfD+f2fUeHjq9d1Lbbt4UY6x5iYmLo1I1nTy35A8BU+q7OMY0FE/X9ZlfMaoT0JQYHWgrJEuw2ARsIPz6XzmHstyeqDyOSa/qW6Gb3tfHrlHiGZUEBOj0fa3WYjjRytCpEmYIL6UYUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjGr7jYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjGr7jYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF7C4CEF7;
	Mon, 23 Mar 2026 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279726;
	bh=ttJ0dsMFz6795NWBRWFWzErIByBxwBx586eTgHmlbSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjGr7jYnecbBVRe71CFih1m/vBvbmkm+BOaeZeh68CQsBLHLIhSc7b89G4S/QQnd9
	 pypytFYVMcDaQoeLM9chNZKltaep1UsPAWhbCDPrME8xGwdWnHVkN0lo6pIsoTRBuh
	 BXbK0pwgZEAEBOfGJnEkj6RmvjMKGtvpRqK0XlIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/481] clk: tegra: tegra124-emc: fix device leak on set_rate()
Date: Mon, 23 Mar 2026 14:40:41 +0100
Message-ID: <20260323134526.662068118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit da61439c63d34ae6503d080a847f144d587e3a48 ]

Make sure to drop the reference taken when looking up the EMC device and
its driver data on first set_rate().

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Fixes: 6d6ef58c2470 ("clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver")
Cc: stable@vger.kernel.org	# 4.2: 6d6ef58c2470
Cc: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index 0f6fb776b2298..5f1af6dfe7154 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -197,8 +197,8 @@ static struct tegra_emc *emc_ensure_emc_driver(struct tegra_clk_emc *tegra)
 	tegra->emc_node = NULL;
 
 	tegra->emc = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!tegra->emc) {
-		put_device(&pdev->dev);
 		pr_err("%s: cannot find EMC driver\n", __func__);
 		return NULL;
 	}
-- 
2.51.0




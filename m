Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B474B2D8364;
	Mon, 13 Apr 2026 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098593; cv=none; b=VEwCckjf4lcpxqHmID+axVR0Rguv2mFIqQMxTFV1wAqBlEL2ztMpw53vnoaSjZ9k8pkpbNjwYo1lPmsQyldbOv3BcFKHgwVpA304OQYzOHOtI5CK60ytZKZ5hzvFwn46rO3BMJ2o89b8tAx/uXilPEjAZGVrOcxYjphznIA/g3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098593; c=relaxed/simple;
	bh=wrvixG80c2XE6LihNr2ix1nnO79FtIHrMpR3LPdJHa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl0ZzlGfd6O855ZrS2E3OBYL4VabI3XkUO+IctM8flKsI7QA+YN2fQTkFvXzjn6nGfMX05x4wHZjRRBX0xlAoz3zTvBBDzoAUjOr/m5q8J8vrUpXZ302eZ2tTe6KKooX2WatM4Fmww2u7RAM7cQWg0itkRjoakKegsuoVG5ldRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+Wvkt2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+Wvkt2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A450C2BCAF;
	Mon, 13 Apr 2026 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098593;
	bh=wrvixG80c2XE6LihNr2ix1nnO79FtIHrMpR3LPdJHa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+Wvkt2D5ZRILhbkWAtT10pIB2LO5dSoW+XHflZsJCW7Tia/rt/yjR87ZCPia83hN
	 TNGmXo9DLRViFFSlpHhLQq5VEcN7/yPQJrXaUcWc6bEym+ukgEr10xdjeHeUWH9RBk
	 qzG1F1Uyv8dI0Q/3t0Yc4tU2toQUfOqaW0poZ5Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/491] clk: tegra: tegra124-emc: fix device leak on set_rate()
Date: Mon, 13 Apr 2026 17:54:19 +0200
Message-ID: <20260413155819.587084788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 670bb6b0765f3..4e2fc9ba2b211 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -190,8 +190,8 @@ static struct tegra_emc *emc_ensure_emc_driver(struct tegra_clk_emc *tegra)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671A74F3EA4;
	Thu, 17 Sep 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667707; cv=none; b=cfhIzCIbIlnPgRKUTW9HvE9V4GolEV0vO9fh9o+bImxZh1CPsFNkoRWv39rbd9t/8tOnNnLVT1iqT3kxIdxTwl1NyTidEJwVjlT1m0JTHuHhDKzauPIktrQ0Ny5hAn/ews1lP4YRHOMka4+JqaURik4BpEQMaXzW0yJlzSb2dbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667707; c=relaxed/simple;
	bh=1lHrcqPgiMDgUzi+v/hWDHAK3nBex5LlknRvldDmNkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew5U9K3oxilfF7ZklhHJGfn/m+8BPUTRvYc+tY+acwCqwswUbdTzhrbVYbLevq0+G3f2K7IB+JMcEhIW/Va4M4FE0Qc9N5PujK6ksiILExuuVcA+XdP7q9ZjQBSwOteVzqdkOhaUf4sTV2P8XjLsFLss0S/smtYetO/KjNrVizE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPIRk3Tk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPIRk3Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613391F000FF;
	Thu, 17 Sep 2026 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667705;
	bh=oyFjyKk3SAZ0QewR6p8y21UcoHJB2kR79KyRYUKcrCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPIRk3TkzkrK3QgWFVNXkWkNBHtVF581ADd//3hy1YfSYrHh0TwYIzKct2STM7ANd
	 GVVt22VdhRPlngdvvoE0xGOIsLuQC27LuyEUZZ2IWWQodLc7cA1e+UrwnlTpXK9/Md
	 CXN6QN7k2qJCZat3QC5CVu5RIvhB/+IdXYcoyJHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0183/1102] soc/tegra: fuse: Register nvmem lookups at probe
Date: Thu, 17 Sep 2026 16:02:06 +0100
Message-ID: <20260917151544.157646517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

[ Upstream commit 8a3571618c2e3f339b5b6fee5841143face58a2b ]

Register nvmem lookups in tegra_fuse_probe(), after the nvmem device has
been registered, since they can only be used after the nvmem device is
registered.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra.c b/drivers/soc/tegra/fuse/fuse-tegra.c
index 74d2fedea71ca..972a63993e1db 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -182,10 +182,6 @@ static int tegra_fuse_probe(struct platform_device *pdev)
 		}
 
 		fuse->soc->init(fuse);
-
-		err = tegra_fuse_add_lookups(fuse);
-		if (err)
-			return dev_err_probe(&pdev->dev, err, "failed to add FUSE lookups\n");
 	}
 
 	fuse->clk = devm_clk_get_optional(&pdev->dev, "fuse");
@@ -231,6 +227,10 @@ static int tegra_fuse_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	err = tegra_fuse_add_lookups(fuse);
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "failed to add FUSE lookups\n");
+
 	fuse->rst = devm_reset_control_get_optional(&pdev->dev, "fuse");
 	if (IS_ERR(fuse->rst))
 		return dev_err_probe(&pdev->dev, PTR_ERR(fuse->rst), "failed to get FUSE reset\n");
@@ -473,7 +473,7 @@ static int __init tegra_init_fuse(void)
 	const struct of_device_id *match;
 	struct device_node *np;
 	struct resource regs;
-	int err;
+	int err = 0;
 
 	tegra_init_apbmisc();
 
@@ -566,10 +566,6 @@ static int __init tegra_init_fuse(void)
 
 	tegra_fuse_print_sku_info(&tegra_sku_info);
 
-	err = tegra_fuse_add_lookups(fuse);
-	if (err)
-		pr_err("failed to add FUSE lookups\n");
-
 	return err;
 }
 early_initcall(tegra_init_fuse);
-- 
2.53.0




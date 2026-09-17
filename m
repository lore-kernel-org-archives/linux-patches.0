Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DAC4E7808;
	Thu, 17 Sep 2026 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664215; cv=none; b=uoWxWawRBJb4TFrZcsUi3b9HxSpqMVOmMg414tKhzAr5EFyVbONaSQ1SG5H1cYCAjNillkAfDH8uwvyzZqq/XFgGo4ApY+bJkPvLj+4HMcHhcsZrmT1avXKmorCeGSpye0cl0YfWqHihIeJOKiSk1vcLeDBUiH0wuUo6ZmplZ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664215; c=relaxed/simple;
	bh=Qa+sxh3uQ727l+CmOFEofUVFmrIBY2EhH2lx3ZHagbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTAC93xLSEzQjn+e+QEtarclhFN2GA2703K6NYIVrnKf4bhVR5aYAvXdpE+I9HTZEb3mIyXDElG++jP+ylbRM0ZPUn+QiAXQJJj28j4hicwkqsuTYg1RriNNCbCOr0GtwcChJrLaHZXqBBYj6UP28vM++xS1sNkqGYOM+Ou9ABM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pu1AuJ+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pu1AuJ+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996B31F00899;
	Thu, 17 Sep 2026 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664214;
	bh=39lq2Hj0xoYroqvSt9SIbX850PzLEnJa44GmQaFFF9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pu1AuJ+CT9LGDq+2QZ7IKsvEluW3HhOOeB6r3MVC01JaC7tVOAHIdZTPoU0bMgn7z
	 hloJtuDtfuFNjphyCjoT7dMUPOFk/Yy3A+wDBG3cAH/Wf3pfw2yVMm8AMWfoWtOtGd
	 rQWu5g1F/rPLFnvpQAY23DubjFhAyrLXQt2UGqwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0259/1250] soc/tegra: fuse: Register nvmem lookups at probe
Date: Thu, 17 Sep 2026 16:00:54 +0100
Message-ID: <20260917151559.174671270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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




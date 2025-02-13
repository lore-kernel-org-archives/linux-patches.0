Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D23626B088;
	Thu, 13 Feb 2025 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459193; cv=none; b=M/yTl37iTdaPTd5ynz2gARhiUEENGIV/gYEdqfpsq419mjWkSKYcPzynx1g7AmWnPfqkGe5YTp7YWbNPG5HuftD58erCywIvTMop+foqTJQXmbuyNgDjQzMVEbx16l1zPKFl3+SDi29I0rCevKWk9vm+9IxwtKDC+Yytzgly0FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459193; c=relaxed/simple;
	bh=QAdcnTb54v7URbLqQUNE3c+Bkf3HjXs88ryNvcaFD9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIe+Mf9wrn/xSUgN5iSeFB3wdhr+0KVkZCXWL3G61U2ansk3lArqcfOGDLWKgiRlLOro4u+u8FULCBE1LiMlTKiZWNoC+GVfspETs/a4Yx2koUYX6BWQ4RSGvl9HI+cuEmxUinHc0bnEBhNTDajVxZe8S0v43n2aNzBOdYM5Gvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfBHE4Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfBHE4Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1115C4CED1;
	Thu, 13 Feb 2025 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459193;
	bh=QAdcnTb54v7URbLqQUNE3c+Bkf3HjXs88ryNvcaFD9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfBHE4Yyzo1qAZKVsyy7jkZVCXx5d4NtSEpclvvIurbKKRltBvMpE0CY29sMp0wV1
	 C+eLYNWHmg+y0T55L8J/b+JGm+xyzVk3NyChP3y5+9Xt4jBgqj+/Na3DL6b5P02bc1
	 UjQP9I1P/ZQZRs/11kBWHPfX1aUdZKJkWP9pQGMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.13 194/443] clk: mmp2: call pm_genpd_init() only after genpd.name is set
Date: Thu, 13 Feb 2025 15:25:59 +0100
Message-ID: <20250213142448.097513819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Lubomir Rintel <lkundrak@v3.sk>

commit e24b15d4704dcb73920c3d18a6157abd18df08c1 upstream.

Setting the genpd's struct device's name with dev_set_name() is
happening within pm_genpd_init(). If it remains NULL, things can blow up
later, such as when crafting the devfs hierarchy for the power domain:

  Unable to handle kernel NULL pointer dereference at virtual address 00000000 when read
  ...
  Call trace:
   strlen from start_creating+0x90/0x138
   start_creating from debugfs_create_dir+0x20/0x178
   debugfs_create_dir from genpd_debug_add.part.0+0x4c/0x144
   genpd_debug_add.part.0 from genpd_debug_init+0x74/0x90
   genpd_debug_init from do_one_initcall+0x5c/0x244
   do_one_initcall from kernel_init_freeable+0x19c/0x1f4
   kernel_init_freeable from kernel_init+0x1c/0x12c
   kernel_init from ret_from_fork+0x14/0x28

Bisecting tracks this crash back to commit 899f44531fe6 ("pmdomain: core:
Add GENPD_FLAG_DEV_NAME_FW flag"), which exchanges use of genpd->name
with dev_name(&genpd->dev) in genpd_debug_add.part().

Fixes: 899f44531fe6 ("pmdomain: core: Add GENPD_FLAG_DEV_NAME_FW flag")
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: stable@vger.kernel.org # v6.12+
Link: https://lore.kernel.org/r/20241231190336.423172-1-lkundrak@v3.sk
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mmp/pwr-island.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/mmp/pwr-island.c
+++ b/drivers/clk/mmp/pwr-island.c
@@ -106,10 +106,10 @@ struct generic_pm_domain *mmp_pm_domain_
 	pm_domain->flags = flags;
 	pm_domain->lock = lock;
 
-	pm_genpd_init(&pm_domain->genpd, NULL, true);
 	pm_domain->genpd.name = name;
 	pm_domain->genpd.power_on = mmp_pm_domain_power_on;
 	pm_domain->genpd.power_off = mmp_pm_domain_power_off;
+	pm_genpd_init(&pm_domain->genpd, NULL, true);
 
 	return &pm_domain->genpd;
 }



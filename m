Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C9B23A98E;
	Thu, 13 Feb 2025 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457651; cv=none; b=B+OKHrwyS27il5b0HagzDEkLvWl93QWjcRTkb9vy+uAhaEWM38G8MDHudTBW6QhSK9In4nzpd0ot6fdn0BVwm4aCPVMgoqfcVLAtm2G/k/VZa1r5up+mlalVC4Qe/uoCBfg8wW9wjfJ3qo+GsNvWEzk7Z/cgq9W3mEugAjtHXww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457651; c=relaxed/simple;
	bh=Myya8tjifBR1c5SlsS5WCa/yJ4qLFToMwkQRgVobtTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfLy2TdTGuY3kec+gY796GlfGhHnj5Pk0YnKELDuI9Y0iHsNtyaKtfZ5H/AfRlI450nNypyeV0nLYLOWsbEjlk4Dgx5ghjLrgPUaYgmGFIKAsh8fme3eu9h66wmFL5wIk4Ec0ZzYHKUNhhkT68O3gIaEer3eWPMWStHwM/oEMqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiaHEy1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiaHEy1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A28C4CED1;
	Thu, 13 Feb 2025 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457651;
	bh=Myya8tjifBR1c5SlsS5WCa/yJ4qLFToMwkQRgVobtTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiaHEy1oFWSfKf3AiaGJUjuLhlTxIqz7DVgJ04jcNQA+l7napMLIDrfWsg50pX/Kh
	 mCO1caDV+wkR9Zba3NQJZ8wv+yrGdiEqi6C79cHYYLSin14T6dWbwEnBr7MEOKcp5/
	 CI+y1HhisocEMGNNGvaalTw0ErmMIRQ2aPXZ8vz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 174/422] clk: mmp2: call pm_genpd_init() only after genpd.name is set
Date: Thu, 13 Feb 2025 15:25:23 +0100
Message-ID: <20250213142443.258740577@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/mmp/pwr-island.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mmp/pwr-island.c b/drivers/clk/mmp/pwr-island.c
index edaa2433a472..eaf5d2c5e593 100644
--- a/drivers/clk/mmp/pwr-island.c
+++ b/drivers/clk/mmp/pwr-island.c
@@ -106,10 +106,10 @@ struct generic_pm_domain *mmp_pm_domain_register(const char *name,
 	pm_domain->flags = flags;
 	pm_domain->lock = lock;
 
-	pm_genpd_init(&pm_domain->genpd, NULL, true);
 	pm_domain->genpd.name = name;
 	pm_domain->genpd.power_on = mmp_pm_domain_power_on;
 	pm_domain->genpd.power_off = mmp_pm_domain_power_off;
+	pm_genpd_init(&pm_domain->genpd, NULL, true);
 
 	return &pm_domain->genpd;
 }
-- 
2.48.1




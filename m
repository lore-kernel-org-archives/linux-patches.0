Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECF61487F4;
	Mon,  6 Jan 2025 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176870; cv=none; b=F+Ziuidl+hmDnvLOWeTTbqZfI2tZDXMkrb/dKOTAeIX4Z/s45ARr6/kBXKxJnX6OBTBLnMcjVk8ElfqbI5s9j0sO5jWzuhz7Xt094EYV6QxGfPpYD9TVekyn15VXiFF6GoR9tGN2qIJkHM/5gMOHr69F9Y2gwbV9VOAKYhwG/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176870; c=relaxed/simple;
	bh=EY39v9bDx1+4qNStfO7XeaQxWnfVOWqrQfTW7v7Xltw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWEeIL9w7kFsvrAw6RoG3ltKuJhjKa4YQN9tbRR5N1b50hX30wQRoSXn/MV56uF+MMuVr1NSlgT+OILo3YZ8p7YzkDPGhkgO7QmC6JD7GPNU/oTcGMUDoCQnTN6/zBY5naxRwyz274+DFdR+PD2YmBciJfrugxVvh+r0Vi4trVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zb8DoPHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zb8DoPHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CE4C4CED2;
	Mon,  6 Jan 2025 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176870;
	bh=EY39v9bDx1+4qNStfO7XeaQxWnfVOWqrQfTW7v7Xltw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zb8DoPHRoXNRFFLvQM/7TW4XyOJKcNt58MEAfi/DV+lpxBE8+hIaYvADR4r4tnLal
	 FG4Tx3ALa2c4zSsDADgIZdRgceVISI4Xak2ghv7MYHSmepg1i+AE5vrQ5nhtrdWrcV
	 ArLoCydxb/sSVDSLXKWme9uz0ihLIKgxt9roni8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/81] net: stmmac: platform: provide devm_stmmac_probe_config_dt()
Date: Mon,  6 Jan 2025 16:15:58 +0100
Message-ID: <20250106151130.426193634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit d74065427374da6659a2d7fad4ec55c8926d43c4 ]

Provide a devres variant of stmmac_probe_config_dt() that allows users to
skip calling stmmac_remove_config_dt() at driver detach.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230623100417.93592-9-brgl@bgdev.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2b6ffcd7873b ("net: stmmac: restructure the error path of stmmac_probe_config_dt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 41 +++++++++++++++++++
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  2 +
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 0046a4ee6e64..5b4517b0ca08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -8,6 +8,7 @@
   Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
@@ -628,6 +629,39 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	return ret;
 }
 
+static void devm_stmmac_remove_config_dt(void *data)
+{
+	struct plat_stmmacenet_data *plat = data;
+
+	/* Platform data argument is unused */
+	stmmac_remove_config_dt(NULL, plat);
+}
+
+/**
+ * devm_stmmac_probe_config_dt
+ * @pdev: platform_device structure
+ * @mac: MAC address to use
+ * Description: Devres variant of stmmac_probe_config_dt(). Does not require
+ * the user to call stmmac_remove_config_dt() at driver detach.
+ */
+struct plat_stmmacenet_data *
+devm_stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
+{
+	struct plat_stmmacenet_data *plat;
+	int ret;
+
+	plat = stmmac_probe_config_dt(pdev, mac);
+	if (IS_ERR(plat))
+		return plat;
+
+	ret = devm_add_action_or_reset(&pdev->dev,
+				       devm_stmmac_remove_config_dt, plat);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return plat;
+}
+
 /**
  * stmmac_remove_config_dt - undo the effects of stmmac_probe_config_dt()
  * @pdev: platform_device structure
@@ -650,12 +684,19 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	return ERR_PTR(-EINVAL);
 }
 
+struct plat_stmmacenet_data *
+devm_stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
 }
 #endif /* CONFIG_OF */
 EXPORT_SYMBOL_GPL(stmmac_probe_config_dt);
+EXPORT_SYMBOL_GPL(devm_stmmac_probe_config_dt);
 EXPORT_SYMBOL_GPL(stmmac_remove_config_dt);
 
 int stmmac_get_platform_resources(struct platform_device *pdev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
index 3fff3f59d73d..2102c6d41464 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
@@ -13,6 +13,8 @@
 
 struct plat_stmmacenet_data *
 stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac);
+struct plat_stmmacenet_data *
+devm_stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac);
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat);
 
-- 
2.39.5




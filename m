Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDA202C38;
	Tue, 17 Jun 2025 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175354; cv=none; b=n+GBcsqXMUwwBIoNYm4yOxH/VAfrzjDna86qFjUCjCUVFvhly7pu9asaX2fuWo7cUdhqkW1skcLumhrZVIajTyafs9z7XqxaFPn/GMX0lPoscw4sK8dZDdU3+OfUSzv5/osS7N3n3o8BH4CBxaspsA0HbkbHj/YEdf+uSm2RhS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175354; c=relaxed/simple;
	bh=BPTJQ0cUAYyAeVaYE88mfrz/Ee3gkoxe7Waqs97MTXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skwTk+PabEpIp04HdUnx7mYbm+igU9lNjp08rQmd+CF/at4RhyWmWXAwAN1yRmjQw0zyGNj6iqVksz6tLs5LOD9m/neccGrTxe4m70aoYn7DriJuPFXH1jHMlniRKnDwbmcoTBsm0cHSuelB6OqUpBEuPoj6Ab8C82M20jb2UJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F98phgJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F98phgJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C91C4CEE3;
	Tue, 17 Jun 2025 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175354;
	bh=BPTJQ0cUAYyAeVaYE88mfrz/Ee3gkoxe7Waqs97MTXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F98phgJMu/LxZpeuYjEmZFcihtYrqSaKUd6oaIOZdXmAyGbqTvyYV3RPj02OX2RlU
	 162AnGrThVrI5eeqxdDB/aM6JCbZ/twf6E4mVZx7Wo99La9CDh+yfTqZJzhoQORMBe
	 AUBCkKEyZoMh/vBt/5BrxoDvQVFt/4YEp5PiXThQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 080/780] thermal/drivers/mediatek/lvts: Fix debugfs unregister on failure
Date: Tue, 17 Jun 2025 17:16:28 +0200
Message-ID: <20250617152454.773718166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b49825661af93d9b8d7236f914803f136896f8fd ]

When running the probe function for this driver, the function
lvts_debugfs_init() gets called in lvts_domain_init() which, in
turn, gets called in lvts_probe() before registering threaded
interrupt handlers.

Even though it's unlikely, the last call may fail and, if it does,
there's nothing removing the already created debugfs folder and
files.

In order to fix that, instead of calling the lvts debugfs cleanup
function upon failure, register a devm action that will take care
of calling that upon failure or driver removal.

Since devm was used, also delete the call to lvts_debugfs_exit()
in the lvts_remove() callback, as now that's done automatically.

Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20250402083852.20624-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 088481d91e6e2..c0be4ca55c7b8 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -213,6 +213,13 @@ static const struct debugfs_reg32 lvts_regs[] = {
 	LVTS_DEBUG_FS_REGS(LVTS_CLKEN),
 };
 
+static void lvts_debugfs_exit(void *data)
+{
+	struct lvts_domain *lvts_td = data;
+
+	debugfs_remove_recursive(lvts_td->dom_dentry);
+}
+
 static int lvts_debugfs_init(struct device *dev, struct lvts_domain *lvts_td)
 {
 	struct debugfs_regset32 *regset;
@@ -245,12 +252,7 @@ static int lvts_debugfs_init(struct device *dev, struct lvts_domain *lvts_td)
 		debugfs_create_regset32("registers", 0400, dentry, regset);
 	}
 
-	return 0;
-}
-
-static void lvts_debugfs_exit(struct lvts_domain *lvts_td)
-{
-	debugfs_remove_recursive(lvts_td->dom_dentry);
+	return devm_add_action_or_reset(dev, lvts_debugfs_exit, lvts_td);
 }
 
 #else
@@ -1374,8 +1376,6 @@ static void lvts_remove(struct platform_device *pdev)
 
 	for (i = 0; i < lvts_td->num_lvts_ctrl; i++)
 		lvts_ctrl_set_enable(&lvts_td->lvts_ctrl[i], false);
-
-	lvts_debugfs_exit(lvts_td);
 }
 
 static const struct lvts_ctrl_data mt7988_lvts_ap_data_ctrl[] = {
-- 
2.39.5




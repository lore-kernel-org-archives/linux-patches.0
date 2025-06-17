Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7017420F090;
	Tue, 17 Jun 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174724; cv=none; b=FK1D04NFU+HEBHTGNW8rOT59WnP9siMi1gluDHNEqB5TuzXYTk4i7l2XmnzLDYR1La/WAn7crmpQPU9axQr2j9h83pXvU816FjwV7hbG5M/m6EMmB6hMFpMLbSNEGKIGk0Kb0xDNdoefkl7EJHDeyM2uRVbACOB3s9+whxz4ANA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174724; c=relaxed/simple;
	bh=gt3NNMBs8jshSCjviRvU0w2hyuC/Ai6fEDxfHfQGjPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir5i97wj0cYilyUjUXUuwdY7U9ybfpGI5HH3sl6PhTeadWs8vJhllQB887tyg5g3GbjSfbKdga4JCdDKQk9qiqbZRSOrcXFISQZei7rHI+PqfTnm3KdXyApajqAwTADdFCxvoDTMjvsSgTLD8ImUrE4mwnVU/u5Nk88PMqtRo70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLVOKwDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLVOKwDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7D8C4CEE3;
	Tue, 17 Jun 2025 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174724;
	bh=gt3NNMBs8jshSCjviRvU0w2hyuC/Ai6fEDxfHfQGjPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLVOKwDKDzvLAOyZJ3lUT8+HUgTlPiouf3M3bcORg2X4RqA0eWrAtJPoIZLE2NfHK
	 OEn01MtO+oeynHbDsfjIcO2If4DRnnDwpoT/1fk2muaBwP2DDnx3lLucy4o3JTLo3z
	 3IMqScH8ViS8OGbKK/FWs1t/QO6alQczmBEwaoPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/512] thermal/drivers/mediatek/lvts: Fix debugfs unregister on failure
Date: Tue, 17 Jun 2025 17:20:20 +0200
Message-ID: <20250617152421.726913858@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 3295b27ab70d2..944c28a0c4736 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -209,6 +209,13 @@ static const struct debugfs_reg32 lvts_regs[] = {
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
@@ -241,12 +248,7 @@ static int lvts_debugfs_init(struct device *dev, struct lvts_domain *lvts_td)
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
@@ -1352,8 +1354,6 @@ static void lvts_remove(struct platform_device *pdev)
 
 	for (i = 0; i < lvts_td->num_lvts_ctrl; i++)
 		lvts_ctrl_set_enable(&lvts_td->lvts_ctrl[i], false);
-
-	lvts_debugfs_exit(lvts_td);
 }
 
 static const struct lvts_ctrl_data mt7988_lvts_ap_data_ctrl[] = {
-- 
2.39.5




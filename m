Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7CE1F543D;
	Tue, 21 Jan 2025 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483113; cv=none; b=QPvoq3toTtDlAhjIPhKt5ajOZHv6960uZlS7/nKkBvnY92k95WQj1CWE+zu08+xciWDq6ouN6WWwid/9lqwikOIOmhTo7Q0oBhQsDsfAXj5aU1N2euiLFj8D/jHiT7ge7+jfF/m+yOCtwtNsufGqupP/5NrxnNe7m2+zN0QQqVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483113; c=relaxed/simple;
	bh=afMTiyGptUvHbjYAD3p9l8gQU0nV+jtuY4Wsl0mzxDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uicyMQfuju1t2b890XAd/VTE6Zyibb7gFLxneWbXve9/tgY+T15N74wVtOxca8A92rai+uc//xstg77UAyTFiTVPV9FP9je25MyeFlH4jZVbbKCFYiznZfbW2K1KDai/IIU6+VwE4nxw/6YLJ9AepW4WN/EactaRoa0+nvFAmOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqhvP6kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqhvP6kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B6FC4CEDF;
	Tue, 21 Jan 2025 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483113;
	bh=afMTiyGptUvHbjYAD3p9l8gQU0nV+jtuY4Wsl0mzxDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqhvP6kQJEvV6G0k/2Y4KNqBtGvhMWMV9WqRREFwyiY3c/ugLb6rios06lhKsZoPK
	 gg3FdJAnAPDMhkrLxfhj9dqvr/DM+bK5t7M4tAO2hGOOKklwshxFN4JhuHWs34cNo9
	 taA3TZpA3OcgCirCDJHxmOSgLD+h1Y72yM6HK5lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.15 120/127] Revert "regmap: detach regmap from dev on regmap_exit"
Date: Tue, 21 Jan 2025 18:53:12 +0100
Message-ID: <20250121174534.267126367@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f373a189817584d0af5f922e91cad40e45f12314 which is
commit 3061e170381af96d1e66799d34264e6414d428a7 upstream.

It was backported incorrectly, a fixed version will be applied later.

Cc: Cosmin Tanislav <demonsingur@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250115033244.2540522-1-tzungbi@kernel.org
Reported-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -663,17 +663,6 @@ int regmap_attach_dev(struct device *dev
 }
 EXPORT_SYMBOL_GPL(regmap_attach_dev);
 
-static int dev_get_regmap_match(struct device *dev, void *res, void *data);
-
-static int regmap_detach_dev(struct device *dev, struct regmap *map)
-{
-	if (!dev)
-		return 0;
-
-	return devres_release(dev, dev_get_regmap_release,
-			      dev_get_regmap_match, (void *)map->name);
-}
-
 static enum regmap_endian regmap_get_reg_endian(const struct regmap_bus *bus,
 					const struct regmap_config *config)
 {
@@ -1508,7 +1497,6 @@ int regmap_reinit_cache(struct regmap *m
 {
 	int ret;
 
-	regmap_detach_dev(map->dev, map);
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 



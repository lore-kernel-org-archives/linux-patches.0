Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27181F3FFE;
	Tue, 21 Jan 2025 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482747; cv=none; b=NLp3WVJ8yJk4WiczyVXE/tviLYNmNpOg63NOIl24Nlt9ECZzBiR5VDa/rOSRFKKCiuwI2Nhzkh+d1jUrnCPYVlTstsZRlycwCCVHvwnQXiZ1C89wrTdSjKezTaJnSlzxTrwWyZxT4OEgX7jn8SghbaAsL5Wl0iTaA9DA9KJTNkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482747; c=relaxed/simple;
	bh=vlY6oJTFVTdUPzBiQOwHvXPzpod3/NYqUv7AlLc2H6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSJU+OSEsQDgmhn4Hv9Nd83WN48sUHpfSSLEtTjAI/XrrOnKRbxype1V/F/0V0mebto6PXwrIqdFMvbocbMAkD3l3/KKvkyhBkje1tFvU3hFLxcjnukQ/3uR0w974K4DV22Ujak/xf2ehF3OcjmHQXiMy4YJVc/uJi23z5cGJeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRELSTA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRELSTA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CE0C4CEDF;
	Tue, 21 Jan 2025 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482747;
	bh=vlY6oJTFVTdUPzBiQOwHvXPzpod3/NYqUv7AlLc2H6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRELSTA4RkkzKLcFKH9itxV1X7Mo1pFgex2dbK3ceoXewQgXzYdSRQ3B8q3qgSPci
	 V5lbOzM/5r1NCYkI4VrRCtyYb9xr8jsE0wgeZa6nVdJ/FEr74+itbt3nX9Jwxp79YG
	 TC/ZMlRt7TikLEQON3HG5eirvFdqOvSsOsf4/H1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.1 58/64] Revert "regmap: detach regmap from dev on regmap_exit"
Date: Tue, 21 Jan 2025 18:52:57 +0100
Message-ID: <20250121174523.772794229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 48dc44f3c1afa29390cb2fbc8badad1b1111cea4 which is
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
@@ -652,17 +652,6 @@ int regmap_attach_dev(struct device *dev
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
@@ -1513,7 +1502,6 @@ int regmap_reinit_cache(struct regmap *m
 {
 	int ret;
 
-	regmap_detach_dev(map->dev, map);
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 



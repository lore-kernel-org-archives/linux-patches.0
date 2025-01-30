Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541AD1E522;
	Thu, 30 Jan 2025 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247294; cv=none; b=SJdiSD8xnUJRA27tBg/an++rM9y2XZlcfi/SE9FQqNmmtE9Ibk/EsuCt7Oj36t4ClTDO1Za7o1tYdaRBfeID3oGSK2qdbK0apWndlnM+M+Thytu9xlAkxb2CpwHdwpMjd56CMm+ao86iKAAvpcgBfniTwDPKKwwJJewMpqbhKPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247294; c=relaxed/simple;
	bh=F69TeJAhEODsZzoqGKVsgaZqdZ+d0VcwJG+hlElDlHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx4iSLDmOXCdpsH+SlGFnxYjOyCnYFqn3X73JzNV2SOv5dk7SFKFOHMUblXS1yNCkpUaopSA8rdbtRfpxx+5U4rK2mUPprU1F6GWCO7jyTvndCu2yd6ZYR7SMxKAPXrpP8rrE957mM3i62Q+JBkeeawjHzdTZhVQUVlRxCgX/LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9lMuyNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9lMuyNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB7EC4CED2;
	Thu, 30 Jan 2025 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247294;
	bh=F69TeJAhEODsZzoqGKVsgaZqdZ+d0VcwJG+hlElDlHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9lMuyNqNQGum8nbijlejy+m5XBdzSXqma5XqmBGLnwg9ZLoOvIZyDw1SKzGh0Wex
	 cwkOax7S8LLntdhfNm6vaNQ7FwdpTlJV40hLS7FWdoLbXJuIWESkHGp9MYht9B1IM6
	 qj84jQeBdlxXYlBSqooVPn42Ms+IS0G5bDhkgeS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.15 07/24] regmap: detach regmap from dev on regmap_exit
Date: Thu, 30 Jan 2025 15:01:59 +0100
Message-ID: <20250130140127.591593912@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

From: Cosmin Tanislav <demonsingur@gmail.com>

commit 3061e170381af96d1e66799d34264e6414d428a7 upstream.

At the end of __regmap_init(), if dev is not NULL, regmap_attach_dev()
is called, which adds a devres reference to the regmap, to be able to
retrieve a dev's regmap by name using dev_get_regmap().

When calling regmap_exit, the opposite does not happen, and the
reference is kept until the dev is detached.

Add a regmap_detach_dev() function and call it in regmap_exit() to make
sure that the devres reference is not kept.

Cc: stable@vger.kernel.org
Fixes: 72b39f6f2b5a ("regmap: Implement dev_get_regmap()")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20241128130554.362486-1-demonsingur%40gmail.com
Link: https://patch.msgid.link/20241128131625.363835-1-demonsingur@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250115033314.2540588-1-tzungbi@kernel.org
Link: https://lore.kernel.org/r/20250115033244.2540522-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -663,6 +663,17 @@ int regmap_attach_dev(struct device *dev
 }
 EXPORT_SYMBOL_GPL(regmap_attach_dev);
 
+static int dev_get_regmap_match(struct device *dev, void *res, void *data);
+
+static int regmap_detach_dev(struct device *dev, struct regmap *map)
+{
+	if (!dev)
+		return 0;
+
+	return devres_release(dev, dev_get_regmap_release,
+			      dev_get_regmap_match, (void *)map->name);
+}
+
 static enum regmap_endian regmap_get_reg_endian(const struct regmap_bus *bus,
 					const struct regmap_config *config)
 {
@@ -1531,6 +1542,7 @@ void regmap_exit(struct regmap *map)
 {
 	struct regmap_async *async;
 
+	regmap_detach_dev(map->dev, map);
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	regmap_range_exit(map);



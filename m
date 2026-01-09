Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BA335561;
	Fri,  9 Jan 2026 11:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959958; cv=none; b=KwnzbmuBBgf7Oph28qt2iw4eVScHEVBGW5lrbvsZ2OUsVRtLcVzGzO/gHEbYX3kt9uAxb8Xb8ZsR6XJhapo4qjFnFKumjcRbLDa3/wgLs4aLCw0ePso1V/WxGlQnfwwmYg6Ado4YtcZu88Gb58iCwEle3ERJ2g6WTzGyUavgpOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959958; c=relaxed/simple;
	bh=tsut64ycdIVvS0RDKjUxmFT3Kh/4xIo3vT9GQnbzJ1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMNWAJZyM+JuTgRtMVqunw7YPuwrPaR+flKESbmy5ogq/be0MpbjFuRR1g4nJmipI1EVmmi9ClCGuIFmuG7d6D1i7kAqD9dReAc8b4U3ZTWzhNGlLFAksyaMAX1wcT3+zzxXH4SXi8pVIBCj6jpbZc2DF/dF5Wy12QmfYsLOW8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoPzENm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoPzENm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A833C4CEF1;
	Fri,  9 Jan 2026 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959958;
	bh=tsut64ycdIVvS0RDKjUxmFT3Kh/4xIo3vT9GQnbzJ1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoPzENm4aUzivsx6t9IxkEdDZG7fxmVRcQENfue+7sYSkN13/AmC59aYdIXWV9S1A
	 IoJAxZz2ABtomRnuTqzO6datvh/z00sZKRkxgLzKF8tRq4SVvm1k5KFlsC+jVbCFrQ
	 s9LjhQ7KAAtkEU1Axu+jsM2Rx7WNBz3jp6m2KPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sparkhuang <huangshaobo3@xiaomi.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/737] regulator: core: Protect regulator_supply_alias_list with regulator_list_mutex
Date: Fri,  9 Jan 2026 12:36:14 +0100
Message-ID: <20260109112142.838642028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sparkhuang <huangshaobo3@xiaomi.com>

[ Upstream commit 0cc15a10c3b4ab14cd71b779fd5c9ca0cb2bc30d ]

regulator_supply_alias_list was accessed without any locking in
regulator_supply_alias(), regulator_register_supply_alias(), and
regulator_unregister_supply_alias(). Concurrent registration,
unregistration and lookups can race, leading to:

1 use-after-free if an alias entry is removed while being read,
2 duplicate entries when two threads register the same alias,
3 inconsistent alias mappings observed by consumers.

Protect all traversals, insertions and deletions on
regulator_supply_alias_list with the existing regulator_list_mutex.

Fixes: a06ccd9c3785f ("regulator: core: Add ability to create a lookup alias for supply")
Signed-off-by: sparkhuang <huangshaobo3@xiaomi.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251127025716.5440-1-huangshaobo3@xiaomi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 465f4f870162f..23cdf220ca7db 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1970,6 +1970,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 {
 	struct regulator_supply_alias *map;
 
+	mutex_lock(&regulator_list_mutex);
 	map = regulator_find_supply_alias(*dev, *supply);
 	if (map) {
 		dev_dbg(*dev, "Mapping supply %s to %s,%s\n",
@@ -1978,6 +1979,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 		*dev = map->alias_dev;
 		*supply = map->alias_supply;
 	}
+	mutex_unlock(&regulator_list_mutex);
 }
 
 static int regulator_match(struct device *dev, const void *data)
@@ -2456,22 +2458,26 @@ int regulator_register_supply_alias(struct device *dev, const char *id,
 				    const char *alias_id)
 {
 	struct regulator_supply_alias *map;
+	struct regulator_supply_alias *new_map;
 
-	map = regulator_find_supply_alias(dev, id);
-	if (map)
-		return -EEXIST;
-
-	map = kzalloc(sizeof(struct regulator_supply_alias), GFP_KERNEL);
-	if (!map)
+	new_map = kzalloc(sizeof(struct regulator_supply_alias), GFP_KERNEL);
+	if (!new_map)
 		return -ENOMEM;
 
-	map->src_dev = dev;
-	map->src_supply = id;
-	map->alias_dev = alias_dev;
-	map->alias_supply = alias_id;
-
-	list_add(&map->list, &regulator_supply_alias_list);
+	mutex_lock(&regulator_list_mutex);
+	map = regulator_find_supply_alias(dev, id);
+	if (map) {
+		mutex_unlock(&regulator_list_mutex);
+		kfree(new_map);
+		return -EEXIST;
+	}
 
+	new_map->src_dev = dev;
+	new_map->src_supply = id;
+	new_map->alias_dev = alias_dev;
+	new_map->alias_supply = alias_id;
+	list_add(&new_map->list, &regulator_supply_alias_list);
+	mutex_unlock(&regulator_list_mutex);
 	pr_info("Adding alias for supply %s,%s -> %s,%s\n",
 		id, dev_name(dev), alias_id, dev_name(alias_dev));
 
@@ -2491,11 +2497,13 @@ void regulator_unregister_supply_alias(struct device *dev, const char *id)
 {
 	struct regulator_supply_alias *map;
 
+	mutex_lock(&regulator_list_mutex);
 	map = regulator_find_supply_alias(dev, id);
 	if (map) {
 		list_del(&map->list);
 		kfree(map);
 	}
+	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_unregister_supply_alias);
 
-- 
2.51.0




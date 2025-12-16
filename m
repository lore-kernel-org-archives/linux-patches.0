Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E404F2BE7B2;
	Tue, 16 Dec 2025 11:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884659; cv=none; b=u7xWEnRP0x9So7z1SzuIuX6W8o/Tvkh35auR480OhpmV3gB4ATa7h6p+ssUgV+jsa5ebsKIXyyF1Jx/SJbTJjzfyTJxu64Gdrv9KBB58gOzSBx2gzIx/WPTBt+6zqn1Gtb2b1Ai5X2LSFf6+LRjYPeiIbPNDa0fKQt6dWSD1qxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884659; c=relaxed/simple;
	bh=f8YMryeWm4FNPFr3v6drlCo+OcgIOiN6fHtlX39qKw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwCZTODxDhv95Wf5bJBTIee8pM1XU+jyqgZJSi+Nu3CmbT1OW58kr10YQje8Vg62czyjdXkI5U6ZJ1PZs1ZjZTCL/5JpbS4oE14NtgWIkukJonmOfjRZNOkoNm1+e6DuHVHq78m7aOk3wJ4cbcCW7MujRsL5q7jGCVBndj9CAzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDt4KVgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDt4KVgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69591C4CEF1;
	Tue, 16 Dec 2025 11:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884658;
	bh=f8YMryeWm4FNPFr3v6drlCo+OcgIOiN6fHtlX39qKw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDt4KVgIcYZhjA4yGHb+vKzSUsU0jHCnY+CaFQY/AI67iymKOHXIR8PSsSBZUWq53
	 YE7ADNEzHdeIcQYN9g9DUJPQXfNobhIOCP4M2aCJtX4IbfJKc6XJVCqBDRGlVvO33s
	 E8HFJNFPtersWz6xJ8dyoS2BhN8sGlnm/9kzguME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sparkhuang <huangshaobo3@xiaomi.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/354] regulator: core: Protect regulator_supply_alias_list with regulator_list_mutex
Date: Tue, 16 Dec 2025 12:13:48 +0100
Message-ID: <20251216111330.373661149@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be9704d34c015..1c0748fee6846 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1914,6 +1914,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 {
 	struct regulator_supply_alias *map;
 
+	mutex_lock(&regulator_list_mutex);
 	map = regulator_find_supply_alias(*dev, *supply);
 	if (map) {
 		dev_dbg(*dev, "Mapping supply %s to %s,%s\n",
@@ -1922,6 +1923,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 		*dev = map->alias_dev;
 		*supply = map->alias_supply;
 	}
+	mutex_unlock(&regulator_list_mutex);
 }
 
 static int regulator_match(struct device *dev, const void *data)
@@ -2442,22 +2444,26 @@ int regulator_register_supply_alias(struct device *dev, const char *id,
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
 
@@ -2477,11 +2483,13 @@ void regulator_unregister_supply_alias(struct device *dev, const char *id)
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




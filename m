Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745413BB9E0;
	Thu, 15 Jan 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499104; cv=none; b=LrleON4TRo/8TlnOgdoEKe+2+inu+xD00ZlAx3GdCsV/puJQ1i+5oItrFDib2utp0T0+exNzSzR0bICdWxWdvHMN1kda3i096XWbPMMN7MBBT9FYDPZjOCKrwWO38dLdXAlwgNd7mkKzRr+o2oufxuGfAnNsZF5pvCecAPy3vqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499104; c=relaxed/simple;
	bh=01QtM1zpTJJXcMbKb2p3Y++JI32JoPdpxBjGA2OQLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS+r6CjJGdScgNn5OlhT6tX9gXgmpoR0iE1g0lEnqHDdlBAaTWoGn8HQCfWJnnozALWFyHkGfdITm58v+AFYwoXFtjusX2CVY9wdzh9FlSYQKOoH6yyp2YG/YCBJVrvF6eDOMhpzorfA6Td3czgr/XChYpsee6/z4BXrG0N7nDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIOzbgqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIOzbgqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF6DC116D0;
	Thu, 15 Jan 2026 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499104;
	bh=01QtM1zpTJJXcMbKb2p3Y++JI32JoPdpxBjGA2OQLPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIOzbgqCR7DY0Nv3UVR9JPwP7USE2SVTbFlRsfwa4QH1ti2R6HhPK3og26AWR9r9r
	 yr3gpUp3hr9YooW0UT176U+sqyXjKWJh/Hh+MHTXJ1jmbyOEUa8LEsJkmzydF/Ta6h
	 TCBnGriMA0QmJ3t3XOTZ7jjA0+KGkQDxqGFFnTNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sparkhuang <huangshaobo3@xiaomi.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/451] regulator: core: Protect regulator_supply_alias_list with regulator_list_mutex
Date: Thu, 15 Jan 2026 17:45:10 +0100
Message-ID: <20260115164234.861455842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7abc839a67c2d..0e2129be02265 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1810,6 +1810,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 {
 	struct regulator_supply_alias *map;
 
+	mutex_lock(&regulator_list_mutex);
 	map = regulator_find_supply_alias(*dev, *supply);
 	if (map) {
 		dev_dbg(*dev, "Mapping supply %s to %s,%s\n",
@@ -1818,6 +1819,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 		*dev = map->alias_dev;
 		*supply = map->alias_supply;
 	}
+	mutex_unlock(&regulator_list_mutex);
 }
 
 static int regulator_match(struct device *dev, const void *data)
@@ -2296,22 +2298,26 @@ int regulator_register_supply_alias(struct device *dev, const char *id,
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
 
@@ -2331,11 +2337,13 @@ void regulator_unregister_supply_alias(struct device *dev, const char *id)
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




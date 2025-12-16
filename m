Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1698637A3E8;
	Tue, 16 Dec 2025 12:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888254; cv=none; b=q0wrDGJhh9qCqgtG76bFQ8cIMb0zWXyIQPzKgQ+17sUjpNkxwYU4+RPxzfA08Kxo4FtKvyeyOHJ6r4ODinI5tgUJAhbBO7gNBY0KrjAFddujI7fCPxJEKzLwQ8uRnQDheiLkuiQ56JTkBdAJ1gYc3X4Lw+rB4rxS1rQGNfzc43E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888254; c=relaxed/simple;
	bh=EBGDKnYCF6rGP8JlU3NykiF6rq01NFVaWEtT1kRG4vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhMlBeDDUk6hPuH1AI4clm5iFOxHntXRUyoWp/ICsNvi3pafqcJpJO/G9FpF6GqrBGYFgH4601u36+op5bv8coJq4J2vQurc6FpwMNzRI9C0qcXNYQyspoFXUFULsCs+Ywl+Jw2TpUiTwQRbRRFA3STfrl6d3UeB5eRJiYJrdQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/6eb9au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/6eb9au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF2FC16AAE;
	Tue, 16 Dec 2025 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888253;
	bh=EBGDKnYCF6rGP8JlU3NykiF6rq01NFVaWEtT1kRG4vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/6eb9aup3q9OfIJ3+ivDPBI0ZKaH/r+JBjfZAie5ay6scB1fWWgbZS+4UqvYL/b8
	 XxcCoLRFsO0NGzh1iLdv6wKqU6iVDVGJe3kfrxSfbw8nJJpNwheuBzUbwuWh0EPM8L
	 bU6O+H+JilZ90Hl3RSAonFIKri1fD7Fm5BxnDh+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sparkhuang <huangshaobo3@xiaomi.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 478/614] regulator: core: Protect regulator_supply_alias_list with regulator_list_mutex
Date: Tue, 16 Dec 2025 12:14:05 +0100
Message-ID: <20251216111418.689359692@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fc93612f4ec0c..b38b087eccfd7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1947,6 +1947,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 {
 	struct regulator_supply_alias *map;
 
+	mutex_lock(&regulator_list_mutex);
 	map = regulator_find_supply_alias(*dev, *supply);
 	if (map) {
 		dev_dbg(*dev, "Mapping supply %s to %s,%s\n",
@@ -1955,6 +1956,7 @@ static void regulator_supply_alias(struct device **dev, const char **supply)
 		*dev = map->alias_dev;
 		*supply = map->alias_supply;
 	}
+	mutex_unlock(&regulator_list_mutex);
 }
 
 static int regulator_match(struct device *dev, const void *data)
@@ -2497,22 +2499,26 @@ int regulator_register_supply_alias(struct device *dev, const char *id,
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
 
@@ -2532,11 +2538,13 @@ void regulator_unregister_supply_alias(struct device *dev, const char *id)
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




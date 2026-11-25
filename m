Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622292;
	b=y9MFZj2KVUTBNXuzuSoI6WGpSWQb1jJ4xD5uYx1fuJ3d2oWobUvFWiPGmxNKRDJ/fOM+
	 mA2ZCFEGQZeORnvBaSMTExIaVSlj6bZveOHstACJUQB381excuF5nu7Ya2UgXLRb6TIwQ
	 JUNCxpJiJqRVQy4Dkc4NJvYm4swBcf4JJ/N9JKaWRiSnwctsehs0NVD1+w7Z2R7c+d5iv
	 rRQBxdnbYS2oYkRqXY7d3ZAKvQB9wPOORIb8s8WtZMgvHYQnj1z6CI14WrctlDApVR0qc
	 qgRzLaxle2AxoatADzUFeSaPCVjBxQJG5lNIysrignB9+/WyMHJergEMuuI6pSI7KBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=stalJe+MVhHkBhGe6n95UwTRaADAnYlHq6Xpgz+2vOw=;
	b=Q7B+rCLUjo6nEJCNXscPbFYF6UE8bzk1Nwz8wjesu5mQL4deX/O+CurHeXwLu38CHBUp
	 pZ8DMwQ96tMjZp+pI2YnrrbHUs4AK+mjlOlmFsQlLZ8UOfhg3kZ6QNKrVEw52IhvDpPjW
	 iisX1oih4WMGG/0yFrtbh1I6VjT4kDY5bHTP8djAEb5UkhGdUp1+HoBNExJsvO5jbQGfD
	 7/AdEKSkdXolxd+/tyS04Lyj+jFptpuVQBAV2tJyM9vbXwLTGGHECqLcs/0hD9P5Rjo22
	 UExmAkPklXnzrweiAH1c232JolewMglDAawANlWTwzDro/9bbta61R1bNZUT1F1PzAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbpuChRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E86E606A323;
	Wed, 25 Nov 2026 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbpuChRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8471F000C6;
	Wed, 25 Nov 2026 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622292;
	bh=stalJe+MVhHkBhGe6n95UwTRaADAnYlHq6Xpgz+2vOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbpuChRxQKIz6tnJbyFimkJOoHXPwB6IUT9e3YV9eGlXjje8k5PQhaiiCq6ZPtEuh
	 i/PL0bEloylO+JfLSO4ym8Xsyh2zByF7T0HUI7OXHzj5ZYDN/mwugz/f18jw43+UmB
	 t+NNjj42XgJdNzR6xofFcNuTPgUBdX5NaDq5lK4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 489/990] media: rc: Replace open coded krealloc() for keymap
Date: Wed, 25 Nov 2026 15:30:56 +0100
Message-ID: <20261125143833.548874067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit e4b4aa413cc2e48a261c8c513ced964a3390c0cf ]

Replace open coded krealloc() and remove superfluous member of struct
rc_map - we don't need to track both the size in bytes and entries.

Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: ab9567336171 ("media: rc: Add missing locking for keymap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-main.c | 45 +++++++++++++++++++-------------------
 include/media/rc-map.h     |  2 --
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2f1684a81eb14..6b14ccfc3080a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -17,9 +17,8 @@
 #include <linux/module.h>
 #include "rc-core-priv.h"
 
-/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE	256
-#define IR_TAB_MAX_SIZE	8192
+#define IR_TAB_MIN_ENTRIES	32
+#define IR_TAB_MAX_ENTRIES	1024
 
 static const struct {
 	const char *name;
@@ -214,21 +213,23 @@ static int scancode_to_u64(const struct input_keymap_entry *ke, u64 *scancode)
 static int ir_create_table(struct rc_dev *dev, struct rc_map *rc_map,
 			   const char *name, u64 rc_proto, size_t size)
 {
+	unsigned int alloc;
 	rc_map->name = kstrdup(name, GFP_KERNEL);
 	if (!rc_map->name)
 		return -ENOMEM;
+	alloc = roundup_pow_of_two(size);
 	rc_map->rc_proto = rc_proto;
-	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
+	rc_map->len = 0;
+	rc_map->size = alloc;
+	rc_map->scan = kmalloc_objs(struct rc_map_table, alloc, GFP_KERNEL);
 	if (!rc_map->scan) {
 		kfree(rc_map->name);
 		rc_map->name = NULL;
 		return -ENOMEM;
 	}
 
-	dev_dbg(&dev->dev, "Allocated space for %u keycode entries (%u bytes)\n",
-		rc_map->size, rc_map->alloc);
+	dev_dbg(&dev->dev, "Allocated space for %u keycode entries (%zu bytes)\n",
+		alloc, alloc * sizeof(struct rc_map_table));
 	return 0;
 }
 
@@ -262,38 +263,36 @@ static void ir_free_table(struct rc_map *rc_map)
 static int ir_resize_table(struct rc_dev *dev, struct rc_map *rc_map,
 			   gfp_t gfp_flags)
 {
-	unsigned int oldalloc = rc_map->alloc;
-	unsigned int newalloc = oldalloc;
-	struct rc_map_table *oldscan = rc_map->scan;
+	unsigned int newsize = rc_map->size;
 	struct rc_map_table *newscan;
 
 	if (rc_map->size == rc_map->len) {
 		/* All entries in use -> grow keytable */
-		if (rc_map->alloc >= IR_TAB_MAX_SIZE)
+		if (newsize >= IR_TAB_MAX_ENTRIES)
 			return -ENOMEM;
 
-		newalloc *= 2;
-		dev_dbg(&dev->dev, "Growing table to %u bytes\n", newalloc);
+		newsize *= 2;
+
+		dev_dbg(&dev->dev, "Growing table to %u entries\n", newsize);
 	}
 
-	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
+	if (rc_map->len * 3 < rc_map->size && rc_map->size > IR_TAB_MIN_ENTRIES) {
 		/* Less than 1/3 of entries in use -> shrink keytable */
-		newalloc /= 2;
-		dev_dbg(&dev->dev, "Shrinking table to %u bytes\n", newalloc);
+		newsize /= 2;
+		dev_dbg(&dev->dev, "Shrinking table to %u entries\n", newsize);
 	}
 
-	if (newalloc == oldalloc)
+	if (newsize == rc_map->size)
 		return 0;
 
-	newscan = kmalloc(newalloc, gfp_flags);
+	newscan = krealloc_array(rc_map->scan, newsize,
+				 sizeof(struct rc_map_table), gfp_flags);
 	if (!newscan)
 		return -ENOMEM;
 
-	memcpy(newscan, rc_map->scan, rc_map->len * sizeof(struct rc_map_table));
 	rc_map->scan = newscan;
-	rc_map->alloc = newalloc;
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	kfree(oldscan);
+	rc_map->size = newsize;
+
 	return 0;
 }
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index d95ed3e96de28..f167c37179c8f 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -148,7 +148,6 @@ struct rc_map_table {
  * @scan: pointer to struct &rc_map_table
  * @size: Max number of entries
  * @len: Number of entries that are in use
- * @alloc: size of \*scan, in bytes
  * @rc_proto: type of the remote controller protocol, as defined at
  *	     enum &rc_proto
  * @name: name of the key map table
@@ -158,7 +157,6 @@ struct rc_map {
 	struct rc_map_table	*scan;
 	unsigned int		size;
 	unsigned int		len;
-	unsigned int		alloc;
 	enum rc_proto		rc_proto;
 	const char		*name;
 	spinlock_t		lock;
-- 
2.53.0




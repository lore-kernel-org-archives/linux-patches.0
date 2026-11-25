Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625105;
	b=j8eWGCj3oFznRpqBmMAtkL4p+hjOafQJ8b8GLIL28xqTTKVF0xmuDp6LeF+LMbswZD6L
	 63HwKlYgidHKkagBFxPxcjdvMz1Opi32GF2ARBrKO1yqSeUXDte2XP2MRIL0ucduK5fSw
	 8oLXG+mBvEigM+599v+pI1SgrWLTkrNtpfYs6Dq1zv5HGKxWL6cRzkwMVT9gWtJbq0d/u
	 19pzzhMm1Cexz2iep65i7jjk4jOtLIGM6SJri2QNike297CzdUskFcOOz87MsOuOgbz0I
	 F5/QEWidXVZ7BpWjvIXQOsqvIVh3JQvw/9LGEWd/oDdNiVE+zQC5q5HNsDICVueGTyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5jAdSYVTWzzZyiHBlEuaEsLQOHVVB/zMuAa/DhjzWg=;
	b=WI5buSSRS1aBkhM1RLETQbiXF50OP6FnfaVk1iDmmSUu6R+GLbQ6JaynO9dL23mwJTPC
	 95Cylm/OVP7GrUB3kVH3j7NZRlDGCYA+7/9ExxCUUGe2Q++ZRvIbqhb6hOrKuHN/w+WXQ
	 kFGg549CPw5QqFAWwZnrQFW9ckdnx9KeZIqV0ARpPiFXvMBGeFrd/fiN/yIMJLKe/su+E
	 yhND9/H0uS5rmwEHNazj6MYA8n5j20bYyvlRnMarg2lOA912mwc4Aqw6NLd61i05AsSMR
	 fFM3cQmR9F7Ad1ppAt6wE84nVjgvbotk1D7tOG3sZgNKYAWLK24oW6+tdr1f2mvmyRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uK9rvmNQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14291606A32E;
	Wed, 25 Nov 2026 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uK9rvmNQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4C91F000C0;
	Wed, 25 Nov 2026 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625104;
	bh=q5jAdSYVTWzzZyiHBlEuaEsLQOHVVB/zMuAa/DhjzWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uK9rvmNQAN3wdkOLy2f7wa6x5cl4+v3jVcbMiXOP3OFgJGfPtwFyWW4P7Ld+nzaZV
	 v7gUErJIIrpUPW40u+LNGCY03O4qTar7CZsl81OG/fe6Xg5W1ecxpyXNoXx7qfyjY3
	 2n0gNCwYC/BB+Fv46PqanOkFKAZq3Rm5N+09bP3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/816] media: rc: Replace open coded krealloc() for keymap
Date: Wed, 25 Nov 2026 15:31:59 +0100
Message-ID: <20261125143857.784441449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eb19ee6765dfb..63b536571d442 100644
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
index ab8c1b82dff6a..c84b4ef70a841 100644
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




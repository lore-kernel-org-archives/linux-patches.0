Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063830;
	b=G+Si2w/Vb20xdAEjuTkEn9eJ5Wgju26N77KW0A0+nD0tHnrkfh23t/os2KEvGVnUSEvt
	 dp0zpOemEJ6xhlG7BqRwg9jScZmHgeVwFFY78Ap5xgrVOnLZavhRNgJE41k42haZm5SbE
	 3cSu/O+LcmhhYJGAax3+vrD7R3vjOmabS+BUj5T1629o07PJ4M1LWWsqeGqNpAN6BXiiM
	 0UXHdaZSJ/+mIuHSfzY/OyM9pmhN1o0H6992Go/NiQe2rOCxNbAt6kQ9ytRI0WVj04THO
	 /G6oG1g4TtodM8XHsJH4yPrdF4T6rY2qsyoWT4/maOtblXwyQSuE8a2QbwyPoaVGlCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IczeEn+PQlxS/wJWMUyG35TgKtbiZQKZZyb8gsj79dc=;
	b=TG4kXb4e7Em7hysQ1yBSDh0CncIeaujsdLrsYnDzIDQOAUvRAE3z/eb1MweEiM4TQtbj
	 DSkX/MS0CzX4eAH5agBrLgZo2rQ1MetDWQV4kFTh45jTJfvCXizhWKhm3ziG0Nu8w/mus
	 4jZeLjRCxkzYNCytf6Jm17eNS7bb9qTJ0okpUjcTai34T+7td6T701i+oMl70SYYDykZH
	 RokF5BIor8+rTnebj18aE5FGo037voJIWeBC5VMngFlnhZYvmKY7OIyXiVdlkfdq+c30b
	 JGFnaBBgSzOkOr3d1tbZgMHzk7/rMry7rF66KUrYP8FkRT2VNQGew9F2H0nyUPuX23A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bj4VHDpl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D4E606A326;
	Sat,  7 Nov 2026 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bj4VHDpl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C01F008A2;
	Sat,  7 Nov 2026 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063829;
	bh=IczeEn+PQlxS/wJWMUyG35TgKtbiZQKZZyb8gsj79dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bj4VHDpljZ7yViIc3IgAc/gUhcDpjDLwjP1HADMpNpZgr5I7zxnFeNJv8Yvc4wq22
	 CCuTH0bWA6Pv2jkhDuM1JwEQ6816dw0nYyR0OVGhqLzQEV7J77QHfXoqTbEZoE7cyA
	 T5YwDp7hLpJldNfj3S0eoITunQ4CTulF5JfYZeHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0011/1257] media: rc: Add missing locking for keymap
Date: Sat,  7 Nov 2026 08:38:27 -0500
Message-ID: <20261107134939.738984575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit ab9567336171e46ce9e03ee126902b3fd7901baa ]

When the rc_map for an rc_dev gets updated, locking is required but is
missing in places. A concurrent scancode lookup and a call to
rc_{register,unregistered}_device() could result in a use-after-free;
this could happen if IR is decoded during those function calls.

Add lockdep assertions where locks are required.

ir_free_table() should only be called for non-TX devices else we will
use a spinlock without iniitializing it.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-main.c | 86 +++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 29 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 81f3aafcae8f4..946521ace142e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -104,7 +104,6 @@ static struct rc_map_list *seek_rc_map(const char *name)
 
 struct rc_map *rc_map_get(const char *name)
 {
-
 	struct rc_map_list *map;
 
 	map = seek_rc_map(name);
@@ -201,7 +200,7 @@ static int scancode_to_u64(const struct input_keymap_entry *ke, u64 *scancode)
  * ir_create_table() - initializes a scancode table
  * @dev:	the rc_dev device
  * @rc_map:	the rc_map to initialize
- * @name:	name to assign to the table
+ * @map_name:	name to assign to the table
  * @rc_proto:	ir type to assign to the new table
  * @size:	initial size of the table
  *
@@ -211,23 +210,31 @@ static int scancode_to_u64(const struct input_keymap_entry *ke, u64 *scancode)
  * return:	zero on success or a negative error code
  */
 static int ir_create_table(struct rc_dev *dev, struct rc_map *rc_map,
-			   const char *name, u64 rc_proto, size_t size)
+			   const char *map_name, u64 rc_proto, size_t size)
 {
+	struct rc_map_table *scan;
 	unsigned int alloc;
-	rc_map->name = kstrdup(name, GFP_KERNEL);
-	if (!rc_map->name)
+	char *name;
+
+	name = kstrdup(map_name, GFP_KERNEL);
+	if (!name)
 		return -ENOMEM;
+
 	alloc = roundup_pow_of_two(size);
-	rc_map->rc_proto = rc_proto;
-	rc_map->len = 0;
-	rc_map->size = alloc;
-	rc_map->scan = kmalloc_objs(struct rc_map_table, alloc, GFP_KERNEL);
-	if (!rc_map->scan) {
-		kfree(rc_map->name);
-		rc_map->name = NULL;
+	scan = kmalloc_objs(struct rc_map_table, alloc, GFP_KERNEL);
+	if (!scan) {
+		kfree(name);
 		return -ENOMEM;
 	}
 
+	scoped_guard(spinlock_irqsave, &rc_map->lock) {
+		rc_map->name = name;
+		rc_map->scan = scan;
+		rc_map->rc_proto = rc_proto;
+		rc_map->len = 0;
+		rc_map->size = alloc;
+	}
+
 	dev_dbg(&dev->dev, "Allocated space for %u keycode entries (%zu bytes)\n",
 		alloc, alloc * sizeof(struct rc_map_table));
 	return 0;
@@ -237,16 +244,26 @@ static int ir_create_table(struct rc_dev *dev, struct rc_map *rc_map,
  * ir_free_table() - frees memory allocated by a scancode table
  * @rc_map:	the table whose mappings need to be freed
  *
- * This routine will free memory alloctaed for key mappings used by given
+ * This routine will free memory allocated for key mappings used by given
  * scancode table.
  */
 static void ir_free_table(struct rc_map *rc_map)
 {
-	rc_map->size = 0;
-	kfree(rc_map->name);
-	rc_map->name = NULL;
-	kfree(rc_map->scan);
-	rc_map->scan = NULL;
+	struct rc_map_table *scan;
+	const char *name;
+
+	scoped_guard(spinlock_irqsave, &rc_map->lock) {
+		name = rc_map->name;
+		scan = rc_map->scan;
+
+		rc_map->size = 0;
+		rc_map->len = 0;
+		rc_map->name = NULL;
+		rc_map->scan = NULL;
+	}
+
+	kfree(name);
+	kfree(scan);
 }
 
 /**
@@ -266,6 +283,8 @@ static int ir_resize_table(struct rc_dev *dev, struct rc_map *rc_map,
 	unsigned int newsize = rc_map->size;
 	struct rc_map_table *newscan;
 
+	lockdep_assert_held(&rc_map->lock);
+
 	if (rc_map->size == rc_map->len) {
 		/* All entries in use -> grow keytable */
 		if (newsize >= IR_TAB_MAX_ENTRIES)
@@ -317,6 +336,8 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 	int old_keycode = rc_map->scan[index].keycode;
 	int i;
 
+	lockdep_assert_held(&rc_map->lock);
+
 	/* Did the user wish to remove the mapping? */
 	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
 		dev_dbg(&dev->dev, "#%d: Deleting scan 0x%04llx\n",
@@ -372,6 +393,8 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 {
 	unsigned int i;
 
+	lockdep_assert_held(&rc_map->lock);
+
 	/*
 	 * Unfortunately, some hardware-based IR decoders don't provide
 	 * all bits for the complete IR code. In general, they provide only
@@ -396,7 +419,7 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 	/* No previous mapping found, we might need to grow the table */
 	if (rc_map->size == rc_map->len) {
 		if (!resize || ir_resize_table(dev, rc_map, GFP_ATOMIC))
-			return -1U;
+			return UINT_MAX;
 	}
 
 	/* i is the proper index to insert our new keycode */
@@ -478,16 +501,18 @@ static int ir_setkeytable(struct rc_dev *dev, const struct rc_map *from)
 	if (rc)
 		return rc;
 
-	for (i = 0; i < from->size; i++) {
-		index = ir_establish_scancode(dev, rc_map,
-					      from->scan[i].scancode, false);
-		if (index >= rc_map->len) {
-			rc = -ENOMEM;
-			break;
-		}
+	scoped_guard(spinlock_irqsave, &rc_map->lock) {
+		for (i = 0; i < from->size; i++) {
+			index = ir_establish_scancode(dev, rc_map,
+						      from->scan[i].scancode, false);
+			if (index >= rc_map->len) {
+				rc = -ENOMEM;
+				break;
+			}
 
-		ir_update_mapping(dev, rc_map, index,
-				  from->scan[i].keycode);
+			ir_update_mapping(dev, rc_map, index,
+					  from->scan[i].keycode);
+		}
 	}
 
 	if (rc)
@@ -523,6 +548,8 @@ static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
 {
 	struct rc_map_table *res;
 
+	lockdep_assert_held(&rc_map->lock);
+
 	res = bsearch(&scancode, rc_map->scan, rc_map->len,
 		      sizeof(struct rc_map_table), rc_map_cmp);
 	if (!res)
@@ -1993,7 +2020,8 @@ int rc_register_device(struct rc_dev *dev)
 	scoped_guard(mutex, &dev->lock)
 		dev->registered = false;
 out_free_table:
-	ir_free_table(&dev->rc_map);
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		ir_free_table(&dev->rc_map);
 out_raw:
 	ida_free(&rc_ida, minor);
 	return rc;
-- 
2.53.0




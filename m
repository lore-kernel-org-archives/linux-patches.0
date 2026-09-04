Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F613F23DB;
	Fri,  4 Sep 2026 05:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499187; cv=none; b=u1RCh5ID8UVoOj1gscSOzNZvJLUGA/ArrJxGVqih0Lo0Ud8/SvVMP9/dxHQvXugkQnfI0xIXCsud10jRNNouXNbfSrDk0YEm49O2HWKpDGbV0QzidnNC9PxdWCjjlNjBK1rCymS1xX+9wSVUl6LIk7MtJ4nen3eJ3AowULAEF7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499187; c=relaxed/simple;
	bh=PsQMPy7rE7iCT1Q5EMoZ+NAjeo/dP2ZeBhUYGjiHbrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ae52PNT6BEz8xTX2c+/xAhWaO1xD9T0UpAb8w3YE7XBFYsVO8SannKSf1zDJ0MgC5CMfYUfnLVp4iakCKV+G4OgftkYjAMomWPbBBU8HWT9fW+e0XezsDIObvaEPNPMeu7BR+3KrLlFF/2BiwfE00Q6r+TRQyQ2eWSg8D2/vpxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QipLekEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QipLekEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8551F00A3D;
	Fri,  4 Sep 2026 05:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499185;
	bh=8CTsFbHuD5Rp0IqPfVv8G64UGz6ycLTBzRje9RJz/ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QipLekEBvXnyPk3hxZf7CDjLI7dWKaLq/lkED9B2YqnU0zIufI8fKhCFGymT17y4I
	 7y7SP/lB/FQvz8JsUI4aNSJiEx1dsE1B93kbWQlBbje3T9yBiix7fM08gekSWU6xJ9
	 uG2jjVp8CZ1ajoQp6UxnbuAuBkQUayK3yVy+w8u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 328/713] dm array: validate array block headers on read
Date: Fri,  4 Sep 2026 06:54:56 +0200
Message-ID: <20260904045811.183450212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 2965787723084835b18dfe993cd450ebf5bd4540 upstream.

array_block_check() validates blocknr and csum and nothing else, while
node_check(), next to it, has bounded the structural fields since both
were written. dm_array_cursor_next() takes its loop bound from the
on-disk nr_entries and element_at() is unguarded pointer arithmetic, so
a count larger than the block holds keeps the cursor in one block while
the index grows past it and the read walks off the dm-bufio buffer --
dm_cache_load_mappings() drives it once per cache block at activation.

Check the header against itself: reject a zero value_size, require
max_entries to equal calc_max_entries() for that value_size and block
size, and require nr_entries to fit. Equality rather than an upper bound,
since a count below the real capacity trips BUG_ON() in fill_ablock() and
trim_ablock(). Metadata dm-array writes satisfies all three.

Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-array.c |   37 ++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -38,6 +38,14 @@ struct array_block {
  */
 #define CSUM_XOR 595846735
 
+/*
+ * Each array block can hold this many values.
+ */
+static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
+{
+	return (size_of_block - sizeof(struct array_block)) / value_size;
+}
+
 static void array_block_prepare_for_write(const struct dm_block_validator *v,
 					  struct dm_block *b,
 					  size_t size_of_block)
@@ -55,6 +63,7 @@ static int array_block_check(const struc
 			     size_t size_of_block)
 {
 	struct array_block *bh_le = dm_block_data(b);
+	uint32_t nr_entries, max_entries, value_size;
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(bh_le->blocknr)) {
@@ -74,6 +83,26 @@ static int array_block_check(const struc
 		return -EILSEQ;
 	}
 
+	nr_entries = le32_to_cpu(bh_le->nr_entries);
+	max_entries = le32_to_cpu(bh_le->max_entries);
+	value_size = le32_to_cpu(bh_le->value_size);
+
+	if (!value_size) {
+		DMERR_LIMIT("%s failed: value_size is zero", __func__);
+		return -EILSEQ;
+	}
+
+	if (max_entries != calc_max_entries(value_size, size_of_block)) {
+		DMERR_LIMIT("%s failed: max_entries %u invalid for value_size %u",
+			    __func__, max_entries, value_size);
+		return -EILSEQ;
+	}
+
+	if (nr_entries > max_entries) {
+		DMERR_LIMIT("%s failed: too many entries", __func__);
+		return -EILSEQ;
+	}
+
 	return 0;
 }
 
@@ -139,14 +168,6 @@ static void dec_ablock_entries(struct dm
 }
 
 /*
- * Each array block can hold this many values.
- */
-static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
-{
-	return (size_of_block - sizeof(struct array_block)) / value_size;
-}
-
-/*
  * Allocate a new array block.  The caller will need to unlock block.
  */
 static int alloc_ablock(struct dm_array_info *info, size_t size_of_block,



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216014;
	b=OcfQWGLkXQhqHbhe2cBrk/2GCR5sKd4HQ/IPicq9o5tq4Ie0th0qQRaDNDMOM/4kll/Z
	 yAEsCdQRVJS0OwwUXC2GhoYl8V/7JI0neNVBgl/BZZ3u/XNLI7rVSJuBk2zMCZgAC0fdM
	 e05IgO4Ybb6HcngKfV3zyvDF2b1b5d5JUsJDfkVyywVIPzwojhhLcqAmEWYJHvG3ApApB
	 qKKXo+gdN5iwVKy6mKjyXgsKgTUMIlySduCrcNOpLF3luMzJeOjDj56kycOEaSobh0SUS
	 rKze/hHx3lNqV51v6YMqupgvilK6d5U/JkhPTj6Bnt6bPCybxJArrT6vVJx/PBoR2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHRuhzD3umGiZLYlMbljcF5e3UMfR8c/dHbsWsJPz9c=;
	b=EsVQWR2FpWrgS/2M0QkP7fmDf6Btm1pR8iVTfPpWGcrRGaDxNjVwt9NB9K11MI9cQ6iX
	 gQDzRspshi4PRJv6DJlBwqwRIPDAIpA24aGuZiW1X0FV3am1xRhwxT5wBl6lTKczwyGzh
	 Jdt5Qx1yzU2ObRJogeir30FAqaEQMOdAGTVMeeudaQiUDnfNP8gmT8NNdEVTDKPPCPvQE
	 gzblqcvFUXDAWISZLcgQ+xEdO5w2SAmetoe+O+eQ1jjPx8oArzSIoWuv5RsiUysrRsSpo
	 Tjmr6y6RXbsvMeXOZfkAlykbbQYAGJsd3sWBGVyGIFfSR9MtJrcX5Ap6nVxFiKOEFGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWGgUIQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B51E606A31D;
	Wed, 28 Oct 2026 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWGgUIQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF021F01825;
	Wed, 28 Oct 2026 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216014;
	bh=BHRuhzD3umGiZLYlMbljcF5e3UMfR8c/dHbsWsJPz9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWGgUIQFglbgokZAMi3quApWKDSdFUysdiKtKidtrg5G3P+U9eW7vtEwiXVO3W+yY
	 T8ZpXJDp4/0yEMJUKTv3e1NLdR5dzxIoVjY3EN3uphrLV2PKxKKpMzlzvWcaq6u7kL
	 NFHQLcadNmPz03YQRSmn4KU4IHSwZn193v9zrjeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1409/1887] dm array: validate array block headers on read
Date: Wed, 28 Oct 2026 17:58:25 +0100
Message-ID: <20261028170531.522564517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 2965787723084835b18dfe993cd450ebf5bd4540 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-array.c | 37 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index a1522d6805d4d..9f85dbcffe3a1 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -37,6 +37,14 @@ struct array_block {
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
 static void array_block_prepare_for_write(struct dm_block_validator *v,
 					  struct dm_block *b,
 					  size_t size_of_block)
@@ -54,6 +62,7 @@ static int array_block_check(struct dm_block_validator *v,
 			     size_t size_of_block)
 {
 	struct array_block *bh_le = dm_block_data(b);
+	uint32_t nr_entries, max_entries, value_size;
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(bh_le->blocknr)) {
@@ -73,6 +82,26 @@ static int array_block_check(struct dm_block_validator *v,
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
 
@@ -137,14 +166,6 @@ static void dec_ablock_entries(struct dm_array_info *info, struct array_block *a
 		on_entries(info, ab, vt->dec);
 }
 
-/*
- * Each array block can hold this many values.
- */
-static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
-{
-	return (size_of_block - sizeof(struct array_block)) / value_size;
-}
-
 /*
  * Allocate a new array block.  The caller will need to unlock block.
  */
-- 
2.53.0




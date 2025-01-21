Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ABC1F5439;
	Tue, 21 Jan 2025 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482796; cv=none; b=EitFQACvbfiTUirQX+Eph0YgKvuzSo946yWxrigHhKBp68W2C5eUA701wOLA/VYjS2puSqsbx6M4ponDQ7GruelDOgyciZirdAFSKKcfNTpefxdJJ34n4bjVvsKDLuI2jQNXzl7hhW7A8pO7k6KT9j/wFpQy9FDVZyIxW4RDARM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482796; c=relaxed/simple;
	bh=W2wg8waDcXUxiw8vW+UWz4/rCEOzGeAsO5knFYpUhhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKJwBDyBRve6Jypv1JHoF06yqw6q6PJZDwz8GxSezO9MiS5s8wMY8kuGkzKTBi5iXY6J7NQBTIO/MOwiLZL4rWcFZN1wUf96Yzy11caYBY84SrlW+6sVHbFtYt7B5eh5SOzbSMsYwiupqFEiU5fUFXFNuMJFUIXhqTaqjn2qpbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tyz9U+u8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tyz9U+u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006DAC4CEE0;
	Tue, 21 Jan 2025 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482794;
	bh=W2wg8waDcXUxiw8vW+UWz4/rCEOzGeAsO5knFYpUhhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tyz9U+u8SzKEtlUPAiIFnZsAghXi2WAxj16rj/QaJ9oUlIyCueoZ37wysyGDflrie
	 666yjKNYa8bvtFtDZDUUyVX6HHlW4q26sb5h2ZHMZKn4uRcd54HFB/Lu0X4CZzOz1M
	 rpmtMhPYRWPMmcLIuRT3vJn4cBNoBgHBKDas4hfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/127] dm array: fix releasing a faulty array block twice in dm_array_cursor_end
Date: Tue, 21 Jan 2025 18:51:15 +0100
Message-ID: <20250121174529.808850073@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit f2893c0804d86230ffb8f1c8703fdbb18648abc8 ]

When dm_bm_read_lock() fails due to locking or checksum errors, it
releases the faulty block implicitly while leaving an invalid output
pointer behind. The caller of dm_bm_read_lock() should not operate on
this invalid dm_block pointer, or it will lead to undefined result.
For example, the dm_array_cursor incorrectly caches the invalid pointer
on reading a faulty array block, causing a double release in
dm_array_cursor_end(), then hitting the BUG_ON in dm-bufio cache_put().

Reproduce steps:

1. initialize a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. wipe the second array block offline

dmsteup remove cache cmeta cdata corig
mapping_root=$(dd if=/dev/sdc bs=1c count=8 skip=192 \
2>/dev/null | hexdump -e '1/8 "%u\n"')
ablock=$(dd if=/dev/sdc bs=1c count=8 skip=$((4096*mapping_root+2056)) \
2>/dev/null | hexdump -e '1/8 "%u\n"')
dd if=/dev/zero of=/dev/sdc bs=4k count=1 seek=$ablock

3. try reopen the cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

Kernel logs:

(snip)
device-mapper: array: array_block_check failed: blocknr 0 != wanted 10
device-mapper: block manager: array validator check failed for block 10
device-mapper: array: get_ablock failed
device-mapper: cache metadata: dm_array_cursor_next for mapping failed
------------[ cut here ]------------
kernel BUG at drivers/md/dm-bufio.c:638!

Fix by setting the cached block pointer to NULL on errors.

In addition to the reproducer described above, this fix can be
verified using the "array_cursor/damaged" test in dm-unit:
  dm-unit run /pdata/array_cursor/damaged --kernel-dir <KERNEL_DIR>

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
Reviewed-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-array.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 3a963d783a86..33bc4b38911a 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -911,23 +911,27 @@ static int load_ablock(struct dm_array_cursor *c)
 	if (c->block)
 		unlock_ablock(c->info, c->block);
 
-	c->block = NULL;
-	c->ab = NULL;
 	c->index = 0;
 
 	r = dm_btree_cursor_get_value(&c->cursor, &key, &value_le);
 	if (r) {
 		DMERR("dm_btree_cursor_get_value failed");
-		dm_btree_cursor_end(&c->cursor);
+		goto out;
 
 	} else {
 		r = get_ablock(c->info, le64_to_cpu(value_le), &c->block, &c->ab);
 		if (r) {
 			DMERR("get_ablock failed");
-			dm_btree_cursor_end(&c->cursor);
+			goto out;
 		}
 	}
 
+	return 0;
+
+out:
+	dm_btree_cursor_end(&c->cursor);
+	c->block = NULL;
+	c->ab = NULL;
 	return r;
 }
 
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E69037F010;
	Sat, 17 Oct 2026 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253167; cv=none; b=B5/+W7C3d5EARaSr0RFGSLlS7N/H0B8UFinRU2jQ//bNsubOSvUH4NJA/8fV4ysIQNOrARPj3V9azOXaNJfq0/JxFwewtCcaHII3T7ZNZ1/v4Rw6MdCw4GljJu/o9u35FIVK86EAOInLr9nWShJRLM2I+0kQGBSqxm6IlPLmzOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253167; c=relaxed/simple;
	bh=t8PObSLzgKicZWt3JW40DBedZHYKstMzw13TvJu86eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfqKQU6rfdmncCT1ZUsysFgM7ei55E6wsWoD7YvXD/8vNNEy3vsa/zb/KWCWKb37Yai/FjcdjqY0NLZb6sn5bxFN+w5cIkB+8k6B7515F9T+7wiRRvY4xEmUctiHGj+dov1RyqKnbu5GJNSBA3cBY7RXRtKqIapEETUdMeroav0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK43IEZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK43IEZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF8C1F000C4;
	Sat, 17 Oct 2026 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253166;
	bh=lTgHp8n6TGrvF6+OTPzEJ79AaXzrwz90Cs0wOD4IWZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qK43IEZOwyDeexnBzZZU9F+AKJ0VwjCLA+GI5hxELqF0Oduef/vzTiNsgNQRscGAS
	 UGXutxYYSSWTgbHEYIk3WBVEGvh7JI5C9vffqnxotKhLJvZxOvtYFsWTCS57+Caa4I
	 9+IN2nT1BD76nACcG5787wsFgwav70BGfTN1ieYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/869] dm-integrity: rename internal_hash
Date: Sat, 17 Oct 2026 17:47:53 +0200
Message-ID: <20261017160037.839148808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit e8a052ee1fb570b8e07f05f65752646eaac74355 ]

Rename "internal_hash" to "internal_shash" and introduce a boolean value
"internal_hash".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Stable-dep-of: 764b683a6180 ("dm-integrity: fix buffer overflow in inline mode with large tag size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 76d0c84380a8c..bdc83a5f583b9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -219,10 +219,11 @@ struct dm_integrity_c {
 	__u8 log2_blocks_per_bitmap_bit;
 
 	unsigned char mode;
+	bool internal_hash;
 
 	int failed;
 
-	struct crypto_shash *internal_hash;
+	struct crypto_shash *internal_shash;
 	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
@@ -1635,11 +1636,11 @@ static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector
 				      const char *data, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
-	SHASH_DESC_ON_STACK(req, ic->internal_hash);
+	SHASH_DESC_ON_STACK(req, ic->internal_shash);
 	int r;
 	unsigned int digest_size;
 
-	req->tfm = ic->internal_hash;
+	req->tfm = ic->internal_shash;
 
 	r = crypto_shash_init(req);
 	if (unlikely(r < 0)) {
@@ -4700,12 +4701,14 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		buffer_sectors = 1;
 	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
 
-	r = get_mac(&ic->internal_hash, &ic->internal_hash_alg, &ti->error,
+	r = get_mac(&ic->internal_shash, &ic->internal_hash_alg, &ti->error,
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
 		goto bad;
-	if (ic->internal_hash)
-		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_hash);
+	if (ic->internal_shash) {
+		ic->internal_hash = true;
+		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_shash);
+	}
 
 	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
 		    "Invalid journal mac", "Error setting journal mac key");
@@ -5239,8 +5242,8 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	if (ic->sb)
 		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
 
-	if (ic->internal_hash)
-		crypto_free_shash(ic->internal_hash);
+	if (ic->internal_shash)
+		crypto_free_shash(ic->internal_shash);
 	free_alg(&ic->internal_hash_alg);
 
 	if (ic->journal_crypt)
-- 
2.53.0




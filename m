Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D4F414A0E;
	Fri,  4 Sep 2026 05:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500113; cv=none; b=hl03UcbBe36u8qIUJnb9+dDDY0QuKjPtMZVzBX2kNcbcBuevs8ftCJaE+Dr8KkVjHk08D4IxWRhhi/ki3IMhu7Kd4rsm5OcKocecrI1voo3PmcpLvwsIRxTwGU8rst/xrrzuTp+OSQ7SRWAnEXT+rcg4r8Ht1d4jCKfDBMB3WJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500113; c=relaxed/simple;
	bh=hElNsTnEaPZZHKSzg2/KZXh0Sx+419BOLGfHDNJSMCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mljUIn4DSASZj5/OWgLMx0fQ5Z4M130Y7NrwoqPxsoTV9P5BvOuC24CIzXtKYRyfQdsWqVVr5VnCeZtEBKklNsmD4qsPhjS6rDB9mga2S9MQb9XVKrzi3w0GaiaoONpMv+JNaVsB2OdiBe7DhvGsXqBl5v0KpejJOu7MjOcaSOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNpj1OVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNpj1OVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D601F00A3D;
	Fri,  4 Sep 2026 05:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500112;
	bh=bH3PXWpRLsX8sAs45XnGRrbaeuTgcHVQRwSXRL2KOtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNpj1OVSyvOYfQl6h87ZmI6XZGX+iLU+iEzIapgzafrl4yt1E4LAwBf0rVg0g+2+A
	 FKb9t4tKtxlzIE2TljTdkt5c4asR8hSmGea4ygmmVpFLA21kws8DwrPLr6/mYq5nGE
	 TrGHAdTjKpCFgKkWxsEQCUDG2e0JFtXqt9sb8Bpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 655/713] dm-pcache: validate kset key_num and intra-segment bounds
Date: Fri,  4 Sep 2026 07:00:23 +0200
Message-ID: <20260904045818.517947585@linuxfoundation.org>
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

commit f11deb032fd84081e7831cffcba895d893054a22 upstream.

Two more fields decoded from the cache device go unbounded. The kset
key_num drives cache_kset_crc() and the replay loop in cache_replay(),
the writeback worker and the GC worker, but only the magic and a
fixed-seed CRC are checked first, so a non-last kset whose key_num exceeds
the PCACHE_KSET_KEYS_MAX buffer reads past its end before the CRC compare.
A key's intra-segment offset and length in cache_key_decode() are taken
verbatim, so a key running past its segment is replayed into the cache
tree and the data CRC check and every later read hit then copy adjacent
persistent memory into the caller's bio -- an out-of-bounds read that
leaks to user space. Both fields are controlled by whoever supplies the
cache device (CAP_SYS_ADMIN); the CRC seed is public.

Add kset_onmedia_valid() to bound key_num before any kset read, and
reject a key whose offset plus length, computed in 64 bits, exceeds the
segment data_size. Valid metadata is unaffected.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.h           |   21 +++++++++++++++++++++
 drivers/md/dm-pcache/cache_gc.c        |    8 ++++----
 drivers/md/dm-pcache/cache_key.c       |   10 +++++++++-
 drivers/md/dm-pcache/cache_writeback.c |    8 ++++----
 4 files changed, 38 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -491,6 +491,27 @@ static inline u32 cache_key_data_crc(str
 	return crc32c(PCACHE_CRC_SEED, data, key->len);
 }
 
+/**
+ * kset_onmedia_valid - Validate a kset header read from the cache device.
+ * @kset_onmedia: Pointer to the kset copied from on-media metadata.
+ *
+ * The magic and CRC are attacker-computable (fixed public seed). A non-last
+ * kset stores key_num keys inline, and cache_kset_crc() and the replay loop
+ * read struct_size(.., data, key_num) bytes from a buffer sized for
+ * PCACHE_KSET_KEYS_MAX keys, so key_num must be bounded before any such use.
+ */
+static inline bool kset_onmedia_valid(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC)
+		return false;
+
+	if (!(kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) &&
+	    kset_onmedia->key_num > PCACHE_KSET_KEYS_MAX)
+		return false;
+
+	return true;
+}
+
 static inline u32 cache_kset_crc(struct pcache_cache_kset_onmedia *kset_onmedia)
 {
 	u32 crc_size;
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -44,11 +44,11 @@ static bool need_gc(struct pcache_cache
 		return false;
 	}
 
-	/* Check if kset_onmedia is corrupted */
-	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
-		pcache_dev_debug(pcache, "gc error: magic is not as expected. key_tail: %u:%u magic: %llx, expected: %llx\n",
+	/* Reject a corrupted or out-of-bounds kset before reading its keys */
+	if (!kset_onmedia_valid(kset_onmedia)) {
+		pcache_dev_debug(pcache, "gc error: invalid kset. key_tail: %u:%u magic: %llx, key_num: %u\n",
 					key_tail->cache_seg->cache_seg_id, key_tail->seg_off,
-					kset_onmedia->magic, PCACHE_KSET_MAGIC);
+					kset_onmedia->magic, kset_onmedia->key_num);
 		return false;
 	}
 
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -97,6 +97,14 @@ int cache_key_decode(struct pcache_cache
 	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
 	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
 
+	if ((u64)key->cache_pos.seg_off + key->len >
+			key->cache_pos.cache_seg->segment.data_size) {
+		pcache_dev_err(pcache, "key seg_off %u + len %u exceeds segment data size %u\n",
+				key->cache_pos.seg_off, key->len,
+				key->cache_pos.cache_seg->segment.data_size);
+		return -EIO;
+	}
+
 	key->seg_gen = key_onmedia->seg_gen;
 	key->flags = key_onmedia->flags;
 
@@ -778,7 +786,7 @@ int cache_replay(struct pcache_cache *ca
 			goto out;
 		}
 
-		if (kset_onmedia->magic != PCACHE_KSET_MAGIC ||
+		if (!kset_onmedia_valid(kset_onmedia) ||
 				kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
 			break;
 		}
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -55,11 +55,11 @@ static inline bool is_cache_clean(struct
 		return true;
 	}
 
-	/* Check if the magic number matches the expected value */
-	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
-		pcache_dev_debug(pcache, "dirty_tail: %u:%u magic: %llx, not expected: %llx\n",
+	/* Reject a corrupted or out-of-bounds kset before reading its keys */
+	if (!kset_onmedia_valid(kset_onmedia)) {
+		pcache_dev_debug(pcache, "dirty_tail: %u:%u invalid kset magic: %llx, key_num: %u\n",
 				dirty_tail->cache_seg->cache_seg_id, dirty_tail->seg_off,
-				kset_onmedia->magic, PCACHE_KSET_MAGIC);
+				kset_onmedia->magic, kset_onmedia->key_num);
 		return true;
 	}
 



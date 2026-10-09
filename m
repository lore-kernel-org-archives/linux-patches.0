Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8763D647A;
	Fri,  9 Oct 2026 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555263; cv=none; b=EPppCetKF1p/LUjDydDycDFKTzmIcJgX+SLbTnkDTlh4zELRIvH6MDCRrZKV2T+i0esP4XhPGABG7N6FleuXo8maPAOspI0AbhSAuV2cMv4tuUlooGDK7oOL+zICd/BsGbWCxnqvCKvDbFe9jtfqXsHO8yoTTI4+uzTDj+GTFv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555263; c=relaxed/simple;
	bh=gcxKE0xquTE1WUP94uE1UyF4KH/LVbzn037ANiSh7hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfOx1otrKaRg30ZswXkXtnlGoefKPX7mobisy9j+yy5grw3Ox1YFOBK7WL3rWZkTjtkCN2cJ9UOo32uFe/8q9aWQ0PUcWEEN4jd2zmACCZRXNWuPev8qFK0by4VA4H3UkSKbTOCbF6gS5sAI4zJ7rS+1YdkqMfES/TBOZ31egE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjWmKnsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjWmKnsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8401B1F00898;
	Fri,  9 Oct 2026 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555251;
	bh=oiY8tBeeEeuXVFmo+KnZq4iRtJUdfkukYoUQKCvKhMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjWmKnsiN582z83wmGSzyYAdMU3mCVzQgJ83BP5kZPGrpocFK3eejH/23YWbHt3lT
	 x4iRnG40agtsaMBnMAWeu0JWBlnS4E15dTVgowIULcR883S37TGdE+QeQkyNm84O5W
	 fwHhsaOJSD6NWgnni4IyNAONpKmEPwhnogGUdUX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 002/428] dm-pcache: bound the logical key offset from persistent memory
Date: Fri,  9 Oct 2026 16:05:39 +0200
Message-ID: <20261009140946.072984072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

[ Upstream commit 97fc4b53dbe4a983fdf093243067fa6a64562307 ]

cache_key_decode() takes a key's logical off from the cache device and
later indexes req_key_tree->subtrees[] by it in get_subtree(). An off
past the device forms a subtree pointer outside the array, which
rb_insert() writes through during replay.

Reject a key of zero length, or whose off+len (computed in 64 bits)
exceeds the device size, before it is used.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-pcache/cache_key.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index 61a71876ca1d1..40afba5f3723b 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -90,10 +90,19 @@ int cache_key_decode(struct pcache_cache *cache,
 			struct pcache_cache_key *key)
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	u64 dev_bytes = (u64)cache->dev_size << SECTOR_SHIFT;
 
 	key->off = key_onmedia->off;
 	key->len = key_onmedia->len;
 
+	if (key_onmedia->len == 0 ||
+	    key_onmedia->len > dev_bytes ||
+	    key_onmedia->off > dev_bytes - key_onmedia->len) {
+		pcache_dev_err(pcache, "key off %llu + len %u exceeds device size\n",
+				key_onmedia->off, key_onmedia->len);
+		return -EIO;
+	}
+
 	if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
 		pcache_dev_err(pcache, "invalid cache_seg_id %u in cache key (n_segs %u)\n",
 				key_onmedia->cache_seg_id, cache->n_segs);
-- 
2.53.0




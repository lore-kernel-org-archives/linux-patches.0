Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A28536728D;
	Sat, 12 Sep 2026 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205828; cv=none; b=NtU+ETKjWvTB3gNhINsDkpSbgJfdTPYXmRaLBmbjvIzewG+YrQNzOv26z/AjNAp3QCdPspxFdYSEPttqqf0O7XgheCYsGF7xUzF7ppbgNBgOLHo+Jjj2ep8LbMt16JOs8TBbojTg1+pXyfkQblAqVAEcXijsPgFPVRQScoOpTgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205828; c=relaxed/simple;
	bh=YKi+HfRLDq4/M/BuRkR8QAcQTG17LYPFXoOkdccK+es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNKcNek/FBSITv1JQ9YwoJQIiYF1OR4weg9iPambSS/4vtA4ruj8qEadzV1MVbmlbZovZ130SV3uTforCMi6XNp/WM7ELOmcicgJ4z0mvtnfdbpTDhhO5lcvZvExacQiV4I0jS+X8NxRRMEPCHme8elh+Yj6odWEOT2OQe+VsXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzSFm8+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzSFm8+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EFE1F000FF;
	Sat, 12 Sep 2026 09:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205827;
	bh=uXysWRCBCNpe1aJMA5Kb9I3VWFie+VdgS5WsfI1CnKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzSFm8+T5Duuo0JcyIFHBoXUfiR0/qw1vxWIiKX3pWGrrSnqfu+ean4tcfRj+ovvs
	 5CMXCSeCXjCfi2AnnnGWvEynvIBFfslNan02bBGzyFCwlKMahFNywyQtvEtBdbHZny
	 me3dKGtOquFdVpHeJNQmqdHlM42fv9oapZ/KR2K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0080/1518] dm-pcache: bound the logical key offset from persistent memory
Date: Sat, 12 Sep 2026 08:37:29 +0200
Message-ID: <20260912065625.266688550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
[ adjusted context to account for the missing cache_seg_id_valid() check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_key.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -90,10 +90,19 @@ int cache_key_decode(struct pcache_cache
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
 	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
 	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
 



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049500;
	b=ArQYfK/o95vCTmXosV48iUVWOhVXyFSAnzqRiMZmBFAuuY3fILlJOQzObbaVwrwaywjg
	 axV2PFn9Eqe9wDZFNtko+Eh0v6KDf0zSaKt3enruBUebeqPen05n70rl3PCeYr5XM+f39
	 zfAGd3dOFfO+72U+zAivoLpUe+k+uaFjCw4YuMO8oUd9qIi/119lvqGILIZVIW2gP6asx
	 xqqrq1UQI4UAxlrMqSB1igytc41PyFihJyBftclsIva5WXPHuyxhv37OmrAi46LPeQTUn
	 dHZdfPDhM3Oja6JjIu5CW0IIOw8G1GHqErDyOMm6ejLGHo3ryMDn8XUpwxLjMYP2EBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ykKEmjqo1iW8lUmukwiPiNPrPDoxVocBXrCv8ShZk64=;
	b=gO1iER4EnLTD2uSLth/EHZ+gYmxsnsk8rLeQPTSZrhzXXNHz+gHB7My2fw+bruC3GCMJ
	 jv4ad9X+g6B/yZHPFzofP6yLZeaRMgCivLM1gg1roMMLwbo9av8ZDIriMXSvs/QOB15jI
	 REMTVLdB22ts1Y4AYxc6wF18VRT3p7ihfjNpNyCfUmf4BDgLWo8QJYBSEw4EScm5jNKwh
	 NHYuGw5O/hWBbt8LzCSHqIP+PQEPMCeJXGg3j5wS01pd1O9mCNHFQH+Bo9mxeo6OSdxLc
	 wmZpx9aoQGqjQdq1JBsQ97M76Hm3jTH825NgkIYOj+IaHp0ig/ALumOIVGxf3ti7gxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIT83e8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F245F606A320;
	Thu, 19 Nov 2026 00:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIT83e8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E97B1F000C4;
	Thu, 19 Nov 2026 00:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049499;
	bh=ykKEmjqo1iW8lUmukwiPiNPrPDoxVocBXrCv8ShZk64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIT83e8VMjRDrxLd/qELy/U0Ln20Bu6uVl/cz72aPpzgLvF/FXnf1bO8PtOTsAvFB
	 D05+cN1au+cA7YrOQeOIfrFHcTKPgpT4qYir5xo0NSdAZU0M3dAJ+nJwI21N6DueNd
	 y/IzhBSsVlPDQnp7mBHOAJEKpzuAVtEV0HWKIroM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2374/2857] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
Date: Wed, 18 Nov 2026 15:56:48 +0100
Message-ID: <20261118150327.000601595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 9bdef63e2b5d4a88810329a1cab3642d6378a895 ]

For DUP and RAID profiles with zones in a mismatching active state, i.e.
due to one of the zones of the block-group being on a conventional
zone, btrfs_zone_activate() has already put the block group on the list.

This leads to a double list add and refcounting problems.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1c4f959923dd4..2f9c6540b2655 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1563,10 +1563,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
-			btrfs_get_block_group(cache);
 			spin_lock(&fs_info->zone_active_bgs_lock);
-			list_add_tail(&cache->active_bg_list,
-				      &fs_info->zone_active_bgs);
+			if (list_empty(&cache->active_bg_list)) {
+				btrfs_get_block_group(cache);
+				list_add_tail(&cache->active_bg_list,
+					      &fs_info->zone_active_bgs);
+			}
 			spin_unlock(&fs_info->zone_active_bgs_lock);
 		}
 	} else {
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9627DF71;
	Mon,  6 Jan 2025 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177967; cv=none; b=YakwHAxzxkj+ms5RVdsDbF1uBg0QjLe6mFetmfXMuu+VzmqA+nt2cKhKsK0JUHCX6/fpIQTEDjWz1WMuQpSzC0yLPviCaE8d3WYBF1Ubpio9trUxnRFd9ZETvxeWf9aUlRvbe0Abe/uQKKUqDoVApg1IUx8sAnnZ/dun2BNoHHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177967; c=relaxed/simple;
	bh=GU3HtvhEsZxhVFqPrIKsIQuNLKVykNK00SKmCfYGbPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsYBnedtqe/ukZNyAi47aXs10pidj9iCvh+MzNtQgdHRvIU9XaK6q54oO38FV32Eeq/aE2BTIJVsfvxdKA/ZUIcDwyquQGf52Ohr16XGZbNkeroS49qKQq4pBJJWM0IdHueI7Yg2sigBAAZVgsS4LrqidI8xUMtg6mqRTIvM5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEw8vDKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEw8vDKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A1FC4CED2;
	Mon,  6 Jan 2025 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177965;
	bh=GU3HtvhEsZxhVFqPrIKsIQuNLKVykNK00SKmCfYGbPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEw8vDKjhQ5evP1eUAu5k9LkXZTHvfT/UBUlLBTberAlERKtGoKDgttJ6TBbySdMr
	 zIbwZ2jx0yXQJRKgr3Yvp+MOh0klK1SDubZIp9UriyZViKrojZj89uBQvGmLotET52
	 OiX1YbWTZjlEIW0bdyhlTEbF/JhMvVTVI9P7Lug4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/156] btrfs: handle bio_split() errors
Date: Mon,  6 Jan 2025 16:16:11 +0100
Message-ID: <20250106151144.934043780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit c7c97ceff98cc459bf5e358e5cbd06fcb651d501 ]

Commit e546fe1da9bd ("block: Rework bio_split() return value") changed
bio_split() so that it can return errors.

Add error handling for it in btrfs_split_bio() and ultimately
btrfs_submit_chunk(). As the bio is not submitted, the bio counter must
be decremented to pair btrfs_bio_counter_inc_blocked().

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 31f96c2d8691..5fd0b39d8c70 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -81,6 +81,9 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 
 	bio = bio_split(&orig_bbio->bio, map_length >> SECTOR_SHIFT, GFP_NOFS,
 			&btrfs_clone_bioset);
+	if (IS_ERR(bio))
+		return ERR_CAST(bio);
+
 	bbio = btrfs_bio(bio);
 	btrfs_bio_init(bbio, fs_info, NULL, orig_bbio);
 	bbio->inode = orig_bbio->inode;
@@ -684,7 +687,8 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 				&bioc, &smap, &mirror_num);
 	if (error) {
 		ret = errno_to_blk_status(error);
-		goto fail;
+		btrfs_bio_counter_dec(fs_info);
+		goto end_bbio;
 	}
 
 	map_length = min(map_length, length);
@@ -692,7 +696,15 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		map_length = btrfs_append_map_length(bbio, map_length);
 
 	if (map_length < length) {
-		bbio = btrfs_split_bio(fs_info, bbio, map_length);
+		struct btrfs_bio *split;
+
+		split = btrfs_split_bio(fs_info, bbio, map_length);
+		if (IS_ERR(split)) {
+			ret = errno_to_blk_status(PTR_ERR(split));
+			btrfs_bio_counter_dec(fs_info);
+			goto end_bbio;
+		}
+		bbio = split;
 		bio = &bbio->bio;
 	}
 
@@ -766,6 +778,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 
 		btrfs_bio_end_io(remaining, ret);
 	}
+end_bbio:
 	btrfs_bio_end_io(bbio, ret);
 	/* Do not submit another chunk */
 	return true;
-- 
2.39.5




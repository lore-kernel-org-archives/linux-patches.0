Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BD217BED0;
	Sat, 17 Oct 2026 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253801; cv=none; b=eKF45CFEAqdASucx71c+HTbhw3EeBiAupebUsk92jWvhk0S6KhSx9sp68UUSQEmoyOAVL0wSoZV7iQJiVsCDbroV6KTN/2/E3VCUkBs4eQw8fw3wo4mxH1gxeTQw61959WYxwJTLunqUuBh097zcuiQtF0bsSbHYWzqcwxboyL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253801; c=relaxed/simple;
	bh=1o/ZSwxp4sX6vH7OMyzwRocngGVat8USeUivW2vxmGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQHLxspESiqE4RawUy/IoiTU3xXWktfGRF7UL6TYSncrAhvhfeeNLeJjSbGFTZqr807CH1Nm091HwwVoQTPuU/LeZnXpmq+0t93XctNbj9XbJNKrwrb+8QF/+bjW4wQWrZkXMMajCrQCNYBPsDSjKPht9iJsukjPXxQsrQeDvPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJwdLrtL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJwdLrtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8761F000C4;
	Sat, 17 Oct 2026 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253800;
	bh=PiWfO/YtgJcF6+JpAKqRixVunzbhizOTpoiO5joUKl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJwdLrtLfwniogAkbttHiykR06Pl6N+6tFAeFfZT0OkblaUBfjfhibwvcwONV4AdO
	 3PCX63N5MpOUkrFxn0HagZ7iTgJsSChYSjnNb/OC3CS0ZIpDAMP57xG8YVp8eHZ3yE
	 uLxALWL+YT3HGCvCbgdEasUlTb3uJ+uiKVBjfisY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/869] btrfs: tree-log: dont use token set/get accessors in fill_inode_item()
Date: Sat, 17 Oct 2026 17:51:17 +0200
Message-ID: <20261017160043.106653759@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit c418a1504540c6678279b965ea73fe61621faa65 ]

The token versions of set/get accessors will be removed, use the normal
helpers.

There's additional overhead of the token helpers that update the cached
address in case it moves to another page/folio. The normal versions
don't need to do that.

Note this is similar to fill_inode_item() in inode.c but with slight
differences. The two functions could be deduplicated eventually.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 5254d4181add ("btrfs: fix zero size inode with non-zero size after log replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 48 ++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 983771a2a4568..ab036ef65fdc8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4276,44 +4276,34 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct inode *inode, int log_inode_only,
 			    u64 logged_isize)
 {
-	struct btrfs_map_token token;
 	u64 flags;
 
-	btrfs_init_map_token(&token, leaf);
-
 	if (log_inode_only) {
 		/* set the generation to zero so the recover code
 		 * can tell the difference between an logging
 		 * just to say 'this inode exists' and a logging
 		 * to say 'update this inode with these values'
 		 */
-		btrfs_set_token_inode_generation(&token, item, 0);
-		btrfs_set_token_inode_size(&token, item, logged_isize);
+		btrfs_set_inode_generation(leaf, item, 0);
+		btrfs_set_inode_size(leaf, item, logged_isize);
 	} else {
-		btrfs_set_token_inode_generation(&token, item,
-						 BTRFS_I(inode)->generation);
-		btrfs_set_token_inode_size(&token, item, inode->i_size);
+		btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
+		btrfs_set_inode_size(leaf, item, inode->i_size);
 	}
 
-	btrfs_set_token_inode_uid(&token, item, i_uid_read(inode));
-	btrfs_set_token_inode_gid(&token, item, i_gid_read(inode));
-	btrfs_set_token_inode_mode(&token, item, inode->i_mode);
-	btrfs_set_token_inode_nlink(&token, item, inode->i_nlink);
+	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
+	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
+	btrfs_set_inode_mode(leaf, item, inode->i_mode);
+	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
 
-	btrfs_set_token_timespec_sec(&token, &item->atime,
-				     inode_get_atime_sec(inode));
-	btrfs_set_token_timespec_nsec(&token, &item->atime,
-				      inode_get_atime_nsec(inode));
+	btrfs_set_timespec_sec(leaf, &item->atime, inode_get_atime_sec(inode));
+	btrfs_set_timespec_nsec(leaf, &item->atime, inode_get_atime_nsec(inode));
 
-	btrfs_set_token_timespec_sec(&token, &item->mtime,
-				     inode_get_mtime_sec(inode));
-	btrfs_set_token_timespec_nsec(&token, &item->mtime,
-				      inode_get_mtime_nsec(inode));
+	btrfs_set_timespec_sec(leaf, &item->mtime, inode_get_mtime_sec(inode));
+	btrfs_set_timespec_nsec(leaf, &item->mtime, inode_get_mtime_nsec(inode));
 
-	btrfs_set_token_timespec_sec(&token, &item->ctime,
-				     inode_get_ctime_sec(inode));
-	btrfs_set_token_timespec_nsec(&token, &item->ctime,
-				      inode_get_ctime_nsec(inode));
+	btrfs_set_timespec_sec(leaf, &item->ctime, inode_get_ctime_sec(inode));
+	btrfs_set_timespec_nsec(leaf, &item->ctime, inode_get_ctime_nsec(inode));
 
 	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
@@ -4327,13 +4317,13 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	 * inode item in subvolume tree as needed (see overwrite_item()).
 	 */
 
-	btrfs_set_token_inode_sequence(&token, item, inode_peek_iversion(inode));
-	btrfs_set_token_inode_transid(&token, item, trans->transid);
-	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
+	btrfs_set_inode_sequence(leaf, item, inode_peek_iversion(inode));
+	btrfs_set_inode_transid(leaf, item, trans->transid);
+	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	flags = btrfs_inode_combine_flags(BTRFS_I(inode)->flags,
 					  BTRFS_I(inode)->ro_flags);
-	btrfs_set_token_inode_flags(&token, item, flags);
-	btrfs_set_token_inode_block_group(&token, item, 0);
+	btrfs_set_inode_flags(leaf, item, flags);
+	btrfs_set_inode_block_group(leaf, item, 0);
 }
 
 static int log_inode_item(struct btrfs_trans_handle *trans,
-- 
2.53.0




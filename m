Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEDA394783;
	Tue, 21 Jul 2026 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665104; cv=none; b=GiF//h4/vtf/+W7zgBwQAClQzlDPjZ5PDN6bGMICwU7ex1LLd14OH6MOHJdgthXcamZSg3EB231m1QfjZjaYgqUspmI2KlYoJgXUI5yaHT9GfULCD5sJezQk0peI1zl/z8yKibDMCPyjBKm1qpDkm8hohDy4dQQuFtnihq2DbrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665104; c=relaxed/simple;
	bh=szfEjglFzBxVeGN7viCipBfj+gI51r9bFGowJmNDioc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+ULMxYON4iiBerYi8Qy508BYAPeR+g6VYfUU0cgf5KjUgQYbjlAc+fSrd4NpsRtE/r1z8jkO92T3sZ6sNLoPv9bKCtaLFrO8vTTQZP2mbTHYXnP0/dKKlysYz1GF/IcRFYroAgjE3BtzJhpTZGrTrQ3KOzyb9eBlQGtYhzK7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJKWfVoe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJKWfVoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3B01F000E9;
	Tue, 21 Jul 2026 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665103;
	bh=bpJX99Cn+phsPia/wxssOFLFq5S2RhIKoTnPzEe43hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJKWfVoefDGA71kACZoq+Xo3r/9z6E5Dln0bQ/zX+gm/asYvHPO64ftomQ4K4qPSm
	 3Jm92zRSSsTHp2rtQRCrSTyIeP1FRgm1AwWwLrE91UYRDxK/wugg7Whp7VurY924Ew
	 Q6qWpn3tXRCLT0NaS9+dwLgfgc46hBLYrzKDlF9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0176/1266] fs/ntfs3: handle attr_set_size() errors when truncating files
Date: Tue, 21 Jul 2026 17:10:13 +0200
Message-ID: <20260721152445.745047715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 576248a34b927e93b2fd3fff7df735ba73ad7d01 ]

If attr_set_size() fails while truncating down, the error is silently
ignored and the inode may be left in an inconsistent state.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 89e35825c5c49d..3eee810c69e2f7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -371,8 +371,8 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	int err, dirty = 0;
 	u64 new_valid;
+	int err;
 
 	if (!S_ISREG(inode->i_mode))
 		return 0;
@@ -388,7 +388,6 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 	}
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
-
 	truncate_setsize(inode, new_size);
 
 	ni_lock(ni);
@@ -402,20 +401,19 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 		ni->i_valid = new_valid;
 
 	ni_unlock(ni);
+	if (unlikely(err))
+		return err;
 
 	ni->std_fa |= FILE_ATTRIBUTE_ARCHIVE;
 	inode->i_mtime = inode_set_ctime_current(inode);
 	if (!IS_DIRSYNC(inode)) {
-		dirty = 1;
+		mark_inode_dirty(inode);
 	} else {
 		err = ntfs_sync_inode(inode);
 		if (err)
 			return err;
 	}
 
-	if (dirty)
-		mark_inode_dirty(inode);
-
 	/*ntfs_flush_inodes(inode->i_sb, inode, NULL);*/
 
 	return 0;
-- 
2.53.0




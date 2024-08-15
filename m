Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0B71714D0;
	Thu, 15 Aug 2024 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728736; cv=none; b=Zwm3Qa1ZSDVjyzPhErJbPjMHmYy8qXtIihReN9huFhlh0KYYyGc2J1JdEjK40Q0mptsmsPsc4Fpn6wW6DJkKMINWIQnaECn1vpN0ijJ3fVQKcggQci6quK9K0DQnfEkwogdKLv9fOH8247bWL0EQxYACYQTCwHB5O1c0PFcPdm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728736; c=relaxed/simple;
	bh=gHTYCWXrn0rmtoM3Z+ImNjGdB7dKPfgFqwAXl7i/PWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7ee805Zlh6ZN/qv0xNc0FNFYA47JDv+EWGO0IpuDiWJI6x97sDycKq8Hj13Z6D1H/WChjnQmdqiKNytdElQEAMLsu2eCDnDOrpK2HYVoG+BA5zStUbX0vvFu6cr4ZHvvEQpTk8V/0vW3EEDuL69Do5Gbez3rfHFV2vCZQSce0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urOqXlSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urOqXlSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60000C32786;
	Thu, 15 Aug 2024 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728736;
	bh=gHTYCWXrn0rmtoM3Z+ImNjGdB7dKPfgFqwAXl7i/PWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urOqXlSkqGaEuQ6NwUdIgEo5lm/mKPpVHcGP+H9FqnH0Q+qBpwFaaTZnt7sqiBeS2
	 vh2OGJaR0+tcBHrKPLQ9HOOaTwQ1w+cSdIH42ZjHrqR7YJzcm7Dn+nrW0WVh+dTMgl
	 h9k2IlqQTff5o2mr2DJOd1YYTVvn6owVodjg3cVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 094/196] nilfs2: handle inconsistent state in nilfs_btnode_create_block()
Date: Thu, 15 Aug 2024 15:23:31 +0200
Message-ID: <20240815131855.679080744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 4811f7af6090e8f5a398fbdd766f903ef6c0d787 upstream.

Syzbot reported that a buffer state inconsistency was detected in
nilfs_btnode_create_block(), triggering a kernel bug.

It is not appropriate to treat this inconsistency as a bug; it can occur
if the argument block address (the buffer index of the newly created
block) is a virtual block number and has been reallocated due to
corruption of the bitmap used to manage its allocation state.

So, modify nilfs_btnode_create_block() and its callers to treat it as a
possible filesystem error, rather than triggering a kernel bug.

Link: https://lkml.kernel.org/r/20240725052007.4562-1-konishi.ryusuke@gmail.com
Fixes: a60be987d45d ("nilfs2: B-tree node cache")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=89cc4f2324ed37988b60
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/btnode.c |   25 ++++++++++++++++++++-----
 fs/nilfs2/btree.c  |    4 ++--
 2 files changed, 22 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -51,12 +51,21 @@ nilfs_btnode_create_block(struct address
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
 		     buffer_dirty(bh))) {
-		brelse(bh);
-		BUG();
+		/*
+		 * The block buffer at the specified new address was already
+		 * in use.  This can happen if it is a virtual block number
+		 * and has been reallocated due to corruption of the bitmap
+		 * used to manage its allocation state (if not, the buffer
+		 * clearing of an abandoned b-tree node is missing somewhere).
+		 */
+		nilfs_error(inode->i_sb,
+			    "state inconsistency probably due to duplicate use of b-tree node block address %llu (ino=%lu)",
+			    (unsigned long long)blocknr, inode->i_ino);
+		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
 	bh->b_bdev = inode->i_sb->s_bdev;
@@ -67,6 +76,12 @@ nilfs_btnode_create_block(struct address
 	unlock_page(bh->b_page);
 	put_page(bh->b_page);
 	return bh;
+
+failed:
+	unlock_page(bh->b_page);
+	put_page(bh->b_page);
+	brelse(bh);
+	return ERR_PTR(-EIO);
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
@@ -224,8 +239,8 @@ retry:
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
-	if (!nbh)
-		return -ENOMEM;
+	if (IS_ERR(nbh))
+		return PTR_ERR(nbh);
 
 	BUG_ON(nbh == obh);
 	ctxt->newbh = nbh;
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -63,8 +63,8 @@ static int nilfs_btree_get_new_block(con
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
-	if (!bh)
-		return -ENOMEM;
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 
 	set_buffer_nilfs_volatile(bh);
 	*bhp = bh;



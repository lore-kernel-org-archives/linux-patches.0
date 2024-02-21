Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13B478B7C;
	Wed, 21 Feb 2024 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523342; cv=none; b=BVTrE44iWyNOSdbHS+fU66SDfGZzh7tcVC+EfNkja0cPE0wTb7aKC81udOpn1A55bb+KGXP+de2hJwFpZBVs0/1z+Y1W1r2EtWv3OKX/syDsW0J6O5qIpJLI0d5i6Tolu1TCFejyhAnH3yTLgTgO+Af5pAICMuh83DmQF0VM+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523342; c=relaxed/simple;
	bh=gOXAgDxea0uTHDji1qz7Q7OtiOxO8VdOwKeuwLeZwsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo0c50kv+D9Qq8rCwBcS5gqF3pQUqouNChPG8rhCVgeYsCNaKXwkyolRWa518mDbb77dwY2mS9tiZSgYAs8tAVA4KTbTluTvHSbwfXwJE7SXj6Tz7vEqwcd4H/582cwI5ObI0zs04+1sG0gJdUk3HiaQ8MTzfPlgG+SqTn+HqTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVoyU/S2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVoyU/S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A546C433F1;
	Wed, 21 Feb 2024 13:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523342;
	bh=gOXAgDxea0uTHDji1qz7Q7OtiOxO8VdOwKeuwLeZwsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVoyU/S2oZtEENRheYNnDcXPbFht22ktntGomKnyP6fN+SwwPsFaRjOakIv7MBibw
	 I6kmCgPdJ8t6sMDz+JsnseA5KXzOWNum0w7VTjxTsTApfVqSC1IjBvBQ2ndwALolhp
	 rmtDiJRXr5JWfa3Uftr52o4J6J51uTMTRlBoA2vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 407/476] nilfs2: fix data corruption in dsync block recovery for small block sizes
Date: Wed, 21 Feb 2024 14:07:38 +0100
Message-ID: <20240221130023.049012006@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 67b8bcbaed4777871bb0dcc888fb02a614a98ab1 upstream.

The helper function nilfs_recovery_copy_block() of
nilfs_recovery_dsync_blocks(), which recovers data from logs created by
data sync writes during a mount after an unclean shutdown, incorrectly
calculates the on-page offset when copying repair data to the file's page
cache.  In environments where the block size is smaller than the page
size, this flaw can cause data corruption and leak uninitialized memory
bytes during the recovery process.

Fix these issues by correcting this byte offset calculation on the page.

Link: https://lkml.kernel.org/r/20240124121936.10575-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/recovery.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -472,9 +472,10 @@ static int nilfs_prepare_segment_for_rec
 
 static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 				     struct nilfs_recovery_block *rb,
-				     struct page *page)
+				     loff_t pos, struct page *page)
 {
 	struct buffer_head *bh_org;
+	size_t from = pos & ~PAGE_MASK;
 	void *kaddr;
 
 	bh_org = __bread(nilfs->ns_bdev, rb->blocknr, nilfs->ns_blocksize);
@@ -482,7 +483,7 @@ static int nilfs_recovery_copy_block(str
 		return -EIO;
 
 	kaddr = kmap_atomic(page);
-	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
+	memcpy(kaddr + from, bh_org->b_data, bh_org->b_size);
 	kunmap_atomic(kaddr);
 	brelse(bh_org);
 	return 0;
@@ -521,7 +522,7 @@ static int nilfs_recover_dsync_blocks(st
 			goto failed_inode;
 		}
 
-		err = nilfs_recovery_copy_block(nilfs, rb, page);
+		err = nilfs_recovery_copy_block(nilfs, rb, pos, page);
 		if (unlikely(err))
 			goto failed_page;
 



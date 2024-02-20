Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D0F151CD0;
	Tue, 20 Feb 2024 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463154; cv=none; b=oXYr8HwX0po48K3UuBkvYEpvishsQFfku68snfMK2btUdJxngkePAcHqL3/mU9tq1qTN5vMeWQ9hwLLv6PRuNEOFyYqDQ+bruvwTQciSnTR922L9eGjS18Nex+GSFpDPfzj3qYQKFalbPvMLOi8NDBv0GffvfvfiYPa+HLLHId8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463154; c=relaxed/simple;
	bh=kBBk7IWp6eKTFnt1xCpYqUCS/udjQWisW7dGwYTCXec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGHBmE6etXcISrB8d9Xr75Okk5XY8Z21stR1y7Y1/616hEJ0UdTf1yImKq/ZKxZEWnm/fFCSP/NqucRZOrMpFhhbVqJ9UVWcP8ceWIH6YWNTKYpPRaX8GE79iplP9hX9aJqm97/3tSFJhLMDRD5KylyK4Z9wuGdV/qTMqiBJC8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDrkK0Yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDrkK0Yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89509C433F1;
	Tue, 20 Feb 2024 21:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463154;
	bh=kBBk7IWp6eKTFnt1xCpYqUCS/udjQWisW7dGwYTCXec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDrkK0Yum6lrFmrGAFZDfzerdoEpLaW4n0De61in71G/MLIlW0HRm7pwIfxfirPZW
	 FQ9vQDuIlToeE4/pb3BBBSMTPXg+Yb85W1kdEJwEKeCiizX2pslQo8RFl8IMhdpt03
	 aPqsKrsKysC/rbnwk6oHFao8gjhlNizGd6+6EA7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 135/197] nilfs2: fix data corruption in dsync block recovery for small block sizes
Date: Tue, 20 Feb 2024 21:51:34 +0100
Message-ID: <20240220204845.111486478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F742374C4;
	Tue,  8 Apr 2025 11:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110804; cv=none; b=X3MCVqLfwJYzHDfo/E7Vg3aQYbDl93OdGZ1tXJQkuFWDr7TySNQi67fOU2k5bITxmDmq188OxvhZv87pM4KSAfk4beiIw1f3X1joSD6rFEr+vKvluyWsIqRHi7CVgYxh86AIIAHNSQBW1GPKIwHlDj+ifkUAzADqZnJcCejmOgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110804; c=relaxed/simple;
	bh=NxtR6cM7KRL/fSRQU5XFiXzvHY720pghASysugAQb2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D74YPa9AUE50D9mxr15tWFjBTTYqDp1PoP9Qd4zwTjTM/T3naBawA09g2U/L8TrzvL0aU4eXXGf1TMeVjTSrrkktUJelk6bqPnrbEDqBGS4Nl8MqziqX46w54aLctz3fUw/7KZJLUiCmYTdxEELx3J3D1pJ0rd2VAvBZ9pTkwAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol/ViC6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol/ViC6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD4C4CEE5;
	Tue,  8 Apr 2025 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110804;
	bh=NxtR6cM7KRL/fSRQU5XFiXzvHY720pghASysugAQb2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ol/ViC6/t9lzUzM5lZbTqiJ4A3qICzXER8On+xmXtq+5Eq8yuLAGNE126j9M7ooZ+
	 1ZIiCM0d4TcWdSvwyXITNGaqI0bG8FPtBT5j/j58x7Y/n3P86yQXgxNeY0GtImyOVh
	 8q3S63JYgdJw8+BCOPnAeqRDQOx5zuZBj3rc8Wlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 199/731] jbd2: fix off-by-one while erasing journal
Date: Tue,  8 Apr 2025 12:41:36 +0200
Message-ID: <20250408104918.908249208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 18aba2adb3e2a676fff0d81e51f5045f3c636666 ]

In __jbd2_journal_erase(), the block_stop parameter includes the last
block of a contiguous region; however, the calculation of byte_stop is
incorrect, as it does not account for the bytes in that last block.
Consequently, the page cache is not cleared properly, which occasionally
causes the ext4/050 test to fail.

Since block_stop operates on inclusion semantics, it involves repeated
increments and decrements by 1, significantly increasing the complexity
of the calculations. Optimize the calculation and fix the incorrect
byte_stop by make both block_stop and byte_stop to use exclusion
semantics.

This fixes a failure in fstests ext4/050.

Fixes: 01d5d96542fd ("ext4: add discard/zeroout flags to journal flush")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250217065955.3829229-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index d8084b31b3610..49a9e99cbc03d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1965,17 +1965,15 @@ static int __jbd2_journal_erase(journal_t *journal, unsigned int flags)
 			return err;
 		}
 
-		if (block_start == ~0ULL) {
-			block_start = phys_block;
-			block_stop = block_start - 1;
-		}
+		if (block_start == ~0ULL)
+			block_stop = block_start = phys_block;
 
 		/*
 		 * last block not contiguous with current block,
 		 * process last contiguous region and return to this block on
 		 * next loop
 		 */
-		if (phys_block != block_stop + 1) {
+		if (phys_block != block_stop) {
 			block--;
 		} else {
 			block_stop++;
@@ -1994,11 +1992,10 @@ static int __jbd2_journal_erase(journal_t *journal, unsigned int flags)
 		 */
 		byte_start = block_start * journal->j_blocksize;
 		byte_stop = block_stop * journal->j_blocksize;
-		byte_count = (block_stop - block_start + 1) *
-				journal->j_blocksize;
+		byte_count = (block_stop - block_start) * journal->j_blocksize;
 
 		truncate_inode_pages_range(journal->j_dev->bd_mapping,
-				byte_start, byte_stop);
+				byte_start, byte_stop - 1);
 
 		if (flags & JBD2_JOURNAL_FLUSH_DISCARD) {
 			err = blkdev_issue_discard(journal->j_dev,
@@ -2013,7 +2010,7 @@ static int __jbd2_journal_erase(journal_t *journal, unsigned int flags)
 		}
 
 		if (unlikely(err != 0)) {
-			pr_err("JBD2: (error %d) unable to wipe journal at physical blocks %llu - %llu",
+			pr_err("JBD2: (error %d) unable to wipe journal at physical blocks [%llu, %llu)",
 					err, block_start, block_stop);
 			return err;
 		}
-- 
2.39.5




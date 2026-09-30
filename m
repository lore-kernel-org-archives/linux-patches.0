Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183945304B2;
	Wed, 30 Sep 2026 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790663; cv=none; b=rAedVvAW0sQfKGKXgJDa0WpBK+YtEuICIslBY0iy+KvO6R/RVh2f20A66vaTjxF4h1D/G76Dzi2R+b7yYU/icJRa1U6TQOf6Cr1nwleeMA29zAgHBtM0TyR4YJ7stTxj6MkjGc2XxY7PDeYDzDbw8Q727swNKnraTpx9fMz/C2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790663; c=relaxed/simple;
	bh=mB0OXHveAumeuO7sNqME+qNKrI0aQhhL263px1olaWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llmncOK3BTaVP3IoqsMJpZTFW2s+3u71K20BMUJ1Pr7zThXgPLJmLJiYKAjHgYMJ9sdrPhYosHlYE6ajrbe+OmAUHXVT53mREwXJiX+jjcE8YPR+W+ekP4EENNi1yNbRanT3gQzO6++ZLiTVbgffkjwZpO8/RnBeVTy5rLtrDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFULiC6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFULiC6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F511F000FF;
	Wed, 30 Sep 2026 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790661;
	bh=3RHXZWllbXf9Iil9foU72+Q7Eji5JKDvIAghSXZ7HcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFULiC6aPogGI1gtuDb8tvGMoF+YxVtp8fHEXpTuwe+XhiJbFng8jlaNkVFD+U/qT
	 wG8lyWMpcssQQco1p6PqxP557CxlC2QfcPQfTFHaZhjfwnYu5Kd15Hofsy85K4R1HG
	 gQFuKg0+rGekiD53/uK509Rp5+4Ohe96VCwHplhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/752] hfsplus: fix issue of direct writes beyond end-of-file
Date: Wed, 30 Sep 2026 17:17:56 +0200
Message-ID: <20260930152358.280946483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 5f63ac80aef2ee6bb58eab62e98c264774872da6 ]

The xfstests' test-case generic/729 fails with error:

sudo ./check generic/729
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #36 SMP PREEMPT_DYNAMIC Fri Apr 17 12:40:51 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/729  23s ... [failed, exit status 1]- output mismatch

mmap-rw-fault: /mnt/test/mmap-rw-fault.tmp: Input/output error

The hfsplus_get_block() only allows creating the next
sequential block. It returns -EIO for direct writes
beyond EOF. This patch waits for any in-flight DIO on the inode
to finish. Then, it extends the file by calling
generic_cont_expand_simple() with the goal to guarantee
that blockdev_direct_IO() finds all needed blocks
already reachable sequentially. And, finally, it flushes and
invalidates the DIO range again so the page cache is clean
before the direct write begins.

sudo ./check generic/729
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #40 SMP PREEMPT_DYNAMIC Thu Apr 16 15:41:03 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/729  23s ...  32s
Ran: generic/729
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/210
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260417214940.2735557-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 4310b9105d0fa..840729acb9bcc 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -129,9 +129,44 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
+	loff_t isize;
 	size_t count = iov_iter_count(iter);
+	loff_t end = iocb->ki_pos + count;
 	ssize_t ret;
 
+	/*
+	 * The hfsplus_get_block() only allows creating the next sequential block.
+	 * For direct writes beyond EOF, expand the file first.
+	 */
+	if (iov_iter_rw(iter) == WRITE && iocb->ki_pos > i_size_read(inode)) {
+		loff_t start_off, end_off;
+		loff_t start_page, end_page;
+
+		isize = i_size_read(inode);
+
+		/*
+		 * Wait for any in-flight DIO on this inode to finish before
+		 * calling generic_cont_expand_simple().
+		 */
+		inode_dio_wait(inode);
+
+		ret = generic_cont_expand_simple(inode, iocb->ki_pos);
+		if (ret)
+			return ret;
+
+		start_off = isize;
+		end_off = (end > 0) ? end - 1 : end;
+
+		ret = filemap_write_and_wait_range(mapping, start_off, end_off);
+		if (ret)
+			return ret;
+
+		start_page = start_off >> PAGE_SHIFT;
+		end_page = end_off >> PAGE_SHIFT;
+
+		invalidate_inode_pages2_range(mapping, start_page, end_page);
+	}
+
 	ret = blockdev_direct_IO(iocb, inode, iter, hfsplus_get_block);
 
 	/*
@@ -139,8 +174,7 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	 * blocks outside i_size. Trim these off again.
 	 */
 	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
-		loff_t isize = i_size_read(inode);
-		loff_t end = iocb->ki_pos + count;
+		isize = i_size_read(inode);
 
 		if (end > isize)
 			hfsplus_write_failed(mapping, end);
-- 
2.53.0




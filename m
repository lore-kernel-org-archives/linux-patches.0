Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BA4330B36;
	Fri, 17 Oct 2025 15:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716621; cv=none; b=r71tAMDdg+dyZEsu5fZHUvYat01BCL/9sv8dM9I8m+8EAdIEetNWucpm4cPBv3cQ6p+pvrzbxJiZ3ZaClaWCc13vo2wnamS6LfQMG2wkKgxqHkeyC3juRvVZCTNM3//4lMclYvluVPfoQDF9+mIcmiolvuWUAtfXN/JeVrpa5Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716621; c=relaxed/simple;
	bh=msU9vuifxP/R67luoj3DemoXevf6Wol7OY+5/efZNmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ag4B0JySUyY4GlhK7KT0ZyUDNARSG4HV8UXS53BP6m0cLmAY0M2BiBkEs/Fxpx4yx9H9agxdmILf8UzFOaZ0vW8rKpXrrtY9OhbOAK1Cov1hOJ/4lt4ZA8tnQgWBmha7v8/trO2aQTo5bQE/Ma4/cqXQjhU0PkrOFYVgWBASR9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=divyBtHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="divyBtHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FF9C4CEE7;
	Fri, 17 Oct 2025 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716620;
	bh=msU9vuifxP/R67luoj3DemoXevf6Wol7OY+5/efZNmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=divyBtHgqpNpPlRNLJskYWkd35MzxYstbeHGkH/GO1/ykzaYgMEpQSCENsX8R01/7
	 vdFuO7DlT+9fbFexj7ZfTUnHfpJQyHKgUbHhn59Y5FlkvmD2C3+y+PSAiK5b/c1V+v
	 /31N6fP9HLA50lbu27CujDoQK12vpJECiiwhs4Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 220/276] ext4: increase i_disksize to offset + len in ext4_update_disksize_before_punch()
Date: Fri, 17 Oct 2025 16:55:13 +0200
Message-ID: <20251017145150.494441206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Sun <sunyongjian1@huawei.com>

commit 9d80eaa1a1d37539224982b76c9ceeee736510b9 upstream.

After running a stress test combined with fault injection,
we performed fsck -a followed by fsck -fn on the filesystem
image. During the second pass, fsck -fn reported:

Inode 131512, end of extent exceeds allowed value
	(logical block 405, physical block 1180540, len 2)

This inode was not in the orphan list. Analysis revealed the
following call chain that leads to the inconsistency:

                             ext4_da_write_end()
                              //does not update i_disksize
                             ext4_punch_hole()
                              //truncate folio, keep size
ext4_page_mkwrite()
 ext4_block_page_mkwrite()
  ext4_block_write_begin()
    ext4_get_block()
     //insert written extent without update i_disksize
journal commit
echo 1 > /sys/block/xxx/device/delete

da-write path updates i_size but does not update i_disksize. Then
ext4_punch_hole truncates the da-folio yet still leaves i_disksize
unchanged(in the ext4_update_disksize_before_punch function, the
condition offset + len < size is met). Then ext4_page_mkwrite sees
ext4_nonda_switch return 1 and takes the nodioread_nolock path, the
folio about to be written has just been punched out, and it’s offset
sits beyond the current i_disksize. This may result in a written
extent being inserted, but again does not update i_disksize. If the
journal gets committed and then the block device is yanked, we might
run into this. It should be noted that replacing ext4_punch_hole with
ext4_zero_range in the call sequence may also trigger this issue, as
neither will update i_disksize under these circumstances.

To fix this, we can modify ext4_update_disksize_before_punch to
increase i_disksize to min(i_size, offset + len) when both i_size and
(offset + len) are greater than i_disksize.

Cc: stable@kernel.org
Signed-off-by: Yongjian Sun <sunyongjian1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Message-ID: <20250911133024.1841027-1-sunyongjian@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3906,7 +3906,11 @@ int ext4_can_truncate(struct inode *inod
  * We have to make sure i_disksize gets properly updated before we truncate
  * page cache due to hole punching or zero range. Otherwise i_disksize update
  * can get lost as it may have been postponed to submission of writeback but
- * that will never happen after we truncate page cache.
+ * that will never happen if we remove the folio containing i_size from the
+ * page cache. Also if we punch hole within i_size but above i_disksize,
+ * following ext4_page_mkwrite() may mistakenly allocate written blocks over
+ * the hole and thus introduce allocated blocks beyond i_disksize which is
+ * not allowed (e2fsck would complain in case of crash).
  */
 int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 				      loff_t len)
@@ -3917,9 +3921,11 @@ int ext4_update_disksize_before_punch(st
 	loff_t size = i_size_read(inode);
 
 	WARN_ON(!inode_is_locked(inode));
-	if (offset > size || offset + len < size)
+	if (offset > size)
 		return 0;
 
+	if (offset + len < size)
+		size = offset + len;
 	if (EXT4_I(inode)->i_disksize >= size)
 		return 0;
 



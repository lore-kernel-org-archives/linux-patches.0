Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100CA3370E0;
	Fri, 17 Oct 2025 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713432; cv=none; b=KsiGVE1M8ginuCzKbwRT5qJ3ekZnZmzn5vGA80a2Wf1eQV8AyjZtZDwpSRPZ5rZ2tredhISVJvRCBYF10EMKvNZrL4vXoyI8gnK+yx/orCXz1aethAca6+YXcStAoEy6cIbNmaPOe1FV333pmrcZMStBaHAmmtHRk7gBNfjxkZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713432; c=relaxed/simple;
	bh=xoODPbniTobvfUhspqbP85L4zH3vBC7VfvVlPSjSXIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvQ9Hau+c4iV+/vuddSNMZ+fx2FxQY+dGIQtsamNE1lzXaT/imd7Go86EiPjVTqC7/eL1J6rwHwoZ39gJPFUJSH07X3EJJhTFRqKvcrdx6qC37YLmCfwhpII7kWHUBrPQAWtsN2ZIZQKvsGndg+c903vHJEntX7MVRZ+co34GI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/M4ibiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/M4ibiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F073C4CEE7;
	Fri, 17 Oct 2025 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713431;
	bh=xoODPbniTobvfUhspqbP85L4zH3vBC7VfvVlPSjSXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/M4ibiJdbsc2F1CLpnn4raLdCliv02fvwMi7iYpH80iFZCgPOytS3Hk/nD30+e2j
	 t0tcHT6Xg/82R9F8nMWr6GH1ermhVwJWczBcnrOnbDF1C6byTGxddemKXCfM8NcEsB
	 QDRXg/YhBeTySVuAQdNLJboD0zbZCube4RY3Z460=
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
Subject: [PATCH 6.1 130/168] ext4: increase i_disksize to offset + len in ext4_update_disksize_before_punch()
Date: Fri, 17 Oct 2025 16:53:29 +0200
Message-ID: <20251017145133.814611266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3945,7 +3945,11 @@ int ext4_can_truncate(struct inode *inod
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
@@ -3956,9 +3960,11 @@ int ext4_update_disksize_before_punch(st
 	loff_t size = i_size_read(inode);
 
 	WARN_ON(!inode_is_locked(inode));
-	if (offset > size || offset + len < size)
+	if (offset > size)
 		return 0;
 
+	if (offset + len < size)
+		size = offset + len;
 	if (EXT4_I(inode)->i_disksize >= size)
 		return 0;
 



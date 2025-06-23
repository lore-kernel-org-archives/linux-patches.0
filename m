Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B1713A265;
	Mon, 23 Jun 2025 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684591; cv=none; b=DG4XyMIfHzp9jAHABPiripp3Hs53A5sieHq64eep23cKSDK3LXlQwd0n2hZbIdF9IsGTQeh05GVJ1f83ooVlXgC9WaHUPt7ePMYtWYAtdmzH7wDe3PQSNdV8yTKfCO21l4biH3SBDlXgzZ9SWaYiz33kjPnptj8cOibKEJPsi9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684591; c=relaxed/simple;
	bh=wZM9khl4+d8grb+6lzvXY2TjINUBNXpYaVaMX1kPtqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd+/KRuXzO4aLcj/+PSsfdxY7tXdKJp+aZtkjcr8odqv4X4lCfe/X/rWgiq7GW8k6s/kgxsWsKeYIsMnKCBxXCRzeMtQSD4YSO6ouh0oNVhhRrXH9VRnH3cnMsM8AMLsW6j9q3vMKfrjaWT6NLAWIj2GjJ5wF9DyxzxYXhad6uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RODjbewG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RODjbewG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C29C4CEEA;
	Mon, 23 Jun 2025 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684591;
	bh=wZM9khl4+d8grb+6lzvXY2TjINUBNXpYaVaMX1kPtqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RODjbewGXf/FjJ7tDwwsRGotOlI3CRWPOwzwfiR9QvYz5ZaJFBWpL7UpkeGp4/KzK
	 /O66do7Kmm6eUlJeEgBAfxxw2ZZixm2IUDzbRgsVrTBenX4Oz4zC9bJxe3TnRADIxI
	 9PfkQsK98jvMHtPkFMs0jzqwrJQW36R7ifnwoZ9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org
Subject: [PATCH 6.15 118/592] ext4: only dirty folios when data journaling regular files
Date: Mon, 23 Jun 2025 15:01:16 +0200
Message-ID: <20250623130703.077671956@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

commit e26268ff1dcae5662c1b96c35f18cfa6ab73d9de upstream.

fstest generic/388 occasionally reproduces a crash that looks as
follows:

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
Call Trace:
 <TASK>
 ext4_block_zero_page_range+0x30c/0x380 [ext4]
 ext4_truncate+0x436/0x440 [ext4]
 ext4_process_orphan+0x5d/0x110 [ext4]
 ext4_orphan_cleanup+0x124/0x4f0 [ext4]
 ext4_fill_super+0x262d/0x3110 [ext4]
 get_tree_bdev_flags+0x132/0x1d0
 vfs_get_tree+0x26/0xd0
 vfs_cmd_create+0x59/0xe0
 __do_sys_fsconfig+0x4ed/0x6b0
 do_syscall_64+0x82/0x170
 ...

This occurs when processing a symlink inode from the orphan list. The
partial block zeroing code in the truncate path calls
ext4_dirty_journalled_data() -> folio_mark_dirty(). The latter calls
mapping->a_ops->dirty_folio(), but symlink inodes are not assigned an
a_ops vector in ext4, hence the crash.

To avoid this problem, update the ext4_dirty_journalled_data() helper to
only mark the folio dirty on regular files (for which a_ops is
assigned). This also matches the journaling logic in the ext4_symlink()
creation path, where ext4_handle_dirty_metadata() is called directly.

Fixes: d84c9ebdac1e ("ext4: Mark pages with journalled data dirty")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Link: https://patch.msgid.link/20250516173800.175577-1-bfoster@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1009,7 +1009,12 @@ int ext4_walk_page_buffers(handle_t *han
  */
 static int ext4_dirty_journalled_data(handle_t *handle, struct buffer_head *bh)
 {
-	folio_mark_dirty(bh->b_folio);
+	struct folio *folio = bh->b_folio;
+	struct inode *inode = folio->mapping->host;
+
+	/* only regular files have a_ops */
+	if (S_ISREG(inode->i_mode))
+		folio_mark_dirty(folio);
 	return ext4_handle_dirty_metadata(handle, NULL, bh);
 }
 



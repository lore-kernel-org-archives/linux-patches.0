Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211FB2C15BB;
	Mon, 27 Oct 2025 19:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592151; cv=none; b=A15ZlYtKMQgSIf4XMrTjtt+d9EmOoDNkimev1TBNOtrOd9oEH+5KGCTQGL23B9Y91i8UKUnp3P5Ofwi0SXAN+i12eG+Zyk5mnJinUDfbwl+FvKonSKDp10ULbWM8Bgfc6KQ8EwkzmJ+ue95IMbAXLphcbFgbnGHtplduRxpbly0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592151; c=relaxed/simple;
	bh=iTiAXvWkW6annGtt9UnqGOj3g5esa0My+6bJsx46dG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYFgebX+wNZjdYx1DdtBEu1cqPgXRvIjfRJTcTbp8BCnjwhHh1SDUsTQJBWHdruKosgkeGUHaYRaM9DsMZec0STuVmcGT0TR9l72bRFuuuTtqoOgDXufjMvU+GIxm6z9VcdfDflcAOgwNYPZTbWDl5CbXpu6eMEEzQOqzUa5S2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/dAAxVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/dAAxVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1ACC4CEF1;
	Mon, 27 Oct 2025 19:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592150;
	bh=iTiAXvWkW6annGtt9UnqGOj3g5esa0My+6bJsx46dG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/dAAxVDXm3p3KhoaI5umOSLa/KROzyWFMU9IeEtHnr00h8ZTyInde1NvfNOCMMvo
	 nrkCrqiI+nFvAydKyD3f5EBsceCcCqhe2gnlx8eqXvvbJY6HKeypdZ8tx2sxI0PQBr
	 QquJWCOJamWlA8NqjidUPtG1A45nJ3heymRshdGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+038b7bf43423e132b308@syzkaller.appspotmail.com
Subject: [PATCH 6.1 005/157] ext4: detect invalid INLINE_DATA + EXTENTS flag combination
Date: Mon, 27 Oct 2025 19:34:26 +0100
Message-ID: <20251027183501.383311755@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 1d3ad183943b38eec2acf72a0ae98e635dc8456b upstream.

syzbot reported a BUG_ON in ext4_es_cache_extent() when opening a verity
file on a corrupted ext4 filesystem mounted without a journal.

The issue is that the filesystem has an inode with both the INLINE_DATA
and EXTENTS flags set:

    EXT4-fs error (device loop0): ext4_cache_extents:545: inode #15:
    comm syz.0.17: corrupted extent tree: lblk 0 < prev 66

Investigation revealed that the inode has both flags set:
    DEBUG: inode 15 - flag=1, i_inline_off=164, has_inline=1, extents_flag=1

This is an invalid combination since an inode should have either:
- INLINE_DATA: data stored directly in the inode
- EXTENTS: data stored in extent-mapped blocks

Having both flags causes ext4_has_inline_data() to return true, skipping
extent tree validation in __ext4_iget(). The unvalidated out-of-order
extents then trigger a BUG_ON in ext4_es_cache_extent() due to integer
underflow when calculating hole sizes.

Fix this by detecting this invalid flag combination early in ext4_iget()
and rejecting the corrupted inode.

Cc: stable@kernel.org
Reported-and-tested-by: syzbot+038b7bf43423e132b308@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=038b7bf43423e132b308
Suggested-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Message-ID: <20250930112810.315095-1-kartikey406@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4968,6 +4968,14 @@ struct inode *__ext4_iget(struct super_b
 	}
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
 	ext4_set_inode_flags(inode, true);
+	/* Detect invalid flag combination - can't have both inline data and extents */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA) &&
+	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		ext4_error_inode(inode, function, line, 0,
+			"inode has both inline data and extents flags");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	inode->i_blocks = ext4_inode_blocks(raw_inode, ei);
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
 	if (ext4_has_feature_64bit(sb))



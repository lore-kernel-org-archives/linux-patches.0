Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3753328F4;
	Mon, 27 Oct 2025 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591564; cv=none; b=hMwx3Ak14xgWR0BilhSFoe42bvc/NnD8Ytcxp89/HfVKJNofHk0XB+ql/vajHhqcf1ctpGIuNuSqh2f4xlXhVk+S5wq683XOwOfw5IF8yBs63/ke8gLp+JTcOGdkVYNdizoQZCq1oczZ33XiOfwTcEf1sy1OKh8GzuGKmO0CQRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591564; c=relaxed/simple;
	bh=iMMpN/GVeikLSZgrRlMDiBEl2BCInqCd2q3orYdTIck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4A+06jFNmS2rD1NTFnFwA8UMMnCqoyHawSZWbEWtm0aJl1tPlC9gVZED5YSUnH5MXIqoCAV8nRXAlset82DOZ0MmEn1vh61lFpk60TyUiDxai0NAyzZVNj76/HBHW0R+YaEe+vpZ+jrwhGBAvyyCs1l0UpLAunkJ+8PQLZfZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMSJT1ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMSJT1ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D97C4CEF1;
	Mon, 27 Oct 2025 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591564;
	bh=iMMpN/GVeikLSZgrRlMDiBEl2BCInqCd2q3orYdTIck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMSJT1niIDYwB+LJEvVk/403ttTOjSNPsIzwQIiRZBSr+So5jk3kbR8TumOeIvJCC
	 GNn0Na01bFmxMeCUWuwB6ZnWae+2gZvJZsxZfgkdMbLPaqvnnq92fNtRKJ3PTpgtMA
	 AIImVET3Lh/BSpHxTw6Fer8z1fSppW8/EAVheFyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+038b7bf43423e132b308@syzkaller.appspotmail.com
Subject: [PATCH 5.10 228/332] ext4: detect invalid INLINE_DATA + EXTENTS flag combination
Date: Mon, 27 Oct 2025 19:34:41 +0100
Message-ID: <20251027183530.819250786@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4868,6 +4868,14 @@ struct inode *__ext4_iget(struct super_b
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41160246798;
	Tue, 21 Oct 2025 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076696; cv=none; b=d8ucUMByRzxXdXETWKEFfcvToF2C1K5pTqxtr98ozzW8VdPUZK3mIaAnRPuFULSkFX2OhlbJv8JcCuY9yM6eNrdjrA0dRG8FvKMkG9hQ7OLx2Ef8lCFW+DIX9y05qPyQYgzPyUo2yXbpX3KhpDPfGwMuBDYYJ3QCsQpgxRb3dnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076696; c=relaxed/simple;
	bh=ku87VREVJZ87wzyL5gn07V2xs4Ni8P32YXGaR3fr/EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+yWQtRh2RdZ/TRIDki0F6/C6Tci2lvuS6ERIPCxQbtg+uTADorleToQUgJsQ4IwQQCmIs7RXkAtzMgSVGjGOKsqW9X7fn7ZBZvr6WaWWlFe4c2ig8rw8FPJ8dkwDKh2BEeVLWyqUGhpzCSCFkxLbuw+z6L3NHVpCs5+LFUv1OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SjDH7vM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SjDH7vM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C4EC116B1;
	Tue, 21 Oct 2025 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076695;
	bh=ku87VREVJZ87wzyL5gn07V2xs4Ni8P32YXGaR3fr/EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SjDH7vMbhpN/dMHlBT8Vc4GBO8IhquUfkiTupnKIAITOAgX8YnkLpINMBrf6jBj+
	 D+B4rVW3s81mEgdTGiECrZq9AIaLuhefkPJPtgJyLZXlldJN1QjbtU0Wb4ybtKhsoS
	 yFA8py4iFgr4lsinMtMnsIGZFipXs0EBlA/aRdkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+038b7bf43423e132b308@syzkaller.appspotmail.com
Subject: [PATCH 6.12 010/136] ext4: detect invalid INLINE_DATA + EXTENTS flag combination
Date: Tue, 21 Oct 2025 21:49:58 +0200
Message-ID: <20251021195036.209695898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4904,6 +4904,14 @@ struct inode *__ext4_iget(struct super_b
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F277D495D9;
	Thu, 30 Nov 2023 16:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLFJZ0pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B897C433C8;
	Thu, 30 Nov 2023 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361810;
	bh=S7kuL67gLEnZ5PM2MiunJ0iFfY5rtwSH1AzFWHaH7No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLFJZ0pd9OJk2QChkIksmklyP9LPvrlfY+G35Iad7MCf4OIgUzb5ehGKxQmTsR79t
	 W0X/IjpprLIw8HiLtEAVZMCpHGO6Cc1I3YVAp9x2ZXKRVhcCnghATCRpOU2BOfVq93
	 74iBo6wlLJKolUZzv69E6Ony2BsiovQaNcO/dTB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/82] ext4: using nofail preallocation in ext4_es_remove_extent()
Date: Thu, 30 Nov 2023 16:22:19 +0000
Message-ID: <20231130162137.492748540@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit e9fe2b882bd5b26b987c9ba110c2222796f72af5 ]

If __es_remove_extent() returns an error it means that when splitting
extent, allocating an extent that must be kept failed, where returning
an error directly would cause the extent tree to be inconsistent. So we
use GFP_NOFAIL to pre-allocate an extent_status and pass it to
__es_remove_extent() to avoid this problem.

In addition, since the allocated memory is outside the i_es_lock, the
extent_status tree may change and the pre-allocated extent_status is
no longer needed, so we release the pre-allocated extent_status when
es->es_len is not initialized.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-7-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8e387c89e96b ("ext4: make sure allocate pending entry not fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 682f5e4ce2d00..cb8241adda929 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1456,6 +1456,7 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	ext4_lblk_t end;
 	int err = 0;
 	int reserved = 0;
+	struct extent_status *es = NULL;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return 0;
@@ -1470,17 +1471,25 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	end = lblk + len - 1;
 	BUG_ON(end < lblk);
 
+retry:
+	if (err && !es)
+		es = __es_alloc_extent(true);
 	/*
 	 * ext4_clear_inode() depends on us taking i_es_lock unconditionally
 	 * so that we are sure __es_shrink() is done with the inode before it
 	 * is reclaimed.
 	 */
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, &reserved, NULL);
+	err = __es_remove_extent(inode, lblk, end, &reserved, es);
+	if (es && !es->es_len)
+		__es_free_extent(es);
 	write_unlock(&EXT4_I(inode)->i_es_lock);
+	if (err)
+		goto retry;
+
 	ext4_es_print_tree(inode);
 	ext4_da_release_space(inode, reserved);
-	return err;
+	return 0;
 }
 
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7904340C03;
	Tue, 29 Apr 2025 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950043; cv=none; b=Df+SC5+8uIX8qA4eRbYBi1t9cv/sHEImVXK4Vd934wlCZcnaKVvDtPSOfaEafMi1jVWMVGdI/ZXW4+bOye+dGPTNbl6pFbh63IqhBANStftE8T/sWU0jKIvcbM0RHmAGlgnVbN2kWkvwUQHqxk2DY0HFlD9OwaNPbvqW3F6jzgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950043; c=relaxed/simple;
	bh=dmEKyhW45AwnH8/RRg0WrEafFtjjR1Gb3hC63BYndY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9+hEC4iTU+UYyITmVAVe0HZFytKU7dEEFJ9K0aEVdmcVN4N4nOnL4MH2pZYfEWN9Q7F3ZZy7O9JVczGxwfNk80Fih7nJ2mgndAd2UbB10BCXCzNqSHRNHMk9Aj8jBwfaXLeSrll2za59hB+vv63XqSTDSu2PElZNm0kpGQ7Lo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ak0rG27Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ak0rG27Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F42C4CEE3;
	Tue, 29 Apr 2025 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950043;
	bh=dmEKyhW45AwnH8/RRg0WrEafFtjjR1Gb3hC63BYndY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak0rG27Qcla2qpLqL6CnJW1s63Kj7uCaJqkEsPi7NbfAB5iw0iP/XhhSVEmv2sy1j
	 DTS3ekBw/Ew/XuK4wIDr7amqKfX3VcjM8tShZbZ4yWFVOAmnqTjEhJJP7siLsRUPZm
	 fyTPWelB0JU67VsW3AHWWAakQRAqioqyDZt8rGXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/167] ext4: make block validity check resistent to sb bh corruption
Date: Tue, 29 Apr 2025 18:44:07 +0200
Message-ID: <20250429161057.352588365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit ccad447a3d331a239477c281533bacb585b54a98 ]

Block validity checks need to be skipped in case they are called
for journal blocks since they are part of system's protected
zone.

Currently, this is done by checking inode->ino against
sbi->s_es->s_journal_inum, which is a direct read from the ext4 sb
buffer head. If someone modifies this underneath us then the
s_journal_inum field might get corrupted. To prevent against this,
change the check to directly compare the inode with journal->j_inode.

**Slight change in behavior**: During journal init path,
check_block_validity etc might be called for journal inode when
sbi->s_journal is not set yet. In this case we now proceed with
ext4_inode_block_valid() instead of returning early. Since systems zones
have not been set yet, it is okay to proceed so we can perform basic
checks on the blocks.

Suggested-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/0c06bc9ebfcd6ccfed84a36e79147bf45ff5adc1.1743142920.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/block_validity.c | 5 ++---
 fs/ext4/inode.c          | 7 ++++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 6fe3c941b5651..4d6ba140276b5 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -351,10 +351,9 @@ int ext4_check_blockref(const char *function, unsigned int line,
 {
 	__le32 *bref = p;
 	unsigned int blk;
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 
-	if (ext4_has_feature_journal(inode->i_sb) &&
-	    (inode->i_ino ==
-	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+	if (journal && inode == journal->j_inode)
 		return 0;
 
 	while (bref < p+max) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f460150ec73e5..abe7f769054ff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -406,10 +406,11 @@ static int __check_block_validity(struct inode *inode, const char *func,
 				unsigned int line,
 				struct ext4_map_blocks *map)
 {
-	if (ext4_has_feature_journal(inode->i_sb) &&
-	    (inode->i_ino ==
-	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+
+	if (journal && inode == journal->j_inode)
 		return 0;
+
 	if (!ext4_inode_block_valid(inode, map->m_pblk, map->m_len)) {
 		ext4_error_inode(inode, func, line, map->m_pblk,
 				 "lblock %lu mapped to illegal pblock %llu "
-- 
2.39.5




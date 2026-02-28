Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D254D39448A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301098; cv=none; b=u5GmNt3ANMUlrM/Y762f2GJhJGdqtv8n40zWaWpm51gtXeMjRuwqzIplVCMyOr3gQRwZmIS3eCx/6PSXdsJOV+XOwzLIQSqBj7JOlk6mQSDs+FVKhPUo4u6h8d0PyS1+Rd3RTbfxENhZrEORtuFlYAS3JK3Gvtc5AAplNLvehE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301098; c=relaxed/simple;
	bh=zyfKnpCqXTFCfjfLFGUkUa6IbnWaHjfwhruIC5jBlPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbK8/m2adsG3eucwjxgVsdgqWiMAVHIPnH/db9negphsBahXDGTVl0YNyp4xbjMcjzN6mTzcxGwlJ5U9i80miZSvNP5lbDbrk0xA1Rfl2rDg5Ff2d6wsuQ4He3s2t0xwIX1wrrnkk+myuPp3Kg+vd7C9kJIyx845cTcKKmb12O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLCMBiB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLCMBiB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE731C19425;
	Sat, 28 Feb 2026 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301098;
	bh=zyfKnpCqXTFCfjfLFGUkUa6IbnWaHjfwhruIC5jBlPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLCMBiB59jVoYoL9n2I6XOnHpOJBaIdhzPajb/OR2/eQwaaSjTP7MUbwoLQjmQkYB
	 qlAiYiqfCC8F6ki2eMI9nuXKgmquI+RMyQvpa3ehb4kkDTAb/RgZDitNEVat9gTSV6
	 GCdOr1koqCob4ngm0IIalWLOzD9F9+KVpZ3F79y3rH4YNkyb4NXQj+eX6/KjSz80U8
	 OrftPdd4KF8XyhWgObtsCJs0suM+VHiCMPHRuf2hekhIYgJ6Vl8vGNoPy8haqT/eFf
	 mB8YJfdrRhdYhtcCbqCS7GgNZ8wiUYSUlbntIuaf74CdGq54iDss77Ezn9bPTyXtf3
	 VtTtAq8Bcw+rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/752] ext4: use reserved metadata blocks when splitting extent on endio
Date: Sat, 28 Feb 2026 12:39:21 -0500
Message-ID: <20260228174750.1542406-250-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 01942af95ab6c9d98e64ae01fdc243a03e4b973f ]

When performing buffered writes, we may need to split and convert an
unwritten extent into a written one during the end I/O process. However,
we do not reserve space specifically for these metadata changes, we only
reserve 2% of space or 4096 blocks. To address this, we use
EXT4_GET_BLOCKS_PRE_IO to potentially split extents in advance and
EXT4_GET_BLOCKS_METADATA_NOFAIL to utilize reserved space if necessary.

These two approaches can reduce the likelihood of running out of space
and losing data. However, these methods are merely best efforts, we
could still run out of space, and there is not much difference between
converting an extent during the writeback process and the end I/O
process, it won't increase the risk of losing data if we postpone the
conversion.

Therefore, also use EXT4_GET_BLOCKS_METADATA_NOFAIL in
ext4_convert_unwritten_extents_endio() to prepare for the buffered I/O
iomap conversion, which may perform extent conversion during the end I/O
process.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20260105014522.1937690-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae7f2d6b32e32..7338f93313b61 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3805,6 +3805,8 @@ ext4_convert_unwritten_extents_endio(handle_t *handle, struct inode *inode,
 	 * illegal.
 	 */
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
+		int flags = EXT4_GET_BLOCKS_CONVERT |
+			    EXT4_GET_BLOCKS_METADATA_NOFAIL;
 #ifdef CONFIG_EXT4_DEBUG
 		ext4_warning(inode->i_sb, "Inode (%ld) finished: extent logical block %llu,"
 			     " len %u; IO logical block %llu, len %u",
@@ -3812,7 +3814,7 @@ ext4_convert_unwritten_extents_endio(handle_t *handle, struct inode *inode,
 			     (unsigned long long)map->m_lblk, map->m_len);
 #endif
 		path = ext4_split_convert_extents(handle, inode, map, path,
-						EXT4_GET_BLOCKS_CONVERT, NULL);
+						  flags, NULL);
 		if (IS_ERR(path))
 			return path;
 
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F93153A7;
	Fri,  6 Dec 2024 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497769; cv=none; b=Tx6JKGk2dqxlti+uZg6S6q1GVAAiHMvmUyCK98GzpmzYNBb/Mp0Yg2hT9rf2cR9o6UtELB52U+aPtFW4aLKX6ldLhAqoRHg6NAQAabCVNhmoG1B/jt9+xWHJ/fsIHixfY8LplcPGy23yE5tQmYGA5GvfkmLBd4Pfvx/wQQCjVqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497769; c=relaxed/simple;
	bh=6FmHX+EDEOub3QKpcwvAim+Fw0l2bmerU3OiTYwZl/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXKu1IT2plbtEDe8zQlC8TatkZUmL7hESbocmdqxrk0ch58TXZ2Rq6SgLUVtNNr1SSn0+l8rbIRRw+IQG+q78YYlRWvHI3trskVtASIaU/NMg2JsWLo0oGlSzhv0ITKtXFs9Y2lQeyckRA18AJFP8Ui/bY9lNHs//XEoI2VV8H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4rvQD1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4rvQD1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD45C4CED1;
	Fri,  6 Dec 2024 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497768;
	bh=6FmHX+EDEOub3QKpcwvAim+Fw0l2bmerU3OiTYwZl/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4rvQD1vflmvEJBPDli4/BYc+Oc8Gm+iIa5ZUKQfQiQGAEjWkAySIG0rD0xWtABoU
	 Wha92CtzlX7g0/tTo4iLim1wFn1G3ZpWhk7+cQ4SH6ybfduuLAiz9SFUGA4UqCWfYe
	 UkaZ3l8e1ANEc6vuh23Ku8DTBBNnwzXPzLV9uuJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Han <hanqi@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 346/676] f2fs: compress: fix inconsistent update of i_blocks in release_compress_blocks and reserve_compress_blocks
Date: Fri,  6 Dec 2024 15:32:45 +0100
Message-ID: <20241206143706.863461483@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Han <hanqi@vivo.com>

[ Upstream commit 26413ce18e85de3dda2cd3d72c3c3e8ab8f4f996 ]

After release a file and subsequently reserve it, the FSCK flag is set
when the file is deleted, as shown in the following backtrace:

F2FS-fs (dm-48): Inconsistent i_blocks, ino:401231, iblocks:1448, sectors:1472
fs_rec_info_write_type+0x58/0x274
f2fs_rec_info_write+0x1c/0x2c
set_sbi_flag+0x74/0x98
dec_valid_block_count+0x150/0x190
f2fs_truncate_data_blocks_range+0x2d4/0x3cc
f2fs_do_truncate_blocks+0x2fc/0x5f0
f2fs_truncate_blocks+0x68/0x100
f2fs_truncate+0x80/0x128
f2fs_evict_inode+0x1a4/0x794
evict+0xd4/0x280
iput+0x238/0x284
do_unlinkat+0x1ac/0x298
__arm64_sys_unlinkat+0x48/0x68
invoke_syscall+0x58/0x11c

For clusters of the following type, i_blocks are decremented by 1 and
i_compr_blocks are incremented by 7 in release_compress_blocks, while
updates to i_blocks and i_compr_blocks are skipped in reserve_compress_blocks.

raw node:
D D D D D D D D
after compress:
C D D D D D D D
after reserve:
C D D D D D D D

Let's update i_blocks and i_compr_blocks properly in reserve_compress_blocks.

Fixes: eb8fbaa53374 ("f2fs: compress: fix to check unreleased compressed cluster")
Signed-off-by: Qi Han <hanqi@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 74fac935bd092..ad26733f1f46c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3755,7 +3755,7 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
 		to_reserved = cluster_size - compr_blocks - reserved;
 
 		/* for the case all blocks in cluster were reserved */
-		if (to_reserved == 1) {
+		if (reserved && to_reserved == 1) {
 			dn->ofs_in_node += cluster_size;
 			goto next;
 		}
-- 
2.43.0




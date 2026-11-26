Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705393;
	b=KSberFg+8NeHs7e4IHYEiIqs+eLcdX7LF4bijwv9gFhjI43jvW+a4Uc0rLw0YSg8NhZ1
	 h08wM/Jb1jcWjGrLPfqPNDm72mJ8lDGEZ8unoTrXpWoWKNpJ638iND6WBQFQits6Y/yS5
	 bDJJqCs/7NO2KhPjkFa5JfFTVGwcGqmaFZK4XQV4scMyD7HcfBdRn9q5hg6N+RweKvErP
	 SYloloxFv9kb2WKdc1vk3f8PymRFUcHBJ7lrxZiJpzs1k7TRW9mfgbqG+lb5PWnx89i88
	 va3mZR6enwZxLzfqYCfmY+eXa+7IuUer4rBaBqt9YpOcR/d8O1TRNBgqB8UxkrTIbhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KE1DcPDJ80rOHoZe6MA2jl3sLWV6W5hlzptMme1Q0vo=;
	b=E5Rs708TCwe1Pdvy4kjVe08sAhC+RFzrnSNtai7TkuOnf4XMigZ4LCFYdRaw02z2QcK+
	 WmgaC34nufoYmwvETO0Dv77KPkhFHwf5CMTC1SmBYqpFYT/zUsTS5jTmmwPew5TPg+Ttq
	 hTcu/MT7UYuprsyKwmRxssYGy6n90iEawfp7tJ1lIHb8Pbo/Xi2kNaDvWPpg2H2jL9V95
	 dUCJKxOoeUHvIvKsdrA70rh7NU47FxmcnADXnlDM2rY4Hil21icaavyvb2MoGLNopnDm1
	 +V4K+0u0rpgyFS6oDaODjUjATHRLvf3XiRirMvqh51Bi5ijq/Mj06pWtTWApSY4CDWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ut6oHlCu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF1B606A323;
	Thu, 26 Nov 2026 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ut6oHlCu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39791F000CA;
	Thu, 26 Nov 2026 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705393;
	bh=KE1DcPDJ80rOHoZe6MA2jl3sLWV6W5hlzptMme1Q0vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ut6oHlCu8TgXDLyOh/Gw4SfsRnkwjLV+xqKRNy4NINs4oizrs8U9kOSwtRLpAA14T
	 qUiU7xh+XkKLtUkswLI9yWXgTeXTSzHKz+kf9Y3aS7ZM0UeM9fItQbF7D5Clf1SDw2
	 hodm/kptGM9R0eJIlAVue4F5krIRXb6COD2yT4R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+512459401510e2a9a39f@syzkaller.appspotmail.com,
	syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Bin Lan <lanbincn@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/319] ext4: avoid infinite loops caused by residual data
Date: Thu, 26 Nov 2026 15:39:12 +0100
Message-ID: <20261126144010.898114834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 5422fe71d26d42af6c454ca9527faaad4e677d6c ]

On the mkdir/mknod path, when mapping logical blocks to physical blocks,
if inserting a new extent into the extent tree fails (in this example,
because the file system disabled the huge file feature when marking the
inode as dirty), ext4_ext_map_blocks() only calls ext4_free_blocks() to
reclaim the physical block without deleting the corresponding data in
the extent tree. This causes subsequent mkdir operations to reference
the previously reclaimed physical block number again, even though this
physical block is already being used by the xattr block. Therefore, a
situation arises where both the directory and xattr are using the same
buffer head block in memory simultaneously.

The above causes ext4_xattr_block_set() to enter an infinite loop about
"inserted" and cannot release the inode lock, ultimately leading to the
143s blocking problem mentioned in [1].

If the metadata is corrupted, then trying to remove some extent space
can do even more harm. Also in case EXT4_GET_BLOCKS_DELALLOC_RESERVE
was passed, remove space wrongly update quota information.
Jan Kara suggests distinguishing between two cases:

1) The error is ENOSPC or EDQUOT - in this case the filesystem is fully
consistent and we must maintain its consistency including all the
accounting. However these errors can happen only early before we've
inserted the extent into the extent tree. So current code works correctly
for this case.

2) Some other error - this means metadata is corrupted. We should strive to
do as few modifications as possible to limit damage. So I'd just skip
freeing of allocated blocks.

[1]
INFO: task syz.0.17:5995 blocked for more than 143 seconds.
Call Trace:
 inode_lock_nested include/linux/fs.h:1073 [inline]
 __start_dirop fs/namei.c:2923 [inline]
 start_dirop fs/namei.c:2934 [inline]

Reported-by: syzbot+512459401510e2a9a39f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1659aaaaa8d9d11265d7
Tested-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
Reported-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=512459401510e2a9a39f
Tested-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Tested-by: syzbot+512459401510e2a9a39f@syzkaller.appspotmail.com
Link: https://patch.msgid.link/tencent_43696283A68450B761D76866C6F360E36705@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
[ Minor context conflict resolved. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 33624c68a3d75..f6dbd3eaaccd4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4392,9 +4392,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 	err = ext4_ext_insert_extent(handle, inode, &path, &newex, flags);
 	if (err) {
-		if (allocated_clusters) {
+		/*
+		 * Gracefully handle out of space conditions. If the filesystem
+		 * is inconsistent, we'll just leak allocated blocks to avoid
+		 * causing even more damage.
+		 */
+		if (allocated_clusters && (err == -EDQUOT || err == -ENOSPC)) {
 			int fb_flags = 0;
-
 			/*
 			 * free data blocks we just allocated.
 			 * not a good idea to call discard here directly,
-- 
2.53.0




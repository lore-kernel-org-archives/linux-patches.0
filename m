Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38D82C15BB;
	Tue, 31 Mar 2026 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975454; cv=none; b=ZpZMHyF1d4QOl1afNdtOx+W2whrYxI7Svg5sgWNCIEAFjzXRStbkLuhmSYIFgTsF9RSIkf2LTnJfW8rBRwXbpBYjl7ZXTrqbYDF+cdiSNClDDvFTxRrHTLRzeizX1kPAeQlZij4B3tPJSzFYyDO0rhqJ718tQ63cbCXfVv0vfx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975454; c=relaxed/simple;
	bh=s2HL3gVf2WfM3JaZZu+/RcjrMTnoeYkUhj6vZK61oGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l84ZuSgYsjEF0AHh61ZdcglizT64Lstr67sMtGH0y6R2nnwRMH0O5wqBGJuIlCdB1ACxUgyASwYOLr8eHy9hcR0lyfGHHakRSWbKUwX1E09nAoE665LCCvr4krCyuVcxF8ERppxBzdilIp3TosynrxIBKpCd+k/KK8++6ZbVs2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJGR2AcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJGR2AcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A12CC19423;
	Tue, 31 Mar 2026 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975454;
	bh=s2HL3gVf2WfM3JaZZu+/RcjrMTnoeYkUhj6vZK61oGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJGR2AcPg989oPnbYrcYHAbpKS+EuvQIDe11ySZSLeoE3y8KOYlm8W1C7BB8YF+pD
	 cwG1fTr9hdAnMk0SME4XM9rnijoPOY7DLL/gQt3iQHe/5cekkbvWQvQ+bqUBu4OsXA
	 3ccXfcKDkiesznMNRoWdJwipKwd9VC0rd2jnmFNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+512459401510e2a9a39f@syzkaller.appspotmail.com,
	syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 300/342] ext4: avoid infinite loops caused by residual data
Date: Tue, 31 Mar 2026 18:22:13 +0200
Message-ID: <20260331161809.969382558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 5422fe71d26d42af6c454ca9527faaad4e677d6c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4461,9 +4461,13 @@ got_allocated_blocks:
 	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
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



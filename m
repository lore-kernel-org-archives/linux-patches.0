Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704521;
	b=S9w/GnCMdzWr+A3KXmcYSvt6DljM8yvTIeqiPQwgIEPcbjv/vdoFJQ/E400NflVOq5LT
	 MkNFZfvjAJzpVCSfXjbx4K5zWt7+fMrq7haL+73YjLrXIcR1iyh8bJG77WS5FZ4OrVrnX
	 0fYBN0oqBwvLx1zgnEUPgycenbfXXvyq3PV8ogDyzJgippPWNbcISpLz1AZrbzFMi2B4m
	 Ya60KM/PLihPgsRtZxnYNiDG1P7jqYfdfPZWoPq6f+nmZd7gVSm9ohdmLa+k0+2Nil1Mh
	 oR+Bsl6nN9iHZPwhdUDOnMQR1o6MfXSTxTpVeLU3yTi60ky7gmk+j/VjfBt4rmLMktw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7UrueupMHzbgvlskVVg+dkaO+2l1trykXCiBsgDv5YY=;
	b=iH/HVqOWCyLbmWcee5i5EGgrANzaLw6JHtT82ON7bbxc8dNxEqANvMIsEyIrEp2Fjlnq
	 0+n9xu0muy4/yk3NxxDBE1pY1RQgfNtH4RG8anw7dQBfKYg/CfQUnG6GnvIx7AK5wvrRp
	 fBs/GvySNlpJbHFqGNTQP0LnDpxq0q+Qpp0a907GRY+8DgurNgR8NVwp07wQt1TPKHZWk
	 0aD8LbNr/SLdHQH6NyLVzjYA5+gd3DqqCWQq/x1r/srFVYkcEWWrDMRXrDCAtQQlywFD8
	 jxOeMyc/CxZsm/ogL2KsUmeiYERMZAlQ91FB8+XnRpMUXzgu76AzhbX2ISEknU6WCmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdP0NPnx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BF2606A31C;
	Thu, 26 Nov 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdP0NPnx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878451F000D1;
	Thu, 26 Nov 2026 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704521;
	bh=7UrueupMHzbgvlskVVg+dkaO+2l1trykXCiBsgDv5YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdP0NPnxv4jcXdHA0tnU4MHD5/djeDzsDNVl6Dou9Ahwo6Rk4rLY8NOo9yYEnw8p2
	 X12Gn1c6QAw+utSoAlCPZ5CrHQmpRmCQ2iSiYELT/dzbIx1rbasQavzuBieJZg+PVq
	 yvj6mmj8zHorBITufsRZfVcoZYQHAphHOofgnN/I=
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
Subject: [PATCH 5.10 154/265] ext4: avoid infinite loops caused by residual data
Date: Thu, 26 Nov 2026 15:38:04 +0100
Message-ID: <20261126143615.852229674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ext4/extents.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4386,9 +4386,13 @@ got_allocated_blocks:
 
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



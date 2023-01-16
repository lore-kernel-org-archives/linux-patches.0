Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1F46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9AFC433D2;
	Mon, 16 Jan 2023 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886712;
	bh=yfWE6JRUawIW7xITywdhSwf+oQaEeQJfr9+IrWrjF+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDVDjWpc2hDsDmO+/jEZaaRWFMPiXdvFyf+gcPhrrKbjPxi5koSoT/+pUD6Oz5fY6
	 T7XIEf5hRiniSPmlIQQHZSD9MNH0goEJjatEu5/QriiRuxybV1gA47kL/Losym/3eD
	 Vg/18qj8oGqttB6tuzIP6xi+PO2t2G8xAxzYgGTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.4 533/658] ext4: fix inode leak in ext4_xattr_inode_create() on an error path
Date: Mon, 16 Jan 2023 16:50:21 +0100
Message-Id: <20230116154933.929867917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

commit e4db04f7d3dbbe16680e0ded27ea2a65b10f766a upstream.

There is issue as follows when do setxattr with inject fault:

[localhost]# fsck.ext4  -fn  /dev/sda
e2fsck 1.46.6-rc1 (12-Sep-2022)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Unattached zero-length inode 15.  Clear? no

Unattached inode 15
Connect to /lost+found? no

Pass 5: Checking group summary information

/dev/sda: ********** WARNING: Filesystem still has errors **********

/dev/sda: 15/655360 files (0.0% non-contiguous), 66755/2621440 blocks

This occurs in 'ext4_xattr_inode_create()'. If 'ext4_mark_inode_dirty()'
fails, dropping i_nlink of the inode is needed. Or will lead to inode leak.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221208023233.1231330-5-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1442,6 +1442,9 @@ static struct inode *ext4_xattr_inode_cr
 		if (!err)
 			err = ext4_inode_attach_jinode(ea_inode);
 		if (err) {
+			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
+				ext4_warning_inode(ea_inode,
+					"cleanup dec ref error %d", err);
 			iput(ea_inode);
 			return ERR_PTR(err);
 		}



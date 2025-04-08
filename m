Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF5A2676E0;
	Tue,  8 Apr 2025 11:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110783; cv=none; b=EftJrnvEThJUI99TGQSIkGn3w0HhAtyzag+PcLk4u5tImxg8UYZXipGKioPtyi4uszVj8TWCVAy6BVct8j/cyc2cDVrsQOfM7NIUuQIWyEa4McOepLrRh1BUAEnw+jGogZAdCkJ48uoPqjR2ZK03RgRc7TMQ9KepSuoiqS1dKHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110783; c=relaxed/simple;
	bh=qLi7Q0lD9qDru+6fIfa7wvJcqMLDsGwewmF+nw1Hz+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEgcY4f0NuFvOWpAxEeY7y7ATIelO+mzSLXMHyT0yifhA18Jx/9+R/cknhbuVN+COIPWIlGXddjJtuuPdGNwK+uBodJgO8i8/W6qck8Z1uCX8cN67r+HBhoTKJ9yKeEEQEGDSHAVnZaKsJbBMIrAx+fGX74VI/LTVtl1eJBPuo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cY9k3KIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cY9k3KIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1494C4CEE5;
	Tue,  8 Apr 2025 11:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110783;
	bh=qLi7Q0lD9qDru+6fIfa7wvJcqMLDsGwewmF+nw1Hz+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cY9k3KIlXPTCEoYfJV6HocxebGN/bD5eqKOx8tdqY/ncMoRcuE0QfuK8/OWxk0VPE
	 c21OyKuHdZGVhhnpO8FYmGSpzcqNbec5KFzVSGe48iHK5KSJG6K7xCYSnb4SehnmMh
	 Hk5/ZM7lQJbvVgTNT/Gr7gSRqD1/D6rwQzJLbu4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48a99e426f29859818c0@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 192/731] ext4: verify fast symlink length
Date: Tue,  8 Apr 2025 12:41:29 +0200
Message-ID: <20250408104918.747422713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5f920d5d60839f7cbbb1ed50eac68d8bc0a73a7c ]

Verify fast symlink length stored in inode->i_size matches the string
stored in the inode to avoid surprises from corrupted filesystems.

Reported-by: syzbot+48a99e426f29859818c0@syzkaller.appspotmail.com
Tested-by: syzbot+48a99e426f29859818c0@syzkaller.appspotmail.com
Fixes: bae80473f7b0 ("ext4: use inode_set_cached_link()")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://patch.msgid.link/20250206094454.20522-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7c54ae5fcbd45..64e280fed9119 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5007,8 +5007,16 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 			inode->i_op = &ext4_encrypted_symlink_inode_operations;
 		} else if (ext4_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext4_fast_symlink_inode_operations;
-			nd_terminate_link(ei->i_data, inode->i_size,
-				sizeof(ei->i_data) - 1);
+			if (inode->i_size == 0 ||
+			    inode->i_size >= sizeof(ei->i_data) ||
+			    strnlen((char *)ei->i_data, inode->i_size + 1) !=
+								inode->i_size) {
+				ext4_error_inode(inode, function, line, 0,
+					"invalid fast symlink length %llu",
+					 (unsigned long long)inode->i_size);
+				ret = -EFSCORRUPTED;
+				goto bad_inode;
+			}
 			inode_set_cached_link(inode, (char *)ei->i_data,
 					      inode->i_size);
 		} else {
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320E1250C07;
	Wed,  5 Mar 2025 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197511; cv=none; b=bdfcrf+huV6XEJCYTbkH+3/eofzflso5iKHd32+61LzLkYPcxpqfEFukvfbGe+mI+2kBf7+ozyiHiVKw7ymDfeiPP0FfxV2Tf3zqKZA27jOq9p+WHVUyOAzrOxIwR/RxCgED955hEfhl/dz3txm56VEuIDa2NsDzhOqd27yTtaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197511; c=relaxed/simple;
	bh=eNPLO9HWFuaF+e68h+R+YuhOnUWkCNgl9hQiCSJ4Zuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6WZOJST9ivSb5w+e/trp2GZUIz8u4NKD4m/IynI84VBFEKapFsSnWJEzIAqMR4icHy55ll8TAG7waQKbB0bFogO2ysGKFBhXuf89C48lnQZRZ6gVACrMe7RM+a7Xuk7Qd0LQPuGh/XSVz69nBBbEhqRcavGVQm/IUmc8K8r9gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MXUB3uD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MXUB3uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38FC4CED1;
	Wed,  5 Mar 2025 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197511;
	bh=eNPLO9HWFuaF+e68h+R+YuhOnUWkCNgl9hQiCSJ4Zuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MXUB3uD//ZlxansqewTvXYAaM4WZ4/D5XVrZ8uZfT0bPYVDNt9P8EtN0KhDfyDm0
	 bL2JuD687sfSmqDqeYw4ZKdmlSbT+YPdrPNqibc4xDUABmM5ohSHeVwLFIzw7u0Hr9
	 fHPtifrAE7R0eBe+Xckd13ozcn2v4HTq44owcmCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	"Ubisectech Sirius" <bugreport@ubisectech.com>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 174/176] Squashfs: check the inode number is not the invalid value of zero
Date: Wed,  5 Mar 2025 18:49:03 +0100
Message-ID: <20250305174512.422582645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

From: Phillip Lougher <phillip@squashfs.org.uk>

commit 9253c54e01b6505d348afbc02abaa4d9f8a01395 upstream.

Syskiller has produced an out of bounds access in fill_meta_index().

That out of bounds access is ultimately caused because the inode
has an inode number with the invalid value of zero, which was not checked.

The reason this causes the out of bounds access is due to following
sequence of events:

1. Fill_meta_index() is called to allocate (via empty_meta_index())
   and fill a metadata index.  It however suffers a data read error
   and aborts, invalidating the newly returned empty metadata index.
   It does this by setting the inode number of the index to zero,
   which means unused (zero is not a valid inode number).

2. When fill_meta_index() is subsequently called again on another
   read operation, locate_meta_index() returns the previous index
   because it matches the inode number of 0.  Because this index
   has been returned it is expected to have been filled, and because
   it hasn't been, an out of bounds access is performed.

This patch adds a sanity check which checks that the inode number
is not zero when the inode is created and returns -EINVAL if it is.

[phillip@squashfs.org.uk: whitespace fix]
  Link: https://lkml.kernel.org/r/20240409204723.446925-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20240408220206.435788-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: "Ubisectech Sirius" <bugreport@ubisectech.com>
Closes: https://lore.kernel.org/lkml/87f5c007-b8a5-41ae-8b57-431e924c5915.bugreport@ubisectech.com/
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -48,6 +48,10 @@ static int squashfs_new_inode(struct sup
 	gid_t i_gid;
 	int err;
 
+	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
+	if (inode->i_ino == 0)
+		return -EINVAL;
+
 	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &i_uid);
 	if (err)
 		return err;
@@ -58,7 +62,6 @@ static int squashfs_new_inode(struct sup
 
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
-	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
 	inode->i_mtime.tv_sec = le32_to_cpu(sqsh_ino->mtime);
 	inode->i_atime.tv_sec = inode->i_mtime.tv_sec;
 	inode->i_ctime.tv_sec = inode->i_mtime.tv_sec;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E020B3E;
	Tue, 23 Apr 2024 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908550; cv=none; b=hFDgM4F3CT1WS1TlcG0XJSz+JVwlSriSWwoke4Sr3L51jJXF4eUK/IcJdHWuIlO2qLWnJ+568tOBF8K5zZMH17LJFrfBhG6vylHOyQD0answHWuf3QCZ970NJn/XJYFgdZPcfFGriu2nnre2BeE57MtV2O4qKFRT6oP7ct5R82E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908550; c=relaxed/simple;
	bh=SRU5OYpDbHY1aP2PGMiF0y7Zse+N9Smgu/kXgnocBkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TerKeqy9d5sOh1hf3EipGUhqASpZUjDbWLtDWBM54ky/fMahui1kVS3Id36wQSdNY7H0bmDQryDfnbK2NMX+T18q+KYis9GnBFZFMx7c3S/Dz/7WgKX3pYJRKvsgigGcfik19i3jVPC188F55649m4R4xPb0BE+QWz1SIANycq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6TNK9i/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6TNK9i/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A39C32782;
	Tue, 23 Apr 2024 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908550;
	bh=SRU5OYpDbHY1aP2PGMiF0y7Zse+N9Smgu/kXgnocBkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6TNK9i//j0iYaqMzR7uw9pxaFDGlfq7yvbNQLl7R/KC4qsR17QuVq0t3Zxm3SDlR
	 dyq5b/xQIjKRR/XZ2i4iuvlq4AJZrUoNUozcziGN16T5sNHH4tSbtAA6ieoUSKfycV
	 8Srz1+EoMzCvZCFJmgehaT9iWJgXxGnctzg9pbew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	"Ubisectech Sirius" <bugreport@ubisectech.com>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 150/158] Squashfs: check the inode number is not the invalid value of zero
Date: Tue, 23 Apr 2024 14:39:32 -0700
Message-ID: <20240423213900.722105945@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 	inode_set_mtime(inode, le32_to_cpu(sqsh_ino->mtime), 0);
 	inode_set_atime(inode, inode_get_mtime_sec(inode), 0);
 	inode_set_ctime(inode, inode_get_mtime_sec(inode), 0);



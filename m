Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C91BFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DDBC433EF;
	Mon, 15 May 2023 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170002;
	bh=1zb8Ey/MVSe1zLHuRIFD5SMwRO3RGD8I6SRjxY31cmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9xCaZzSEbgp/JTbl5VoM7zyWJUiZIsenrWhz/r0uAc1BRqCpaP9/yeZs9X26ucZy
	 xvefs3j/x6j9wvCLdw+TWhksoFMbYUL/NkQrat2j+cqWDoBojfzA8CI2qX1CvjuAzE
	 cPbrlMcZRDsXZjOpwM86pxihIWopI+4kttP8jCh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+64b645917ce07d89bde5@syzkaller.appspotmail.com,
	syzbot+0d042627c4f2ad332195@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.3 239/246] ext4: fix invalid free tracking in ext4_xattr_move_to_block()
Date: Mon, 15 May 2023 18:27:31 +0200
Message-Id: <20230515161729.814215621@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit b87c7cdf2bed4928b899e1ce91ef0d147017ba45 upstream.

In ext4_xattr_move_to_block(), the value of the extended attribute
which we need to move to an external block may be allocated by
kvmalloc() if the value is stored in an external inode.  So at the end
of the function the code tried to check if this was the case by
testing entry->e_value_inum.

However, at this point, the pointer to the xattr entry is no longer
valid, because it was removed from the original location where it had
been stored.  So we could end up calling kvfree() on a pointer which
was not allocated by kvmalloc(); or we could also potentially leak
memory by not freeing the buffer when it should be freed.  Fix this by
storing whether it should be freed in a separate variable.

Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230430160426.581366-1-tytso@mit.edu
Link: https://syzkaller.appspot.com/bug?id=5c2aee8256e30b55ccf57312c16d88417adbd5e1
Link: https://syzkaller.appspot.com/bug?id=41a6b5d4917c0412eb3b3c3c604965bed7d7420b
Reported-by: syzbot+64b645917ce07d89bde5@syzkaller.appspotmail.com
Reported-by: syzbot+0d042627c4f2ad332195@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2615,6 +2615,7 @@ static int ext4_xattr_move_to_block(hand
 		.in_inode = !!entry->e_value_inum,
 	};
 	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
+	int needs_kvfree = 0;
 	int error;
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
@@ -2637,7 +2638,7 @@ static int ext4_xattr_move_to_block(hand
 			error = -ENOMEM;
 			goto out;
 		}
-
+		needs_kvfree = 1;
 		error = ext4_xattr_inode_get(inode, entry, buffer, value_size);
 		if (error)
 			goto out;
@@ -2676,7 +2677,7 @@ static int ext4_xattr_move_to_block(hand
 
 out:
 	kfree(b_entry_name);
-	if (entry->e_value_inum && buffer)
+	if (needs_kvfree && buffer)
 		kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);



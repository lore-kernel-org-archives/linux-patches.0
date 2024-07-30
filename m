Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1462B189537;
	Tue, 30 Jul 2024 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358786; cv=none; b=lrj/28dNxLp5lYZGI5QmrXDGUmkR9aGvJFPS9L5fjdqHZtNI+II7cfKvm+/NKEedVvmW9iWrryey8ZZ/0sTlYDtyEfbZ8YFX4GSMBa74d78kXrx+5haeGuk18OdlFJ0VrBunMqaNJbSzY632LF0OYiPI9IUTeuE8ZrBkKSk1v/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358786; c=relaxed/simple;
	bh=qDjaAQYtaaHX7RdcRaC+dj8AZDcq3cvdcc1Z3FRHExA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzuowofFxSp0KAgcR4TwKDDjUxG2IDJONlWCzrroqzmxGwxzJWSMBH3rEF5NVtATRd6OQn5upWmJRtM63S8QTPXWu5EVIi/VDvLQq5Adv23i2gFy4y2zki4SYmFiiX+A/fjt/m99FAXWQ1kr4C7DT9SQvf7Yvn94E9TdPDRCGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnKcg9CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnKcg9CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D68C32782;
	Tue, 30 Jul 2024 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358785;
	bh=qDjaAQYtaaHX7RdcRaC+dj8AZDcq3cvdcc1Z3FRHExA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnKcg9CV8pGxIO8I8ZeJSQTnuXXY9XmUwZyKndKvp1SyIav/Atd6hfGnzFnWX3KyP
	 UYOJk7yZQ00hPDnEEOGP1bipKWQIXh+g5hBvykcq0vIASpA8ggVzYnJbx6vwfzgcdo
	 84vES9wgBMLP/R6iZczYg5+El85WXZpH5+ZuVums=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 397/568] ext4: check dot and dotdot of dx_root before making dir indexed
Date: Tue, 30 Jul 2024 17:48:24 +0200
Message-ID: <20240730151655.388051946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 50ea741def587a64e08879ce6c6a30131f7111e7 upstream.

Syzbot reports a issue as follows:
============================================
BUG: unable to handle page fault for address: ffffed11022e24fe
PGD 23ffee067 P4D 23ffee067 PUD 0
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 PID: 5079 Comm: syz-executor306 Not tainted 6.10.0-rc5-g55027e689933 #0
Call Trace:
 <TASK>
 make_indexed_dir+0xdaf/0x13c0 fs/ext4/namei.c:2341
 ext4_add_entry+0x222a/0x25d0 fs/ext4/namei.c:2451
 ext4_rename fs/ext4/namei.c:3936 [inline]
 ext4_rename2+0x26e5/0x4370 fs/ext4/namei.c:4214
[...]
============================================

The immediate cause of this problem is that there is only one valid dentry
for the block to be split during do_split, so split==0 results in out of
bounds accesses to the map triggering the issue.

    do_split
      unsigned split
      dx_make_map
       count = 1
      split = count/2 = 0;
      continued = hash2 == map[split - 1].hash;
       ---> map[4294967295]

The maximum length of a filename is 255 and the minimum block size is 1024,
so it is always guaranteed that the number of entries is greater than or
equal to 2 when do_split() is called.

But syzbot's crafted image has no dot and dotdot in dir, and the dentry
distribution in dirblock is as follows:

  bus     dentry1          hole           dentry2           free
|xx--|xx-------------|...............|xx-------------|...............|
0   12 (8+248)=256  268     256     524 (8+256)=264 788     236     1024

So when renaming dentry1 increases its name_len length by 1, neither hole
nor free is sufficient to hold the new dentry, and make_indexed_dir() is
called.

In make_indexed_dir() it is assumed that the first two entries of the
dirblock must be dot and dotdot, so bus and dentry1 are left in dx_root
because they are treated as dot and dotdot, and only dentry2 is moved
to the new leaf block. That's why count is equal to 1.

Therefore add the ext4_check_dx_root() helper function to add more sanity
checks to dot and dotdot before starting the conversion to avoid the above
issue.

Reported-by: syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae688d469e36fb5138d0
Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240702132349.2600605-2-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 5 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2218,6 +2218,52 @@ static int add_dirent_to_buf(handle_t *h
 	return err ? err : err2;
 }
 
+static bool ext4_check_dx_root(struct inode *dir, struct dx_root *root)
+{
+	struct fake_dirent *fde;
+	const char *error_msg;
+	unsigned int rlen;
+	unsigned int blocksize = dir->i_sb->s_blocksize;
+	char *blockend = (char *)root + dir->i_sb->s_blocksize;
+
+	fde = &root->dot;
+	if (unlikely(fde->name_len != 1)) {
+		error_msg = "invalid name_len for '.'";
+		goto corrupted;
+	}
+	if (unlikely(strncmp(root->dot_name, ".", fde->name_len))) {
+		error_msg = "invalid name for '.'";
+		goto corrupted;
+	}
+	rlen = ext4_rec_len_from_disk(fde->rec_len, blocksize);
+	if (unlikely((char *)fde + rlen >= blockend)) {
+		error_msg = "invalid rec_len for '.'";
+		goto corrupted;
+	}
+
+	fde = &root->dotdot;
+	if (unlikely(fde->name_len != 2)) {
+		error_msg = "invalid name_len for '..'";
+		goto corrupted;
+	}
+	if (unlikely(strncmp(root->dotdot_name, "..", fde->name_len))) {
+		error_msg = "invalid name for '..'";
+		goto corrupted;
+	}
+	rlen = ext4_rec_len_from_disk(fde->rec_len, blocksize);
+	if (unlikely((char *)fde + rlen >= blockend)) {
+		error_msg = "invalid rec_len for '..'";
+		goto corrupted;
+	}
+
+	return true;
+
+corrupted:
+	EXT4_ERROR_INODE(dir, "Corrupt dir, %s, running e2fsck is recommended",
+			 error_msg);
+	return false;
+}
+
 /*
  * This converts a one block unindexed directory to a 3 block indexed
  * directory, and adds the dentry to the indexed directory.
@@ -2252,17 +2298,17 @@ static int make_indexed_dir(handle_t *ha
 		brelse(bh);
 		return retval;
 	}
+
 	root = (struct dx_root *) bh->b_data;
+	if (!ext4_check_dx_root(dir, root)) {
+		brelse(bh);
+		return -EFSCORRUPTED;
+	}
 
 	/* The 0th block becomes the root, move the dirents out */
 	fde = &root->dotdot;
 	de = (struct ext4_dir_entry_2 *)((char *)fde +
 		ext4_rec_len_from_disk(fde->rec_len, blocksize));
-	if ((char *) de >= (((char *) root) + blocksize)) {
-		EXT4_ERROR_INODE(dir, "invalid rec_len for '..'");
-		brelse(bh);
-		return -EFSCORRUPTED;
-	}
 	len = ((char *) root) + (blocksize - csum_size) - (char *) de;
 
 	/* Allocate new block for the 0th block's dirents */



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE6D4C83
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F02C433EF;
	Mon, 16 Jan 2023 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886865;
	bh=1dqAHGRbfaQnDFsQsvdy3d0rpymkmJrWcZC5DZFVBz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRa7dHQxTHqB3yM7K5qoZrRqHEum2eaS6EzzcKZcbr8FblpJlIdnNmmykja83GysO
	 b3tHr0Lq01U4lVgJw24UDXGEJmTQZmY0IWihkGTeVcPMR0H1sC3iQaZ61bbdzOk3v8
	 Lnni9mMdag8O+/NBVxl6HbJN2zZysytlhc2mPdt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.4 592/658] ext4: dont allow journal inode to have encrypt flag
Date: Mon, 16 Jan 2023 16:51:20 +0100
Message-Id: <20230116154936.570722114@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 105c78e12468413e426625831faa7db4284e1fec upstream.

Mounting a filesystem whose journal inode has the encrypt flag causes a
NULL dereference in fscrypt_limit_io_blocks() when the 'inlinecrypt'
mount option is used.

The problem is that when jbd2_journal_init_inode() calls bmap(), it
eventually finds its way into ext4_iomap_begin(), which calls
fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks() requires that if
the inode is encrypted, then its encryption key must already be set up.
That's not the case here, since the journal inode is never "opened" like
a normal file would be.  Hence the crash.

A reproducer is:

    mkfs.ext4 -F /dev/vdb
    debugfs -w /dev/vdb -R "set_inode_field <8> flags 0x80808"
    mount /dev/vdb /mnt -o inlinecrypt

To fix this, make ext4 consider journal inodes with the encrypt flag to
be invalid.  (Note, maybe other flags should be rejected on the journal
inode too.  For now, this is just the minimal fix for the above issue.)

I've marked this as fixing the commit that introduced the call to
fscrypt_limit_io_blocks(), since that's what made an actual crash start
being possible.  But this fix could be applied to any version of ext4
that supports the encrypt feature.

Reported-by: syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com
Fixes: 38ea50daa7a4 ("ext4: support direct I/O with fscrypt using blk-crypto")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221102053312.189962-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4836,7 +4836,7 @@ static struct inode *ext4_get_journal_in
 
 	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (!S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode) || IS_ENCRYPTED(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;



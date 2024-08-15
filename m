Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9351A00CE;
	Thu, 15 Aug 2024 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729501; cv=none; b=oMBOdsVoq6lbuv8dHQSLk/qu4bCc39PSmr+Omir1Dh4VcimG/RdX1OlnQcIXbYYQV6NqkYRRdoyF8QwyLorBM4iostD2dH+JCUg+ttsZf7P00aI0uKrB395Y16zOAvMFhfrY9wS56CNpSlDl0+lYlwHkrAhTiMnkgYeI7R37474=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729501; c=relaxed/simple;
	bh=C9VjhH+DUpfbPIG1iwkLL0Op/8DTk5HlMi6BMprgnfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTfmcU4a3HzLqtqZc9wQ9QJFf3Aat97ayQMBku15yEyhVjJ7kGJly/3NL54Tt5bGCTB00ZyCIClCJ6VE7W5urvIqzv3AooneLaronuoEZ8pZw2zeYxDELGLHsvVHvtYS3z8obb43OxpK0lTgA13PWd+1H1J34HGa1RWdM5G09O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARhzPECs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARhzPECs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F11FC32786;
	Thu, 15 Aug 2024 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729501;
	bh=C9VjhH+DUpfbPIG1iwkLL0Op/8DTk5HlMi6BMprgnfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARhzPECsZM8LmrsKstB75kFkxRn47jPxJazn3IAtIoH10fJLej453apggzNY+DfKa
	 igoG0e7zhoeY8L9FzCiQEoI9ZC24yo3eUHfNt1k0SCZrURZ6ByTNa8ScER2Dw2QUYp
	 8sVhhkTun0P9Wk9uPbrqnOhO1aNF5UpxqD8qVYlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c1fe13fcb51574b249b@syzkaller.appspotmail.com,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/484] ext4: avoid writing unitialized memory to disk in EA inodes
Date: Thu, 15 Aug 2024 15:19:35 +0200
Message-ID: <20240815131945.812597236@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 65121eff3e4c8c90f8126debf3c369228691c591 ]

If the extended attribute size is not a multiple of block size, the last
block in the EA inode will have uninitialized tail which will get
written to disk. We will never expose the data to userspace but still
this is not a good practice so just zero out the tail of the block as it
isn't going to cause a noticeable performance overhead.

Fixes: e50e5129f384 ("ext4: xattr-in-inode support")
Reported-by: syzbot+9c1fe13fcb51574b249b@syzkaller.appspotmail.com
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240613150234.25176-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 37f3c2ebe6f82..e788f291ae86d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1384,6 +1384,12 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
 			goto out;
 
 		memcpy(bh->b_data, buf, csize);
+		/*
+		 * Zero out block tail to avoid writing uninitialized memory
+		 * to disk.
+		 */
+		if (csize < blocksize)
+			memset(bh->b_data + csize, 0, blocksize - csize);
 		set_buffer_uptodate(bh);
 		ext4_handle_dirty_metadata(handle, ea_inode, bh);
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FB5184535;
	Tue, 30 Jul 2024 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357444; cv=none; b=g0fjDOISaA5ZTqwYDs7c1HeoNjsC5QckgEfFpJ7SLUhkH3eHdwZ5SAgE0qAY/CVIA9Ai3fqu9PedLmBUrBC9Wt4OiStjOjzg6QyjYwCMvX1IsOj0kCSnIZeAlN9voECk6wl98avLQPLy69lgojjs+4CFEuIzZ8mPaaCpSKe/vlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357444; c=relaxed/simple;
	bh=VcOhbNKJsAca+cjNQVVTmyBSk0kIt1oXgVaN+LFEazw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngrXgSzy5v7KCMyufe/QlAU2Cb5IrSQMhhVGgFWgFO4Ol/Ka1LgVHPLta02hcoK1zDDN2ucM0zt8cdUKMH9NGJFBiIPMwF3GXByAGZfjp0Vo0eAR3RCggsCbytkIdAp9ALObGrjGyI6kwLm0QFMIpLPpqC0u9mzmjLavtWIWpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MefnXjFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MefnXjFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBA4C32782;
	Tue, 30 Jul 2024 16:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357444;
	bh=VcOhbNKJsAca+cjNQVVTmyBSk0kIt1oXgVaN+LFEazw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MefnXjFD6xlTVGxB3OV4evYPzpWyw7XshCfzf5OHERJJXYuBT148ruUetNCqK+ASQ
	 nzc4x/cntbwh7zqF1RSZn7DfuyBLT9Igk+lbCIE3f9KyOhLoxK4qOhiTv9W0qSA2IY
	 l0F4JX8l4nh2BAPFeUh/1aN5mPDoEvR4WLA3ALYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c1fe13fcb51574b249b@syzkaller.appspotmail.com,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/568] ext4: avoid writing unitialized memory to disk in EA inodes
Date: Tue, 30 Jul 2024 17:45:50 +0200
Message-ID: <20240730151649.378980200@linuxfoundation.org>
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
index 41b4630b17d64..c58cbe9f7809c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1433,6 +1433,12 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
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




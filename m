Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD46C472520;
	Tue, 21 Jul 2026 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656610; cv=none; b=YXroHKphg/wLLyiKi+mtwZ8y6h3Mc6TBeeDPpB/KZiajIAOzKv29V0PcdlwLOcwd8rPjWgd1G1JuE08hkKWmpff8YP/egBqkjwLdQi0VLEcDGSwxH4YbJ4qD9yBwB9fWECTELwrS45Gf3Sw8S67d63+HrZGIZreS2Gqm17MZKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656610; c=relaxed/simple;
	bh=jfpTTX9juJoWpK/iDfp0M1eE/4q2RQgRr4cG2X/zTl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAQbowDvSGd5KlXODFvwAwOjFgPcMy2ICwuOk8RXATf/AqurorauX2nBYNA0ZHCXxPrnI2ELm74N/gpNh43cDKEL33AO1uMzs7nDu/meXWFcARtudxIyC6xxjmIXuQy1cN3SIC0RXLFrpDwj6ULLLc0SpUwO2TQcs5V+geZI4eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBf62Eci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBf62Eci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A251F000E9;
	Tue, 21 Jul 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656609;
	bh=2rIX9KT/2aQYSUio0o3g3D8VnO0zxdsnSYNCCnO403k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBf62EciitDm0TIPq8WUp68s7v/mt0g3mXHYpqh7GQ0EkWYl7bjWwcdGctjWpu1Xm
	 x6GXlxeLvI70hPSQGnuqXt/JohLa77jPoCKkqxVXGeGZzwoKmLxXCkY5C1LmQsW23g
	 7dGOUI0s9h6goj/oLjOg68m6NSUGkkEjIpwKfZc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0451/1611] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Tue, 21 Jul 2026 17:09:27 +0200
Message-ID: <20260721152525.448029064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

[ Upstream commit ad09aa45965d3fafaf9963bc78109b73c0f9ac8d ]

When the data=journal mount option is used, the ext4_journalled_write_end()
function incorrectly calls ext4_write_inline_data_end() without checking
if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.

If a previous attempt to convert the inline data to an extent failed (e.g.
due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
call to ext4_write_begin() will not prepare the inline data xattr for
writing, but ext4_journalled_write_end() will incorrectly attempt to write
to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
ext4_write_inline_data() since i_inline_size was not expanded.

Fix this by ensuring that ext4_journalled_write_end() only calls
ext4_write_inline_data_end() if the EXT4_STATE_MAY_INLINE_DATA flag is
set, mirroring the behavior of ext4_write_end() and ext4_da_write_end().

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260608065227.3018-1-aditya.ansh182@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3ed0c2656e2e1d..c38ca1441b25f3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1561,7 +1561,8 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.53.0




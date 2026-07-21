Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B03B3C0A;
	Tue, 21 Jul 2026 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666072; cv=none; b=WjRziAfm3vnmM8sHQlo2vwjEf7ugFpH3J1LB/CHU852GFTFPJb2ehHsogYN7HpHpNUJbVWAxrLl5NbdaiOnpBXJO5amYqve01yNIq2zyxOq47dnnrR2koH9tv9X1ETwJEZ8orV0SVORFGHGkVrcs6BBieEfqfNfYs1EEiaUr0IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666072; c=relaxed/simple;
	bh=erx9bsZqYrk1ez/Rw9O61QoVCramzsAbUGEyETosxmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Btlijo9dgCamXyH/iLsJawJ4INgSMAC4IYC4yWzchX933AIc1QX6Bd/1F5vsAS5+QPvkjwOOI4Et6aOFhny85c8fncVj6TAwvKKKRWDN7GRnP3yOLT4vGHvfRxNev62HUip1jngbZeNZNTspqcrYDZKRFoenL0eHIeSkOC9qFsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIuj4ugp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIuj4ugp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA51A1F000E9;
	Tue, 21 Jul 2026 20:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666069;
	bh=mcoQoDw12CUlCA9sdBqqihAjFU3mQtCEAZT2/xclOD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIuj4ugpbDEd7j3VkUFtJvR5fUe4KolrgUUFCQssVEYz08wzNlxJnfNIkqX3sD9Sg
	 CE+A/F0XmrG2tNOBwp0/9RTN0auYw2JBR3efRBYqMMYG0ClEPMhEPM8dq8FRItxdBn
	 uBlnwop4+7C8N+atJSXiyDuZLeUjj9Bp2tVoE2OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0542/1266] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Tue, 21 Jul 2026 17:16:19 +0200
Message-ID: <20260721152453.994572311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d72e7f3263eaf9..6a0afec3542bb4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1431,7 +1431,8 @@ static int ext4_journalled_write_end(struct file *file,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.53.0




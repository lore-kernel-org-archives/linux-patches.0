Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6932D0C75;
	Sat, 12 Sep 2026 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215859; cv=none; b=YvhcHg6Sz+N8WoUdLbdAl74F24c/f+8DQovnRtP0WppNuwmq43TAARxf7rSilitOk+rd9aIxQkR58RcI9/hMj64Fx/qH0/a8/OZ/8SGlsFN08+qWQp9Pj9I3+/7ie3d79q3gkzTU+nLsmRCoVty63niJHQeCDrRvBrKtnoHQibA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215859; c=relaxed/simple;
	bh=CYSwGSAJ8OE80Og8/1RUv/pcN682lR8U4RAl1IXSDHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfvSzVWwv1AQgnRLLaK48pRDReObOx3zjK4H3Zm0axLOMkXJ/9g5RMhaJleoB8x38VJTkwIWwoPh0P17ouec7/xbzF8fcIg06yBv+CW4Vsu0ygKL31OuX3NburFSMKWmi/+GWpp/bJNO4vLzk6rPZR5Ch1Rr2uzvuun8zU4djf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3w5MSO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3w5MSO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058741F000FF;
	Sat, 12 Sep 2026 12:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215858;
	bh=XOekfUJ6T+6VBDT/8JSMFkuxR7y7HyEftBRvLOcqdxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3w5MSO5P1GDDn1aQX9c3arhe3dMxjcH0xWQ/ZPuvVyI0+fC5jyJEanwXHdxyhi3O
	 hX2wfAKXubnL8+bY9zmOC9SeUY335ZKCczEFxH9cbQ21o6H3NgX6Ul4vPQqprF2YTT
	 s2QefURSuyWU7ppgHuavCpSujK2PQxTcXwZYmXNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0619/1376] ext4: fix out-of-bounds read in ext4_read_inline_dir()
Date: Sat, 12 Sep 2026 08:50:45 +0200
Message-ID: <20260912065621.338123481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 9333cc809f0a89e001b814155a6cb8903a6274df ]

ext4_read_inline_dir() can read a dirent header past the end of its inline
buffer, triggering a slab-out-of-bounds read during getdents64():

  BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
  Read of size 2 at addr ffff88800f3dd23c by task exploit/148
   ...
   __ext4_check_dir_entry
   ext4_read_inline_dir
   iterate_dir

The dirent payload lives in a buffer of exactly inline_size bytes:

	dir_buf = kmalloc(inline_size, GFP_NOFS);

but iteration runs in a position space extra_offset bytes larger
(extra_size = extra_offset + inline_size) so the synthetic "." and ".."
land at their block-dir offsets. A dirent is formed at "dir_buf + pos -
extra_offset", yet the ext4_check_dir_entry() length argument uses the
larger extra_size. A position whose dirent header would extend past
extra_size is therefore accepted, and the rescan loop's rec_len probe and
ext4_check_dir_entry() dereference de->rec_len before the entry is rejected.

Reject a position whose minimum-size dirent header would not fit within
extra_size before forming de, in both the rescan and main loops, and pass
inline_size rather than extra_size to ext4_check_dir_entry() so the length
check matches the physical buffer.

Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260615190519.946736-1-xmei5@asu.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index b55bf19c82f26..54eb10c376379 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1554,6 +1554,8 @@ int ext4_read_inline_dir(struct file *file,
 			/* for other entry, the real offset in
 			 * the buf has to be tuned accordingly.
 			 */
+			if (i + ext4_dir_rec_len(1, NULL) > extra_size)
+				break;
 			de = (struct ext4_dir_entry_2 *)
 				(dir_buf + i - extra_offset);
 			/* It's too expensive to do a full
@@ -1588,10 +1590,17 @@ int ext4_read_inline_dir(struct file *file,
 			continue;
 		}
 
+		/*
+		 * de lives at dir_buf + ctx->pos - extra_offset, within the
+		 * kmalloc(inline_size) buffer.  Make sure its header fits before
+		 * ext4_check_dir_entry() dereferences de->rec_len.
+		 */
+		if (ctx->pos + ext4_dir_rec_len(1, NULL) > extra_size)
+			goto out;
 		de = (struct ext4_dir_entry_2 *)
 			(dir_buf + ctx->pos - extra_offset);
 		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
-					 extra_size, ctx->pos))
+					 inline_size, ctx->pos))
 			goto out;
 		if (le32_to_cpu(de->inode)) {
 			if (!dir_emit(ctx, de->name, de->name_len,
-- 
2.53.0




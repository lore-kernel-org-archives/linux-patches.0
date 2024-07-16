Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB3119AD72;
	Tue, 16 Jul 2024 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145493; cv=none; b=rWbwBSVm+oWFOEDis8wfPqgfbF/LPDwkJ9mLKOSHok6TTrI5mSukyAD6k2kbVGl9qCbhRmxqBJUtLFeoNqaF9l0wWEa6yDYWA2LxNau8vmCW+poiO4pdhzCP0MGDSi9K29uS2DHRd/L96b7IHRAbq5G8WaxhwuR8A8UchkXS4og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145493; c=relaxed/simple;
	bh=cJbW0iwtJiAaAaAd6kkN0ptXjq2xHcafzj1tAAvpd9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0TV28S6Zc8njBdHrLV+sk/K0YeUHVHLjweaHCowEQR565mefhqwhcx0xECgaykZrseIKPCoG+k/jZ1mkgeMLy79hlfUBdLL3Zq1Tk/j4uRZO/AOEBnPbu01IIByr5p2DWK3WTJnuzkzl6Jxd091ceKy99o5o23Hh1WOPOtousI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j50CYkIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j50CYkIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8696C116B1;
	Tue, 16 Jul 2024 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145493;
	bh=cJbW0iwtJiAaAaAd6kkN0ptXjq2xHcafzj1tAAvpd9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j50CYkIgdWmXTiXqstMri5oJNVFme255+YOfUac6KrPgIaXZ+bfXlRZDi6Sl+tDfK
	 ndiCR1OOf58338o5XvQFD9uD9DMCvDbKH9gta0QzJJUjnjWD40ekWCnRNThYZhCTY1
	 vLB7SZddby0hPd3FrtIJslm5MTHLLocDDVzW3770=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 84/96] nilfs2: fix kernel bug on rename operation of broken directory
Date: Tue, 16 Jul 2024 17:32:35 +0200
Message-ID: <20240716152749.747162543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit a9e1ddc09ca55746079cc479aa3eb6411f0d99d4 upstream.

Syzbot reported that in rename directory operation on broken directory on
nilfs2, __block_write_begin_int() called to prepare block write may fail
BUG_ON check for access exceeding the folio/page size.

This is because nilfs_dotdot(), which gets parent directory reference
entry ("..") of the directory to be moved or renamed, does not check
consistency enough, and may return location exceeding folio/page size for
broken directories.

Fix this issue by checking required directory entries ("." and "..") in
the first chunk of the directory in nilfs_dotdot().

Link: https://lkml.kernel.org/r/20240628165107.9006-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d3abed1ad3d367fa2627
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -396,11 +396,39 @@ found:
 
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct page **p)
 {
-	struct nilfs_dir_entry *de = nilfs_get_page(dir, 0, p);
+	struct page *page;
+	struct nilfs_dir_entry *de, *next_de;
+	size_t limit;
+	char *msg;
 
+	de = nilfs_get_page(dir, 0, &page);
 	if (IS_ERR(de))
 		return NULL;
-	return nilfs_next_entry(de);
+
+	limit = nilfs_last_byte(dir, 0);  /* is a multiple of chunk size */
+	if (unlikely(!limit || le64_to_cpu(de->inode) != dir->i_ino ||
+		     !nilfs_match(1, ".", de))) {
+		msg = "missing '.'";
+		goto fail;
+	}
+
+	next_de = nilfs_next_entry(de);
+	/*
+	 * If "next_de" has not reached the end of the chunk, there is
+	 * at least one more record.  Check whether it matches "..".
+	 */
+	if (unlikely((char *)next_de == (char *)de + nilfs_chunk_size(dir) ||
+		     !nilfs_match(2, "..", next_de))) {
+		msg = "missing '..'";
+		goto fail;
+	}
+	*p = page;
+	return next_de;
+
+fail:
+	nilfs_error(dir->i_sb, "directory #%lu %s", dir->i_ino, msg);
+	nilfs_put_page(page);
+	return NULL;
 }
 
 ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)



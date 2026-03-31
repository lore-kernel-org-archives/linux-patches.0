Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594442D7DEF;
	Tue, 31 Mar 2026 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976859; cv=none; b=WPzCGUv0eIb3DK1cPjpIRPxN8chsmyt1rUIx2I50Bguu9HOne+3OUltSa0kai5ZdL0aMCuPtXvgy6L8ADajWsDHaILCe8lSmvVdCq3kM1ujop2HCv+HipYMp2gnhJ3k/r4PV/whrH/yqrez/9QpnUAidTEwXasNySmwYlxr2788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976859; c=relaxed/simple;
	bh=m02/ecOA/ZDSHMkDGuyv09pAjIFqarjwmeOD2+jW7AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh9mymlxt4jfL20fiFRCT49GEVh4LByAgNUPz/0/IxrrXnaEswh6mLT6bRmXTR0yl3WqkNNbC6N8Yq5vH5g4ipHlzfOFr5Ge1ZDXmM0rYG7xrxspn4LvA3D/Sjcfn6kWw8zugewEBICEpcrWBpDd0sBx0KgMdNATXbXqzLI3IGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1+JHKXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1+JHKXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FF2C19423;
	Tue, 31 Mar 2026 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976859;
	bh=m02/ecOA/ZDSHMkDGuyv09pAjIFqarjwmeOD2+jW7AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1+JHKXCb9bDCqQt5cvoFK48ZXiJE/nJW5Kn2PFUF+SpMNxAWp4H8xoe0Lx4QlQUN
	 0fv85IXAADzNZbdNC81VkUZ51U4aBGtrfSxYmdoY3eiMtoF63W4n275H0PHI9KiEAm
	 AVtgY/jJO1tdJjbsnHUHsDemDZSArYKCdFSA05Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 255/309] ext4: convert inline data to extents when truncate exceeds inline size
Date: Tue, 31 Mar 2026 18:22:38 +0200
Message-ID: <20260331161802.960004858@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit ed9356a30e59c7cc3198e7fc46cfedf3767b9b17 upstream.

Add a check in ext4_setattr() to convert files from inline data storage
to extent-based storage when truncate() grows the file size beyond the
inline capacity. This prevents the filesystem from entering an
inconsistent state where the inline data flag is set but the file size
exceeds what can be stored inline.

Without this fix, the following sequence causes a kernel BUG_ON():

1. Mount filesystem with inode that has inline flag set and small size
2. truncate(file, 50MB) - grows size but inline flag remains set
3. sendfile() attempts to write data
4. ext4_write_inline_data() hits BUG_ON(write_size > inline_capacity)

The crash occurs because ext4_write_inline_data() expects inline storage
to accommodate the write, but the actual inline capacity (~60 bytes for
i_block + ~96 bytes for xattrs) is far smaller than the file size and
write request.

The fix checks if the new size from setattr exceeds the inode's actual
inline capacity (EXT4_I(inode)->i_inline_size) and converts the file to
extent-based storage before proceeding with the size change.

This addresses the root cause by ensuring the inline data flag and file
size remain consistent during truncate operations.

Reported-by: syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7de5fe447862fc37576f
Tested-by: syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Link: https://patch.msgid.link/20260207043607.1175976-1-kartikey406@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5915,6 +5915,18 @@ int ext4_setattr(struct mnt_idmap *idmap
 		if (attr->ia_size == inode->i_size)
 			inc_ivers = false;
 
+		/*
+		 * If file has inline data but new size exceeds inline capacity,
+		 * convert to extent-based storage first to prevent inconsistent
+		 * state (inline flag set but size exceeds inline capacity).
+		 */
+		if (ext4_has_inline_data(inode) &&
+		    attr->ia_size > EXT4_I(inode)->i_inline_size) {
+			error = ext4_convert_inline_data(inode);
+			if (error)
+				goto err_out;
+		}
+
 		if (shrink) {
 			if (ext4_should_order_data(inode)) {
 				error = ext4_begin_ordered_truncate(inode,



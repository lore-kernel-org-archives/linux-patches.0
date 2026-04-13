Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C543A3264CE;
	Mon, 13 Apr 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099344; cv=none; b=HWHprfYEHgyOG2u48+WMVRpeVi9YhCH7qgkE/06Pca9Adc0OTSMQx8SSyKJfQv7XBa8TIyFDeF6LR4aZB2iZYEOoeiSlfBQ+Os9rvsvyTTwgcpD+DEz7H4u5AzOwe+XPwAvr2sIv4oyM8BeGZFPdYb0UMJt7v5Lwfb0+dfLcFYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099344; c=relaxed/simple;
	bh=u9GZjRiJO51KvmMEFFUxkNTFWgsGFrId3+1K3T71fD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPKoj5ptqNL0Ua3VlvG2r28pfXm3pxNDLL5UVp6npHiqVydnqNL/4bvmetJ1BteDX0iN4DI+9pSvEHSsuOnnU6MU0RSvo5EDRbl1XFEWPNkYMjJNwJSMWSvHqFyqa+Eta1jUHC44kVeFIpqh5JR/xwLaFcQ1GvPOb9FbBn2ASi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzCGP1pS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzCGP1pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C348C2BCAF;
	Mon, 13 Apr 2026 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099344;
	bh=u9GZjRiJO51KvmMEFFUxkNTFWgsGFrId3+1K3T71fD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzCGP1pS1kTRLiim5HgUwHnK6XG6lcSE+hixBouk8fPSqK7iFO8obJmd+7P6IwIxa
	 XRW9jCZ0OsgZr5JqIsn1APDzq2+fQH8OU584gRitGRc6WQhmiWVit7S2NYCRRqQli7
	 rr2MoHeoEdm2rpClXHicl2CUvSI9IX7/9M4C0364=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 304/491] ext4: convert inline data to extents when truncate exceeds inline size
Date: Mon, 13 Apr 2026 17:59:09 +0200
Message-ID: <20260413155830.422654961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5576,6 +5576,18 @@ int ext4_setattr(struct dentry *dentry,
 		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
 			inode_inc_iversion(inode);
 
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D82D0C7E;
	Mon, 13 Apr 2026 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098063; cv=none; b=eEMaSndbdQdH0iOjBrDc/tHLzVX6uaV9bT5ivIjIZX2hgYHgYPUmly5wSX6eME2NsKZj8MdpnwGA5m5ugZQsoDC6zX7NoyQqbITibmReHo4BV4oMfAkZOUo1PV+5QpbSxEmrbX7RIAoJ3yJV1k2MNTlHi6SwZPVrtQyFR81BsyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098063; c=relaxed/simple;
	bh=1pjf20jBqRQDjBeIQiN//fYLEVt0h5tGH2liWDUFSzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgkA1HaeavjX1up5di+H2IaQl5FhHZ34ac5UFE876GMjKhnxWErvMcKRceuNgem9XVroaZemELZpMpuVlmmW1t4RdQgamJPZ5bf2Od18XaQ02n7t+rGn3SEUgw4QgDaRvxPRvgM9DoSfVrTNPeSNq1fuXwyHcDHUmRt12GmoxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKIizvMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKIizvMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E929C2BCAF;
	Mon, 13 Apr 2026 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098063;
	bh=1pjf20jBqRQDjBeIQiN//fYLEVt0h5tGH2liWDUFSzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKIizvMjqHyqFH9eI2V7zV5rPN/FrnqqMDubnzKPpMDsr2YcfxPQ59rZ/WxG+I1SE
	 gyo7UXp1zWMnEUPez8S3BG6fphRAkZybmHMi9fc0WHqsM/ucesz5M2id1eCTC5OExd
	 qUwuRTrn+UzbBX5I1fmgc9mb98eo0pp/M4luyPj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 380/570] ext4: convert inline data to extents when truncate exceeds inline size
Date: Mon, 13 Apr 2026 17:58:31 +0200
Message-ID: <20260413155844.714375720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5507,6 +5507,18 @@ int ext4_setattr(struct user_namespace *
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



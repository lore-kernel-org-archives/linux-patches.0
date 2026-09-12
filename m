Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB2357D18;
	Sat, 12 Sep 2026 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227314; cv=none; b=aiWuyWd1qEv+TnksUJf8WlTOnxO6f8fR+Mzn+FEEZfdcVSzg92rzdkGWRK+EmoBKbRsHEb109OkEfeFlgqp/49didOvp9PhaOOccEHUePLVltCme8D7Yl4zv3Ny06kHifZfO3ogToEbBbMGU7uj5FXAXxghXQTk/v3Lp3KEim9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227314; c=relaxed/simple;
	bh=x+2dbP89xJ9b4ZKU+ybJo9ZtlniP3Fq+Fz9DHQOPW+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCSYj3PFpeVR7ZOm9SqeAOEVAf6dq3aJ7dATdyRQwBwns3hV1qu/jQvPubJn10sBgqz8FSQjHqtlQhKUiNnoGt4F2Don23xoSXtEEEWNX6uhokMtT6Qf1kAUCzVXECCn/OHB6k94K/0Qo0OQ5fuQhvVTvMVDq3MFpe+s9iWqhBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9nL59Go; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9nL59Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5221F000FF;
	Sat, 12 Sep 2026 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227313;
	bh=LLnBrP/HHJEFDyYRj8zAovXc7iGkPMs5vsoI/W8WP6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9nL59GoLUVZcFlKGl7qhQZ5sKjuS0iv5OeIf0eMFBS64ZxCsy7D6QNUsKRk3Aw/T
	 i956HOlrZUImn52DSAOFunvqHHsYIWDt37X0MBbZD4U0B0waoMjLvfPWXZU9ConZYJ
	 VWf4kCdq64lOSGAGHCoKqv9Zn9tCOfI4qVjnRCHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ted Tso <tytso@mit.edu>,
	"zhangyi (F)" <yi.zhang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0156/1191] ocfs2: fix readdir position truncation on 32-bit kernels
Date: Sat, 12 Sep 2026 08:48:04 +0200
Message-ID: <20260912065551.712806171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit a63308ab426f3a3c7e33b02c150ea59054620261 upstream.

In ocfs2_dir_foreach_blk_el(), the directory cookie position is
rebuilt with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

`ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask

	~(sb->s_blocksize - 1)

is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
block size).  In the AND expression with the 64-bit `ctx->pos`, that
unsigned operand is zero-extended to 64 bits per the usual arithmetic
conversions, yielding 0x00000000fffff000.  The high 32 bits of
`ctx->pos` are silently cleared, even though directory size is
allowed to exceed 4 GiB.

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
position is reset back into the first 4 GiB block, making the
re-validation path re-enumerate already-returned dirents indefinitely.

This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
for all non-inline directories, so a directory large enough to cross
4 GiB reaches it.

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat, and the
fix mirrors the equivalent ext4 fix in this series.  Cast the operand
to loff_t so the mask is 64-bit before the AND:

	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

64-bit kernels are unaffected.

Link: https://lore.kernel.org/20260806022044.167962-3-zhanxusheng@xiaomi.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1882,7 +1882,7 @@ static int ocfs2_dir_foreach_blk_el(stru
 				i += le16_to_cpu(de->rec_len);
 			}
 			offset = i;
-			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
+			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
 				| offset;
 			*f_version = inode_query_iversion(inode);
 		}



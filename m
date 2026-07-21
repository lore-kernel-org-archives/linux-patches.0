Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9278D46E009;
	Tue, 21 Jul 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658781; cv=none; b=NigYX3NXP7k1/DRDitrQWXususN8lTVSo2Wv9by3fjyaq33HKR3Ey9HNDSeZIOE90AAi4vQ0NGg/FJEaxFQR0D+weayLVaHHOZa++YzAGa3u0bgDlZyo9yQr45/GXXwroo1XMV9iOdtCHJ5aYk20hg5Dm+eBkg4di1Av/vnh7KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658781; c=relaxed/simple;
	bh=sYU2IBFyw8dx8cciec+oNAOEO81Cgm5JNRmMSfLfrdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrlYFxF8f2lAiX8534Jt1ux9wTE00o901cYcnCtuww8I+AbNhQeL04HP5UMw0GtsVCjjmK5Lzqo1DUvmJgngbdUkTqy/cjtzK7a4CGUTMuqdbQOPY2N9H0Fdm1aYayAAKd164hBdGWaJxUFKuXUlgrs1j+oYQFF99rNpfgUQno4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ2zOBHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ2zOBHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3DA1F000E9;
	Tue, 21 Jul 2026 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658780;
	bh=aas2kqT7WLmdWof/4+bj8LCvZ+0c0CR2tSmUpxHnRzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZ2zOBHW3KWGffuuSDYa8tJ1wmb+5Vfu59GYpmNxNz20C5SQIodzmhBeZwxBmIeUz
	 BfbxOK51+Rx08xLT+bjV2FEiihRAw5gCC5JTrD+jSuK/t/BdiCSNPyZbv6Y0K3Yeeo
	 6o9bbmzob05k7BWrtL43iwTuKWEJoNuxeN7648vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1273/1611] ocfs2: reject dinodes with non-canonical i_mode type
Date: Tue, 21 Jul 2026 17:23:09 +0200
Message-ID: <20260721152544.079568377@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 5366a017099c6a3c443be908a05f26fd72af12a1 upstream.

Patch series "ocfs2: harden inode validators against forged metadata", v2.

This series adds three structural checks to OCFS2 dinode validation so
malformed on-disk fields are rejected before ocfs2_populate_inode() copies
them into the in-core inode.

The checks cover:

  - i_mode values whose type bits do not name a canonical POSIX file
    type;
  - non-device dinodes whose id1.dev1.i_rdev field is non-zero; and
  - non-inline dinodes that claim non-zero i_size while i_clusters is
    zero, covering directories unconditionally and regular files on
    non-sparse volumes.

The normal read path reports these through ocfs2_error(), matching the
existing suballoc-slot, inline-data, chain-list, and refcount checks.  The
online filecheck path uses the same structural predicates but keeps its
own reporting contract, returning OCFS2_FILECHECK_ERR_INVALIDINO instead
of calling ocfs2_error().


This patch (of 3):

ocfs2_validate_inode_block() currently accepts any non-zero i_mode value.
ocfs2_populate_inode() then copies that mode verbatim into inode->i_mode
and dispatches on i_mode & S_IFMT to the file/dir/symlink/special_file
iops; an unrecognised type falls through to ocfs2_special_file_iops and
init_special_inode().

Reject dinodes whose type bits do not name one of the seven canonical
POSIX file types.  Use fs_umode_to_ftype(), the same generic file-type
conversion helper OCFS2 already uses for directory entries, so the
accepted inode type set matches the kernel file-type vocabulary instead of
open-coding a local switch.

Apply the same structural check to the online filecheck read path.
filecheck keeps its own error namespace, so it reports malformed i_mode
through the filecheck logger and OCFS2_FILECHECK_ERR_INVALIDINO instead of
calling ocfs2_error(), but it must not allow a malformed dinode to proceed
into ocfs2_populate_inode().

Link: https://lore.kernel.org/20260519110404.1803902-1-michael.bommarito@gmail.com
Link: https://lore.kernel.org/20260519110404.1803902-2-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -64,7 +64,12 @@ static int ocfs2_filecheck_read_inode_bl
 static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 						struct buffer_head *bh);
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
-					      struct buffer_head *bh);
+						      struct buffer_head *bh);
+
+static bool ocfs2_valid_inode_mode(umode_t mode)
+{
+	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
+}
 
 void ocfs2_set_inode_flags(struct inode *inode)
 {
@@ -1505,6 +1510,24 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * Reject dinodes whose i_mode does not name one of the seven
+	 * canonical POSIX file types.  ocfs2_populate_inode() copies
+	 * i_mode verbatim into inode->i_mode and then dispatches via
+	 * switch (mode & S_IFMT) to file/dir/symlink/special_file iops;
+	 * an unrecognised type falls into ocfs2_special_file_iops with
+	 * init_special_inode(), which interprets i_rdev.  Constrain the
+	 * type here so the dispatch only ever sees a value mkfs.ocfs2 /
+	 * VFS can produce.
+	 */
+	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: mode 0%o has unknown file type\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1633,6 +1656,15 @@ static int ocfs2_filecheck_validate_inod
 		     (unsigned long long)bh->b_blocknr,
 		     le32_to_cpu(di->i_fs_generation));
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
+		goto bail;
+	}
+
+	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_mode));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
@@ -1820,4 +1852,3 @@ const struct ocfs2_caching_operations oc
 	.co_io_lock		= ocfs2_inode_cache_io_lock,
 	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
 };
-



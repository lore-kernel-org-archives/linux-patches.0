Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34FC56C625;
	Wed,  9 Sep 2026 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962930; cv=none; b=ZBRgEl1zSTdr7qxFSXUnl5JVa0q4M4v0pO5kZjEjvQ9BuVqWK20UUSsdEZFq1CG9/2cT+w2ZtiCk98crp/SjkIm+5b48LBa3w5cLD2s4YIrJ2TT2NmLWOKpx4Rj+96QfEc6FX9FHK8k6nJyqgEVx8yhq1Dp181Wj98MfEN5JCoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962930; c=relaxed/simple;
	bh=Cvbz7R0l3bHctluMUzqKp0jwIeDX5wT02dtF3RHOTUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaRPN1MlsTCj6JAmCATU8aSri4x0MNpBz1Ak95GLHUIEVeHc9hMnSY6W+gdNUxq4V/i30UTeidRmcq9n7kG2nPHuCk2keGwucy+xpbL38mViw8Z8m/Br6CW2kQN838824Ci3cTVN3KnA0dDL+Gv/F/cJvM3Bbd1t2PKZG6mmB8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFuxMPp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFuxMPp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126421F00A3A;
	Wed,  9 Sep 2026 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962928;
	bh=8aFOpbHliWPueJHg5YyAcVV/ekgOtXTop51WODfv1hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFuxMPp2xSJBMerofr+6V3Sp/9n+vr3y9vFPO9f8zkOTJr2rQKf6zrp7J/+8cL0Bp
	 zWCKD0tpbvc1L5+llovUZLhJAaA83hR7wUdG84g+DG3Ly9rPtOdLV9MwipLI7ix1xb
	 fdwI1nyoI15M5d5chqPHdEF9O3MVFtaw47JfFlp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 453/556] f2fs: return writeback error from collapse range
Date: Wed,  9 Sep 2026 15:42:13 +0200
Message-ID: <20260909134246.509890054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

commit f8a4108800254d6f7b2755515fbbd9d0caac561e upstream.

f2fs_collapse_range() writes back pages moved by f2fs_do_collapse(),
but ignores the return value. If writeback fails, the ioctl can still
truncate page cache, shrink blocks, and report success.

Return the error before truncating page cache or updating the file size.

Fixes: b4ace3370324 ("f2fs: support FALLOC_FL_COLLAPSE_RANGE")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1617,11 +1617,14 @@ static int f2fs_collapse_range(struct in
 
 	/* write out all moved pages, if possible */
 	filemap_invalidate_lock(inode->i_mapping);
-	filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	if (ret)
+		goto out_unlock;
 	truncate_pagecache(inode, offset);
 
 	new_size = i_size_read(inode) - len;
 	ret = f2fs_truncate_blocks(inode, new_size, true);
+out_unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 	if (!ret)
 		f2fs_i_size_write(inode, new_size);



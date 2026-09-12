Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3547ACD7;
	Sat, 12 Sep 2026 18:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238136; cv=none; b=uYrMSpLTGcGD3Oj+52s2BCbfqUQNjBl540zqT+R4yeduiWtgHC7Nud/2oJbtpx06LrcolU7JjgjOipuu+H0kDbVQc22617yevc3bCVKBC9OyxDrnJk/wROXMY0DUiimG4RmrRBo1q4uhEHblUQpS4qC0G5ov51eRFwwBiZ2xlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238136; c=relaxed/simple;
	bh=5UBx4U1SdMH1AWeRzbCH/zqoeFk9PqFKDCK0ZBhMzq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzDpRlQ2NISOZhW7pZS8gHlMz2PKrn7LU1o1e++s6zQ/haX5eTYL79AIX6f44YaQhOL+iURbKxBRziYetqkukPRm1CPvoFVntNuref7K/BJkszfDMH133jD7oyrinpxOAt3FFBnurW5PiKIBnE7SDU61Sk2M06tKNulUZlJxBWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D58c+VOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D58c+VOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239DA1F000FF;
	Sat, 12 Sep 2026 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238134;
	bh=tzK3OR/BQ/bL2Z/wNEeATQvRVMGAcbM0MP8savckUZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D58c+VOic5v88GpnJCcQHTZzDo5HJDImZjvspTPOsUUzcIrRMaR+rOJtdOW1K40i8
	 wRCiei2Xa7mFwLHmsSbW0nDbZxk0m/H5sef6FJncC4vDJVVfjuNIv5HS1LBw/GNWcT
	 rb32NHebzVc0uP6rM9iWwbc5WlMNYzp2qR16pw2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 357/935] f2fs: return writeback error from collapse range
Date: Sat, 12 Sep 2026 08:56:27 +0200
Message-ID: <20260912065534.995997898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -1414,11 +1414,14 @@ static int f2fs_collapse_range(struct in
 
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



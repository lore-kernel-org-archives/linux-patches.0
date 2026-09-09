Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2966584949;
	Wed,  9 Sep 2026 14:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964268; cv=none; b=O7pI+pTOqV+jqy5kRZYKc08vkX8dXSElxC0pJfLXWyuriXqjr8rA7x06SwhVy5vIjN5syuugVD+fANY08lt/GOFurpt56nSb9ZPiRfHYck/sIKwwNc3XnObGMzd1yRxenwS3ZWQxyAyaRf843uG+ojBVhtaieXOJmNFdS9cEda0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964268; c=relaxed/simple;
	bh=CYkp2UgF0y1tyBy44SjJ6RNJSMv3CdUNrPGCwQjFZmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To7Cg69h/gdD/+wCzF6JDj5stDVR3whxjHGVV5+VNa1D7BWbaTpp7C/Kz1tiIHaCpfEaqgEysyifb5O+v7FUIG5IwKJUhDEyF/G9aqOk0wefvt2cMzeLa9KusZ+VQVSQfeVyfZHR0mFLGM3SBXPm0F7EUfv6hE+2WcGKkJJQQFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZokLm05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZokLm05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ECE1F00A3A;
	Wed,  9 Sep 2026 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964266;
	bh=SXiHnG/C7uuD3T1hFvNrp6+tWKr+A0Uct4YLx0Bn0As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZokLm051Zty9T49nJqnJTnsQsFaYgQndj7InYawYkgojFGaGaZkbrhEFjXdrsYUL
	 SpkTMuV/id4aclv6/SuRzo+emlzv7jjwNPfI6ll2Ykjs0gG4QNSdSEWiPvMFM7+l7v
	 CcaUljNF9NF4RCpJGwAm3ZhQU+sudGhl0u11HY1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 357/583] f2fs: return writeback error from collapse range
Date: Wed,  9 Sep 2026 15:40:42 +0200
Message-ID: <20260909134250.378558805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1599,11 +1599,14 @@ static int f2fs_collapse_range(struct in
 
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A721929DB64;
	Sat, 12 Sep 2026 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228567; cv=none; b=AP9eNyKLWESbiv+RylAzyH70vROQZL1ujiCMvhWN1uvqwC7hvj0Z9FVMl86uQyudPEV2lUqXaHbwL+FQGhW+aH6578PqJDvCu9r2f8hi3yb2On6x8vSzngwflWvnicT1kS27PtWmOEOVLFnAhTM1ViRLl/LTGTYdmRGRqz1LLe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228567; c=relaxed/simple;
	bh=/5JY3yq1f1t4ELiHR/b7Speu0T1F7HnWRG+WUMxRXic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buqvAPc3jK7UFSUM9b+ypMMIZsxjsJLbo733PiGM4CBhUNzPNvCkXMFKmPNwquhD1cb8e46bd1dX18afuqVlTbFglqZ/FnRRYMpz9GPabIvH8zhwIvonQZWsq4JX32xOksssgx93xoHOWus2ES/evdyT+TcTDn/8tQ/E11yMaY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgc7pKcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgc7pKcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB0F1F000FF;
	Sat, 12 Sep 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228566;
	bh=opasFTkEvKmucia+jzFYi0fSVU/jPiVQN6a4E24ewx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgc7pKcDcDxpNlE/7vybPt38kEnvo3IfkGZLfKsDFPDITHLCP5Ws5x3pTZsv0nSV1
	 QySYLM12ILzsRmHQMEr+5cWHJwevaQqhVocQAEVAP04Y83XddOnaOJV4L1yoWVP3ye
	 nLb+8f0aPCgZWw9Zfd0dfuMHtlQJxBc6Eko3TUio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 0410/1191] f2fs: return symlink writeback errors
Date: Sat, 12 Sep 2026 08:52:18 +0200
Message-ID: <20260912065557.448385906@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit a2c73a7a677afdaa8b16d775188f9ef5cfbfd8b2 upstream.

F2FS writes long symlink data with page_symlink() and then flushes the
symlink mapping to reduce the chance of exposing a broken symlink.

That flush result is currently ignored. If the writeback fails, symlink()
still returns success even though the symlink is not durable and the same
operation can already surface -EIO through syncfs().

Return the writeback error to userspace and skip the dirsync flush once the
symlink data flush has failed.

Fixes: d0cae97cb600 ("f2fs: flush symlink path to avoid broken symlink after POR")
Cc: stable@kernel.org
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/namei.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -663,15 +663,16 @@ err_out:
 	 * performance regression.
 	 */
 	if (!err) {
-		filemap_write_and_wait_range(inode->i_mapping, 0,
-							disk_link.len - 1);
+		err = filemap_write_and_wait_range(inode->i_mapping, 0,
+						   disk_link.len - 1);
 
-		if (IS_DIRSYNC(dir))
+		if (!err && IS_DIRSYNC(dir))
 			f2fs_sync_fs(sbi->sb, 1);
-	} else {
-		f2fs_unlink(dir, dentry);
 	}
 
+	if (err)
+		f2fs_unlink(dir, dentry);
+
 	f2fs_balance_fs(sbi, true);
 	goto out_free_encrypted_link;
 



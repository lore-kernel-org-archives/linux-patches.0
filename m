Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D719479880;
	Sat, 12 Sep 2026 11:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214054; cv=none; b=R3qroUWg5RJBHntzNhWspusEgIKgmUR+1P7xnd482Um2EMSBSvyb+h/dqbZs+WlGVuwK4XTrNeZshLnY++p0xBqdb79tvKXEvZy0IhD8eFrjW86t7Kx5xn7GEiDmJZ4wSgXe/gBtMoOQ+apgSvjqtiumrLhyjVbHAlJJC8ArQzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214054; c=relaxed/simple;
	bh=qfUQE3rCaqRjadABSsIZ/EphWq1QyQ9Bo2BGbMyqjuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr9iqlfnwk6L6vZCHGPV8yC+Lzvnqv+n9gv2XBUJV67D9YMDeI/VnRZLJX+/30OxrkfIrCd87J0VFIyd/NkOJP8IBV3Wml6pTCLlj8Ahwep2PBx2UbE/jfFm8LlxHnghUu0fL3tA0nmleBO1+ZdCyZAoMzQMNQlri+Ovt1WhJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vw6QbRRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vw6QbRRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D9C1F00893;
	Sat, 12 Sep 2026 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214050;
	bh=QaBusY1l9WKt0PscGdqsOi0ly+Sf6UcDrApcdaU70Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vw6QbRRuArw5bdtmiI6fS2mXvKHO0D1rpNhq7K44HWAwjaVF02Ratj0GAZqBv14aP
	 Ifm8ivgPKtZ/PSA5/yrjq2TTx2WX6K25L6UazbFJPb8IY6A1Kutv6zlfcebZish5Rk
	 5Hsjx2H6KKPKh7Jo/QErqDt1/H9GA+Y69oXfTH14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0248/1376] f2fs: return symlink writeback errors
Date: Sat, 12 Sep 2026 08:44:34 +0200
Message-ID: <20260912065613.067234340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -672,15 +672,16 @@ err_out:
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
 



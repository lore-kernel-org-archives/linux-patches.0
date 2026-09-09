Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF27A568FD3;
	Wed,  9 Sep 2026 14:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962887; cv=none; b=RuPbJ7ZSTsOW/FVXDrwfoeWlBeLr6hmbipGALd595Qna87q37g+PHnAt/Sgt5AzE/JYY+MzWrwJPsuLED+v7TDCKhlvZUQhY//N2wotxIeT2rFDZICYsmDdETzVwlGke54btLeKY4q4b89mxQoJhTFpN7NI+86qKDzWsGkWFtX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962887; c=relaxed/simple;
	bh=qM+mKRsifOP00S3WsifTxfwQTSPrEXp1Te0CcZPW02k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptUO2qwhY0ToKtm+7p3Oj2hxs2BGehHbBZvdpEeNsWxvTZ8QF1QMe0JvG/o3xrtD9AB0OflrS+V1V64yOcn0T0YeP82YgWPhgbvbUvomMYpNw73AQYjneTEAm68GfCnSitCuPux3THwBTofFk7g+P1/PoEviMs4J1t44Qn6HSMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwTvqXbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwTvqXbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23111F00A3D;
	Wed,  9 Sep 2026 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962885;
	bh=/kYSODNmddnEumyUeVPkMH9ffn2ns5VFtRy2Tti/c+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwTvqXbJk4/yDamGT0KN3CPmcSUXkjx2ZS7p8kTn+9bKLrOhhxv5awqheFuKvX3XY
	 gGIv46cgtONBtqxEhYJ8pa6v/Q4yf+/qfMKX1FaLhihCKRpgkOD4E8wfwUZU3B4Q2w
	 +ivGQkABhHoqs0iQ1VmSIilRAUsa7/84oqSN6YKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 446/556] f2fs: return symlink writeback errors
Date: Wed,  9 Sep 2026 15:42:06 +0200
Message-ID: <20260909134246.286023102@linuxfoundation.org>
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
@@ -707,15 +707,16 @@ err_out:
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
 



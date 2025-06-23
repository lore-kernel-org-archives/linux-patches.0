Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99844315A;
	Mon, 23 Jun 2025 21:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714865; cv=none; b=PyyGD+qkXlR/d2WnjhzCX1DVtaOOOTH7ueMZN3reQMqx4wnECaD47cGESPYm8Iv/JWN3J5vx41qRv4Skzqe9BzEL6C+4BI0rWRKgEusnIk7QnQV1dFQMgl64qdtKXo7Gsv4wobqa+d09c4NEXtxYQQdCmi+/xGNu7/2pV7gjwok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714865; c=relaxed/simple;
	bh=DxjW80zt/sk0J6mKBJI3VWOkA3zxi8sKVJ2EqgmuMLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivPo4ogFSzTmeqeQc3XVwa2uXNyOjYRAUM0vprWpjeEuC5VdYBqz+sIOpC+vmVATTerXWtEOrHiuk1P29QNk5oywtjbpHjwcjF4suZs9KDlAvz4P/ouWaH1+pMjJTAM6MLOvohfytSUn0WuZleTJ3zeyLE6WVG7rz6XUbmZFo4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8Li/GkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8Li/GkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DB6C4CEEA;
	Mon, 23 Jun 2025 21:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714865;
	bh=DxjW80zt/sk0J6mKBJI3VWOkA3zxi8sKVJ2EqgmuMLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8Li/GkY/KmjJh316MGpXJKWsJijsNUj2eVwzukPMCeNflY4gv/xgZ7Mov76zZgzh
	 g0mAn4IPdBvmlJAgNRLtySei2HRlZO22KI7UVWDTZSiQg9cltn7nrYXMzrh5QAeWrT
	 2xDZU+0503u699qdyRRGlmZsiHznHDcRVCBh1LTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Luis Henriques <luis@igalia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 443/592] fs: drop assert in file_seek_cur_needs_f_lock
Date: Mon, 23 Jun 2025 15:06:41 +0200
Message-ID: <20250623130710.968665946@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis@igalia.com>

[ Upstream commit dd2d6b7f6f519d078a866a36a625b0297d81c5bc ]

The assert in function file_seek_cur_needs_f_lock() can be triggered very
easily because there are many users of vfs_llseek() (such as overlayfs)
that do their custom locking around llseek instead of relying on
fdget_pos(). Just drop the overzealous assertion.

Fixes: da06e3c51794 ("fs: don't needlessly acquire f_lock")
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Luis Henriques <luis@igalia.com>
Link: https://lore.kernel.org/20250613101111.17716-1-luis@igalia.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 3a3146664cf37..b6db031545e65 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1198,8 +1198,12 @@ bool file_seek_cur_needs_f_lock(struct file *file)
 	if (!(file->f_mode & FMODE_ATOMIC_POS) && !file->f_op->iterate_shared)
 		return false;
 
-	VFS_WARN_ON_ONCE((file_count(file) > 1) &&
-			 !mutex_is_locked(&file->f_pos_lock));
+	/*
+	 * Note that we are not guaranteed to be called after fdget_pos() on
+	 * this file obj, in which case the caller is expected to provide the
+	 * appropriate locking.
+	 */
+
 	return true;
 }
 
-- 
2.39.5




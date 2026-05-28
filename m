Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F7933CE8A;
	Thu, 28 May 2026 20:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000542; cv=none; b=PJ8lWjiqX6I69Bj7sURk1uUMSzAbvltve+xZZDWbB0uaKUh93qgK/SrsalP98o/xdep9JZpkT8AGKBd5mBXXlBawGI61T60uEvwbrX+di4/ZsCHBP7boOyTpsljg0bk14DCZs2KYc3Pl/p414nXCGZh4B3uGeY2oi9ST/miJS9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000542; c=relaxed/simple;
	bh=firqZoSSNjmXo8cHDSkXVtu3pOV02dmjrVWZkzVoElA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWaVIu6GMZ+Vc5IfU+pnvyczecN3KsQ9C6Qkxq9TYxCG1jNUUQw/y7sTk+8QXRWXa+qcmPsCb53TKgRgbJcBbZrNXn+aPpqvDURq8p7CVKFEwe5A1/irbvFDApYeoQfr3sKI4ESYZ/e/fv2W1bNzXPvovEfQNqAiVs0JKxac7+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MPGGiqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MPGGiqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DB21F000E9;
	Thu, 28 May 2026 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000540;
	bh=a2s5TFKuJEHwbslcJe1biaeCUXwLgjMv6uCGT6rWcN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MPGGiqqBfF5Ywr1UAN9oiG+XOFzPBeYMjoMeweQYJGvAUdwqEGA8Yor2R0+08Rek
	 hPPDbpvBY/+CTyjUbnEXgAPHxiDZdM6urwlIvBjA29bD4Wexkwy8VRKB8RPVBNEdIV
	 j/xP/EJ00tuFIyMukWIed0wo99on0werL2X0bCGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.12 080/272] fs/ntfs3: handle attr_set_size() errors when truncating files
Date: Thu, 28 May 2026 21:47:34 +0200
Message-ID: <20260528194631.617489988@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 576248a34b927e93b2fd3fff7df735ba73ad7d01 ]

If attr_set_size() fails while truncating down, the error is silently
ignored and the inode may be left in an inconsistent state.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
[ Minor context conflict resolved. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -500,8 +500,8 @@ static int ntfs_truncate(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	int err, dirty = 0;
 	u64 new_valid;
+	int err;
 
 	if (!S_ISREG(inode->i_mode))
 		return 0;
@@ -517,7 +517,6 @@ static int ntfs_truncate(struct inode *i
 	}
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
-
 	truncate_setsize(inode, new_size);
 
 	ni_lock(ni);
@@ -531,22 +530,19 @@ static int ntfs_truncate(struct inode *i
 		ni->i_valid = new_valid;
 
 	ni_unlock(ni);
+	if (unlikely(err))
+		return err;
 
 	ni->std_fa |= FILE_ATTRIBUTE_ARCHIVE;
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (!IS_DIRSYNC(inode)) {
-		dirty = 1;
+		mark_inode_dirty(inode);
 	} else {
 		err = ntfs_sync_inode(inode);
 		if (err)
 			return err;
 	}
 
-	if (dirty)
-		mark_inode_dirty(inode);
-
-	/*ntfs_flush_inodes(inode->i_sb, inode, NULL);*/
-
 	return 0;
 }
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB046A03B;
	Tue, 23 Jan 2024 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975329; cv=none; b=rry8FSIp+CnjyUBw0b9OeBccixjV0LOjNQhcGAzlfzAOeiwmVRACSJSLAuL7xVpUXS3WRIf08LFikMNTWfnk1DaHjvU1P27G3vczilrD6YEv5d/vXNb+Li9zi1KgLHjFP6aCz+M7VHTgzBeHfIdaUD5FC7VwfRvMwQgazMaS59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975329; c=relaxed/simple;
	bh=9f+PTP4rZmhrLcVonrDvG4lnNrlQnId3BqzJ4b9apZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUy8qV0HA4wR/aYMSb1XfPr5zKsdg56zgzQSy/MpAt+1tVMv4Rnldv+l0NNs1CF9Mrd+3oigdNV0MLHyHAv3VcDVnnmpHlWfNAAh/ADHZIj0/vCDk36kVEzyrS+ACWtMdPeSAu6FD+oNyzYNnrrxjcz3TTqYVaA02/WKZ+2dXsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03R6gsBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03R6gsBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4B1C43390;
	Tue, 23 Jan 2024 02:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975329;
	bh=9f+PTP4rZmhrLcVonrDvG4lnNrlQnId3BqzJ4b9apZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03R6gsBZr3o22nabkm/JaPYnD/5ez2aKlOiSYwLTEEMIPH2ptoKfRXDWLkQXMHJaO
	 vMARlezviNTSNuX/OGGICDSwY581QeZza0np+1MMaVPTxaIyEE/PJs5dD3hydV+BGu
	 gfXNJFDUX/hPIKNvhiTbSTetLtyi2gcAAcYQBrWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/583] f2fs: fix to check return value of f2fs_recover_xattr_data
Date: Mon, 22 Jan 2024 15:55:44 -0800
Message-ID: <20240122235820.976688913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 86d7d57a3f096c8349b32a0cd5f6f314e4416a6d ]

Should check return value of f2fs_recover_xattr_data in
__f2fs_setxattr rather than doing invalid retry if error happen.

Also just do set_page_dirty in f2fs_recover_xattr_data when
page is changed really.

Fixes: 50a472bbc79f ("f2fs: do not return EFSCORRUPTED, but try to run online repair")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c  |  6 +++---
 fs/f2fs/xattr.c | 11 +++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8b30f11f37b4..9e00932770d8 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2751,11 +2751,11 @@ int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
 	f2fs_update_inode_page(inode);
 
 	/* 3: update and set xattr node page dirty */
-	if (page)
+	if (page) {
 		memcpy(F2FS_NODE(xpage), F2FS_NODE(page),
 				VALID_XATTR_BLOCK_SIZE);
-
-	set_page_dirty(xpage);
+		set_page_dirty(xpage);
+	}
 	f2fs_put_page(xpage, 1);
 
 	return 0;
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index e197657db36b..e47cc917d118 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -660,11 +660,14 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	here = __find_xattr(base_addr, last_base_addr, NULL, index, len, name);
 	if (!here) {
 		if (!F2FS_I(inode)->i_xattr_nid) {
+			error = f2fs_recover_xattr_data(inode, NULL);
 			f2fs_notice(F2FS_I_SB(inode),
-				"recover xattr in inode (%lu)", inode->i_ino);
-			f2fs_recover_xattr_data(inode, NULL);
-			kfree(base_addr);
-			goto retry;
+				"recover xattr in inode (%lu), error(%d)",
+					inode->i_ino, error);
+			if (!error) {
+				kfree(base_addr);
+				goto retry;
+			}
 		}
 		f2fs_err(F2FS_I_SB(inode), "set inode (%lu) has corrupted xattr",
 								inode->i_ino);
-- 
2.43.0




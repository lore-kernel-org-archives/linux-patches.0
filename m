Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD646D0B2;
	Tue, 21 Jul 2026 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658682; cv=none; b=krst1eZQnvWAWGYQnM7Y/Cd/gXjLfEZXZjMPkauI9XhkE7WJGBur44Q2RU5kmE+2zkhlhaUzm1GSjPIR8Rx6XBpki6EIpRPfkcp+GNfIV/cRLVJBHsHuT9C51DTqXuIoRwHrFUwGtbB5C2ALeJCwXHNmWDLIptXD0UQaoQtQpUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658682; c=relaxed/simple;
	bh=z9HcCG5tV1I68TxAx2FlKctESZZXTgfNu6eTalNBO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIQWT8PtpPt36KpyGlSSoPHR8y/Nze9ojPFRi2QNrnJwu0qSF3HYscky2rsrU6zSfPRkKXIipSvSmzQd0wxKnDjiRJhIp4xyxcj6g2e0yCI2MP2asnL72O47wrjYVZfN2Rj/jJF2kMATDvPswaZ02oRQghjzXhveq5zizvz54SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlMU51kf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlMU51kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B0E1F000E9;
	Tue, 21 Jul 2026 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658681;
	bh=mu9LUa/Z5GCSP0O1f9EffJYqi7DRam268t6WGh66eJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlMU51kfp5ZI0rFJNZ7CdWzz1QfeTBsW1MA0zZjcbm5LMZAlU/Z57rk5QDVFQhD1A
	 QTh1MyN0IWKQXPdRM7fa+999TdO7Zs8HrO702Rncjp3h9bWFV1WHorI9A3lMR57tPZ
	 nZtLhS7+wDLE7pWYq7VvO6HEdSPQkmj1FkjCv8V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 1234/1611] fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
Date: Tue, 21 Jul 2026 17:22:30 +0200
Message-ID: <20260721152543.197184193@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit 932fa0c1496286e39e14e27194c1ee7c2181629f upstream.

In ntfs3_rename(), when IS_DIRSYNC(new_dir) is true, the code syncs
the renamed file inode instead of the target directory new_dir:
    if (IS_DIRSYNC(new_dir))
        ntfs_sync_inode(inode);      /* should be new_dir */

DIRSYNC requires that directory metadata changes are written to disk
synchronously.  Since new_dir was modified (a new directory entry was
added), it is new_dir that must be synced to satisfy the guarantee,
not the renamed file itself.

This bug has existed since the initial ntfs3 implementation and was
carried through the refactoring in commit 78ab59fee07f
("fs/ntfs3: Rework file operations").

Fix by syncing new_dir instead of inode.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -340,7 +340,7 @@ static int ntfs_rename(struct mnt_idmap
 			ntfs_sync_inode(dir);
 
 		if (IS_DIRSYNC(new_dir))
-			ntfs_sync_inode(inode);
+			ntfs_sync_inode(new_dir);
 	}
 
 	if (dir_ni != new_dir_ni)



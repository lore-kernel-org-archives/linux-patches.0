Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D9944AB7B;
	Tue, 21 Jul 2026 21:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670056; cv=none; b=lEXdVhM4NT4JScLstJa/ey/FMri6Xo435ddXJZ4SAjJlAASjg//T1mPU4jwunEdeUEIHwg7qySgmrEnhlJBVJYTUdBQ8JWDhqv+VQUDz5zuJbo6+ynyyMoiEMTyItKFFeozmhid+prvsDqOugVoS35X6vWoyrZORVIGp0HMgx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670056; c=relaxed/simple;
	bh=I1JwWroTw5vNR+wNmoKkAzB7zYbkuIV7z+az33ZgT14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2nG8lo/nLgmrX1eNdDTNDrG8wWh+aFaQan21W55CsiUkKnQi3IO4jHJTLovNdamXLJD2voHe+UzVxHHi2mYimhWRjbn+XwLrsyEhAv+BlEq5teaTj5yMwWkdWMfs+rIaYLZkey8XLXD1YjBjogYpiW5+Jx1j75pkfmNiof5ZxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQ/yx8AM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQ/yx8AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77ED1F000E9;
	Tue, 21 Jul 2026 21:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670055;
	bh=G3/cZA6qgXEyy0QGd16KFgj51h1sGP3in7LHxiEzojg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQ/yx8AMS6dmOOx3w7zZYWe3To83ReELQhLuLH7U7Rn1rdqeFv24qNGpcY88RzFgN
	 g+ktIXTFUrOZjlD8okMHCaiUdY0hbSo6a7LKHa4RqAvPUs/NcHWyJYij/7FjpIkQJD
	 jvyZMDGN4E570lk1WKVCtiCMHF4fEMp+8QBRMTnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0786/1067] fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152442.150208558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -333,7 +333,7 @@ static int ntfs_rename(struct user_names
 			ntfs_sync_inode(dir);
 
 		if (IS_DIRSYNC(new_dir))
-			ntfs_sync_inode(inode);
+			ntfs_sync_inode(new_dir);
 	}
 
 	ni_unlock(ni);



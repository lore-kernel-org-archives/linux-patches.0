Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6B43B83FC;
	Tue, 21 Jul 2026 20:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667211; cv=none; b=cYpl5ZZRXTRWmNqGJ9CK4WCQn3S1HK/KIjcIg2NEXunLGgKBJLaXFpu0X5RP4+fKUyGW8kDYli4DEJadsRyRc65fpQ9/9mmKK1JW6Y0/JIpEp9SkojmvzKN0Rk+t0BXbTAexbsZnQpJsAHE9FCJN47T3ulh0tDbF1LdcH1xVIRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667211; c=relaxed/simple;
	bh=jeoGyHPpHoIarWvNuOBtz9gQPo6wd9+bwqVhPAYaIPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seJ++bIgyI/bQw46seuMcY6wIyUgh/zTnwDQBBgPfTYfJU6bEe0HgA0wK7C/KVknyLOoz7DEOONuld5LlGIbSFsWKXwdreLZW/EEOZKqoS8yEAS1DzsEyfTQvWgVlec/yU/VsElB6DzIxbOh35ICullx3e/6CO4GrqfY9BkvqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wmcb9ST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wmcb9ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ED41F000E9;
	Tue, 21 Jul 2026 20:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667210;
	bh=xNJjdIK9MXRy+AVh/Tbykalr9zcn34KW0FYFUgWke4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wmcb9ST6lFQpu6dA6Fo+x+2pcXjTovpnAE9qliqf+t4WiXtVQNILFQtrf4b0JLqv
	 hM0HFK2zSoIYfPLlCcfXXa7K9prrClG5s9gnyN+vYvsyR5XZdHKkWxUH8P7faujy5D
	 373kuxh5uDL64bLZBD588CRlDHbnrKgHO7ws1gms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0976/1266] fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
Date: Tue, 21 Jul 2026 17:23:33 +0200
Message-ID: <20260721152503.683427477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -341,7 +341,7 @@ static int ntfs_rename(struct mnt_idmap
 			ntfs_sync_inode(dir);
 
 		if (IS_DIRSYNC(new_dir))
-			ntfs_sync_inode(inode);
+			ntfs_sync_inode(new_dir);
 	}
 
 	if (dir_ni != new_dir_ni)



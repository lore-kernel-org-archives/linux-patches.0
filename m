Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8772E736D;
	Tue, 21 Jul 2026 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654435; cv=none; b=lK3RrN13MS/p3FJPoTtanpZNszvJMIMSz6rGWjtyKa1TNxXus4UamZ76LOybmw5+PvLKtahUyuvE58ilGBNBcn5hLYENnUWbDhsmxPHrr1ASRJWpLLeg5XEC0AslMxGMiBhxJ/iW0FTZJSf4ywLLdbuOX/KlIOXIX22uMoVL8Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654435; c=relaxed/simple;
	bh=MYblmYrQU8FYi5/uHfE/uopWqqLGom1xBiSdWoEq40Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9MMJqZ/WdFHx09wle4bWbIY4ocAs5NhPMjhEa3U3YtjkfqbBzxWY6qDoXRQd322Gq0q64JznjVbRPykZ8MF3DM4C8bKfOKlip0O7p9uk6mV5AHYm+YzkrYSBlYnRNtzoAc6uE8Stv1fNIxOOqXsUu/rJvfnASvRiVtx6o2H0g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrQwUIzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrQwUIzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D631F000E9;
	Tue, 21 Jul 2026 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654434;
	bh=ZwlYZIl297vrWIviLtbAEjwDtONGX2+4COFonUYDs7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrQwUIzfNHnoW1KbXkzCLaaPKmcVRuAKcOgFt/CPBZVaV3I8s6fI4MuWIUkevtNZL
	 cgenPFH0/SAxLHqWH3uLWG6ddwkpQNMe9z7iToJFnWdwYDsgwNOnz5k6MTzD84fKwK
	 fHlVk8lsg0RxJCGD5iKFnmj1aS21Rs3KVoLaRh5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.1 1701/2077] fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
Date: Tue, 21 Jul 2026 17:22:54 +0200
Message-ID: <20260721152632.881941642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00B46F49C;
	Tue, 21 Jul 2026 19:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663688; cv=none; b=c5//++gIEcoU9KfiyMad8pKn5fykl9WriM+Y/DR8DtoH3DPc8Ht2wl77qVOwpTIWCtP1EdR5pqRoNqLrmL+8EETRjJ9qqd4KlBt+5JLWVzEKPEBZjyMaW8nptpVvXKo3fs3Na3ezxqaVwfMhamRkWQ2Quxe2tMHDJ1YdU6yXPUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663688; c=relaxed/simple;
	bh=ZRANhImug2VkhLoQtqwRsOYE8KmxQc+8+E4mOniWAJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpE2pmDsfTVHqszf2R35+W9sv6EzvM63+YHuXUgruVXwnAmM2VJ+Ac5JUSmiyU/x0Lne5e2TRk0Zu7BxwoB20OTCpxDzUKfOeL6+31AWvLgT/Gk4FZh0J1oLrycOF5RbNEww0lFmlEvnX6j7R9O2jhQtAes7boYcslK/7SDXHkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDIVWMeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDIVWMeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB4F1F000E9;
	Tue, 21 Jul 2026 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663687;
	bh=SW8zGim3Aco30sAMz8sULhhpZZBCyCCXeiGepn0XKFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDIVWMeNiV17vl41bKw5LqhQn+9ZkiWS1kMHTVDkAUfHOURUOa76rYTA/0opTVh58
	 I3Yv27qjwv+db/C1W+urvDk30lA6usEJV/PTDvV1xXJZYJYapBQl55mVViJJ0hl4x7
	 qgq8irbn9nMurQVWTObplkGq7ca2Ltnl5KuyMq2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 0915/1276] fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
Date: Tue, 21 Jul 2026 17:22:38 +0200
Message-ID: <20260721152506.512833143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -324,7 +324,7 @@ static int ntfs_rename(struct mnt_idmap
 			ntfs_sync_inode(dir);
 
 		if (IS_DIRSYNC(new_dir))
-			ntfs_sync_inode(inode);
+			ntfs_sync_inode(new_dir);
 	}
 
 	if (dir_ni != new_dir_ni)



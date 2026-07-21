Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC1825B0AB;
	Tue, 21 Jul 2026 22:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672400; cv=none; b=Kdlc71bjLUK3tmDXNMrWoB10/VfGy+DsxLgPvw83ghylACd7yaGcypGN80gzZiQ47+RMoZvlRhrPle3jX8mCYLSzrY1rHgrO98Nk69Ys4M/+CXJjp6U3qPUvkBUzl+SIFzYieww1Wp5CkAtTTdis0HPJjUkr34iLZnV++miChrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672400; c=relaxed/simple;
	bh=JcwLRQ3yCvGIQeRdnJx9bOjx/BU/b5osaUYFzUjffUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8cPA6RjNRCUjzlt5NSeXb4e+aZUKK0NiD7S6fQkrJMYF3DaIFvQseNgdd3NZL79PKPgia3BWBizrUYYFmZ1oayhBlt7dgB2x7+KeTxfzxMzdJlMvIe9vN5XvQf4Ui2JPYU4FksSdN3GokPEb9lruCTweQJ4DORnOYVf46CvCp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT+Zuj+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT+Zuj+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF811F00A3A;
	Tue, 21 Jul 2026 22:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672399;
	bh=mtg/Z8+of9O9p68NU3MfbqdBs+zzPpFt9OGy/iRWBqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT+Zuj+Bh0ZY3vzpiOWdGUD67d7uxIpHnEzP4cfvgNeCPvgbS5+bKdlgXsvODnSwc
	 TtIepkxJUBaKCJhBiK481u5tCv4Z4ERDoAl3bAivoXAJWUTGUEPgAeNVZT08/XV5gq
	 vyIMKOo5/y3f+enaIutTCqavfpgjngDErEO693gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 610/843] fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
Date: Tue, 21 Jul 2026 17:24:05 +0200
Message-ID: <20260721152419.775198794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,7 +335,7 @@ static int ntfs_rename(struct user_names
 			ntfs_sync_inode(dir);
 
 		if (IS_DIRSYNC(new_dir))
-			ntfs_sync_inode(inode);
+			ntfs_sync_inode(new_dir);
 	}
 
 	ni_unlock(ni);



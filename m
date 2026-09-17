Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E813454704A;
	Thu, 17 Sep 2026 18:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668848; cv=none; b=enLXdNquaKAGU+bbQzgW3pXN4g6pFqPY1HJE8lLa+pBi3Gdn+VD8bRTbFeOFdTOCLML06W1+tijqMW/hje6wS2bMFgURke3iWkr+CrTeaC7ZSkV6H5DvKNOQbVT54JcTr6dTBHxY+wfT2AQfJmPKPTeCoZZVFPIxgwM+BeIwDd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668848; c=relaxed/simple;
	bh=EqrO8xA6jI6KJ+8op0wJHWsE6S7lnA59BDE9ULxzsiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spIKKXZOsZcK7uQ7ukzUDgSjz2c3KyngwIITbBgJ0Q/Om7uNvDZH9g9x5rl8ajPOw7xXuWy7ZexYO31LWWRVLzqrDaM+dwoc6+X6CnTqWjW52BUoZNXgFny9F2HaKuSlKGsTXKOYjNgqoaSP/Tbf6snBXaawDKjEWQYn2tFQpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGIGXkw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGIGXkw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF911F000FF;
	Thu, 17 Sep 2026 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668846;
	bh=3BJoALNGde869QNJFWtHPJjF27NK9lIx8Mruac6hh60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGIGXkw90nEUBXQhVFXtoMSHQK8L5CxKmGNlG1jeXH9mkizudkMitg1tOaCWgVUDY
	 8dUH5MdE+QhIVYKgo5pvQ0IZ/EaPWjROpep2fMP15cTrKtLIlbgiss6M22HyLOC9tv
	 OMEDUgc9SLinsY4GCnJU8LDWH26upFysje+mkQCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0512/1102] ufs: do not treat unreadable directory blocks as empty
Date: Thu, 17 Sep 2026 16:07:35 +0100
Message-ID: <20260917151552.602262109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 08edfb34ee9ca54383970c65ed3a6013e84f5e16 ]

ufs_empty_dir() scans every directory block to decide whether a
directory is empty before rmdir() removes it. When ufs_get_folio()
cannot read or validate a block it returns an error pointer, and the
loop currently skips that block with continue and keeps scanning the
remaining blocks.

If none of the readable blocks hold an entry, the function returns 1
and the caller unlinks the directory. A directory whose contents live
in a block that cannot be read, for example because of an I/O error or
corrupted directory metadata, is therefore seen as empty and removed,
losing the entries it still holds.

Follow the ext2 behaviour and treat an unreadable block as a reason to
consider the directory not empty, so rmdir() fails instead of
discarding data that could not be verified.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260801013942.279992-1-ali@iusegentoo.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index d6e6a21989715..254d9a0b1b241 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -590,7 +590,7 @@ int ufs_empty_dir(struct inode * inode)
 
 		kaddr = ufs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct ufs_dir_entry *)kaddr;
 		kaddr += ufs_last_byte(inode, i) - UFS_DIR_REC_LEN(1);
-- 
2.53.0




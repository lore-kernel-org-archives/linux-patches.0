Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A564A5A79B;
	Tue, 14 May 2024 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683216; cv=none; b=rSPJZAvfBp3QJzxFgGR/IbCmY5H69Cg2s/haLOSsI8bply9WHyBwi6o38J0YBBr6NAF+WNwDtteETnroXZjMbC1Wtum/glcayPAqHIYxMQwcfN9huxn2nGfhiYIFtqdrgQZAalWiH1++548X19nmvOsU5bjWSSmyTb6fFW/Ht/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683216; c=relaxed/simple;
	bh=RRRJAMH/OAnELWlmp0H7Ve2IZ8qe8GJCv1Vp7bP7Ink=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcocKMlRK4/Zz9+9hvBXyeJcoKRd0TUKq5leoO199Nj/oINqWc1OyxSIkUG57+dtr/TzUEfFO56c3qzfEldSHfJf8FK/R09nE8QYDLfRywuIk7Ft+8WP7Nu1CHI/6H7b0HXmjOlQUcCex91BE9l4LCvQjG+4jLGbO8f5NXdP1/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnIfV2yV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnIfV2yV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C229C2BD10;
	Tue, 14 May 2024 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683216;
	bh=RRRJAMH/OAnELWlmp0H7Ve2IZ8qe8GJCv1Vp7bP7Ink=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnIfV2yV8fhYVWnGTGQlL12ZALtk4A2Rv+pIjdvR4GXFqZrkcnEtWNgf69dZoZgew
	 dc6I6lLygWGivEiJDAUcaeLZB9L+5G3ilvMgL+i/6rjUbumFGu/bZS+Icn3fg/Xb5k
	 2uyiTpWFmc6jJuDLNAwSGodlyThGggzeirfRswgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 185/336] fs/9p: remove erroneous nlink init from legacy stat2inode
Date: Tue, 14 May 2024 12:16:29 +0200
Message-ID: <20240514101045.586760858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 6e45a30fe5e7cf5d42ac07262a3d97644f23dc68 ]

In 9p2000 legacy mode, stat2inode initializes nlink to 1,
which is redundant with what alloc_inode should have already set.
9p2000.u overrides this with extensions if present in the stat
structure, and 9p2000.L incorporates nlink into its stat structure.

At the very least this probably messes with directory nlink
accounting in legacy mode.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7ba7efe47b40d..0fde0ab77eff6 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1152,8 +1152,6 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	set_nlink(inode, 1);
-
 	inode_set_atime(inode, stat->atime, 0);
 	inode_set_mtime(inode, stat->mtime, 0);
 	inode_set_ctime(inode, stat->mtime, 0);
-- 
2.43.0




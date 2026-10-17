Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8523AFCF0;
	Sat, 17 Oct 2026 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256867; cv=none; b=pvddsj3UZSxMhsmTHp//YXXayGog64UPLNpPkQJ7CrOQydw62e1FnYXjXFaX8p2iL2At5Za6sQsO2/o+qymhH0pfcOnar3XHo+b7sgXkx+TSRUhHR6C8vup5F8QRc8U6kmnh3WXDEQj/b4YnJj/GKk193cwxV8TX+YtZ2QrtUj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256867; c=relaxed/simple;
	bh=XHqA9tj3Yne87TZqHdWfgibqgyFP3ispWllIBHX5WKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na3O3DEkrKq1XNlz2ylr3J8nk+fCNqde+BPIrC81SWLUbqRfCV6gYtxH9EwoeY01gSKN2N5EvngQNUKzRl/NyBfwb6WMs41kRT/ZW7g+b6nG1PvwciDNpuQ5CJnSyDnGOFftJNfbdJoYW4AS+vKwUav69ZFLTqF5KQhal3UlCIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7F6P5sX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7F6P5sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57B91F000C4;
	Sat, 17 Oct 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256866;
	bh=V7vt7eS7UK3gh28iCnDXKYHNzf0xq1PYXI8GFkNoMF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7F6P5sXkx9Tq3DqxJuwBkbCwqQpDl15xkh2JlNUBjedd/kC0LRQpoeO2vrRlPljE
	 yx81DRN6cY2+6LJkQ1f3GLuJjhF7lXCMm5HZ2sxSh+c19yTwvwBxAl8h7Xc89cyjI1
	 Cv9w3F3E5+wxzJq01tyDzEp4UQHNTNRAnjJytWbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0376/1674] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Sat, 17 Oct 2026 17:44:08 +0200
Message-ID: <20261017160440.765778800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Andrey Albershteyn <aalbersh@kernel.org>

commit d2f96bcb89d36d488a10e3bcf819b98536968286 upstream.

The check that fs-verity is available in the kernel is not necessary
here. Filesystems could have fsverity files even without fs-verity
enabled. In that case, truncate on fsverity file will succeed, what this
check is trying to prevent.

Fixes: e9734653c523 ("fs,fsverity: reject size changes on fsverity files in setattr_prepare")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260727094352.1734826-1-aalbersh@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/attr.c b/fs/attr.c
index c2302fc4b3330..dd3b0b5115af4 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -180,7 +180,7 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * covered by the open-time check because sys_truncate() takes a
 		 * path, not an open file.
 		 */
-		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+		if (IS_VERITY(inode))
 			return -EPERM;
 
 		error = inode_newsize_ok(inode, attr->ia_size);
-- 
2.53.0




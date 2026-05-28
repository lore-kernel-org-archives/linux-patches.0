Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920FADDC5;
	Thu, 28 May 2026 20:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999876; cv=none; b=brinCDoa6WO7OZf3NyH+kULqBkO42snlOsU7ErjW06y4P6mB2E9RwtgSMvu+u1uX+s5BWp3DC+6zxUDmQaqJYJzLhvrHd+hq1/xYG2rzXEIDSjI5X6F9h7Y29WSlekHmObRI9CRvqkfSWODJ46c6skWnFPkGJ9XeE/rIr2faBPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999876; c=relaxed/simple;
	bh=6l3upiWf02MWaN63ijG7fhUdyYRrVWhnfv4jN73+FuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwvbG1shrjgRe4wmNxMri8+DHyfbZAfh12KGDYH9LTSgCRqyYtxkavLYdBEeHMKR+0ElpJCgzvcKfrbuF0qWf2X6yTBMYjcXXWvX2hj8vRMzTI2y7TwJvacCd8j3ND8EIlZqsWlt0voTerecC/LyZa8jx+J5TX8Kf167DGwfTYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsvP9TX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsvP9TX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30221F000E9;
	Thu, 28 May 2026 20:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999875;
	bh=+Hw+xHuxXyczqzT/BwZRmMS7ZX47yOgtPvDtjkZeUqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsvP9TX0lhDlvOIJRqeUUwvApE4BUI11CGFTnXxI24/43LKW1G2eLgsrF2FDEzjka
	 AiXmC3ER5rEpjnPfzcOOTyF3S/v3PRl9qIaf9LjJaJ6hb4yD/6LvY2l/UZXqaHJpf6
	 yXvarxurVbrZXjEYGc3NFp5wkdnbwkQw/Ygh6Tlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/377] fs: Fix return in jfs_mkdir and orangefs_mkdir
Date: Thu, 28 May 2026 21:47:39 +0200
Message-ID: <20260528194644.793643580@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit a7cf1da7ac016490d6a1106f2aa6b602d34e9a12 ]

Return NULL instead of passing to ERR_PTR while err is zero
Fixes these smatch warnings:
  - fs/jfs/namei.c:311 jfs_mkdir() warn: passing zero to 'ERR_PTR'
  - fs/orangefs/namei.c:369 orangefs_mkdir() warn: passing zero
    to 'ERR_PTR'

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://patch.msgid.link/20260501071058.1243245-1-zenghongling@kylinos.cn
Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/namei.c      | 2 +-
 fs/orangefs/namei.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 7879c049632b3..553fca69cf425 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -308,7 +308,7 @@ static struct dentry *jfs_mkdir(struct mnt_idmap *idmap, struct inode *dip,
       out1:
 
 	jfs_info("jfs_mkdir: rc:%d", rc);
-	return ERR_PTR(rc);
+	return rc ? ERR_PTR(rc) : NULL;
 }
 
 /*
diff --git a/fs/orangefs/namei.c b/fs/orangefs/namei.c
index bec5475de094d..75e65e72c2d64 100644
--- a/fs/orangefs/namei.c
+++ b/fs/orangefs/namei.c
@@ -362,7 +362,7 @@ static struct dentry *orangefs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	__orangefs_setattr(dir, &iattr);
 out:
 	op_release(new_op);
-	return ERR_PTR(ret);
+	return ret ? ERR_PTR(ret) : NULL;
 }
 
 static int orangefs_rename(struct mnt_idmap *idmap,
-- 
2.53.0




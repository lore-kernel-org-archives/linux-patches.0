Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84130E82E;
	Thu, 28 May 2026 20:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998691; cv=none; b=DjtwM2+Ov3nTLutW7d7XzZwnEusOPPdbnXhs7TPho5xZtjKdUQ06LWV7bvt31MWvzY9MGeBX/tN/Ag0OwxpCDp4pnBbhtBhWN9Ccq1h2gjN8rM7huPHXzz7dYSSvtlGhG4trIhcN1zVN3OjNhqDVELMkz1gQoRt1YAvjWwhvXzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998691; c=relaxed/simple;
	bh=kLNHvW/pqK5y0KtO8eytU2SlnJNU+HCpFIcEyBm3H/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1X6i93FcxThAoQ1GZR8XPkYqFZ+CAuPmFtx0eq1oCNFmr4gZNzg8w7ayOUqsgK7sr1mxiWmgtEdfR+Vw6K8EwKEQpnNbGAND+F0HsnDf8vItz8Adr/V4vDwI8Dd7J/EDf1CK6kmMwEHSRgsPcXmlqux+Q3Ync/LJO5wfICz/l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmKlfwlf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmKlfwlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7221F000E9;
	Thu, 28 May 2026 20:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998690;
	bh=kQnrJ+K9hmuMxd2LWd7akFTxVPTWxfOt0ueQBDi+/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmKlfwlfkrmSLwTXzWfZ1vaHcs+WVPvR79KRj0KuThaBKC8BL6w01HDC6pMU2s94h
	 BT+1HtY7d4tuAp69w/NebHQtnFAdTHoRMTC97gArCmbFUymaWcjB2BfGGa1dFmFpW3
	 dhK5CBQVyxhkhUit7mCDzCFC32Vcjxyb5bvQDX9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 236/461] fs: Fix return in jfs_mkdir and orangefs_mkdir
Date: Thu, 28 May 2026 21:46:05 +0200
Message-ID: <20260528194653.973597955@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 60c4a0e0fca5e..442d626792622 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -309,7 +309,7 @@ static struct dentry *jfs_mkdir(struct mnt_idmap *idmap, struct inode *dip,
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




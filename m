Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C761EF38C;
	Tue, 12 Aug 2025 18:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023232; cv=none; b=SjbBvpJuc3Ppvq0KK21aSF+Ldf9/KI0XwCDK8eDCdrmKEyEm3K7/wsDZxeZO6SLubHFGiBhVe6TLN+PHMrznYXoT7Zxwl+aqVedQIhLnn+pDZOa/EeqSiqqSO7i02CPFpdXdioq8t1MVQ+mNQQ8coYXXejLkJWdNKHC9QjoeUks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023232; c=relaxed/simple;
	bh=REaYwkF8ITYE8gjSrbM7Viuui2bP3ENFK5XowNEz//Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6HUahzFdzm35DwFAN64rDCIr3ofFrcmQbVrLSIQP160/urOZILukTKCJ0DJde5hGF4jc1rKFSMMKMA+8ayHJRcwAvM6gzjpR3/nUiM8FGMg4zm7jW5WjIr4Kamze8PmY/sEXxFXJ//iogtznUmfkDBEvjVOkkMzxYw0Jp8ubV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lj+I/kf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lj+I/kf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E99C4CEF0;
	Tue, 12 Aug 2025 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023231;
	bh=REaYwkF8ITYE8gjSrbM7Viuui2bP3ENFK5XowNEz//Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj+I/kf5FZ/4IWTvd8KyENjOBA5bb7UWN6FRB6XzFW0uxYAbD7bgKOf/5wQQO9qE9
	 pZyZYGWJVLAH62ZTpujoNSiWJS/pEzM3eY0IRyygiXyLfBbhI0flLUvYOOuedZzheZ
	 U9O9pCUiwJzX2vS6CN7ewCYOdkE48StKJD4B20aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 002/627] [ceph] parse_longname(): strrchr() expects NUL-terminated string
Date: Tue, 12 Aug 2025 19:24:57 +0200
Message-ID: <20250812173419.404765606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 101841c38346f4ca41dc1802c867da990ffb32eb ]

... and parse_longname() is not guaranteed that.  That's the reason
why it uses kmemdup_nul() to build the argument for kstrtou64();
the problem is, kstrtou64() is not the only thing that need it.

Just get a NUL-terminated copy of the entire thing and be done
with that...

Fixes: dd66df0053ef "ceph: add support for encrypted snapshot names"
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 3b3c4d8d401e..9c7062245880 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -215,35 +215,31 @@ static struct inode *parse_longname(const struct inode *parent,
 	struct ceph_client *cl = ceph_inode_to_client(parent);
 	struct inode *dir = NULL;
 	struct ceph_vino vino = { .snap = CEPH_NOSNAP };
-	char *inode_number;
-	char *name_end;
-	int orig_len = *name_len;
+	char *name_end, *inode_number;
 	int ret = -EIO;
-
+	/* NUL-terminate */
+	char *str __free(kfree) = kmemdup_nul(name, *name_len, GFP_KERNEL);
+	if (!str)
+		return ERR_PTR(-ENOMEM);
 	/* Skip initial '_' */
-	name++;
-	name_end = strrchr(name, '_');
+	str++;
+	name_end = strrchr(str, '_');
 	if (!name_end) {
-		doutc(cl, "failed to parse long snapshot name: %s\n", name);
+		doutc(cl, "failed to parse long snapshot name: %s\n", str);
 		return ERR_PTR(-EIO);
 	}
-	*name_len = (name_end - name);
+	*name_len = (name_end - str);
 	if (*name_len <= 0) {
 		pr_err_client(cl, "failed to parse long snapshot name\n");
 		return ERR_PTR(-EIO);
 	}
 
 	/* Get the inode number */
-	inode_number = kmemdup_nul(name_end + 1,
-				   orig_len - *name_len - 2,
-				   GFP_KERNEL);
-	if (!inode_number)
-		return ERR_PTR(-ENOMEM);
+	inode_number = name_end + 1;
 	ret = kstrtou64(inode_number, 10, &vino.ino);
 	if (ret) {
-		doutc(cl, "failed to parse inode number: %s\n", name);
-		dir = ERR_PTR(ret);
-		goto out;
+		doutc(cl, "failed to parse inode number: %s\n", str);
+		return ERR_PTR(ret);
 	}
 
 	/* And finally the inode */
@@ -254,9 +250,6 @@ static struct inode *parse_longname(const struct inode *parent,
 		if (IS_ERR(dir))
 			doutc(cl, "can't find inode %s (%s)\n", inode_number, name);
 	}
-
-out:
-	kfree(inode_number);
 	return dir;
 }
 
-- 
2.39.5




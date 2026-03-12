Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759F35DA73;
	Thu, 12 Mar 2026 20:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346931; cv=none; b=omfNVfy0SUsnxLTqxMkTW1XDWr2adSGUndQMUVHzkE4ZskejiVYPjy80TwZZ8Xq0Prnx9XyUpUuNxj1uZgMmGWK1svGcXnyMokXUeyAyvccZnCPeF6rI3BVW36ArSeanlq17Zzt/T0JwR7rm7qSGaNpxg/f6iQzeNK5usLmpImE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346931; c=relaxed/simple;
	bh=3ED3cp9ih9cqLGBPJN6mhd7oNU2tXiDGUwtRqZI2idQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGD4432boAg6kDNnLbqS8Ibly9uhBzpA4kNx4av4nnWcZ1bk9tBp09ctTHPtoeSDCcUNBMQduch9U67eA8d489NYnDGI6Cu8hr61A5Lj9AkbdT5I5Pu0ZpnSXAVzkkz8GH0230MSr4gYPXOVGE8PvHqYTXxx/9Rt+ec2BiiO8zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urnFIJL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urnFIJL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D29C4CEF7;
	Thu, 12 Mar 2026 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346931;
	bh=3ED3cp9ih9cqLGBPJN6mhd7oNU2tXiDGUwtRqZI2idQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urnFIJL50I7qUgNqHRIKovtDCjYiHskSZAWgtLdpqE3dAfEYHMTe/v1IGxISvBcSO
	 LPIE6N8zx0tvdeW6JJrkZjrRBaNmdkA0R2zR7gFheaQRoTUXUrC+87bchHM0Ar6R2/
	 EFpZbRfCCnEFYpn1PMYaMhtAKA6/41vtb4NOPusk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.12 163/265] xattr: switch to CLASS(fd)
Date: Thu, 12 Mar 2026 21:09:10 +0100
Message-ID: <20260312201024.161650802@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit a71874379ec8c6e788a61d71b3ad014a8d9a5c08 upstream.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xattr.c |   35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -697,9 +697,9 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, cons
 	int error;
 
 	CLASS(fd, f)(fd);
-	if (!fd_file(f))
-		return -EBADF;
 
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
 	error = setxattr_copy(name, &ctx);
 	if (error)
@@ -809,16 +809,13 @@ SYSCALL_DEFINE4(lgetxattr, const char __
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 		void __user *, value, size_t, size)
 {
-	struct fd f = fdget(fd);
-	ssize_t error = -EBADF;
+	CLASS(fd, f)(fd);
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
-	error = getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
+	return getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
 			 name, value, size);
-	fdput(f);
-	return error;
 }
 
 /*
@@ -885,15 +882,12 @@ SYSCALL_DEFINE3(llistxattr, const char _
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 {
-	struct fd f = fdget(fd);
-	ssize_t error = -EBADF;
+	CLASS(fd, f)(fd);
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
-	error = listxattr(fd_file(f)->f_path.dentry, list, size);
-	fdput(f);
-	return error;
+	return listxattr(fd_file(f)->f_path.dentry, list, size);
 }
 
 /*
@@ -950,12 +944,12 @@ SYSCALL_DEFINE2(lremovexattr, const char
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
-	struct fd f = fdget(fd);
+	CLASS(fd, f)(fd);
 	char kname[XATTR_NAME_MAX + 1];
-	int error = -EBADF;
+	int error;
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
 
 	error = strncpy_from_user(kname, name, sizeof(kname));
@@ -970,7 +964,6 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, c
 				    fd_file(f)->f_path.dentry, kname);
 		mnt_drop_write_file(fd_file(f));
 	}
-	fdput(f);
 	return error;
 }
 



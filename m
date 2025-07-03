Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526DC2B9A6;
	Thu,  3 Jul 2025 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555017; cv=none; b=fSWawmg1Cjnr3Xl8Wkkgf2OpNj6GwuVag8re3Sl6ynRHaNuf/vEZpM+Rq8Iv5p5d1ZxHg8uYwvavMYJ+ETY8daKW6DsLS7QtKPdoNNV1ffYCGHZK702ANcK1fA+jkzXBJY7uPnSxdBYtHhNG2vO8h+sy8z2CjUzEROcUODk16aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555017; c=relaxed/simple;
	bh=Cp+NOPeDSJgIxfx1R8w+/gFo3/qCuMRVigegpwmdapo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkVsGwIUS5zX8NtnC1bXr6wseqCjhgQ9pBLBK/1qUKJn782aHUJW5qkOpxFZpfjJ+hb06vySkXk6gx+kyeYSDncg9g3GEFy0noIIMrWPwfRJMViy5hTurr6mfHgZKOQEOj+MJjCZxN2lX1RwLI8zYhcba+H3x4QOMsYpMd0h93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvq+TzLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvq+TzLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EFFC4CEE3;
	Thu,  3 Jul 2025 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555014;
	bh=Cp+NOPeDSJgIxfx1R8w+/gFo3/qCuMRVigegpwmdapo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvq+TzLSxeKKcb2pgC7P2UMRpzTM6TxF8qhjzj+Ewft+5j+DJcdCwsruVHJNw8eS2
	 E1GMzb+MjlO7H7Hm0gPqTF1Hx+5RgaA4+wSXZohdQ3S9QiXdOQMCZ6f5WKbE8eVYZM
	 nC7Q0meUqptniGOf/YvQhUmGsO7l19bT+Lb9lvBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 149/263] userns and mnt_idmap leak in open_tree_attr(2)
Date: Thu,  3 Jul 2025 16:41:09 +0200
Message-ID: <20250703144010.329083535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0748e553df0225754c316a92af3a77fdc057b358 ]

Once want_mount_setattr() has returned a positive, it does require
finish_mount_kattr() to release ->mnt_userns.  Failing do_mount_setattr()
does not change that.

As the result, we can end up leaking userns and possibly mnt_idmap as
well.

Fixes: c4a16820d901 ("fs: add open_tree_attr()")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 24b087ba88159..dfb72f827d4a7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5307,16 +5307,12 @@ SYSCALL_DEFINE5(open_tree_attr, int, dfd, const char __user *, filename,
 			kattr.kflags |= MOUNT_KATTR_RECURSE;
 
 		ret = wants_mount_setattr(uattr, usize, &kattr);
-		if (ret < 0)
-			return ret;
-
-		if (ret) {
+		if (ret > 0) {
 			ret = do_mount_setattr(&file->f_path, &kattr);
-			if (ret)
-				return ret;
-
 			finish_mount_kattr(&kattr);
 		}
+		if (ret)
+			return ret;
 	}
 
 	fd = get_unused_fd_flags(flags & O_CLOEXEC);
-- 
2.39.5




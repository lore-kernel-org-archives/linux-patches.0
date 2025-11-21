Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026113469EC;
	Fri, 21 Nov 2025 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730908; cv=none; b=neIy+O7jZQDNoBEVE740ObjOAXCXEhuzLDoiY9+PZ5aLiHeH0qA/CCrD01wi57dMcgBL644CKs16EgkbS9C5C2+AuRppbQu/iFX7NFoAiocPbM5VE8GlPdOGJM01nCc51Utyq7IvqSYLi3rBv4oiYabpxVKiwSh86uwnO0nvv/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730908; c=relaxed/simple;
	bh=uGbbMbhEpukgFKIOPRcj0VOOTlKoZ7787yD0E1+IAvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9g3jHuZ4djo/InsF3mICOl6UBK/0S8JTgOKkKmbdeY+tPfCWcw28qdUpCrSDEJusP5wAJg9PRoirjg7TJAGSPJ0TUiQHimLaYr4X+Up3kH9J555oZLfqLr+OqKA/oNzGRP+dUL3/yfU1uQxBsJVO4fXwkKlbZE7nuClwNwSyZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1t6aE4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1t6aE4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D71C4CEFB;
	Fri, 21 Nov 2025 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730907;
	bh=uGbbMbhEpukgFKIOPRcj0VOOTlKoZ7787yD0E1+IAvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1t6aE4NdWnA8isRGaTO1ZiFMsVK4RfSSWV0tLVyRzlpihQ01fpVsS1j3qJa9SG9a
	 Ai21vk7SgL9CGp0yrbdqZ1CC3EU54HZ2rm8HuXNq/Y6QHWVyrYTdMwaDMqS5e+0WJC
	 Bj6XZFoP6oXMDR7LaSFaJbUVzKPJVoGqo81xHbf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 024/247] fs: return EOPNOTSUPP from file_setattr/file_getattr syscalls
Date: Fri, 21 Nov 2025 14:09:31 +0100
Message-ID: <20251121130155.471328969@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@redhat.com>

[ Upstream commit d90ad28e8aa482e397150e22f3762173d918a724 ]

These syscalls call to vfs_fileattr_get/set functions which return
ENOIOCTLCMD if filesystem doesn't support setting file attribute on an
inode. For syscalls EOPNOTSUPP would be more appropriate return error.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_attr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 460b2dd21a852..1dcec88c06805 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -416,6 +416,8 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	}
 
 	error = vfs_fileattr_get(filepath.dentry, &fa);
+	if (error == -ENOIOCTLCMD || error == -ENOTTY)
+		error = -EOPNOTSUPP;
 	if (error)
 		return error;
 
@@ -483,6 +485,8 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (!error) {
 		error = vfs_fileattr_set(mnt_idmap(filepath.mnt),
 					 filepath.dentry, &fa);
+		if (error == -ENOIOCTLCMD || error == -ENOTTY)
+			error = -EOPNOTSUPP;
 		mnt_drop_write(filepath.mnt);
 	}
 
-- 
2.51.0




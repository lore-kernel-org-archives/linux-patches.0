Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB822EA16C;
	Tue, 22 Jul 2025 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192431; cv=none; b=k52NNn0f5RBtE0s4hP7wAaG94KD+nQP0+PHHhCyuqhodqPnyZc3mL+hAQNzNEGpieBlsn8yJesZat3FQs4ggH8Y0YYOJ+SPdjgY6ABGSJ5V9+FRWu/bosq3pSbqAQKwDvcUOW0jUropGX8g3AZ0qK108Zg6CA4piuPpBmN8LF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192431; c=relaxed/simple;
	bh=o+N+InAxitP5eOxy5NekaxYQFgznrC7xeu25uw6hw08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlLpNupTELWjZDQiv8lBCwcOLKxlAGs0SzSH9fdzYWkRUHCrjXOWV68/SX/DkDYdRxrC5C1Hv3ZwZTene594e96BWnkTiqVrqyjdz4D3pun/9a1qqDp22Eb98WZB+7o7EB/srpbZcWik4qJs61bjkYcDepydVxC6RrX5wqgygqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvF07zkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvF07zkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36AEC4CEEB;
	Tue, 22 Jul 2025 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192431;
	bh=o+N+InAxitP5eOxy5NekaxYQFgznrC7xeu25uw6hw08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvF07zkhmuPc2vkEWepEIaXQYxfOG1+AHXFl5LGOW0yaWGY+j8TOuAUsWoBkqlhTY
	 NClcWixjrN/Po1zD6Eec4m9z40cjb9582qOLxuLezxTcasCXfEJTend7sO7Y/mj/kd
	 JR059As9pPfqhbV0FeEZ4lbtThJ8tceNa1aFddU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/111] cachefiles: Fix the incorrect return value in __cachefiles_write()
Date: Tue, 22 Jul 2025 15:44:37 +0200
Message-ID: <20250722134335.695644848@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 6b89819b06d8d339da414f06ef3242f79508be5e ]

In __cachefiles_write(), if the return value of the write operation > 0, it
is set to 0. This makes it impossible to distinguish scenarios where a
partial write has occurred, and will affect the outer calling functions:

 1) cachefiles_write_complete() will call "term_func" such as
netfs_write_subrequest_terminated(). When "ret" in __cachefiles_write()
is used as the "transferred_or_error" of this function, it can not
distinguish the amount of data written, makes the WARN meaningless.

 2) cachefiles_ondemand_fd_write_iter() can only assume all writes were
successful by default when "ret" is 0, and unconditionally return the full
length specified by user space.

Fix it by modifying "ret" to reflect the actual number of bytes written.
Furthermore, returning a value greater than 0 from __cachefiles_write()
does not affect other call paths, such as cachefiles_issue_write() and
fscache_write().

Fixes: 047487c947e8 ("cachefiles: Implement the I/O routines")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://lore.kernel.org/20250703024418.2809353-1-wozizhi@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/io.c       | 2 --
 fs/cachefiles/ondemand.c | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 009d23cd435b5..239a6002083d7 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -346,8 +346,6 @@ int __cachefiles_write(struct cachefiles_object *object,
 	default:
 		ki->was_async = false;
 		cachefiles_write_complete(&ki->iocb, ret);
-		if (ret > 0)
-			ret = 0;
 		break;
 	}
 
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 3389a373faf68..cfa8f23fdfb65 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -84,10 +84,8 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 
 	trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
 	ret = __cachefiles_write(object, file, pos, iter, NULL, NULL);
-	if (!ret) {
-		ret = len;
+	if (ret > 0)
 		kiocb->ki_pos += ret;
-	}
 
 out:
 	fput(file);
-- 
2.39.5




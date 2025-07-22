Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA980433A8;
	Tue, 22 Jul 2025 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192100; cv=none; b=ip/uYJbTpAuTkoI23ow2AyqGUfdNmRLVPJ8fngsD7JZpor+fRm7ZAfP2e67Ci/CyZht2AIEczzq6hzyQa1Lu2R60/L/hdF7sGknXnVqoB+Zr41uXI09xTa0qjhEFRkS0uyHKcgP8fFPmsGtDPUbWH9zmS2DkVWtM6S0n4LG5f4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192100; c=relaxed/simple;
	bh=Ay5R6/Fw0ValOSOl2VkqqvAsTGQrDKvbcjQKd0iLXzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4rrW1Vtcu5dC83STJnkxphSrUHHqG3VcZrfE4tKC3cFrTb3t/Ysp4FDFEt4XaHTci5Th5Tn7NiCNFJI9Tv2srIMZF7Q+6WZjoNt0uhK1S9ymWxqbphaBB25r9D2JB68/4gBWU5W6xzqfE/leauLIEyev1WDrVhiB4ekdsnQ1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9+qY0A2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9+qY0A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C97C4CEEB;
	Tue, 22 Jul 2025 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192100;
	bh=Ay5R6/Fw0ValOSOl2VkqqvAsTGQrDKvbcjQKd0iLXzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9+qY0A2v71aUOEOM8bx8VVmXo65JV0OBwIcDr9Ll1gzoRd6OoB4TlbKzZWt4ev5y
	 FBvt/012fsLmV2B9lBpdnQjrLZ+6RMDCfzB2VgOKAPIZzk1t2FB/8EmfQXpwK6OdNa
	 Cq65kBa8P4JpBJZLIGYmLTSMTfccb2EysuGKiS1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/79] cachefiles: Fix the incorrect return value in __cachefiles_write()
Date: Tue, 22 Jul 2025 15:44:39 +0200
Message-ID: <20250722134329.962702063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 000a28f46e59e..5d2a41bab9c19 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -356,8 +356,6 @@ int __cachefiles_write(struct cachefiles_object *object,
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




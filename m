Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2772B2EA752;
	Tue, 22 Jul 2025 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193601; cv=none; b=muImjTUp7qXeHuBmgU23cNQjdlftcjMjAJX0ii1P8rDBa9I/Jy3eXFFMPqnrKT5vuBBCq+OZIJRbX7+K/fdUhyNugqOEQ598XS2ivRybCIpDcATau1oK97jNrzCca1EcibpFl3DgL4HeYsa8kX1ZSfTSbTV7kZxWBpoxOmXsIic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193601; c=relaxed/simple;
	bh=VVBoDv7gXeQCTFbnDOFp4773UAUg5DDESQxDjvB72Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5Qx3+tg+V1bH+IGxXRTxqD89pcMmN1M0mW6Q0ecvHeC8GYYzuiPq5i5WZHPPnLmDYjRPv9uEUPF8qNmdxYZLZkJKrPRT745BrXToBDxwrXsX4bzQw5LqC456kmp5ZANwnp4gzv5Q/OBymDCv/rX+wyTq626bd1f5kypWHS9w5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGowerEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGowerEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EB7C4CEEB;
	Tue, 22 Jul 2025 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193601;
	bh=VVBoDv7gXeQCTFbnDOFp4773UAUg5DDESQxDjvB72Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGowerEgj0b7+0btb8d+oe4wdSKX3xJuR/EeYwLIOLboqYLtUe3sA9kjmcmuBtYr6
	 crjeeSZlRRTWyTKqkFwmhiPSv37ebsDnTGIWOMgU3mmqN2N+VgFw1AD0zoAqqct/vg
	 yrscEocN4Dnk2dJ0Xf38gg4rOIbFqCXUCh4mX8/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 108/187] cachefiles: Fix the incorrect return value in __cachefiles_write()
Date: Tue, 22 Jul 2025 15:44:38 +0200
Message-ID: <20250722134349.788533907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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
index c08e4a66ac07a..3e0576d9db1d2 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -347,8 +347,6 @@ int __cachefiles_write(struct cachefiles_object *object,
 	default:
 		ki->was_async = false;
 		cachefiles_write_complete(&ki->iocb, ret);
-		if (ret > 0)
-			ret = 0;
 		break;
 	}
 
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index d9bc671761282..a7ed86fa98bb8 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -83,10 +83,8 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 
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




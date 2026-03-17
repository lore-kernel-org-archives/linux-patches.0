Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5241A3A4F46;
	Tue, 17 Mar 2026 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767189; cv=none; b=J/m2jOMPYzJA2y/wbOAfP5hmopSDz80GpV+xd3Ewz9HrZUeKwa/+AVUNOooy+/rpjKyzv6nv31OZkZql0eyuOrSflJJ3DpjBV6yQ8zGe37MJZg6jSo08OsWGNqb1zVoXQ8IX/FneKBfvHTJ2l00wqbbyft9B9ZlohrTqqX4RrK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767189; c=relaxed/simple;
	bh=iFkgmghY24rQr5Hlbm85jOFps7m32YY8fcv0T6kewxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATF4ALKNXO3hZasX0o48QmPrd6DqCKFegcBX9HsUdJcxXmNvBzWfKxSP8SafVIktV3x3Gy48Drpa/tj77+5Cvrxuuf1dToGzkDpB8Trd6AB9tgEZuQ82lbNqmS0hTurusJEvhcsB77lECkJRZbCjjgnjXKKIQ30DSjxJ9G/LEH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx2KEvov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx2KEvov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ECDC4CEF7;
	Tue, 17 Mar 2026 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767189;
	bh=iFkgmghY24rQr5Hlbm85jOFps7m32YY8fcv0T6kewxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx2KEvovyt3Pzzdru9pXgJCPiQunX373r1S37nIgM5s/Gg8/SfZjl2KqpIubxENaQ
	 0kJ/WS3AIfy6t+7H9rV4LPZ0sANROSTEtgoWsnt7tgEvojmi9oWs+g0TZo0NEYUfuw
	 WmbxDMFNsBrhi/lL7lNrthAzgA74oDJb+rENXpYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7c31755f2cea07838b0c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/333] fs: init flags_valid before calling vfs_fileattr_get
Date: Tue, 17 Mar 2026 17:30:33 +0100
Message-ID: <20260317162959.518744860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit cb184dd19154fc486fa3d9e02afe70a97e54e055 ]

syzbot reported a uninit-value bug in [1].

Similar to the "*get" context where the kernel's internal file_kattr
structure is initialized before calling vfs_fileattr_get(), we should
use the same mechanism when using fa.

[1]
BUG: KMSAN: uninit-value in fuse_fileattr_get+0xeb4/0x1450 fs/fuse/ioctl.c:517
 fuse_fileattr_get+0xeb4/0x1450 fs/fuse/ioctl.c:517
 vfs_fileattr_get fs/file_attr.c:94 [inline]
 __do_sys_file_getattr fs/file_attr.c:416 [inline]

Local variable fa.i created at:
 __do_sys_file_getattr fs/file_attr.c:380 [inline]
 __se_sys_file_getattr+0x8c/0xbd0 fs/file_attr.c:372

Reported-by: syzbot+7c31755f2cea07838b0c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7c31755f2cea07838b0c
Tested-by: syzbot+7c31755f2cea07838b0c@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_B6C4583771D76766D71362A368696EC3B605@qq.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 1dcec88c06805..9d3e177ad7d1d 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -379,7 +379,7 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
-	struct file_kattr fa;
+	struct file_kattr fa = { .flags_valid = true }; /* hint only */
 	int error;
 
 	BUILD_BUG_ON(sizeof(struct file_attr) < FILE_ATTR_SIZE_VER0);
-- 
2.51.0




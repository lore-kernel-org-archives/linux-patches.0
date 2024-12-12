Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966E222D68;
	Thu, 12 Dec 2024 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019716; cv=none; b=Ix37hJ1dETLWb6k+Sl1i71riKol2HwGngcV3OgVOJQQcF12iAl4xId8pTj5jt85YheHqY5iqEQi9CeRTMeFmGwqfIfiaN9ASrkriRE7WNeN44gvhxiQG/4AUfJ7jPiwa2vg6xbgbxcTYumQ7ZZQ9RKKSwVdwHMkDGAe7HkMcSk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019716; c=relaxed/simple;
	bh=DwbZL5po4cNF14OUlV07kTqP2/UKRXRpXkdxUDuSs/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSU+jRPrhd+zPRHsYej/vwd2EjVnSSvpdA7GaRmvm82yK282aRthpY/GMGuPkA9DHFJfnt2ZEAxyhXaN4AO2AVvGM7gFrPyaT5OtcMQvdoNENIzs2LJdQBg6r3aSNO13fU7T+D/zODzWqbeIjWkkPLQvUAhfbkCY01m7Rhj81tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPeTNhsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPeTNhsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612F6C4CECE;
	Thu, 12 Dec 2024 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019715;
	bh=DwbZL5po4cNF14OUlV07kTqP2/UKRXRpXkdxUDuSs/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPeTNhsjk5UGY21sSHss8zQqY0q/FabtepbR9EHaGgnmp4GJv8CihJG7wfJ059GPJ
	 WDDIWX0KxeDhe8MO1IAx68311/E7AlX6grCP/+52IkedqNUwuExqnWPUlKOwNgFxIK
	 hpuJTRTdbPYnMokfIvnRHjsdBTiDIOjVys72HZ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinsu Lee <jinsu1.lee@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/772] f2fs: fix to avoid forcing direct write to use buffered IO on inline_data inode
Date: Thu, 12 Dec 2024 15:53:43 +0100
Message-ID: <20241212144401.394868328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 26e6f59d0bbaac76fa3413462d780bd2b5f9f653 ]

Jinsu Lee reported a performance regression issue, after commit
5c8764f8679e ("f2fs: fix to force buffered IO on inline_data
inode"), we forced direct write to use buffered IO on inline_data
inode, it will cause performace regression due to memory copy
and data flush.

It's fine to not force direct write to use buffered IO, as it
can convert inline inode before committing direct write IO.

Fixes: 5c8764f8679e ("f2fs: fix to force buffered IO on inline_data inode")
Reported-by: Jinsu Lee <jinsu1.lee@samsung.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/af03dd2c-e361-4f80-b2fd-39440766cf6e@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index a25b9bff76ffc..3bab52d33e806 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -855,7 +855,11 @@ static bool f2fs_force_buffered_io(struct inode *inode, int rw)
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
-	if (f2fs_has_inline_data(inode))
+	/*
+	 * only force direct read to use buffered IO, for direct write,
+	 * it expects inline data conversion before committing IO.
+	 */
+	if (f2fs_has_inline_data(inode) && rw == READ)
 		return true;
 
 	/* disallow direct IO if any of devices has unaligned blksize */
-- 
2.43.0




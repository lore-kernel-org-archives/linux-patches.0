Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4005D8FA;
	Tue, 23 Jan 2024 01:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974387; cv=none; b=qvbBkhbloE7eGmVAg8tTGmjCCOzSqto7SgTVHhFk/WC/6ZsEQ8JbAepz1BYizCfwHsNAUBnqPj74xI/HGb9m2QNfXSKA5IBmbmCA7SXxWvnBg0rHB/WOzLYxosPWHcJxfv5Zc3CdUHO1D/lS2ljEbm4vB3FPgwr5syZUsUKHSi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974387; c=relaxed/simple;
	bh=jccotZ8ngA5YxOu25g7mfwaz+JU7JYy7CUlRaMEE+wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJYvzSJIAb+0QGbTzX5ysIRl+kEFePg1S2k70G6NLBjO1CE/cIIN4/0gF4HpGzeNx4PwCkmj8TGJH3g6y3gE0kTn9LgFNjg6WVmI9KmweVDpYS5y60dFdsgZDR4u0+6fVPBQHZHc0qXckFKA7GxGTiYvxSA7x4QQWdYCNCGTyBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOQEO3B6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOQEO3B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EA5C433C7;
	Tue, 23 Jan 2024 01:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974386;
	bh=jccotZ8ngA5YxOu25g7mfwaz+JU7JYy7CUlRaMEE+wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOQEO3B6GF3+skL/44MpYfz93cq/il+TmRRKTyeVvgcNdiqvZ984QstNUhHPrrMbu
	 dj9uPJI+6xtwl67As3X53Md3hedDfhxj3WZH40QmXtBLI+rJ11LB6JF7x/mEJOOPC6
	 wb5j58x2laUJ+i+R4uVh6ubQTPzesSSZCKGuuZwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/374] f2fs: fix to update iostat correctly in f2fs_filemap_fault()
Date: Mon, 22 Jan 2024 15:57:40 -0800
Message-ID: <20240122235751.705176843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bb34cc6ca87ff78f9fb5913d7619dc1389554da6 ]

In f2fs_filemap_fault(), it fixes to update iostat info only if
VM_FAULT_LOCKED is tagged in return value of filemap_fault().

Fixes: 8b83ac81f428 ("f2fs: support read iostat")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0669ac4c0f12..533ab259ce01 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -41,7 +41,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 
 	ret = filemap_fault(vmf);
-	if (!ret)
+	if (ret & VM_FAULT_LOCKED)
 		f2fs_update_iostat(F2FS_I_SB(inode), APP_MAPPED_READ_IO,
 							F2FS_BLKSIZE);
 
-- 
2.43.0




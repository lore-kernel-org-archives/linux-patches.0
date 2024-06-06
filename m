Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79AF1BB6AE;
	Thu,  6 Jun 2024 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683492; cv=none; b=D0UNU98JDUlKa85IH6MAnfjUBqrj2LFlU7nqdTbafnQa9onA5VRXNEV6X7dW1cKmpwEWXD8uPB2dq/R6J9UzmG+Bf0nHkV85EI5jLECLKnAui3+bWDE2mrww4OsKtSdijDPoL55oPPI+BOy1kKNw5SiFZvpkADqYZr2ubIJNbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683492; c=relaxed/simple;
	bh=ebeFKyoihusRIPTMQFuayFCw/imlrHtDz936ofhRUUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF8DKCL4dwHndJ2LMGBURcTvRLCFIb0/4bxXZ6lS/C2afIh6c4ZkIFKLo37arw/52c290wa3m1wJtVqyUdGQzzxPZYB9ENMimr3ym8AuoT9gHUWyD7a38rNJnOmry4kx3h66uyADlBfrwJmawC+rCPlRUZXfKgzsJisemQGUjCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJtmogG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJtmogG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927DDC32786;
	Thu,  6 Jun 2024 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683492;
	bh=ebeFKyoihusRIPTMQFuayFCw/imlrHtDz936ofhRUUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJtmogG3KUte8K59BLffWKq7RFpi9TiX1zF4KQfOeTyY8kTi4DMaFp0WalZqzpwoQ
	 hxXd1wgegwVpsCC6b5VTGs9ZZxgymcg8B7qw0Vph+opUQxgcnQ7zRy38bHe6gbDoS3
	 Xcanu2KYIScjX2rqJb8eUQ2JI5ZmWQEdMn+HByt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 435/744] f2fs: fix to check pinfile flag in f2fs_move_file_range()
Date: Thu,  6 Jun 2024 16:01:47 +0200
Message-ID: <20240606131746.428100171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e07230da0500e0919a765037c5e81583b519be2c ]

ioctl(F2FS_IOC_MOVE_RANGE) can truncate or punch hole on pinned file,
fix to disallow it.

Fixes: 5fed0be8583f ("f2fs: do not allow partial truncation on pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d908ef72fef6e..5c24d18f4e297 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2813,7 +2813,8 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
-	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst) ||
+		f2fs_is_pinned_file(src) || f2fs_is_pinned_file(dst)) {
 		ret = -EOPNOTSUPP;
 		goto out_unlock;
 	}
-- 
2.43.0




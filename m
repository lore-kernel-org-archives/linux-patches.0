Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DE14532F;
	Tue, 23 Jan 2024 00:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969578; cv=none; b=UNe7AMVcRnlIxNrnCXzhlO0oobZg5geJ+KVl7nP0bIIWpvJ8r5zIpH3pIvq4I7jPEatb5QInaLsr2Jx+52/uQ+s3SwU7spx7v3jyfNUPB+OBE0hXaDO5o38DgSPxkQCIZBxwgRP4YG+iW2Sc2Rad8DhYjtNjkDzAiU7JlfoqOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969578; c=relaxed/simple;
	bh=pYZ9ZboC5YtmzCtpdKRkUJLohhuvzELMugMr5HnyoAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC4HLX6e3uBVImHSssxyYkWEAynUA60cp6jVBlMdTKh1xUm9yk6r+FG/M/Pl6UunSW3fwUYg8FyESdzGKEgAKKmTpi4FGhpEbP/oWO8KD4opfy9YVC9ZcIv6iGW+4fUIgojkXnCAQYUV0KVj9+fYF1okgEGm8eQ9NyMlmDzkMo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7GXKHJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7GXKHJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81740C43390;
	Tue, 23 Jan 2024 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969578;
	bh=pYZ9ZboC5YtmzCtpdKRkUJLohhuvzELMugMr5HnyoAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7GXKHJqmImDIR2Hg4eH2TFJwX9jzRagcd6GGvKEm8Pk8QHtF5uQRV7gHeAKFbi5U
	 fxmO/EB69X7N1yruJehs4zjO8fYsAYgR9KFYoX0jKhniQDPtsA3RzpDM9Dy6/i2ghR
	 nViuOuyJ+k/aGfc+0SHVjpVw5k2zK6JsX8nhq6Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 316/641] f2fs: fix to update iostat correctly in f2fs_filemap_fault()
Date: Mon, 22 Jan 2024 15:53:40 -0800
Message-ID: <20240122235827.774736620@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 37917c634e22..8912511980ae 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -42,7 +42,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 
 	ret = filemap_fault(vmf);
-	if (!ret)
+	if (ret & VM_FAULT_LOCKED)
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 					APP_MAPPED_READ_IO, F2FS_BLKSIZE);
 
-- 
2.43.0




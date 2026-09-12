Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B272C3537FF;
	Sat, 12 Sep 2026 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231611; cv=none; b=jSrjxvNDZmHy0Q0MmT9VQOsvyK/byY5sL4U/c6ruffEkmKtRRN0Dqq45GOH2HpqJbTL3vjDbRwdVC+jTsmqOIJQj+nouXa6G/MBQlZ62aHqky134NVPRdIkpyxNfhXuBLisnPRDYRFKGlqJX8sQkzwV0gfHAohv1B/5ByOWIFRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231611; c=relaxed/simple;
	bh=g7+SKD/BZxXg92st/+NJQxn8tmb8Eh7d4l6UyNX81B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEAkJlRf45nmD0ylUmvxFjb6k6H9LNvicJvQeADEja8koGCLdcNoXmnHL3o/O+YBDVi76DyVidBezlfrZeofrNbRncGs9GEvGieBLDH2gOjJ05cmP2wAV8uGdVOGI219EwK5FBHFEDye8V6mgRP07ZGuqXKQE1Hh48aFaueM/sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Az2GuXC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Az2GuXC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD401F000FF;
	Sat, 12 Sep 2026 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231610;
	bh=9pRihTC+LIp1tcEeVPQ4vosJgNVtuf4kKBPgUdEQUtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Az2GuXC1GKBmI910RoVyiSjbHmF+78cRfg4epFflTUnB2grOzHoqQ4GJEMcyLcAGe
	 LIIENAeQ9YcIGPkj+qDSq4xXstQJfjgZRZ3LxjOjplnk3BhRrHUxMNojo1nqqU4Wr3
	 agcfd2Jwb8CNwkthI7mzBVVuF2P4/DbGCPb0PkKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1034/1191] ksmbd: Do not skip lock checks for single-byte ranges
Date: Sat, 12 Sep 2026 09:02:42 +0200
Message-ID: <20260912065611.406110620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit d40c24634fe077a0dc91fd11fccf44ce12b454d5 ]

check_lock_range() uses inclusive ranges. Its callers pass the end
offset as start + length - 1, so start == end represents a valid
single-byte range rather than an empty range.

The start == end shortcut therefore skips mandatory byte-range lock
checks for one-byte reads, writes, copychunk operations and one-byte
truncate ranges. A conflicting lock covering that byte is not checked
and the operation is allowed to proceed.

Remove the shortcut. The truncate size == inode->i_size case is already
handled by only calling check_lock_range() when the new size differs
from the current file size.

Fixes: 5d510ac31626 ("ksmbd: skip lock-range check on equal size to avoid size==0 underflow")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 1834dd4f255ec..2915f7e98fe93 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -330,9 +330,6 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 	struct file_lock_context *ctx = file_inode(filp)->i_flctx;
 	int error = 0;
 
-	if (start == end)
-		return 0;
-
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
-- 
2.53.0




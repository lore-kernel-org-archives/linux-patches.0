Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43F63537FF;
	Sat, 12 Sep 2026 13:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218733; cv=none; b=EYjWWrim9WhchQ9VLh7RAtx1BPeT+vleUbOeDaTA+nHU0r0rxWCVHziquudrApIn4x0vWpjfOLRnSNsSHCQ1PnV01SVo6z8AL2AfvG0l6AeZxDTvKxNB65C7gKO2bkD12mcXxRYmQbzSdRD/KNZiHlzKH36mTVQiLbKFCudIvEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218733; c=relaxed/simple;
	bh=Bv8tG5UYN/s3HXh5IGrYLTEMwRd+NMxog53rAI/HQtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg/T4Iss34OyPw/y8CL07ykoZh8iHF2U6V/B+thDh+4h/MoJJRPd2xmhMcfq1Nc1xGNDe4zvnWrUuWhtKZULHIlDsqAgioLnEFBAmh6Hdv58Qn8cDVbz+vjB+IIeNBjcHuenf7I7vc7MfaMopYmcfJ6r9KcBDZBYsCMUnzEZR/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI0vCZeY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI0vCZeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAF11F000FF;
	Sat, 12 Sep 2026 13:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218732;
	bh=ZGKLZk00kPuWX9Gtf0/vmw7IxOvaxiB6sz/BJD6uU2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hI0vCZeYKo8HD+9zpQY5Yk2/RA7zwpvXIzc5IfHibEEO7Fq115vZZn8lTyRgPZYuo
	 kxFEqfshdng16H1Lmiv1pzdjFChoeuh3MZB7V/JtnzziiBpqKv5DgyhYFI+Q8KWdcU
	 VCFVQVO/HzhrhVjjesubv7sy3yaHQc1cKgDhkKsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1162/1376] ksmbd: Do not skip lock checks for single-byte ranges
Date: Sat, 12 Sep 2026 08:59:48 +0200
Message-ID: <20260912065633.450394359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d77c3e95645df..6bc19b164dfb6 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -329,9 +329,6 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 	struct file_lock_context *ctx = locks_inode_context(file_inode(filp));
 	int error = 0;
 
-	if (start == end)
-		return 0;
-
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
-- 
2.53.0




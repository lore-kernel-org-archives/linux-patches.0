Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EA437FF60;
	Sat, 12 Sep 2026 09:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203885; cv=none; b=gWF4LRokua/vFV7OCD9Q7zVNNkBIeQFNeL9GqGrrRBiUyz4bWlWTJe6if9knCcZOQRMvtI5BeqOAxqO8MW+DXEWTja75qmiIOw6JoCrZuqRt5IysCH5EeUASHfC9HulJlVaRSn+vio0xZaKE4/bD1ns4Ptn7tlTpz9gNnKCce9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203885; c=relaxed/simple;
	bh=5aYDXvGlJhzZMgjH5ADI2kWIKFsN6cIGpyizub9Etdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGgBMKGm1aE5TtdZsHhaUgMbEtVWGfb+Vi48py+X3ECLQXLqwhA4FRUHRP/EmM7DzzSZP5kxFtOgJqge9sfXqPkLtjLfm63rduYt0kej+dSMagZUTbs3Uz/nicFKU7ppMB1RM+sYv6OOw+rBSejOa9vVab1+GNEEDk76eF/iEv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrmoZAl5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrmoZAl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4681F1F000FF;
	Sat, 12 Sep 2026 09:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203884;
	bh=oB0PBaUqv+VeyXilAQ10SyFkSeyVzlKLiDz79LfViEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrmoZAl5BtmPzoBd1DrhONkU9B9+SLiEYLrb+l7NlVcJQ8FtsZIMQ4OuNjY3USYFr
	 XPufrfFE6dQchTGJvSwKApfzWp26ruXhxVOmxJYwHQ83Iy9Lu517W+i8D5sK4DcqvP
	 bHsJGy3BesEkJzkieEjDpno9EnUf8I09oLmmUo8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1498/1815] ksmbd: Do not skip lock checks for single-byte ranges
Date: Sat, 12 Sep 2026 08:54:08 +0200
Message-ID: <20260912065724.166706045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d324585c0566b..233d127f27015 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -297,9 +297,6 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 	struct file_lock_context *ctx = locks_inode_context(file_inode(filp));
 	int error = 0;
 
-	if (start == end)
-		return 0;
-
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
-- 
2.53.0




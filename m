Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60E21E098;
	Sat, 30 May 2026 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163910; cv=none; b=EaphoHuuV9eeR8YX3rDRpvMQbM+Fmdh30Y/JQlx845L4M7LPSwPt/ys2TcoyUQD80g6jcyzchOJLFiT/bVIJKrwWRNPS7wOQG3vkhQecRFBP3Cj0EqWPXlhPAe2cJi1MLMikKCyE2OHinX2+sf5xY6OXnCGfWX7VvHnAzw1RkIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163910; c=relaxed/simple;
	bh=SHAS8i8bZTkxrSnzn1fZKr+s8RuTVuhq4qW93Q5Ybfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq3h7uou26UXK8tAoOeZSPILnn1BEhx+hTDc9V67k5enJw/Gv3UMHT0++yRV1+65hmRM3TUBR1FI6212eIhz8WYd08NGnbF8SHTCgMsvH8k03uPSTGlc5bwEXe46LUok4AAUO8P7Qkef/RlSjZoKQipMwEmR2kLAJ1q5DUjJgpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhKFe+2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhKFe+2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7571F00893;
	Sat, 30 May 2026 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163909;
	bh=lLcokpNIALuEaO1SFbveBLIYz4dSgH6b3l+fDE943mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhKFe+2b4U6I0Am7S5BmGEqfAay2Mg30evvgMB9u9b+zWZgxlTX3iRt+cCR+6lDmZ
	 yNAll2b9nXMzo5M89vp4WoJ0/dHI6bbZTW9rtBdqJ+GZkEoZUDEfORbPeqD4ZEfJZG
	 A7KwaGqqgCXV8oxNtWQJ4gUFlmDXtIw0tzqe2YhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangshiguang <yangshiguang@xiaomi.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/776] debugfs: check for NULL pointer in debugfs_create_str()
Date: Sat, 30 May 2026 18:01:45 +0200
Message-ID: <20260530160250.597729141@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 31de83980d3764d784f79ff1bc93c42b324f4013 ]

Passing a NULL pointer to debugfs_create_str() leads to a NULL pointer
dereference when the debugfs file is read. Following upstream
discussions, forbid the creation of debugfs string files with NULL
pointers. Add a WARN_ON() to expose offending callers and return early.

Fixes: 9af0440ec86e ("debugfs: Implement debugfs_create_str()")
Reported-by: yangshiguang <yangshiguang@xiaomi.com>
Closes: https://lore.kernel.org/lkml/2025122221-gag-malt-75ba@gregkh/
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260323085930.88894-2-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index df5c2162e7297..e4e66bd2367e8 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -942,7 +942,7 @@ static const struct file_operations fops_str_wo = {
  *          directory dentry if set.  If this parameter is %NULL, then the
  *          file will be created in the root of the debugfs filesystem.
  * @value: a pointer to the variable that the file should read to and write
- *         from.
+ *         from. This pointer and the string it points to must not be %NULL.
  *
  * This function creates a file in debugfs with the given name that
  * contains the value of the variable @value.  If the @mode variable is so
@@ -960,6 +960,9 @@ static const struct file_operations fops_str_wo = {
 void debugfs_create_str(const char *name, umode_t mode,
 			struct dentry *parent, char **value)
 {
+	if (WARN_ON(!value || !*value))
+		return;
+
 	debugfs_create_mode_unsafe(name, mode, parent, value, &fops_str,
 				   &fops_str_ro, &fops_str_wo);
 }
-- 
2.53.0




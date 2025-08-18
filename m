Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE66332039A;
	Mon, 18 Aug 2025 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522589; cv=none; b=OH0nyFinK7exyoObbLaLpBSjMnDICayawRXMN9ZxhQhwnFq1bP1Fr+74HZ7knQcEUuqLr8lpuF7hFIKjVlLJhoJ6I44wRoNjnJyW2OQBI49HgAh5EinHv3O1RPHDgB0+bWp3ut/6a/YzFmiCk3IoSY7jGlSDa5muEyDibQ8EiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522589; c=relaxed/simple;
	bh=Tew0UHTg/OI1WOdwpaGmeq9L9KA40rmD5rBGCOw13hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZjAL68I6WXvqeG6WVBvwDR6jspvV1Fy0gowgaCmOWmUw389JJ7xa/a5/22fqjHsFdRBcV7qD/+X8IJnLyWd1svCqe6NtnNm8PD6pbJy1+e3TytZgC7j+CW7/KPx4kPDA6qIoNnqak7lMsuAf09aCwOW7P0Olr4FC/95V3j7F2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxhUKXbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxhUKXbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D26C4CEEB;
	Mon, 18 Aug 2025 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522588;
	bh=Tew0UHTg/OI1WOdwpaGmeq9L9KA40rmD5rBGCOw13hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxhUKXbLJLbjPD7wGo0y4cBeMNyGz4f704NBfFcxwsCP+pqDf8EQ2ZTg3Zg0WcDuc
	 0BYi64QPAdju6TIYC4p1lGjs71xkuhNE2DiEJ+aEQ4PZh3WN2f8E5SXdH5Oa04rbJr
	 vUZEnqSL8yRBylADASMBWWuj62ZhnlnuH02Wso+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/444] module: Prevent silent truncation of module name in delete_module(2)
Date: Mon, 18 Aug 2025 14:45:54 +0200
Message-ID: <20250818124501.233041350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit a6323bd4e611567913e23df5b58f2d4e4da06789 ]

Passing a module name longer than MODULE_NAME_LEN to the delete_module
syscall results in its silent truncation. This really isn't much of
a problem in practice, but it could theoretically lead to the removal of an
incorrect module. It is more sensible to return ENAMETOOLONG or ENOENT in
such a case.

Update the syscall to return ENOENT, as documented in the delete_module(2)
man page to mean "No module by that name exists." This is appropriate
because a module with a name longer than MODULE_NAME_LEN cannot be loaded
in the first place.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Link: https://lore.kernel.org/r/20250630143535.267745-2-petr.pavlu@suse.com
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 6908062f4560..4511d0a4762a 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -703,14 +703,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	struct module *mod;
 	char name[MODULE_NAME_LEN];
 	char buf[MODULE_FLAGS_BUF_SIZE];
-	int ret, forced = 0;
+	int ret, len, forced = 0;
 
 	if (!capable(CAP_SYS_MODULE) || modules_disabled)
 		return -EPERM;
 
-	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
-		return -EFAULT;
-	name[MODULE_NAME_LEN-1] = '\0';
+	len = strncpy_from_user(name, name_user, MODULE_NAME_LEN);
+	if (len == 0 || len == MODULE_NAME_LEN)
+		return -ENOENT;
+	if (len < 0)
+		return len;
 
 	audit_log_kern_module(name);
 
-- 
2.39.5




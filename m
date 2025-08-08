Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F8D1D61BB;
	Fri,  8 Aug 2025 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667075; cv=none; b=cXEkbudRQ3IFEHm9cf9qXtBwts2GfptzpqB51Zlk1HrKMFgijMG6QCE7n8ke4xhfSvVkT7GFNSPn6EA1aiCMMF2unPLCE5zfsagPye6+A4rnMnXGZRKwAgjthOwLOh5FFLb6pPJyC5qeatEDduxT8AMY2oU2eOeZasKwRcKnnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667075; c=relaxed/simple;
	bh=ZZiBwySTiMIPACxPjy9xEobcxAopojqaVmG80aMHTbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aWaX7YcTEIceMJGfYqjxgkvTDK1gMpl03v9o/njWo9SP2EK2nhBdyDTdwdlk1mUCDIt8pkR+zbQw/D9nAfv+GS/9Rr1W1Sng9Vo5zDrAeUsPnkBCkKbpm5otUqzU298+walmg5rjT8cXhVt9ELvubJRqT2x3hcazDJ6xdoS+020=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C94//DvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C94//DvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39A9C4CEED;
	Fri,  8 Aug 2025 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667074;
	bh=ZZiBwySTiMIPACxPjy9xEobcxAopojqaVmG80aMHTbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C94//DvBqUYgtdqxhdZMDl0IwqgAjCp6z1moZLV3LGzVOfBNF2r0SuglJanDztZmb
	 HPhoKvpYMatMzhLaL2Ll7YcgWB/owvGlAMxgSicLGK0u2/Tr1jWz4ysdvp0b/GTUcQ
	 vAXVqkegeldjlaDhkErCIBb6/gKo5JbbuXHvwPHD5Wm2LaHTWwN+eMbgHTAuyw38NY
	 Q9meBtCC9PLKTjRFFwK+WvZ7E+H5B6MjKmCtZOQWEWkIEzkJcQpABkTXrOu2iWUkEG
	 bi0njVgROJIVkvGQmjs5pK/RBVUko2dOMRW7o4V79i5ey8BTLmu4bCSPQR1pigcJew
	 niPobaLrbQfFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	mcgrof@kernel.org,
	da.gomez@kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] module: Prevent silent truncation of module name in delete_module(2)
Date: Fri,  8 Aug 2025 11:30:49 -0400
Message-Id: <20250808153054.1250675-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Security Fix for Silent Truncation**: The commit fixes a security-
   relevant issue where module names longer than MODULE_NAME_LEN (56
   bytes on 64-bit systems) are silently truncated in the
   delete_module() syscall. This could theoretically lead to
   unintentionally removing the wrong module if two modules share the
   same truncated prefix.

2. **Minimal and Contained Change**: The fix is very small and localized
   - it only modifies the delete_module syscall implementation in
   kernel/module/main.c. The changes are:
   - Changes from `strncpy_from_user(name, name_user,
     MODULE_NAME_LEN-1)` to `strncpy_from_user(name, name_user,
     MODULE_NAME_LEN)`
   - Adds proper length checking: `if (len == 0 || len ==
     MODULE_NAME_LEN) return -ENOENT;`
   - Returns the correct error code (ENOENT) for oversized names

3. **Follows Stable Tree Rules**:
   - Fixes a bug that could affect users (incorrect module removal)
   - Very low risk of regression - the change only affects error
     handling for invalid input
   - No new features or architectural changes
   - Improves consistency with documented behavior (delete_module(2) man
     page)

4. **Prevents Inconsistent Behavior**: The commit message correctly
   points out that modules with names longer than MODULE_NAME_LEN cannot
   be loaded in the first place, so returning ENOENT for such names in
   delete_module makes the behavior consistent across module operations.

5. **Clear Bug Fix**: The old code would accept a 57+ character module
   name, truncate it to 56 characters, and potentially remove a
   different module. The new code properly rejects such names with
   ENOENT, preventing this dangerous silent truncation.

The change is defensive programming that prevents a potential security
issue without introducing any backward compatibility concerns, making it
an ideal candidate for stable backporting.

 kernel/module/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index c2c08007029d..cbd637627eb4 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -751,14 +751,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
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


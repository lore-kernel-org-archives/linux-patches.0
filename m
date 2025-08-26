Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092AF1B85F8;
	Tue, 26 Aug 2025 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214628; cv=none; b=Gw2wrDvPavC+WHL5JdRd8mmljQL+Gtub58Iq+qA3qQWXgS5Jg4+nd90mfZXK2KXZ1Pf1uKt9f9GYrBaAj+EhKmWHkpRfHxoKnobE9CUnqQ8Qe9EdGly9rqs9E66c8l3MvkC+qCyRAIKYhqmm9rSrN6rRoVe7KfHY2h9zB0UH4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214628; c=relaxed/simple;
	bh=NsRb8ve5fchPgXhwFTbSculXloNtdiNWYIp7fEBQ3kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFXBGILHcoleXJ3HqO0HvPwngx4m71pHiqPaKR7uIC2USa6FTbu5sNNCMAp2OjmWjVquq47I7kWlf7ZRpVW9tP1fl4cuZrmevalJt5U00sW2V+1z+M02+pXKIhkDv832pmfml5W+3bvz6eWpIWJpJlWzdcjyAHYTeS4y3+lPeao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kay3Pax6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kay3Pax6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEAEC4CEF1;
	Tue, 26 Aug 2025 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214627;
	bh=NsRb8ve5fchPgXhwFTbSculXloNtdiNWYIp7fEBQ3kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kay3Pax6tAP0gVwSkH7rjqjbYXJxXUI3nnuaEH4AXcz+UxsdViweEMVgETug//esl
	 0LZOO3qY64UsK7SOG4OTE/Cn/T2WXXKqxwoWcXPNIaKSjO8mgOMbd5dmyivFWfZa/P
	 2HjXYeaZbH2LLKiolNQhmWWW3K+HaXj5oHvqf/Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/482] module: Prevent silent truncation of module name in delete_module(2)
Date: Tue, 26 Aug 2025 13:07:42 +0200
Message-ID: <20250826110935.944985976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 554aba47ab68..3269f6c46814 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -699,14 +699,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
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




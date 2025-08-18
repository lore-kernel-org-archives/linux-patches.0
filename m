Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C9731B107;
	Mon, 18 Aug 2025 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525981; cv=none; b=X7vCS8RmMsiO/qf2mL6QC8C86SclYv7AKaheoooqNnkr11ZJbT2cohkEXgDIxy2GMkD0BBHFK6G+lE7OR6Kuw+KsvMUHaDBNwXwqRoUW4kqJaY/4G0UYd3FgysNu8i3WuwX5ePjT8oyuq5zmAackg+WbCdVQPjK2Z72tA9pASdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525981; c=relaxed/simple;
	bh=kOsXsPHp1Bfu77OQSUAPxFgIL5YPL9YIzS/aykxES2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWvya+oPXKuKxJ54oyscE0grtpb2uu6k5C21YJaK4y0Z7OjgyyNldx1TlHvIsgt+G+n2Qre95n2joiLc2VJrC5Kt/hADVLvnjZpDnYzuLkG8CFWBcVjuSe6H1c4SyMOE6isxIh9jBdAy+82uCCp6AqWyKMSB+rGQ6CherfdktRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZN9HMaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZN9HMaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AA3C4CEEB;
	Mon, 18 Aug 2025 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525980;
	bh=kOsXsPHp1Bfu77OQSUAPxFgIL5YPL9YIzS/aykxES2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZN9HMaLv8e0GP2oxaai5K2EL4PjHpo+DdpHKxdwlqbWfGlhLkMQmSkVnj23NUj0y
	 F9Yv9ZhUsjU31P6rfcT2J3G61DuhPmSZtdS98cuGldT4uIWTX0z/u3Xv6b5LnDZWi7
	 ail1pXFc3Wt97MHr5TN4eeKBg6dKYiYMFZaNsk1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 424/570] module: Prevent silent truncation of module name in delete_module(2)
Date: Mon, 18 Aug 2025 14:46:51 +0200
Message-ID: <20250818124522.172235862@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 43df45c39f59..b62f9ccc50d6 100644
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




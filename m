Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B00313957E;
	Tue, 26 Aug 2025 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213296; cv=none; b=Pz4OkRaMaohn3qQp+pKuw+HdzRRkpEHr4xLTxnX5WFvFeeJ5D4duAWw6SvIchlGIycQWOKGQP9qKc6S0xD1OzCgnbSQjDIb9MW3wi4Lr9z/LeaeYssp4AK4f5mpYis3tCUSWgvxOMzDbrYaSoH38L7muYkWmnOWbIz7wDbuXhMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213296; c=relaxed/simple;
	bh=DrGnrV64+SavhqH5CCm+Y71foendf0SsJ7NvzztpZR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiTADM4zAssJo+j3TEsfasILXs/lUwrTzT+nBm5KstEu3ZKEv6+kU6/ZH5m3MNTZcVCblW5ssmSPc2vmpzMQ8E3JWAMbodpWilH9QJXJ5aVl/lAmD8ZRXMAM5G0PfJKE4dz5aL2oah045xOlLReC8hLKGx6xleIFU8Y46P+a3lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6yXmXVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6yXmXVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC965C4CEF1;
	Tue, 26 Aug 2025 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213296;
	bh=DrGnrV64+SavhqH5CCm+Y71foendf0SsJ7NvzztpZR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6yXmXVEtZbgl9c8uBO0rrdzEBeW+6Ez73g56R9ZkdsZ2k9GjhBt+5QTOqih/x1qz
	 3Z+MBXVU5LZvPlXpKrzzrynxiHKL9eaSKeKtr6BA6uEP1prsFa219RhrJeJ+NHafS2
	 66FIvZhI5YRk3vwjnHHCSFfjcvgoGYJG4Bqq2oCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/587] module: Prevent silent truncation of module name in delete_module(2)
Date: Tue, 26 Aug 2025 13:06:51 +0200
Message-ID: <20250826110959.594923225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9711ad14825b..627680e568fc 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -701,14 +701,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
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




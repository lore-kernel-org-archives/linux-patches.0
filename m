Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AE732252B;
	Mon, 18 Aug 2025 13:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524182; cv=none; b=KDuq/h3/37vthpidpXtef8CFWrmgjVkcqHTh0vUfTjPZmExKMX4iBrbqNyKrAwVeXPRHDDtYnBC5+5+6R72RUG6HR+jXcZqMOCngtGHzv7dJWAUSbD+UXOzMJZElynISc9MmC/C95si+7DiRS33E1PitI0KEJ3zoT71GSg4ngjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524182; c=relaxed/simple;
	bh=LCE5SOKHIGIquMYkqPxvhCX6pZ5ofsqbtnm106qhzn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0i2A25nhIDEmExfnEL1XY7+P/iEfw3YnxzNe2k6jJzqfDRe96uw0MLYVxd00IX7cPutj9+DIiRTSJUozdur8+qSF4AA3YmwmJ104clEVpwYDjPPbezMJp2WMjXToWvoFW89g7qrCeVoKpvtN2JJJjDZHhxqZTvtvze9E6Z+JBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFDZ9ccr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFDZ9ccr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AE9C4CEEB;
	Mon, 18 Aug 2025 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524181;
	bh=LCE5SOKHIGIquMYkqPxvhCX6pZ5ofsqbtnm106qhzn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFDZ9ccrELu1byGYRxXNhRdiQbOWLFhAxDCSV2+kZ0/aDflYVvReOWd5mD8ra97JE
	 y5h8HARDmF6v0DZQgytsF5/WJXDf1g/61PEIHH8x0iekGaLsS1bNF0X++aTvz4VKrv
	 3h+4DFERpfpalDXZ9tuPvc0B6nQSb/jNc5Hw7x3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 391/515] module: Prevent silent truncation of module name in delete_module(2)
Date: Mon, 18 Aug 2025 14:46:17 +0200
Message-ID: <20250818124513.469136550@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 05da78b6a6c1..4e4e0fd11dde 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -727,14 +727,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
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




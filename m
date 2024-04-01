Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2DB481B8;
	Mon,  1 Apr 2024 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990965; cv=none; b=KA30aYCHC7fXaG/h1vmoTjhUKNeiRYLagXmQ9nz1v3GJ65zVTg/5vO6GJFs63YFRbbwPRqIsOvLq39oGm2hjurMJ6e4Ewf/0nRfjMwAv/E0D0lqJtP3FKX7R3BFSLZpxCTeiyKG1fz46n1se6JU4V6DBnePO+KORN66DEJ7Jxbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990965; c=relaxed/simple;
	bh=GV9GsQf7EzW86kyoHci1xJXb9NGi0y6iB5rpnk8MYAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9UwY/3sWuRKxUJiPs/OhwVUPBppjV6/sJ+dbeikGItRHp0w8zSM7A1VgJJTQhTh8hGANjxfdwjq/lcrAtytVVBiGWv6Cg+KjT6f10baU8lNYHveUYHsHlwuabb/kJ7p2KBpfjOC1X4HidPdyZe5HnJkN5Jpp1pJpBTAwBECITc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uf3OhVKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uf3OhVKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08304C433C7;
	Mon,  1 Apr 2024 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990965;
	bh=GV9GsQf7EzW86kyoHci1xJXb9NGi0y6iB5rpnk8MYAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uf3OhVKLTdi2ZYmnGjJQEq7jzJDsGY8i47CL8jALQVY3KV6nf7wpu4YHurgf6/V59
	 DvTKsxnLmyyPt1AQfaeatBOXbxb6su32md3lAUnM1mU8h3FHig9zxM56A0jdHvEEX8
	 K/O3UM9O7FvBEVyzCQTpj7d3GN8KC6yaPA+78bKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/272] landlock: Warn once if a Landlock action is requested while disabled
Date: Mon,  1 Apr 2024 17:44:33 +0200
Message-ID: <20240401152533.201590993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 782191c74875cc33b50263e21d76080b1411884d ]

Because sandboxing can be used as an opportunistic security measure,
user space may not log unsupported features.  Let the system
administrator know if an application tries to use Landlock but failed
because it isn't enabled at boot time.  This may be caused by boot
loader configurations with outdated "lsm" kernel's command-line
parameter.

Cc: stable@vger.kernel.org
Fixes: 265885daf3e5 ("landlock: Add syscall implementations")
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20240227110550.3702236-2-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/syscalls.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 2ca0ccbd905ae..d0cb3d0cbf985 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -32,6 +32,18 @@
 #include "ruleset.h"
 #include "setup.h"
 
+static bool is_initialized(void)
+{
+	if (likely(landlock_initialized))
+		return true;
+
+	pr_warn_once(
+		"Disabled but requested by user space. "
+		"You should enable Landlock at boot time: "
+		"https://docs.kernel.org/userspace-api/landlock.html#boot-time-configuration\n");
+	return false;
+}
+
 /**
  * copy_min_struct_from_user - Safe future-proof argument copying
  *
@@ -165,7 +177,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	/* Build-time checks. */
 	build_check_abi();
 
-	if (!landlock_initialized)
+	if (!is_initialized())
 		return -EOPNOTSUPP;
 
 	if (flags) {
@@ -311,7 +323,7 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	struct landlock_ruleset *ruleset;
 	int res, err;
 
-	if (!landlock_initialized)
+	if (!is_initialized())
 		return -EOPNOTSUPP;
 
 	/* No flag for now. */
@@ -402,7 +414,7 @@ SYSCALL_DEFINE2(landlock_restrict_self, const int, ruleset_fd, const __u32,
 	struct landlock_cred_security *new_llcred;
 	int err;
 
-	if (!landlock_initialized)
+	if (!is_initialized())
 		return -EOPNOTSUPP;
 
 	/*
-- 
2.43.0




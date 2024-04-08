Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605C42DF73;
	Mon,  8 Apr 2024 13:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581674; cv=none; b=MWWjWY1hzcNEjx5zedxB7iNuI+P6dI/YbHo0tAdZADP0QuoAsLUENVD2pi1zMGG0mTN/Dq338vKV672kCTKJPs/LEnGPGJle2UQlc/nCpwnkn2BbC0ECyEBgVX/lqbClLVMQabhcnRGcCB9QmBgbugT1/jxS9bUnJhaPcb8kWGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581674; c=relaxed/simple;
	bh=vowLi28RGz4B4lFFx5PbihD5mmzuEJbHAYFvFsyuNEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7mtHWd6y9iGf/AEuAujuPn6lTt2YaqBXDdTZOnL5v/q/e+MD1H9WlPmgwMU/4uwxwK736Wy7acY1mQ5nYpVqxwfdmC3wMv9QTWoqd9gnNR8J2EI5V08OpOkUm8OX0TGr1hWyYeIjyDZkS4qWYKhv5lgGjOBiiq2+ZOIoryWT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dB3wTKXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dB3wTKXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F21C433C7;
	Mon,  8 Apr 2024 13:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581674;
	bh=vowLi28RGz4B4lFFx5PbihD5mmzuEJbHAYFvFsyuNEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dB3wTKXlp0NexbTih+CwZA1Tt/oyGCVtwI+pLW8hkR/nTi2EubNML22VYLnzRDBXP
	 uESmIjcSl88naZpI6QRwJQJWM++K8WbPLpDY9bV/I0j6GXeqOMv3nzTNk9ySNQEbvU
	 2uxtPiXlWXH9mG/1QvHaAZCIiws4cbEZXFMGvR/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/690] landlock: Warn once if a Landlock action is requested while disabled
Date: Mon,  8 Apr 2024 14:48:58 +0200
Message-ID: <20240408125402.135982893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 507d43827afed..229a6918b52f3 100644
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




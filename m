Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DE4778C;
	Mon,  1 Apr 2024 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986901; cv=none; b=CfSC7h0gNFrw1GImTK6fa57/AXWeuQRZQTvlJGl6Zgg276dk99yarmZNHTuMZNHH/HeBmOhQaesI1G0/TDoWZ1JTQLGRg3whkajVYhXlbsOK0AFur97wS9kjFoIqR1FfgMAg9exfvmuM3u8wkV7yM7nwrmA9Zr+opDGk2gZdS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986901; c=relaxed/simple;
	bh=sJSrutjmjRJR//po0nLBdPWwlzSmR17969HiA3fPc/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrHX7uej/aMWIOjdPiaXWn6nAJgeQ7sQdHS6fmf5wotr7O3yCe5IvJTLWqERnSap8AbRjHOn+u8ISHO7nqPODwfpgXAf6qCofUp71OWhIdCvySQRYGFHOrHV0VJIjSDbo/fAS0P1yeC7yQRKlRs8kmCoIPFYcDwuYKdBdw+wSOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUw1E3Ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUw1E3Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DE1C433F1;
	Mon,  1 Apr 2024 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986901;
	bh=sJSrutjmjRJR//po0nLBdPWwlzSmR17969HiA3fPc/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUw1E3IhINWCUL2uuLutpe4S3EuKHIsuRZLVnoFDdPmQ3MsQ0VNTSP7zx+VZKkTSk
	 YQiC9E3PmTA5AJxk3CmdBKMQrlhQL1AO0q2GffTi++sLelbV7L84QrSlOfsm/PyAKH
	 Aps6iX5nv7tr+FOnwsNp1FtxLXZHOVrz+uuCHC+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 121/399] landlock: Warn once if a Landlock action is requested while disabled
Date: Mon,  1 Apr 2024 17:41:27 +0200
Message-ID: <20240401152552.800388920@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 898358f57fa08..6788e73b6681b 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -33,6 +33,18 @@
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
@@ -173,7 +185,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	/* Build-time checks. */
 	build_check_abi();
 
-	if (!landlock_initialized)
+	if (!is_initialized())
 		return -EOPNOTSUPP;
 
 	if (flags) {
@@ -398,7 +410,7 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	struct landlock_ruleset *ruleset;
 	int err;
 
-	if (!landlock_initialized)
+	if (!is_initialized())
 		return -EOPNOTSUPP;
 
 	/* No flag for now. */
@@ -458,7 +470,7 @@ SYSCALL_DEFINE2(landlock_restrict_self, const int, ruleset_fd, const __u32,
 	struct landlock_cred_security *new_llcred;
 	int err;
 
-	if (!landlock_initialized)
+	if (!is_initialized())
 		return -EOPNOTSUPP;
 
 	/*
-- 
2.43.0




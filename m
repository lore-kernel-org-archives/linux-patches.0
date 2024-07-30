Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C74D1A76A4;
	Tue, 30 Jul 2024 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359793; cv=none; b=l4jI/xiAAuiN11WFWv38gtxXeQtnv5+MkkJIW6fZ1+dKF0V3QPw3RZzPbgBfZHcl3ax1saavGnlhk0rCjLw4JhtEqZSL/oaXlqWBL++CnF7E0H6EqeLp/Auc0bQjHKR2kdHFSauJvatJK08EQJ/EvGIPBi0Wl7N57mVbJ3My/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359793; c=relaxed/simple;
	bh=at5BfkMCpDB6671ZCkKObazn5St1iYE7tnvpOEvSra0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXfioIwEkIBWGhKhrLyfChYXvrPN2CjfgRR31aRelnmSXD4mqMzfqqggNqjkEjrBmlmruD60X6tbivIUWNDgx0cztM7ow0WpkS222Ab92SYxFjOoOLGFDpDJQJ+AFydV9ZfwuhPXijfaABWJoB3E/wkmmYbRTGqnwEW/BTBZtXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lt/9f6SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lt/9f6SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC11EC32782;
	Tue, 30 Jul 2024 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359793;
	bh=at5BfkMCpDB6671ZCkKObazn5St1iYE7tnvpOEvSra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt/9f6SHCiDg69dOJSveVXqI1h0P5fM+i9ARyoWeS7KzYmEF7wpQn5h+ePETLcGP9
	 J4KnQ8PgQ9fVMB5qBd1Q7SfHcHaxuRwEIVC/ycjPY4LWYBjBi5qn8qXIfGzaOqRL+/
	 GlQM/ZDuOrPvjhS/pA3OnkndBn//q1D8JVmmgbNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.10 533/809] landlock: Dont lose track of restrictions on cred_transfer
Date: Tue, 30 Jul 2024 17:46:49 +0200
Message-ID: <20240730151745.790173727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 39705a6c29f8a2b93cf5b99528a55366c50014d1 upstream.

When a process' cred struct is replaced, this _almost_ always invokes
the cred_prepare LSM hook; but in one special case (when
KEYCTL_SESSION_TO_PARENT updates the parent's credentials), the
cred_transfer LSM hook is used instead.  Landlock only implements the
cred_prepare hook, not cred_transfer, so KEYCTL_SESSION_TO_PARENT causes
all information on Landlock restrictions to be lost.

This basically means that a process with the ability to use the fork()
and keyctl() syscalls can get rid of all Landlock restrictions on
itself.

Fix it by adding a cred_transfer hook that does the same thing as the
existing cred_prepare hook. (Implemented by having hook_cred_prepare()
call hook_cred_transfer() so that the two functions are less likely to
accidentally diverge in the future.)

Cc: stable@kernel.org
Fixes: 385975dca53e ("landlock: Set up the security framework and manage credentials")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20240724-landlock-houdini-fix-v1-1-df89a4560ca3@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/cred.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/security/landlock/cred.c
+++ b/security/landlock/cred.c
@@ -14,8 +14,8 @@
 #include "ruleset.h"
 #include "setup.h"
 
-static int hook_cred_prepare(struct cred *const new,
-			     const struct cred *const old, const gfp_t gfp)
+static void hook_cred_transfer(struct cred *const new,
+			       const struct cred *const old)
 {
 	struct landlock_ruleset *const old_dom = landlock_cred(old)->domain;
 
@@ -23,6 +23,12 @@ static int hook_cred_prepare(struct cred
 		landlock_get_ruleset(old_dom);
 		landlock_cred(new)->domain = old_dom;
 	}
+}
+
+static int hook_cred_prepare(struct cred *const new,
+			     const struct cred *const old, const gfp_t gfp)
+{
+	hook_cred_transfer(new, old);
 	return 0;
 }
 
@@ -36,6 +42,7 @@ static void hook_cred_free(struct cred *
 
 static struct security_hook_list landlock_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(cred_prepare, hook_cred_prepare),
+	LSM_HOOK_INIT(cred_transfer, hook_cred_transfer),
 	LSM_HOOK_INIT(cred_free, hook_cred_free),
 };
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D68BE8;
	Tue, 30 Jul 2024 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357220; cv=none; b=kZdwf31iFuvmkaZGIyKPmZU4JXRhn1pPE3O+pYCqRFtMVLpgH8udHS6lC2PqTgPBXL4V3cVcvwixTB3ym5UQxXfIcgf3O9dufxN11D94VW+PYR/M5yUFjydha0AYYJAkbAshLmQUSphuHMYkZqELwYkXThLa8vQlYFnUay5GSP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357220; c=relaxed/simple;
	bh=/LhNFdoBIyvrwIGlWTQtWFelxL/Kr+rYmUKmUlrOEao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SlLk5hxdwEGg+a5Z7nbS7dUANav0HBePfDYmQA0Fhlnw9OZCJjDS+LowFMB5S4JcCL/el/3g2AaVM2NFLzRcxd5wSL2usx+iwLZZbh1gcpcchB65naMqvnPSGXo+qD7jS7vo7Hl+3o/cHQZix7FJ1Pebh5zha2itpGt4s3xAQmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4BUdzDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4BUdzDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA96C32782;
	Tue, 30 Jul 2024 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357219;
	bh=/LhNFdoBIyvrwIGlWTQtWFelxL/Kr+rYmUKmUlrOEao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4BUdzDSUVH0PFgUQUKZc88zSSP8Z/9IqmnSFwdkEYWg16iKn0a/wWdPvaqW84wlL
	 CVi4fNIM7/FPzY/wJcqQ/ufD0V6DUDLJD74osFBTXCyQK6AULVMJnjRIWKThPYWBEu
	 6Iq62mp3Rtwq+pHM6gEQ7q81E5vuJrf+pzTDDZqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.1 270/440] landlock: Dont lose track of restrictions on cred_transfer
Date: Tue, 30 Jul 2024 17:48:23 +0200
Message-ID: <20240730151626.382438441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
 
 static struct security_hook_list landlock_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(cred_prepare, hook_cred_prepare),
+	LSM_HOOK_INIT(cred_transfer, hook_cred_transfer),
 	LSM_HOOK_INIT(cred_free, hook_cred_free),
 };
 



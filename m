Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDD861FFE;
	Tue, 12 Aug 2025 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023196; cv=none; b=UDVLS21Z6JEZKK+pflak6+KAWKfBA/EDn0NrDm+pTWKIBB0LkynHxP8B3YLGbSbJJJ2Lz0gTnrw8kL7CLY5/m4NhqdtHY/CghPK+tdJE4JZoh2H0brlwXdDrWKqZs7sXXHgtaLCALay0+iCTeSyvq+GMfE667AUKXDq3LF6xgGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023196; c=relaxed/simple;
	bh=yk5WvbwetinG162H+b7ju5epZrN21AClVmYiqgeT4Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku4r6FJMrvzqM3E0jAbiTFRwWYz/KKiHgVQIYNsX/PUV4AJcMppy+uJ8Lp7ydr30XpVv+HycLk0R5zY2k62MS2T0n4CvD4e89Tv2PAzWOIFmMFygu4UCky5rgKZ69Mbd8gSZ1ad+S1Npas9rfanpjjTib3KJKkcCrGCtxDdj4zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AV1pr52Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AV1pr52Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8639CC4CEF0;
	Tue, 12 Aug 2025 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023196;
	bh=yk5WvbwetinG162H+b7ju5epZrN21AClVmYiqgeT4Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AV1pr52Z4fVycvYUX/eOf57+LkhiV8md/tggkJnzNGq3yHUJh9hXJhLnQLXWFYItC
	 qvURUmDvSQS4uDw30MEighP3ryDTod4myiCd8g6kvE0FrcOIte+CB/A+bqSoJFdyDj
	 nKn8giXJxkyF9OQhZHJqVyWEj//IPpvBv9neBcGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 001/627] audit,module: restore audit logging in load failure case
Date: Tue, 12 Aug 2025 19:24:56 +0200
Message-ID: <20250812173419.366128090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit ae1ae11fb277f1335d6bcd4935ba0ea985af3c32 ]

The move of the module sanity check to earlier skipped the audit logging
call in the case of failure and to a place where the previously used
context is unavailable.

Add an audit logging call for the module loading failure case and get
the module name when possible.

Link: https://issues.redhat.com/browse/RHEL-52839
Fixes: 02da2cbab452 ("module: move check_modinfo() early to early_mod_check()")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/audit.h | 9 ++++-----
 kernel/audit.h        | 2 +-
 kernel/auditsc.c      | 2 +-
 kernel/module/main.c  | 6 ++++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 0050ef288ab3..a394614ccd0b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -417,7 +417,7 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 extern void __audit_log_capset(const struct cred *new, const struct cred *old);
 extern void __audit_mmap_fd(int fd, int flags);
 extern void __audit_openat2_how(struct open_how *how);
-extern void __audit_log_kern_module(char *name);
+extern void __audit_log_kern_module(const char *name);
 extern void __audit_fanotify(u32 response, struct fanotify_response_info_audit_rule *friar);
 extern void __audit_tk_injoffset(struct timespec64 offset);
 extern void __audit_ntp_log(const struct audit_ntp_data *ad);
@@ -519,7 +519,7 @@ static inline void audit_openat2_how(struct open_how *how)
 		__audit_openat2_how(how);
 }
 
-static inline void audit_log_kern_module(char *name)
+static inline void audit_log_kern_module(const char *name)
 {
 	if (!audit_dummy_context())
 		__audit_log_kern_module(name);
@@ -677,9 +677,8 @@ static inline void audit_mmap_fd(int fd, int flags)
 static inline void audit_openat2_how(struct open_how *how)
 { }
 
-static inline void audit_log_kern_module(char *name)
-{
-}
+static inline void audit_log_kern_module(const char *name)
+{ }
 
 static inline void audit_fanotify(u32 response, struct fanotify_response_info_audit_rule *friar)
 { }
diff --git a/kernel/audit.h b/kernel/audit.h
index 0211cb307d30..2a24d01c5fb0 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -200,7 +200,7 @@ struct audit_context {
 			int			argc;
 		} execve;
 		struct {
-			char			*name;
+			const char		*name;
 		} module;
 		struct {
 			struct audit_ntp_data	ntp_data;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 78fd876a5473..eb98cd6fe91f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2864,7 +2864,7 @@ void __audit_openat2_how(struct open_how *how)
 	context->type = AUDIT_OPENAT2;
 }
 
-void __audit_log_kern_module(char *name)
+void __audit_log_kern_module(const char *name)
 {
 	struct audit_context *context = audit_context();
 
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c2c08007029d..43df45c39f59 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3373,7 +3373,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	module_allocated = true;
 
-	audit_log_kern_module(mod->name);
+	audit_log_kern_module(info->name);
 
 	/* Reserve our place in the list. */
 	err = add_unformed_module(mod);
@@ -3537,8 +3537,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	 * failures once the proper module was allocated and
 	 * before that.
 	 */
-	if (!module_allocated)
+	if (!module_allocated) {
+		audit_log_kern_module(info->name ? info->name : "?");
 		mod_stat_bump_becoming(info, flags);
+	}
 	free_copy(info, flags);
 	return err;
 }
-- 
2.39.5




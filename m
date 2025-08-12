Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044AB22425B;
	Tue, 12 Aug 2025 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025446; cv=none; b=LYDWR0TLZ7GInzgpwgJ0sejvRw+YoyYG9q4ThiSLp8CwCSBjNumiRUmmF2UbJ3Aa8NaMPGWBfNvJVNpyKcJw/hPRVyxBxmByo+kHd2kPc1HWwwODEr9HjBBIvGuFPHRHM5kX7K1G3BN7hTeApLunNayBa4/6WPqFbKz7SpwMRfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025446; c=relaxed/simple;
	bh=V0Kf6xh1yJneUtPpue22t8M54KYdwAVZvAsBzd4h0gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7Of9B5pOSIezjpT8OxImkFaceeretlkYHe1RGhcoeE57PDysRcI2HLsGAUd9GqJzZG8QYN29hiqtmZ4KaaCUWUgG5uJF90Qa7LEhRAn8VDSfqaK+94s3WToVDKLgDVmkR3RtKBhzQU8qBambAFTFmsnvCOGqSzY2fEIyOllxMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBXe/6Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBXe/6Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E168C4CEF0;
	Tue, 12 Aug 2025 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025445;
	bh=V0Kf6xh1yJneUtPpue22t8M54KYdwAVZvAsBzd4h0gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBXe/6Vhu74RDKWt1WNapCiBAZeIhUaAMmWRTkpXHn0sFu/RIitIw+2xswBRmaGeF
	 jv6rZapmyhxOZt5IT6xHIgepbu7Z/YyQk9DuNuJQXu314JncWuZ419ne68T4KAUt3u
	 fbq+cRRijJXUDT4V/eWUwaZsl4UVBRaVXEVMSQKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 009/480] audit,module: restore audit logging in load failure case
Date: Tue, 12 Aug 2025 19:43:37 +0200
Message-ID: <20250812174357.691327394@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 9d8a845d9466..05da78b6a6c1 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3298,7 +3298,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	module_allocated = true;
 
-	audit_log_kern_module(mod->name);
+	audit_log_kern_module(info->name);
 
 	/* Reserve our place in the list. */
 	err = add_unformed_module(mod);
@@ -3460,8 +3460,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
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




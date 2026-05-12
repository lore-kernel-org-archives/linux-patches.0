Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC03EDE4A;
	Tue, 12 May 2026 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609177; cv=none; b=Wl23El9sOFchbwZBCi1o/4PejcRxstcUkK5v87h+JGuU0K9uzI7AH91EmLFQlWP4rJvBuHrAHHPFA+JT4ME1H6IRZQOz9/pnOlmhd0oba6YpMjYxKMLK4C6VbW3oIKv0hsER49Xg/ETlxk0fu2jdtpxvpHrAwlJn0/o/LUZngQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609177; c=relaxed/simple;
	bh=D72sYdVzG8PbI1rQ2PNxerdY/Bui6hVLjV4vGuUpoxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddkuZYRY91CyLN0NS56x4HV2hLO8bE0jtUt5inxNwM9xzQaPIq12Hl9R+D7jmmNxzMTiE5rdBSvienwmWdGtrWoAegYKdeI8x/eTkxa87h152EqeJuGcMEaWXQrF6oVnT8bM0yiuoCFlV8KAfv9RK+Z1ay/Y7syS5DeKfIcYpg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnMmWlWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnMmWlWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D24C2BCB0;
	Tue, 12 May 2026 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609177;
	bh=D72sYdVzG8PbI1rQ2PNxerdY/Bui6hVLjV4vGuUpoxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnMmWlWP9zen1JiBrd51oOqilnEGaUP8p3NeFBJdfQNZhR2R6uh+a1GBdROTmWLMn
	 bVbDlkEBSfKkWqDXWCJSYOcWCUhYXLDdXnY2YY9Ati4RF+K2qkH4nHx38EyoIU5ENX
	 hBchw30bvqN33nCTIxmB7dBviZ6UDp+t2naLZhVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 095/307] arm64: signal: Preserve POR_EL0 if poe_context is missing
Date: Tue, 12 May 2026 19:38:10 +0200
Message-ID: <20260512173942.131070494@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Brodsky <kevin.brodsky@arm.com>

commit 030e8a40fff65ca6ac1c04a4d3c08afe72438922 upstream.

Commit 2e8a1acea859 ("arm64: signal: Improve POR_EL0 handling to
avoid uaccess failures") delayed the write to POR_EL0 in
rt_sigreturn to avoid spurious uaccess failures. This change however
relies on the poe_context frame record being present: on a system
supporting POE, calling sigreturn without a poe_context record now
results in writing arbitrary data from the kernel stack into POR_EL0.

Fix this by adding a __valid_fields member to struct
user_access_state, and zeroing the struct on allocation.
restore_poe_context() then indicates that the por_el0 field is valid
by setting the corresponding bit in __valid_fields, and
restore_user_access_state() only touches POR_EL0 if there is a valid
value to set it to. This is in line with how POR_EL0 was originally
handled; all frame records are currently optional, except
fpsimd_context.

To ensure that __valid_fields is kept in sync, fields (currently
just por_el0) are now accessed via accessors and prefixed with __ to
discourage direct access.

Fixes: 2e8a1acea859 ("arm64: signal: Improve POR_EL0 handling to avoid uaccess failures")
Cc: <stable@vger.kernel.org>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |   54 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 11 deletions(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -67,6 +67,9 @@ struct rt_sigframe_user_layout {
 	unsigned long end_offset;
 };
 
+#define TERMINATOR_SIZE round_up(sizeof(struct _aarch64_ctx), 16)
+#define EXTRA_CONTEXT_SIZE round_up(sizeof(struct extra_context), 16)
+
 /*
  * Holds any EL0-controlled state that influences unprivileged memory accesses.
  * This includes both accesses done in userspace and uaccess done in the kernel.
@@ -74,13 +77,35 @@ struct rt_sigframe_user_layout {
  * This state needs to be carefully managed to ensure that it doesn't cause
  * uaccess to fail when setting up the signal frame, and the signal handler
  * itself also expects a well-defined state when entered.
+ *
+ * The struct should be zero-initialised. Its members should only be accessed
+ * via the accessors below. __valid_fields tracks which of the fields are valid
+ * (have been set to some value).
  */
 struct user_access_state {
-	u64 por_el0;
+	unsigned int __valid_fields;
+	u64 __por_el0;
 };
 
-#define TERMINATOR_SIZE round_up(sizeof(struct _aarch64_ctx), 16)
-#define EXTRA_CONTEXT_SIZE round_up(sizeof(struct extra_context), 16)
+#define UA_STATE_HAS_POR_EL0	BIT(0)
+
+static void set_ua_state_por_el0(struct user_access_state *ua_state,
+				 u64 por_el0)
+{
+	ua_state->__por_el0 = por_el0;
+	ua_state->__valid_fields |= UA_STATE_HAS_POR_EL0;
+}
+
+static int get_ua_state_por_el0(const struct user_access_state *ua_state,
+				u64 *por_el0)
+{
+	if (ua_state->__valid_fields & UA_STATE_HAS_POR_EL0) {
+		*por_el0 = ua_state->__por_el0;
+		return 0;
+	}
+
+	return -ENOENT;
+}
 
 /*
  * Save the user access state into ua_state and reset it to disable any
@@ -94,7 +119,7 @@ static void save_reset_user_access_state
 		for (int pkey = 0; pkey < arch_max_pkey(); pkey++)
 			por_enable_all |= POR_ELx_PERM_PREP(pkey, POE_RWX);
 
-		ua_state->por_el0 = read_sysreg_s(SYS_POR_EL0);
+		set_ua_state_por_el0(ua_state, read_sysreg_s(SYS_POR_EL0));
 		write_sysreg_s(por_enable_all, SYS_POR_EL0);
 		/*
 		 * No ISB required as we can tolerate spurious Overlay faults -
@@ -122,8 +147,10 @@ static void set_handler_user_access_stat
  */
 static void restore_user_access_state(const struct user_access_state *ua_state)
 {
-	if (system_supports_poe())
-		write_sysreg_s(ua_state->por_el0, SYS_POR_EL0);
+	u64 por_el0;
+
+	if (get_ua_state_por_el0(ua_state, &por_el0) == 0)
+		write_sysreg_s(por_el0, SYS_POR_EL0);
 }
 
 static void init_user_layout(struct rt_sigframe_user_layout *user)
@@ -333,11 +360,16 @@ static int restore_fpmr_context(struct u
 static int preserve_poe_context(struct poe_context __user *ctx,
 				const struct user_access_state *ua_state)
 {
-	int err = 0;
+	int err;
+	u64 por_el0;
+
+	err = get_ua_state_por_el0(ua_state, &por_el0);
+	if (WARN_ON_ONCE(err))
+		return err;
 
 	__put_user_error(POE_MAGIC, &ctx->head.magic, err);
 	__put_user_error(sizeof(*ctx), &ctx->head.size, err);
-	__put_user_error(ua_state->por_el0, &ctx->por_el0, err);
+	__put_user_error(por_el0, &ctx->por_el0, err);
 
 	return err;
 }
@@ -353,7 +385,7 @@ static int restore_poe_context(struct us
 
 	__get_user_error(por_el0, &(user->poe->por_el0), err);
 	if (!err)
-		ua_state->por_el0 = por_el0;
+		set_ua_state_por_el0(ua_state, por_el0);
 
 	return err;
 }
@@ -1095,7 +1127,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;
-	struct user_access_state ua_state;
+	struct user_access_state ua_state = {};
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current->restart_block.fn = do_no_restart_syscall;
@@ -1507,7 +1539,7 @@ static int setup_rt_frame(int usig, stru
 {
 	struct rt_sigframe_user_layout user;
 	struct rt_sigframe __user *frame;
-	struct user_access_state ua_state;
+	struct user_access_state ua_state = {};
 	int err = 0;
 
 	fpsimd_save_and_flush_current_state();



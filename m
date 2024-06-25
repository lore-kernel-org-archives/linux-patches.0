Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B025D148315;
	Tue, 25 Jun 2024 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308111; cv=none; b=jyuKyy4pBcF+t/0FzsQrDnZyinPw3E3/9keWM3P9ySdHgRZbHLupNO/wabhwg3M8prQWqbbAi8o8h+EPUKxeR1Ge7OoPt+5FcBEXptLLUgVEz/fz5sdaUCSp1oNT2zGy17ItMzrlwt1vi/jzBdBh/GeycnFSeUACo62RVTvJjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308111; c=relaxed/simple;
	bh=DrvNknv2MYIq5GLeZoOYnedz46NCdpVeB6fd23Npf04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQgHHBFkKGYoXLF3oF7NoKBD1Wwb+c2bEgDgKYO4Ei7V8/OJiKecRS2PQTWl/2BS096UDJK2il7XuvotahX/rqtSjA3+EjXnurG6VW0L2vcCwI3liq/cUWMtFQtKRo6WKdLgSJHUJ0doKxriXQVC30jtflOjMrvHhH8bvkTPMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EwsMfGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EwsMfGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E6CC32781;
	Tue, 25 Jun 2024 09:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308111;
	bh=DrvNknv2MYIq5GLeZoOYnedz46NCdpVeB6fd23Npf04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EwsMfGfQbRhaKNWhHOYHRZf1MT3ig4hHmaE8OzVZaRRIl5dys/x9/Z0ZL34Gpft7
	 Sa8I0BoVL3iNhB0mTfCNUuLGO1BuhqHQbO0j0UhxZxLYNZVMrHnIiV1DiKO4vbQ5Py
	 wqOS7d4Oq/nXI4TloDFMURdLrTPoRZq3/6hXcZ2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 011/250] ubsan: Avoid i386 UBSAN handler crashes with Clang
Date: Tue, 25 Jun 2024 11:29:29 +0200
Message-ID: <20240625085548.477870447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 2e431b23a13ce4459cf484c8f0b3218c7048b515 ]

When generating Runtime Calls, Clang doesn't respect the -mregparm=3
option used on i386. Hopefully this will be fixed correctly in Clang 19:
https://github.com/llvm/llvm-project/pull/89707
but we need to fix this for earlier Clang versions today. Force the
calling convention to use non-register arguments.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://github.com/KSPP/linux/issues/350
Link: https://lore.kernel.org/r/20240424224026.it.216-kees@kernel.org
Acked-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ubsan.h | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/lib/ubsan.h b/lib/ubsan.h
index 0abbbac8700d1..0982578fbd98f 100644
--- a/lib/ubsan.h
+++ b/lib/ubsan.h
@@ -124,19 +124,32 @@ typedef s64 s_max;
 typedef u64 u_max;
 #endif
 
-void __ubsan_handle_add_overflow(void *data, void *lhs, void *rhs);
-void __ubsan_handle_sub_overflow(void *data, void *lhs, void *rhs);
-void __ubsan_handle_mul_overflow(void *data, void *lhs, void *rhs);
-void __ubsan_handle_negate_overflow(void *_data, void *old_val);
-void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs);
-void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr);
-void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr);
-void __ubsan_handle_out_of_bounds(void *_data, void *index);
-void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
-void __ubsan_handle_builtin_unreachable(void *_data);
-void __ubsan_handle_load_invalid_value(void *_data, void *val);
-void __ubsan_handle_alignment_assumption(void *_data, unsigned long ptr,
-					 unsigned long align,
-					 unsigned long offset);
+/*
+ * When generating Runtime Calls, Clang doesn't respect the -mregparm=3
+ * option used on i386: https://github.com/llvm/llvm-project/issues/89670
+ * Fix this for earlier Clang versions by forcing the calling convention
+ * to use non-register arguments.
+ */
+#if defined(CONFIG_X86_32) && \
+    defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 190000
+# define ubsan_linkage asmlinkage
+#else
+# define ubsan_linkage
+#endif
+
+void ubsan_linkage __ubsan_handle_add_overflow(void *data, void *lhs, void *rhs);
+void ubsan_linkage __ubsan_handle_sub_overflow(void *data, void *lhs, void *rhs);
+void ubsan_linkage __ubsan_handle_mul_overflow(void *data, void *lhs, void *rhs);
+void ubsan_linkage __ubsan_handle_negate_overflow(void *_data, void *old_val);
+void ubsan_linkage __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs);
+void ubsan_linkage __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr);
+void ubsan_linkage __ubsan_handle_type_mismatch_v1(void *_data, void *ptr);
+void ubsan_linkage __ubsan_handle_out_of_bounds(void *_data, void *index);
+void ubsan_linkage __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
+void ubsan_linkage __ubsan_handle_builtin_unreachable(void *_data);
+void ubsan_linkage __ubsan_handle_load_invalid_value(void *_data, void *val);
+void ubsan_linkage __ubsan_handle_alignment_assumption(void *_data, unsigned long ptr,
+						       unsigned long align,
+						       unsigned long offset);
 
 #endif
-- 
2.43.0




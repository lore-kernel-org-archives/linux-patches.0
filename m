Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E64F5221
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 20:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6196C433EF;
	Mon,  9 Jan 2023 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673297367;
	bh=ZCpIfx/6UP52Vxj4R4wUhX+SXLNpHxh2VEnEZXQEJdM=;
	h=From:To:Cc:Subject:Date:From;
	b=tcY6SHNYWtmLB7FfBUj4VIUl8tjXhVpGGlMeqPQf0JkAo0Kz4SNiRNCFi1xgl8muN
	 EC9vmwUiEY2A5JYQEJfBeVvfVpePlc7bSmmSqMsMYNDbTfMwZAhO8oL5saDewrCc40
	 jdIwxVYtEA2W+7RSdmMVl5xfL92AWlbBhVgV7tdaFdt/qcwlJsqLimQCyhh4vnOqga
	 DiE3NfjcmTDjajypQXosYv9zXvkrou0I5DG1DB/ubeYXRTZg4m6fC0io6ompOMzdMe
	 KjymdCJ2KpPz/bolKYNvvTobcxp3L6tUK1JD4rGiGK3EVAeuGfNdg1RMHKTcrBqjkH
	 KCniDREGSE6FQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
Subject: [PATCH] rust: print: avoid evaluating arguments in `pr_*` macros in `unsafe` blocks
Date: Mon,  9 Jan 2023 21:49:12 +0100
Message-Id: <20230109204912.539790-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment it is possible to perform unsafe operations in
the arguments of `pr_*` macros since they are evaluated inside
an `unsafe` block:

    let x = &10u32 as *const u32;
    pr_info!("{}", *x);

In other words, this is a soundness issue.

Fix it so that it requires an explicit `unsafe` block.

Reported-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Reported-by: Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
Link: https://github.com/Rust-for-Linux/linux/issues/479
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/print.rs | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index 29bf9c2e8aee..30103325696d 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -142,17 +142,24 @@ pub fn call_printk_cont(args: fmt::Arguments<'_>) {
 macro_rules! print_macro (
     // The non-continuation cases (most of them, e.g. `INFO`).
     ($format_string:path, false, $($arg:tt)+) => (
-        // SAFETY: This hidden macro should only be called by the documented
-        // printing macros which ensure the format string is one of the fixed
-        // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
-        // by the `module!` proc macro or fixed values defined in a kernel
-        // crate.
-        unsafe {
-            $crate::print::call_printk(
-                &$format_string,
-                crate::__LOG_PREFIX,
-                format_args!($($arg)+),
-            );
+        // To remain sound, `arg`s must be expanded outside the `unsafe` block.
+        // Typically one would use a `let` binding for that; however, `format_args!`
+        // takes borrows on the arguments, but does not extend the scope of temporaries.
+        // Therefore, a `match` expression is used to keep them around, since
+        // the scrutinee is kept until the end of the `match`.
+        match format_args!($($arg)+) {
+            // SAFETY: This hidden macro should only be called by the documented
+            // printing macros which ensure the format string is one of the fixed
+            // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
+            // by the `module!` proc macro or fixed values defined in a kernel
+            // crate.
+            args => unsafe {
+                $crate::print::call_printk(
+                    &$format_string,
+                    crate::__LOG_PREFIX,
+                    args,
+                );
+            }
         }
     );
 

base-commit: b7bfaa761d760e72a969d116517eaa12e404c262
-- 
2.39.0


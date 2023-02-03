Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCD1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0FBC433D2;
	Fri,  3 Feb 2023 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419761;
	bh=u5Lh3XxPp/bEQRYtiA+eQoiY+oLFhqf3dNatHenyPYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP9gIwfOu7hlaA9OOpQXa5aRlOoydfyY5yE5nguctCyYAeeTzeh48W5CQhCzpg0Ev
	 TeVeos8PpXSaHsWe7LSQoa6/IW3lKEeDGITVZ8TmVcBckJ7ZjF7LOW7vMj3Ox7yWMl
	 2gOHyhKo1uIFfDAHspeUuEAndoOKATJhMXO27hdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH 6.1 27/28] rust: print: avoid evaluating arguments in `pr_*` macros in `unsafe` blocks
Date: Fri,  3 Feb 2023 11:13:15 +0100
Message-Id: <20230203101011.104115185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miguel Ojeda <ojeda@kernel.org>

commit 6618d69aa129a8fc613e64775d5019524c6f231b upstream.

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
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/print.rs |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -115,17 +115,24 @@ pub unsafe fn call_printk(
 macro_rules! print_macro (
     // The non-continuation cases (most of them, e.g. `INFO`).
     ($format_string:path, $($arg:tt)+) => (
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
 );



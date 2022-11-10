Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA28107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B550C433B5;
	Thu, 10 Nov 2022 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098610;
	bh=uX6/pkir0Xey7grEQ8c5/5PlojfkXX4KXlDb5cWi7gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMjyLtNaHUBK7dWmm62B3GEJtoez4W1kGeKCONcxIW4KI1Fr5ul0oNhPPT6QyLkMt
	 /N9DSfUgnyLEUE9TVJhm3z9qxsqOsIV+V0lETiUplg/oOLpOPCNy5cnnOHUcL8PLda
	 Glu2x4PrtYoVx5/I7L/0gZMPnzUA9oxVQngc0MRZYRYj8MaSDc6arELfBB64goFDYn
	 KLFOd38XtLy1qaNTLx7SgwHd2usIS+uq8A/t/3yN/3DF1AKPSAnBdnJ6O5/FU8ez9m
	 dAT++p5ProfJfhhISfzrkrr+B7im6pUHOogZnyxVKX+j8z/I+f2ApU9flmrb2/HPnW
	 A1zfDRLtKAJPg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 24/28] rust: static_assert: add `static_assert!` macro
Date: Thu, 10 Nov 2022 17:41:36 +0100
Message-Id: <20221110164152.26136-25-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the `static_assert!` macro, which is a compile-time assert, similar
to the C11 `_Static_assert` and C++11 `static_assert` declarations [1,2].
Do so in a new module, called `static_assert`.

For instance:

    static_assert!(42 > 24);
    static_assert!(core::mem::size_of::<u8>() == 1);

    const X: &[u8] = b"bar";
    static_assert!(X[1] == b'a');

    const fn f(x: i32) -> i32 {
        x + 2
    }
    static_assert!(f(40) == 42);

Link: https://en.cppreference.com/w/c/language/_Static_assert [1]
Link: https://en.cppreference.com/w/cpp/language/static_assert [2]
Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/lib.rs           |  1 +
 rust/kernel/prelude.rs       |  2 ++
 rust/kernel/static_assert.rs | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)
 create mode 100644 rust/kernel/static_assert.rs

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index d6371c9c8453..9b83ef736298 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -26,6 +26,7 @@ mod allocator;
 pub mod error;
 pub mod prelude;
 pub mod print;
+mod static_assert;
 #[doc(hidden)]
 pub mod std_vendor;
 pub mod str;
diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 345fc9075d1f..178fe8e6cb6d 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -19,6 +19,8 @@ pub use macros::{module, vtable};
 
 pub use super::{dbg, pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr_notice, pr_warn};
 
+pub use super::static_assert;
+
 pub use super::error::{code::*, Error, Result};
 
 pub use super::{str::CStr, ThisModule};
diff --git a/rust/kernel/static_assert.rs b/rust/kernel/static_assert.rs
new file mode 100644
index 000000000000..3115ee0ba8e9
--- /dev/null
+++ b/rust/kernel/static_assert.rs
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Static assert.
+
+/// Static assert (i.e. compile-time assert).
+///
+/// Similar to C11 [`_Static_assert`] and C++11 [`static_assert`].
+///
+/// The feature may be added to Rust in the future: see [RFC 2790].
+///
+/// [`_Static_assert`]: https://en.cppreference.com/w/c/language/_Static_assert
+/// [`static_assert`]: https://en.cppreference.com/w/cpp/language/static_assert
+/// [RFC 2790]: https://github.com/rust-lang/rfcs/issues/2790
+///
+/// # Examples
+///
+/// ```
+/// static_assert!(42 > 24);
+/// static_assert!(core::mem::size_of::<u8>() == 1);
+///
+/// const X: &[u8] = b"bar";
+/// static_assert!(X[1] == b'a');
+///
+/// const fn f(x: i32) -> i32 {
+///     x + 2
+/// }
+/// static_assert!(f(40) == 42);
+/// ```
+#[macro_export]
+macro_rules! static_assert {
+    ($condition:expr) => {
+        const _: () = core::assert!($condition);
+    };
+}
-- 
2.38.1


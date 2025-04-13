Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1551C28E8;
	Sun, 13 Apr 2025 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744505827; cv=none; b=LMcGPaVXzC6MJGTKZlpNPbXhfX+cuN/kdmomdqR+cSTl1KSWTotInUnwShPaTUyiwxZGZCTBA1enETtXB2ryrOKq42Ravc7vg3jKu8dR9YwgnUKK/d1hSVp24kS0qXtJxJOTYsuCo6q2Kf3XXitu8zApmj7QcBpIpTCDr3wCnOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744505827; c=relaxed/simple;
	bh=Tpgfmj/V8vGnWZK4+Qg11gSfka19VHsTtQ0NQMk29lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c8AyHrwQIoC7kDwpK8eKKutwzgJPlU+e0uYPDDRbaltLZt8kfT7sbx6SToqNpIg66Ckm3TT5WyEz1k44b0vL+1nPjaUNDsmbcDG4Fc5exc0uj5x8HhM5D126MVqMUTMXNb3TMP47Yvu4fRMCn0F3dFzs0Sk2ifjNEUfL61nVAGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/hGRiVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/hGRiVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5675C4CEE3;
	Sun, 13 Apr 2025 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744505826;
	bh=Tpgfmj/V8vGnWZK4+Qg11gSfka19VHsTtQ0NQMk29lQ=;
	h=From:To:Cc:Subject:Date:From;
	b=j/hGRiVKoRKlWA0fu9FsReGSxOuyGBXXWVQLO/fGH/WQZ2RXrY3LpPQ8zD2sOgb3Z
	 gqM5Pw6XPACk1wOOI6kmASJAdCtVT6uxPvSFSwPNlUHSenSdUf1UbdL7Bfo9A+aJ6o
	 C6sWcO/lg374SR/J5CMdTy5j/MzgBpRafHh9ySGV3LFHe/SQd9SBjH8+427CxCwuYN
	 giiEcxpGlKbFmSomXBGT9yTwoZYZOQ5AuAWDtYfAhFtAT0bG5916mCGNqDAd0QH+qZ
	 EoebUaTrNwX0F7sHgTQTN4ntNjxEqwXaKgQYCrKFmFHFBuGiSbWSTNONahNeP5S1Cp
	 6Zutjx5zKEUyw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: add C FFI types to the prelude
Date: Sun, 13 Apr 2025 02:56:50 +0200
Message-ID: <20250413005650.1745894-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust kernel code is supposed to use the custom mapping of C FFI types,
i.e. those from the `ffi` crate, rather than the ones coming from `core`.

Thus, to minimize mistakes and to simplify the code everywhere, just
provide them in the `kernel` prelude and ask in the Coding Guidelines
to use them directly, i.e. as a single segment path.

After this lands, we can start cleaning up the existing users.

Ideally, we would use something like Clippy's `disallowed-types` to
prevent the use of the `core` ones, but that one sees through aliases.

Link: https://lore.kernel.org/rust-for-linux/CANiq72kc4gzfieD-FjuWfELRDXXD2vLgPv4wqk3nt4pjdPQ=qg@mail.gmail.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 17 +++++++++++++++++
 rust/kernel/prelude.rs                   |  5 +++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 27f2a7bb5a4a..d0bf0b3a058a 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -191,6 +191,23 @@ or:
 	/// [`struct mutex`]: srctree/include/linux/mutex.h
 
 
+C FFI types
+-----------
+
+Rust kernel code does not use the C FFI types (such as ``c_char``) from
+``core::ffi::*``. Instead, a custom mapping that matches properly the C types
+used in the kernel is provided in the prelude, i.e. ``kernel::prelude::*``.
+
+These types (aliases) should generally be referred directly by their identifier,
+i.e. as a single segment path. For instance:
+
+.. code-block:: rust
+
+	fn f(p: *const c_char) -> c_int {
+	    // ...
+	}
+
+
 Naming
 ------
 
diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index baa774a351ce..f869b02f1f25 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -14,6 +14,11 @@
 #[doc(no_inline)]
 pub use core::pin::Pin;
 
+pub use ::ffi::{
+    c_char, c_int, c_long, c_longlong, c_schar, c_short, c_uchar, c_uint, c_ulong, c_ulonglong,
+    c_ushort, c_void,
+};
+
 pub use crate::alloc::{flags::*, Box, KBox, KVBox, KVVec, KVec, VBox, VVec, Vec};
 
 #[doc(no_inline)]

base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
-- 
2.49.0


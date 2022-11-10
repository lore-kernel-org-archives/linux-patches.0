Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB96107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362CAC433D6;
	Thu, 10 Nov 2022 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098595;
	bh=bTwV3nkr6jPDZcA7hO2dJXGMLx9sZQV043G74OSH4H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CadoW2qBa6bNQMyp1nnAz/fKRxL9PT6Cjyz4lVonGscW0FXbELPIh151r/bpTZLX0
	 RNBGpEae5EeDzpOjPC/lFxm/X6VPej6rwjFjK/TaJOCaNEXZ0jFlLbaFPm9LxgnORm
	 uK6QlIAdByyC1uohiB+V3QQ/ch52eA5RRBBq4PHpLLDPVcrDgDVBcwBaod1F2V71v8
	 b7i8y6F1+iKuiSPcH9IjuBo3kRwpV4TJEVJYuWJ/T9fQNrk4BEQPnomVI4rHV7K/k+
	 sC16wilA/IOLzQ6c7yZUqcRsX5a1u2QcVF/sjIQuDByyUbd8CgZ8SFCbo5L9Hf53wh
	 CYzN6evp+pGOA==
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
Subject: [PATCH v1 19/28] rust: str: add `c_str!` macro
Date: Thu, 10 Nov 2022 17:41:31 +0100
Message-Id: <20221110164152.26136-20-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Guo <gary@garyguo.net>

Add `c_str!`, which is a convenience macro that creates a new `CStr`
from a string literal.

It is designed to be similar to a `str` in usage, and it is usable
in const contexts, for instance:

    const X: &CStr = c_str!("Example");

Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 3ed685cb5a3c..3fb73b888dce 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -128,6 +128,18 @@ impl CStr {
         Ok(unsafe { Self::from_bytes_with_nul_unchecked(bytes) })
     }
 
+    /// Creates a [`CStr`] from a `[u8]`, panic if input is not valid.
+    ///
+    /// This function is only meant to be used by `c_str!` macro, so
+    /// crates using `c_str!` macro don't have to enable `const_panic` feature.
+    #[doc(hidden)]
+    pub const fn from_bytes_with_nul_unwrap(bytes: &[u8]) -> &Self {
+        match Self::from_bytes_with_nul(bytes) {
+            Ok(v) => v,
+            Err(_) => panic!("string contains interior NUL"),
+        }
+    }
+
     /// Creates a [`CStr`] from a `[u8]` without performing any additional
     /// checks.
     ///
@@ -321,6 +333,26 @@ where
     }
 }
 
+/// Creates a new [`CStr`] from a string literal.
+///
+/// The string literal should not contain any `NUL` bytes.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::c_str;
+/// # use kernel::str::CStr;
+/// const MY_CSTR: &CStr = c_str!("My awesome CStr!");
+/// ```
+#[macro_export]
+macro_rules! c_str {
+    ($str:expr) => {{
+        const S: &str = concat!($str, "\0");
+        const C: &$crate::str::CStr = $crate::str::CStr::from_bytes_with_nul_unwrap(S.as_bytes());
+        C
+    }};
+}
+
 #[cfg(test)]
 mod tests {
     use super::*;
-- 
2.38.1


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D18195;
	Sat, 23 Nov 2024 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732385220; cv=none; b=IZF9tWbzR7rZPBf9HiE7X5JGIbtqqKwYTBvkBWNLjZ/EOzOPjVu+Hw2/UtaW4EPfn8BviyVbxkmgF4XL6LhcHoKTji7ULL3KFI7pLLCaZ/u6MvJXDscIyLtT4yEJ41lKKDb3vTtH8nWmv+jMj/sEBf2F+HlZx3yXAbawSoImJc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732385220; c=relaxed/simple;
	bh=G8ni3nF+CHFJWJNVuFNWYcaPAgXx4khmiv9r6zEGe88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bOqOAzXqsB/nkD/3cBZRr02/DjofvypeBnv5hfCZlfRqv4k9piDvm1BN3lUd0e2RBqoVvpV/iQKoKOFL3Iy4uIWcR4fIYqTLUkI7XV0mFCb9arRJo14HOv3nlSg7JXP6RbFHD1dWs6PIPagYLGqS9hofEc7tn0AHXQejcKTZtFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyVONdpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyVONdpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51828C4CECD;
	Sat, 23 Nov 2024 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732385220;
	bh=G8ni3nF+CHFJWJNVuFNWYcaPAgXx4khmiv9r6zEGe88=;
	h=From:To:Cc:Subject:Date:From;
	b=eyVONdpWkApbwCT24KyJkQLD6xlCFJNnSDY9nGrfXDz/mUANd4VyGAiaK172CKNno
	 n/b/5rzAcy6QnWTPjjZaYEu/Pd9ORrXSIclv9ooJ8sPLDHUHlWLu1zNxpg0Ob1vbLZ
	 0KrlDOgbmCihdE7PaP5wVf4i6XkVzF+ns9jPbV/dUr4/Xc3M/THyeDjUZSLq0JGJmq
	 STHLerOMZVTve2SYu8WRRFg/LJ+i1CQLIeQGnXXc0RYB/pyE7t1WqgTI+c/5ryxjgI
	 Mc5EG4zJ3s+6ZFlHunXK86M8ctSCVqC1Hh/HCI9K2u59R33NmkG2Ybto2yVwQ5euJ3
	 em0LGNRjwfQHQ==
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
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: kbuild: run Clippy for `rusttest` code
Date: Sat, 23 Nov 2024 19:06:38 +0100
Message-ID: <20241123180639.260191-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Running Clippy for `rusttest` code is useful to catch issues there too,
even if the code is not as critical. In the future, this code may also
run in kernelspace and could be copy-pasted. Thus it is useful to keep
it under the same standards. For instance, it will now make us add
`// SAFETY` comments.

It also makes everything more consistent.

Thus clean the few issues spotted by Clippy and start running it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile      | 8 ++++----
 rust/kernel/str.rs | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index f349e7b067ea..5b257b814d38 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -114,10 +114,10 @@ rustdoc-kernel: $(src)/kernel/lib.rs rustdoc-core rustdoc-ffi rustdoc-macros \
     $(obj)/bindings.o FORCE
 	+$(call if_changed,rustdoc)
 
-quiet_cmd_rustc_test_library = RUSTC TL $<
+quiet_cmd_rustc_test_library = $(RUSTC_OR_CLIPPY_QUIET) TL $<
       cmd_rustc_test_library = \
 	OBJTREE=$(abspath $(objtree)) \
-	$(RUSTC) $(rust_common_flags) \
+	$(RUSTC_OR_CLIPPY) $(rust_common_flags) \
 		@$(objtree)/include/generated/rustc_cfg $(rustc_target_flags) \
 		--crate-type $(if $(rustc_test_library_proc),proc-macro,rlib) \
 		--out-dir $(objtree)/$(obj)/test --cfg testlib \
@@ -185,10 +185,10 @@ quiet_cmd_rustdoc_test_kernel = RUSTDOC TK $<
 
 # We cannot use `-Zpanic-abort-tests` because some tests are dynamic,
 # so for the moment we skip `-Cpanic=abort`.
-quiet_cmd_rustc_test = RUSTC T  $<
+quiet_cmd_rustc_test = $(RUSTC_OR_CLIPPY_QUIET) T  $<
       cmd_rustc_test = \
 	OBJTREE=$(abspath $(objtree)) \
-	$(RUSTC) --test $(rust_common_flags) \
+	$(RUSTC_OR_CLIPPY) --test $(rust_common_flags) \
 		@$(objtree)/include/generated/rustc_cfg \
 		$(rustc_target_flags) --out-dir $(objtree)/$(obj)/test \
 		-L$(objtree)/$(obj)/test \
diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index d04c12a1426d..f98966ba4991 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -522,6 +522,7 @@ macro_rules! c_str {
 }
 
 #[cfg(test)]
+#[expect(clippy::items_after_test_module)]
 mod tests {
     use super::*;
 
@@ -547,7 +548,7 @@ macro_rules! format {
         })
     }
 
-    const ALL_ASCII_CHARS: &'static str =
+    const ALL_ASCII_CHARS: &str =
         "\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\x09\\x0a\\x0b\\x0c\\x0d\\x0e\\x0f\
         \\x10\\x11\\x12\\x13\\x14\\x15\\x16\\x17\\x18\\x19\\x1a\\x1b\\x1c\\x1d\\x1e\\x1f \
         !\"#$%&'()*+,-./0123456789:;<=>?@\
@@ -581,6 +582,7 @@ fn test_cstr_to_str_panic() {
     fn test_cstr_as_str_unchecked() {
         let good_bytes = b"\xf0\x9f\x90\xA7\0";
         let checked_cstr = CStr::from_bytes_with_nul(good_bytes).unwrap();
+        // SAFETY: The contents come from a string literal which contains valid UTF-8.
         let unchecked_str = unsafe { checked_cstr.as_str_unchecked() };
         assert_eq!(unchecked_str, "🐧");
     }

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
-- 
2.47.0


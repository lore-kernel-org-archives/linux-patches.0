Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BDB257427;
	Fri,  2 May 2025 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194600; cv=none; b=jS1xOEQf0D48x965SzuCnbu4uRMmR1utrveKlbkJvzScGWKwFYAzNRXRUgQuek8pjnggTOwkRzuPuZ9/GGQNb1ZcF4ySZYu8yOLP++wtCtFj7Bb/Ph21Evk+TKCxBdOrs0MT0vTEE5aRR1IlM+huAOOHepaB7JK/Rrtc3YLJtTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194600; c=relaxed/simple;
	bh=5hjxujVq9UNEKFrCpRJWHAmcCo5XnfoXNdbzgUPep2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGCqqbfzpt9K5aUFbWri7o9nIbWSv5foQIvmyUoE7lTe7qpM08D2hnikroFoEunWEO1ljrMsZ+6MCd5BytICZO2YBCfzNoSkUvWlVwdQIYJwFx4VMpu9dKOqOl050MdoAkhcp5XEI5zQypfjZGvRxhbOu5EGlWwzDIMbKzdf21I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhmTD0+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhmTD0+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FAEC4CEE4;
	Fri,  2 May 2025 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746194600;
	bh=5hjxujVq9UNEKFrCpRJWHAmcCo5XnfoXNdbzgUPep2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhmTD0+3p83k5lNd4vW8hDNYkrRd4BRw1MxgihTtFzyY3ubnGf2J3Jdmogppkx3qn
	 Z29LHUwlRRR1Er6x8oocBDW20TcQE0fbYKnPfDVXnefw1vS5ncBxkbFcJreyfKwEtj
	 IzI9orUg/KTKAZ6s7Hx9QcisDJ2hd/irnq97yzU+SKPZpsJ2a6Q8IPluwweOI/7ymn
	 WsDAsqa3/OBdfgQMZx3+SvTXIYCiYPVhzacEWd3aNEPxxLFBkCSi7bjRIKVwFJhrRH
	 Kt8YfJZ1EREKj8GXe+TYwD6oQdaVCg1soItmNm8cG2QWhQjkvsuC5RlwgdUh0P6ItN
	 l1Gtc/P7E29Eg==
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
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH 5/5] rust: clean Rust 1.88.0's `clippy::uninlined_format_args` lint
Date: Fri,  2 May 2025 16:02:37 +0200
Message-ID: <20250502140237.1659624-6-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
References: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.88.0 (expected 2025-06-26) [1], `rustc` may move
back the `uninlined_format_args` to `style` from `pedantic` (it was
there waiting for rust-analyzer suppotr), and thus we will start to see
lints like:

    warning: variables can be used directly in the `format!` string
       --> rust/macros/kunit.rs:105:37
        |
    105 |         let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{}", test);
        |                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#uninlined_format_args
    help: change this to
        |
    105 -         let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{}", test);
    105 +         let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{test}");

There is even a case that is a pure removal:

    warning: variables can be used directly in the `format!` string
      --> rust/macros/module.rs:51:13
       |
    51 |             format!("{field}={content}\0", field = field, content = content)
       |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#uninlined_format_args
    help: change this to
       |
    51 -             format!("{field}={content}\0", field = field, content = content)
    51 +             format!("{field}={content}\0")

The lints all seem like nice cleanups, thus just apply them.

We may want to disable `allow-mixed-uninlined-format-args` in the future.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Benno Lossin <benno.lossin@proton.me>
Link: https://github.com/rust-lang/rust-clippy/pull/14160 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/nova-core/gpu.rs              |  2 +-
 rust/kernel/str.rs                        | 46 +++++++++++------------
 rust/macros/kunit.rs                      | 13 ++-----
 rust/macros/module.rs                     | 19 +++-------
 rust/macros/paste.rs                      |  2 +-
 rust/pin-init/internal/src/pinned_drop.rs |  3 +-
 6 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/nova-core/gpu.rs b/drivers/gpu/nova-core/gpu.rs
index 17c9660da450..ab0e5a72a059 100644
--- a/drivers/gpu/nova-core/gpu.rs
+++ b/drivers/gpu/nova-core/gpu.rs
@@ -93,7 +93,7 @@ pub(crate) fn arch(&self) -> Architecture {
 // For now, redirect to fmt::Debug for convenience.
 impl fmt::Display for Chipset {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
-        write!(f, "{:?}", self)
+        write!(f, "{self:?}")
     }
 }

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 878111cb77bc..fb61ce81ea28 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -73,7 +73,7 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
                 b'\r' => f.write_str("\\r")?,
                 // Printable characters.
                 0x20..=0x7e => f.write_char(b as char)?,
-                _ => write!(f, "\\x{:02x}", b)?,
+                _ => write!(f, "\\x{b:02x}")?,
             }
         }
         Ok(())
@@ -109,7 +109,7 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
                 b'\\' => f.write_str("\\\\")?,
                 // Printable characters.
                 0x20..=0x7e => f.write_char(b as char)?,
-                _ => write!(f, "\\x{:02x}", b)?,
+                _ => write!(f, "\\x{b:02x}")?,
             }
         }
         f.write_char('"')
@@ -447,7 +447,7 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
                 // Printable character.
                 f.write_char(c as char)?;
             } else {
-                write!(f, "\\x{:02x}", c)?;
+                write!(f, "\\x{c:02x}")?;
             }
         }
         Ok(())
@@ -479,7 +479,7 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
                 // Printable characters.
                 b'\"' => f.write_str("\\\"")?,
                 0x20..=0x7e => f.write_char(c as char)?,
-                _ => write!(f, "\\x{:02x}", c)?,
+                _ => write!(f, "\\x{c:02x}")?,
             }
         }
         f.write_str("\"")
@@ -641,13 +641,13 @@ fn test_cstr_as_str_unchecked() {
     #[test]
     fn test_cstr_display() {
         let hello_world = CStr::from_bytes_with_nul(b"hello, world!\0").unwrap();
-        assert_eq!(format!("{}", hello_world), "hello, world!");
+        assert_eq!(format!("{hello_world}"), "hello, world!");
         let non_printables = CStr::from_bytes_with_nul(b"\x01\x09\x0a\0").unwrap();
-        assert_eq!(format!("{}", non_printables), "\\x01\\x09\\x0a");
+        assert_eq!(format!("{non_printables}"), "\\x01\\x09\\x0a");
         let non_ascii = CStr::from_bytes_with_nul(b"d\xe9j\xe0 vu\0").unwrap();
-        assert_eq!(format!("{}", non_ascii), "d\\xe9j\\xe0 vu");
+        assert_eq!(format!("{non_ascii}"), "d\\xe9j\\xe0 vu");
         let good_bytes = CStr::from_bytes_with_nul(b"\xf0\x9f\xa6\x80\0").unwrap();
-        assert_eq!(format!("{}", good_bytes), "\\xf0\\x9f\\xa6\\x80");
+        assert_eq!(format!("{good_bytes}"), "\\xf0\\x9f\\xa6\\x80");
     }

     #[test]
@@ -658,47 +658,47 @@ fn test_cstr_display_all_bytes() {
             bytes[i as usize] = i.wrapping_add(1);
         }
         let cstr = CStr::from_bytes_with_nul(&bytes).unwrap();
-        assert_eq!(format!("{}", cstr), ALL_ASCII_CHARS);
+        assert_eq!(format!("{cstr}"), ALL_ASCII_CHARS);
     }

     #[test]
     fn test_cstr_debug() {
         let hello_world = CStr::from_bytes_with_nul(b"hello, world!\0").unwrap();
-        assert_eq!(format!("{:?}", hello_world), "\"hello, world!\"");
+        assert_eq!(format!("{hello_world:?}"), "\"hello, world!\"");
         let non_printables = CStr::from_bytes_with_nul(b"\x01\x09\x0a\0").unwrap();
-        assert_eq!(format!("{:?}", non_printables), "\"\\x01\\x09\\x0a\"");
+        assert_eq!(format!("{non_printables:?}"), "\"\\x01\\x09\\x0a\"");
         let non_ascii = CStr::from_bytes_with_nul(b"d\xe9j\xe0 vu\0").unwrap();
-        assert_eq!(format!("{:?}", non_ascii), "\"d\\xe9j\\xe0 vu\"");
+        assert_eq!(format!("{non_ascii:?}"), "\"d\\xe9j\\xe0 vu\"");
         let good_bytes = CStr::from_bytes_with_nul(b"\xf0\x9f\xa6\x80\0").unwrap();
-        assert_eq!(format!("{:?}", good_bytes), "\"\\xf0\\x9f\\xa6\\x80\"");
+        assert_eq!(format!("{good_bytes:?}"), "\"\\xf0\\x9f\\xa6\\x80\"");
     }

     #[test]
     fn test_bstr_display() {
         let hello_world = BStr::from_bytes(b"hello, world!");
-        assert_eq!(format!("{}", hello_world), "hello, world!");
+        assert_eq!(format!("{hello_world}"), "hello, world!");
         let escapes = BStr::from_bytes(b"_\t_\n_\r_\\_\'_\"_");
-        assert_eq!(format!("{}", escapes), "_\\t_\\n_\\r_\\_'_\"_");
+        assert_eq!(format!("{escapes}"), "_\\t_\\n_\\r_\\_'_\"_");
         let others = BStr::from_bytes(b"\x01");
-        assert_eq!(format!("{}", others), "\\x01");
+        assert_eq!(format!("{others}"), "\\x01");
         let non_ascii = BStr::from_bytes(b"d\xe9j\xe0 vu");
-        assert_eq!(format!("{}", non_ascii), "d\\xe9j\\xe0 vu");
+        assert_eq!(format!("{non_ascii}"), "d\\xe9j\\xe0 vu");
         let good_bytes = BStr::from_bytes(b"\xf0\x9f\xa6\x80");
-        assert_eq!(format!("{}", good_bytes), "\\xf0\\x9f\\xa6\\x80");
+        assert_eq!(format!("{good_bytes}"), "\\xf0\\x9f\\xa6\\x80");
     }

     #[test]
     fn test_bstr_debug() {
         let hello_world = BStr::from_bytes(b"hello, world!");
-        assert_eq!(format!("{:?}", hello_world), "\"hello, world!\"");
+        assert_eq!(format!("{hello_world:?}"), "\"hello, world!\"");
         let escapes = BStr::from_bytes(b"_\t_\n_\r_\\_\'_\"_");
-        assert_eq!(format!("{:?}", escapes), "\"_\\t_\\n_\\r_\\\\_'_\\\"_\"");
+        assert_eq!(format!("{escapes:?}"), "\"_\\t_\\n_\\r_\\\\_'_\\\"_\"");
         let others = BStr::from_bytes(b"\x01");
-        assert_eq!(format!("{:?}", others), "\"\\x01\"");
+        assert_eq!(format!("{others:?}"), "\"\\x01\"");
         let non_ascii = BStr::from_bytes(b"d\xe9j\xe0 vu");
-        assert_eq!(format!("{:?}", non_ascii), "\"d\\xe9j\\xe0 vu\"");
+        assert_eq!(format!("{non_ascii:?}"), "\"d\\xe9j\\xe0 vu\"");
         let good_bytes = BStr::from_bytes(b"\xf0\x9f\xa6\x80");
-        assert_eq!(format!("{:?}", good_bytes), "\"\\xf0\\x9f\\xa6\\x80\"");
+        assert_eq!(format!("{good_bytes:?}"), "\"\\xf0\\x9f\\xa6\\x80\"");
     }
 }

diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
index 4f553ecf40c0..99ccac82edde 100644
--- a/rust/macros/kunit.rs
+++ b/rust/macros/kunit.rs
@@ -15,10 +15,7 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
     }

     if attr.len() > 255 {
-        panic!(
-            "The test suite name `{}` exceeds the maximum length of 255 bytes",
-            attr
-        )
+        panic!("The test suite name `{attr}` exceeds the maximum length of 255 bytes")
     }

     let mut tokens: Vec<_> = ts.into_iter().collect();
@@ -102,16 +99,14 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
     let mut kunit_macros = "".to_owned();
     let mut test_cases = "".to_owned();
     for test in &tests {
-        let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{}", test);
+        let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{test}");
         let kunit_wrapper = format!(
-            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kunit) {{ {}(); }}",
-            kunit_wrapper_fn_name, test
+            "unsafe extern \"C\" fn {kunit_wrapper_fn_name}(_test: *mut kernel::bindings::kunit) {{ {test}(); }}"
         );
         writeln!(kunit_macros, "{kunit_wrapper}").unwrap();
         writeln!(
             test_cases,
-            "    kernel::kunit::kunit_case(kernel::c_str!(\"{}\"), {}),",
-            test, kunit_wrapper_fn_name
+            "    kernel::kunit::kunit_case(kernel::c_str!(\"{test}\"), {kunit_wrapper_fn_name}),"
         )
         .unwrap();
     }
diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index a9418fbc9b44..2f66107847f7 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -48,7 +48,7 @@ fn emit_base(&mut self, field: &str, content: &str, builtin: bool) {
             )
         } else {
             // Loadable modules' modinfo strings go as-is.
-            format!("{field}={content}\0", field = field, content = content)
+            format!("{field}={content}\0")
         };

         write!(
@@ -126,10 +126,7 @@ fn parse(it: &mut token_stream::IntoIter) -> Self {
             };

             if seen_keys.contains(&key) {
-                panic!(
-                    "Duplicated key \"{}\". Keys can only be specified once.",
-                    key
-                );
+                panic!("Duplicated key \"{key}\". Keys can only be specified once.");
             }

             assert_eq!(expect_punct(it), ':');
@@ -143,10 +140,7 @@ fn parse(it: &mut token_stream::IntoIter) -> Self {
                 "license" => info.license = expect_string_ascii(it),
                 "alias" => info.alias = Some(expect_string_array(it)),
                 "firmware" => info.firmware = Some(expect_string_array(it)),
-                _ => panic!(
-                    "Unknown key \"{}\". Valid keys are: {:?}.",
-                    key, EXPECTED_KEYS
-                ),
+                _ => panic!("Unknown key \"{key}\". Valid keys are: {EXPECTED_KEYS:?}."),
             }

             assert_eq!(expect_punct(it), ',');
@@ -158,7 +152,7 @@ fn parse(it: &mut token_stream::IntoIter) -> Self {

         for key in REQUIRED_KEYS {
             if !seen_keys.iter().any(|e| e == key) {
-                panic!("Missing required key \"{}\".", key);
+                panic!("Missing required key \"{key}\".");
             }
         }

@@ -170,10 +164,7 @@ fn parse(it: &mut token_stream::IntoIter) -> Self {
         }

         if seen_keys != ordered_keys {
-            panic!(
-                "Keys are not ordered as expected. Order them like: {:?}.",
-                ordered_keys
-            );
+            panic!("Keys are not ordered as expected. Order them like: {ordered_keys:?}.");
         }

         info
diff --git a/rust/macros/paste.rs b/rust/macros/paste.rs
index 6529a387673f..cce712d19855 100644
--- a/rust/macros/paste.rs
+++ b/rust/macros/paste.rs
@@ -50,7 +50,7 @@ fn concat_helper(tokens: &[TokenTree]) -> Vec<(String, Span)> {
                 let tokens = group.stream().into_iter().collect::<Vec<TokenTree>>();
                 segments.append(&mut concat_helper(tokens.as_slice()));
             }
-            token => panic!("unexpected token in paste segments: {:?}", token),
+            token => panic!("unexpected token in paste segments: {token:?}"),
         };
     }

diff --git a/rust/pin-init/internal/src/pinned_drop.rs b/rust/pin-init/internal/src/pinned_drop.rs
index c824dd8b436d..c4ca7a70b726 100644
--- a/rust/pin-init/internal/src/pinned_drop.rs
+++ b/rust/pin-init/internal/src/pinned_drop.rs
@@ -28,8 +28,7 @@ pub(crate) fn pinned_drop(_args: TokenStream, input: TokenStream) -> TokenStream
             // Found the end of the generics, this should be `PinnedDrop`.
             assert!(
                 matches!(tt, TokenTree::Ident(i) if i.to_string() == "PinnedDrop"),
-                "expected 'PinnedDrop', found: '{:?}'",
-                tt
+                "expected 'PinnedDrop', found: '{tt:?}'"
             );
             pinned_drop_idx = Some(i);
             break;
--
2.49.0

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C912D1A08CA;
	Mon, 12 May 2025 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072222; cv=none; b=dqgyuGFX0kAEPwcl02xGufgL7WcW3yI4J0PIeycBFbSZcbIkKilAHN9r/1ARfuJ4a7uTf1kv77Euiem8Sju7vAVIlqEiejaZpwm/KnFTwlmK1qir7Lg/bTxHYiUUjROGfECEOgJYu4FjT5vjdJSd9tVG+ZRmvaX7RXJ1HVxCQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072222; c=relaxed/simple;
	bh=ExJFhDIEnE7+bsOAg19nVk+GKDQ3QXDGW6ruwQTwHK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKMROiw3Tx4umc4Kg/ZAUx0MMre3qM+vUFaHbE29qNGoQ/1U+FQFuo+DNdDkN5zZ7Q5kJI8l3/7XgZc+iIQNB/hANefCHp3vlGMlqZ4+o7RKCuRXgHE8yf2MbueMalp7/H+tZyeUyM0gVNS9K6MvMjmZM3Ow7jJhcggEAeCZY8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y33Gku/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y33Gku/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438D5C4CEE7;
	Mon, 12 May 2025 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072222;
	bh=ExJFhDIEnE7+bsOAg19nVk+GKDQ3QXDGW6ruwQTwHK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y33Gku/c3cMCJRZcveSTUN7ndWD9Iml+xy4Vo/2+d098+Na3SbLVhqI4mlUSTv7xD
	 LLdQJBZ+efOvn85UioqUl62KliPZLB1xcrAHO50lo8Fwk9vNJK5ZyjSg10suCrc2Aj
	 AwKQnQj298ch3IsFJyaF6ngm1WduRItDlb5l3y84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 173/197] rust: clean Rust 1.88.0s `clippy::uninlined_format_args` lint
Date: Mon, 12 May 2025 19:40:23 +0200
Message-ID: <20250512172051.430853028@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 211dcf77856db64c73e0c3b9ce0c624ec855daca upstream.

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
Link: https://github.com/rust-lang/rust-clippy/pull/14160 [1]
Acked-by: Benno Lossin <lossin@kernel.org>
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250502140237.1659624-6-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/str.rs         |   46 ++++++++++++++++++++++-----------------------
 rust/macros/module.rs      |   19 ++++--------------
 rust/macros/paste.rs       |    2 -
 rust/macros/pinned_drop.rs |    3 --
 4 files changed, 30 insertions(+), 40 deletions(-)

--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -56,7 +56,7 @@ impl fmt::Display for BStr {
                 b'\r' => f.write_str("\\r")?,
                 // Printable characters.
                 0x20..=0x7e => f.write_char(b as char)?,
-                _ => write!(f, "\\x{:02x}", b)?,
+                _ => write!(f, "\\x{b:02x}")?,
             }
         }
         Ok(())
@@ -92,7 +92,7 @@ impl fmt::Debug for BStr {
                 b'\\' => f.write_str("\\\\")?,
                 // Printable characters.
                 0x20..=0x7e => f.write_char(b as char)?,
-                _ => write!(f, "\\x{:02x}", b)?,
+                _ => write!(f, "\\x{b:02x}")?,
             }
         }
         f.write_char('"')
@@ -401,7 +401,7 @@ impl fmt::Display for CStr {
                 // Printable character.
                 f.write_char(c as char)?;
             } else {
-                write!(f, "\\x{:02x}", c)?;
+                write!(f, "\\x{c:02x}")?;
             }
         }
         Ok(())
@@ -433,7 +433,7 @@ impl fmt::Debug for CStr {
                 // Printable characters.
                 b'\"' => f.write_str("\\\"")?,
                 0x20..=0x7e => f.write_char(c as char)?,
-                _ => write!(f, "\\x{:02x}", c)?,
+                _ => write!(f, "\\x{c:02x}")?,
             }
         }
         f.write_str("\"")
@@ -595,13 +595,13 @@ mod tests {
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
@@ -612,47 +612,47 @@ mod tests {
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
 
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -48,7 +48,7 @@ impl<'a> ModInfoBuilder<'a> {
             )
         } else {
             // Loadable modules' modinfo strings go as-is.
-            format!("{field}={content}\0", field = field, content = content)
+            format!("{field}={content}\0")
         };
 
         write!(
@@ -124,10 +124,7 @@ impl ModuleInfo {
             };
 
             if seen_keys.contains(&key) {
-                panic!(
-                    "Duplicated key \"{}\". Keys can only be specified once.",
-                    key
-                );
+                panic!("Duplicated key \"{key}\". Keys can only be specified once.");
             }
 
             assert_eq!(expect_punct(it), ':');
@@ -140,10 +137,7 @@ impl ModuleInfo {
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
@@ -155,7 +149,7 @@ impl ModuleInfo {
 
         for key in REQUIRED_KEYS {
             if !seen_keys.iter().any(|e| e == key) {
-                panic!("Missing required key \"{}\".", key);
+                panic!("Missing required key \"{key}\".");
             }
         }
 
@@ -167,10 +161,7 @@ impl ModuleInfo {
         }
 
         if seen_keys != ordered_keys {
-            panic!(
-                "Keys are not ordered as expected. Order them like: {:?}.",
-                ordered_keys
-            );
+            panic!("Keys are not ordered as expected. Order them like: {ordered_keys:?}.");
         }
 
         info
--- a/rust/macros/paste.rs
+++ b/rust/macros/paste.rs
@@ -50,7 +50,7 @@ fn concat_helper(tokens: &[TokenTree]) -
                 let tokens = group.stream().into_iter().collect::<Vec<TokenTree>>();
                 segments.append(&mut concat_helper(tokens.as_slice()));
             }
-            token => panic!("unexpected token in paste segments: {:?}", token),
+            token => panic!("unexpected token in paste segments: {token:?}"),
         };
     }
 
--- a/rust/macros/pinned_drop.rs
+++ b/rust/macros/pinned_drop.rs
@@ -25,8 +25,7 @@ pub(crate) fn pinned_drop(_args: TokenSt
             // Found the end of the generics, this should be `PinnedDrop`.
             assert!(
                 matches!(tt, TokenTree::Ident(i) if i.to_string() == "PinnedDrop"),
-                "expected 'PinnedDrop', found: '{:?}'",
-                tt
+                "expected 'PinnedDrop', found: '{tt:?}'"
             );
             pinned_drop_idx = Some(i);
             break;



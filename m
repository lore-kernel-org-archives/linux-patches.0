Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB790264A92;
	Tue, 11 Nov 2025 01:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822863; cv=none; b=ZOyWi4A69j8mTet49VBf5IZXP/kt8fh3EKXqXnWC21cd4fM1ZlXBdRThYpqF4HZKZrO9FGCG+lERdY5x34VftEd+0M84LRLsJaIQ0kNDfZK0DxRVkfO8t6MT5+5mQEGe6TFwWc5ghlcmhjUM3F9/3Acq9+4oZ4L+dDZ4MIWEUkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822863; c=relaxed/simple;
	bh=fQyXnQmEovGhN4SVnqIExtbcXAgMQtZXMnlNrp+mtNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wy/6pQDtz9Zp4ak36kyD9FyltToufFWIyPj+Hau/SZvpIMzk0dJjpwy+pwJSi5ItcSQ8FxLbLN1YzdanTrdiEqrrDFaaMHawOc8mnX/yzPi5du5HEHQ6523K7ESvo1bPbBo1bx8fTb91Reg0jeX92hpfJ2YCAa6xeZF8hzDeXEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRzX39ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRzX39ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC7C116B1;
	Tue, 11 Nov 2025 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822862;
	bh=fQyXnQmEovGhN4SVnqIExtbcXAgMQtZXMnlNrp+mtNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRzX39ekMBMiXmDJ6VxmWkrBLNcekWbNirrwpU/FILo81FoJTmW4alnBDtzlutCjj
	 ABdfwDayLMQfcrxo/wxiKulKmMw0MlgU8vdXIOI2kTLnTtvzdsPXBjKEcS2tQMQ41b
	 4yRzee8KaBiKH9q1tlLHupWHpEYK7d3i4kstJ5VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	David Gow <davidgow@google.com>,
	Kaibo Ma <ent3rm4n@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 185/849] rust: kunit: allow `cfg` on `test`s
Date: Tue, 11 Nov 2025 09:35:55 +0900
Message-ID: <20251111004540.901287258@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaibo Ma <ent3rm4n@gmail.com>

[ Upstream commit c652dc44192d96820d73a7ecd89d275ca7e4355d ]

The `kunit_test` proc macro only checks for the `test` attribute
immediately preceding a `fn`. If the function is disabled via a `cfg`,
the generated code would result in a compile error referencing a
non-existent function [1].

This collects attributes and specifically cherry-picks `cfg` attributes
to be duplicated inside KUnit wrapper functions such that a test function
disabled via `cfg` compiles and is marked as skipped in KUnit correctly.

Link: https://lore.kernel.org/r/20250916021259.115578-1-ent3rm4n@gmail.com
Link: https://lore.kernel.org/rust-for-linux/CANiq72==48=69hYiDo1321pCzgn_n1_jg=ez5UYXX91c+g5JVQ@mail.gmail.com/ [1]
Closes: https://github.com/Rust-for-Linux/linux/issues/1185
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Suggested-by: David Gow <davidgow@google.com>
Signed-off-by: Kaibo Ma <ent3rm4n@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/kunit.rs |  7 +++++++
 rust/macros/kunit.rs | 48 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
index 41efd87595d6e..32640dfc968fe 100644
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -357,4 +357,11 @@ mod tests {
     fn rust_test_kunit_in_kunit_test() {
         assert!(in_kunit_test());
     }
+
+    #[test]
+    #[cfg(not(all()))]
+    fn rust_test_kunit_always_disabled_test() {
+        // This test should never run because of the `cfg`.
+        assert!(false);
+    }
 }
diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
index 81d18149a0cc9..b395bb0536959 100644
--- a/rust/macros/kunit.rs
+++ b/rust/macros/kunit.rs
@@ -5,6 +5,7 @@
 //! Copyright (c) 2023 José Expósito <jose.exposito89@gmail.com>
 
 use proc_macro::{Delimiter, Group, TokenStream, TokenTree};
+use std::collections::HashMap;
 use std::fmt::Write;
 
 pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
@@ -41,20 +42,32 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
     // Get the functions set as tests. Search for `[test]` -> `fn`.
     let mut body_it = body.stream().into_iter();
     let mut tests = Vec::new();
+    let mut attributes: HashMap<String, TokenStream> = HashMap::new();
     while let Some(token) = body_it.next() {
         match token {
-            TokenTree::Group(ident) if ident.to_string() == "[test]" => match body_it.next() {
-                Some(TokenTree::Ident(ident)) if ident.to_string() == "fn" => {
-                    let test_name = match body_it.next() {
-                        Some(TokenTree::Ident(ident)) => ident.to_string(),
-                        _ => continue,
-                    };
-                    tests.push(test_name);
+            TokenTree::Punct(ref p) if p.as_char() == '#' => match body_it.next() {
+                Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Bracket => {
+                    if let Some(TokenTree::Ident(name)) = g.stream().into_iter().next() {
+                        // Collect attributes because we need to find which are tests. We also
+                        // need to copy `cfg` attributes so tests can be conditionally enabled.
+                        attributes
+                            .entry(name.to_string())
+                            .or_default()
+                            .extend([token, TokenTree::Group(g)]);
+                    }
+                    continue;
                 }
-                _ => continue,
+                _ => (),
             },
+            TokenTree::Ident(i) if i.to_string() == "fn" && attributes.contains_key("test") => {
+                if let Some(TokenTree::Ident(test_name)) = body_it.next() {
+                    tests.push((test_name, attributes.remove("cfg").unwrap_or_default()))
+                }
+            }
+
             _ => (),
         }
+        attributes.clear();
     }
 
     // Add `#[cfg(CONFIG_KUNIT="y")]` before the module declaration.
@@ -100,11 +113,22 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
     let mut test_cases = "".to_owned();
     let mut assert_macros = "".to_owned();
     let path = crate::helpers::file();
-    for test in &tests {
+    let num_tests = tests.len();
+    for (test, cfg_attr) in tests {
         let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{test}");
-        // An extra `use` is used here to reduce the length of the message.
+        // Append any `cfg` attributes the user might have written on their tests so we don't
+        // attempt to call them when they are `cfg`'d out. An extra `use` is used here to reduce
+        // the length of the assert message.
         let kunit_wrapper = format!(
-            "unsafe extern \"C\" fn {kunit_wrapper_fn_name}(_test: *mut ::kernel::bindings::kunit) {{ use ::kernel::kunit::is_test_result_ok; assert!(is_test_result_ok({test}())); }}",
+            r#"unsafe extern "C" fn {kunit_wrapper_fn_name}(_test: *mut ::kernel::bindings::kunit)
+            {{
+                (*_test).status = ::kernel::bindings::kunit_status_KUNIT_SKIPPED;
+                {cfg_attr} {{
+                    (*_test).status = ::kernel::bindings::kunit_status_KUNIT_SUCCESS;
+                    use ::kernel::kunit::is_test_result_ok;
+                    assert!(is_test_result_ok({test}()));
+                }}
+            }}"#,
         );
         writeln!(kunit_macros, "{kunit_wrapper}").unwrap();
         writeln!(
@@ -139,7 +163,7 @@ macro_rules! assert_eq {{
     writeln!(
         kunit_macros,
         "static mut TEST_CASES: [::kernel::bindings::kunit_case; {}] = [\n{test_cases}    ::kernel::kunit::kunit_case_null(),\n];",
-        tests.len() + 1
+        num_tests + 1
     )
     .unwrap();
 
-- 
2.51.0




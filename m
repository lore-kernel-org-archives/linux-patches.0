Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF593876B3;
	Fri,  4 Sep 2026 05:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498350; cv=none; b=NtUEeNmKPmYjHTqX4Quepz/uXCqrgsFqH3QFxJnDt/rmgWxvlued0lbYBFZYMlvbni2ZkIg21IstOirVsVIBNJyl02UzPUpnOjPse+r8dh3oVOEO7DSLLii4/umCgM7Mx+Sjtj7GOHpUGEILVFIJzzsa6swMYrpRY43vzMhnLuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498350; c=relaxed/simple;
	bh=Czk0TfdczwceiK1PZkqcgnrVDAYS/M1uAhGHC7w759I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kki+I60cD7CEC+T9RbSMCucGkLHhvKDgOfLqQJynXPZKDNSs5hJV7poD+TYBVBZqDxkUgExAPHA5uOVz7ANd+Ssgju9X8T+h+XO48AKERsspEc8EMGPE3usGM/+zEje/PPDln+CBc3LSM8yDilxJ2TKlAqhH0BW0x6PIMoZAWfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIbVsEhL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIbVsEhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74AF1F00A3D;
	Fri,  4 Sep 2026 05:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498349;
	bh=P5J0DtwDew5nrurmT7yNQaX/kfpbG4HQexi6eBIjhaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIbVsEhLECXWfUwrzkoQwtx5E2joUN+zUqQ5YI+KGfO2dl+fAEuauU3XrQlQ9M5Ve
	 LSWae19QLyquhJkUcx7elYpDrVmAMGyNzTSzXtNfWTHVWmE9kA5LDtnHuYz4k52ijX
	 4RLXIp8zXUrEgGTJELReKFkr2n/7qvIY4yJnaXYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Burak Emir <burak.emir@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 030/713] rust: rust_is_available: warn for `bindgen` < 0.72.1 && libclang >= 22
Date: Fri,  4 Sep 2026 06:49:58 +0200
Message-ID: <20260904045804.506461810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit dc01dfb37b34beeefcfe1c3055364d41a4070c7e upstream.

Starting with LLVM 22, `clang_getTypeDeclaration()` may return a forward
declaration instead of the type definition. This made `bindgen` generate
opaque types [1][2], which in turn made us fail with e.g.

    error[E0609]: no field `__bindgen_anon_1` on type `bindings::kernel_param`
      --> rust/kernel/module_param.rs:78:46
       |
    78 |         let container = unsafe { &*((*param).__bindgen_anon_1.arg.cast::<SetOnce<T>>()) };
       |                                              ^^^^^^^^^^^^^^^^ unknown field
       |
       = note: available field is: `_address`

This was fixed in `bindgen` 0.72.1 [3].

In order to clarify what is going on and avoid confusion [4][5], add
a warning to `rust_is_available.sh` about it when the versions match,
similar to past warnings like the one removed in:

  commit ae64324ad5c1 ("rust: rust_is_available: remove warning for `bindgen` < 0.69.5 && libclang >= 19.1")

In addition, even if the versions match, check if the issue appears to
not reproduce with the given binaries, to avoid a warning in such a case.

Finally, include tests.

[ Nathan, in parallel, updated the instructions of the LLVM+Rust
  kernel.org toolchains [6] so that `--version` is not passed to
  `cargo` for `bindgen`, and thus the latest `bindgen` is installed
  by default, which should help to avoid some of these situations.

  Thanks!

    - Miguel ]

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust-bindgen/issues/3264 [1]
Link: https://github.com/Rust-for-Linux/linux/issues/353 [2] # "Missing fields in nested class with LLVM 22."
Link: https://github.com/rust-lang/rust-bindgen/pull/3278 [3]
Reported-by: Burak Emir <burak.emir@gmail.com>
Link: https://github.com/Rust-for-Linux/linux/issues/1247 [4]
Link: https://lore.kernel.org/rust-for-linux/CABwQupNfMAJOGqRM9ke6tj4f53dCCsBDKU7Vp+zf8mwk7bqt8Q@mail.gmail.com/ [5]
Link: https://mirrors.edge.kernel.org/pub/tools/llvm/rust/ [6]
Tested-by: Burak Emir <burak.emir@gmail.com>
Link: https://patch.msgid.link/20260719120514.159914-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/rust_is_available.sh                    |   14 +++++++++++
 scripts/rust_is_available_bindgen_libclang_22.h |    5 ++++
 scripts/rust_is_available_test.py               |   30 +++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 scripts/rust_is_available_bindgen_libclang_22.h

--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -208,6 +208,20 @@ if [ "$bindgen_libclang_cversion" -lt "$
 	exit 1
 fi
 
+if [ "$bindgen_libclang_cversion" -ge 2200000 ] &&
+	[ "$rust_bindings_generator_cversion" -lt 7201 ]; then
+	# Distributions may have patched the issue.
+	if ! "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang_22.h | grep -q 'pub foo'; then
+		echo >&2 "***"
+		echo >&2 "*** Rust bindings generator '$BINDGEN' < 0.72.1 together with libclang >= 22"
+		echo >&2 "*** may not work due to a bug (https://github.com/rust-lang/rust-bindgen/pull/3278)."
+		echo >&2 "***   Your bindgen version:  $rust_bindings_generator_version"
+		echo >&2 "***   Your libclang version: $bindgen_libclang_version"
+		echo >&2 "***"
+		warning=1
+	fi
+fi
+
 # If the C compiler is Clang, then we can also check whether its version
 # matches the `libclang` version used by the Rust bindings generator.
 #
--- /dev/null
+++ b/scripts/rust_is_available_bindgen_libclang_22.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+struct S;
+struct S {
+	int foo;
+};
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -54,16 +54,23 @@ else:
 """)
 
     @classmethod
-    def generate_bindgen(cls, version_stdout, libclang_stderr):
+    def generate_bindgen(cls, version_stdout, libclang_stderr, libclang_22_patched=False):
         if libclang_stderr is None:
             libclang_case = f"raise SystemExit({cls.bindgen_default_bindgen_libclang_failure_exit_code})"
         else:
             libclang_case = f"print({repr(libclang_stderr)}, file=sys.stderr)"
 
+        if libclang_22_patched:
+            libclang_22_case = "print('pub foo: ::std::os::raw::c_int,')"
+        else:
+            libclang_22_case = "pass"
+
         return cls.generate_executable(f"""#!/usr/bin/env python3
 import sys
 if "rust_is_available_bindgen_libclang.h" in " ".join(sys.argv):
     {libclang_case}
+elif "rust_is_available_bindgen_libclang_22.h" in " ".join(sys.argv):
+    {libclang_22_case}
 else:
     print({repr(version_stdout)})
 """)
@@ -248,6 +255,27 @@ else:
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
         self.assertIn(f"libclang (used by the Rust bindings generator '{bindgen}') is too old.", result.stderr)
 
+    def test_bindgen_bad_libclang_22(self):
+        for (bindgen_version, libclang_version, expected_not_patched) in (
+            ("0.71.1", "21.1.0", self.Expected.SUCCESS),
+            ("0.71.1", "22.0.0", self.Expected.SUCCESS_WITH_WARNINGS),
+            ("0.71.1", "22.1.0", self.Expected.SUCCESS_WITH_WARNINGS),
+
+            ("0.72.0", "22.0.0", self.Expected.SUCCESS_WITH_WARNINGS),
+
+            ("0.72.1", "22.0.0", self.Expected.SUCCESS),
+        ):
+            with self.subTest(bindgen_version=bindgen_version, libclang_version=libclang_version):
+                cc = self.generate_clang(f"clang version {libclang_version}")
+                libclang_stderr = f"scripts/rust_is_available_bindgen_libclang.h:2:9: warning: clang version {libclang_version} [-W#pragma-messages], err: false"
+                bindgen = self.generate_bindgen(f"bindgen {bindgen_version}", libclang_stderr)
+                result = self.run_script(expected_not_patched, { "BINDGEN": bindgen, "CC": cc })
+                if expected_not_patched == self.Expected.SUCCESS_WITH_WARNINGS:
+                    self.assertIn(f"Rust bindings generator '{bindgen}' < 0.72.1 together with libclang >= 22", result.stderr)
+
+                bindgen = self.generate_bindgen(f"bindgen {bindgen_version}", libclang_stderr, libclang_22_patched=True)
+                result = self.run_script(self.Expected.SUCCESS, { "BINDGEN": bindgen, "CC": cc })
+
     def test_clang_matches_bindgen_libclang_different_bindgen(self):
         bindgen = self.generate_bindgen_libclang("scripts/rust_is_available_bindgen_libclang.h:2:9: warning: clang version 999.0.0 [-W#pragma-messages], err: false")
         result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })



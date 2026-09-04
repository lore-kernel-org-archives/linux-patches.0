Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D76637F306;
	Fri,  4 Sep 2026 06:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501696; cv=none; b=HFemICYvkTLjq5VRgkTAZtHBgE4ePaKOdOhOqzDe2PvU4/CLiUqFTIFSuXXQQp6uz5d2nxQLLrJ8RoCM1uZDgHKudjZm7GVQQBFt9CzFw73U6qU44PhIYCqP9OVtWZ4y3+8RKPRFZgdccOq49vofHW4Pa9IeVo6nlMKteQGqEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501696; c=relaxed/simple;
	bh=8AH+Y4Rbt1a1PTyLBeEIx5+I9kJvpO6FvTCDCG+51dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njbirs2HsNnq0PEbk6lCLdfLX0k6D+0qZ07aX3xC5RocTVBLCW+CLj5SvACnBLMPF8dtIejgFeFnuQZUvXUFshttqfOGbBqDORo1U1OyPVGk646XBTiZcHglQPNBgDFlOVRhjs/px94ns/ItVNDasOHptKqPp0g1Ymq6JbaqSkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgC7EaXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgC7EaXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974851F00A3F;
	Fri,  4 Sep 2026 06:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501695;
	bh=ERGUXhC12TDEyqtXIwt7QJ/tMHfLKuKenmY+wQbnDEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgC7EaXjlQqAjnGN+Ea1Fk8hFvcVIZHd978surGQOs5y/XMOFgHeGX26MuojPj19q
	 QprO0rHc7qNt+ars06qMhqqI4ZRQCyIZihL2rjYcG1B2uq68dPL2jnsjETfWsjPWOw
	 x+DWD9JQNDhAFtj8l3JVUF3itWnWo5y5UH7Dn+Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Burak Emir <burak.emir@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/552] rust: rust_is_available: warn for `bindgen` < 0.72.1 && libclang >= 22
Date: Fri,  4 Sep 2026 07:00:58 +0200
Message-ID: <20260904045802.011460539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit dc01dfb37b34beeefcfe1c3055364d41a4070c7e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/rust_is_available.sh                  | 14 +++++++++
 .../rust_is_available_bindgen_libclang_22.h   |  5 ++++
 scripts/rust_is_available_test.py             | 30 ++++++++++++++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 scripts/rust_is_available_bindgen_libclang_22.h

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index d2323de0692c1..82be88d44c184 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -242,6 +242,20 @@ if [ "$bindgen_libclang_cversion" -ge 1900100 ] &&
 	fi
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
diff --git a/scripts/rust_is_available_bindgen_libclang_22.h b/scripts/rust_is_available_bindgen_libclang_22.h
new file mode 100644
index 0000000000000..6b33544c14a81
--- /dev/null
+++ b/scripts/rust_is_available_bindgen_libclang_22.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+struct S;
+struct S {
+	int foo;
+};
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index 4fcc319dea84e..a5fadef98132f 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -54,7 +54,7 @@ else:
 """)
 
     @classmethod
-    def generate_bindgen(cls, version_stdout, libclang_stderr, version_0_66_patched=False, libclang_concat_patched=False):
+    def generate_bindgen(cls, version_stdout, libclang_stderr, version_0_66_patched=False, libclang_concat_patched=False, libclang_22_patched=False):
         if libclang_stderr is None:
             libclang_case = f"raise SystemExit({cls.bindgen_default_bindgen_libclang_failure_exit_code})"
         else:
@@ -70,6 +70,11 @@ else:
         else:
             libclang_concat_case = "pass"
 
+        if libclang_22_patched:
+            libclang_22_case = "print('pub foo: ::std::os::raw::c_int,')"
+        else:
+            libclang_22_case = "pass"
+
         return cls.generate_executable(f"""#!/usr/bin/env python3
 import sys
 if "rust_is_available_bindgen_libclang.h" in " ".join(sys.argv):
@@ -78,6 +83,8 @@ elif "rust_is_available_bindgen_0_66.h" in " ".join(sys.argv):
     {version_0_66_case}
 elif "rust_is_available_bindgen_libclang_concat.h" in " ".join(sys.argv):
     {libclang_concat_case}
+elif "rust_is_available_bindgen_libclang_22.h" in " ".join(sys.argv):
+    {libclang_22_case}
 else:
     print({repr(version_stdout)})
 """)
@@ -300,6 +307,27 @@ else:
                 bindgen = self.generate_bindgen(f"bindgen {bindgen_version}", libclang_stderr, libclang_concat_patched=True)
                 result = self.run_script(self.Expected.SUCCESS, { "BINDGEN": bindgen, "CC": cc })
 
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
-- 
2.53.0




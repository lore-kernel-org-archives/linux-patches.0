Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96DB19DF90;
	Tue,  9 Jul 2024 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541228; cv=none; b=LkQFvEtYUo9hhjcpHEzyEnKvqsB9PhHMIYzPHdY2wF6ZhJfMs9FLpZw/5fzm6GTbzkoM6eZBP9O5AHqSG877ysht/Cnu/Lpq1us8s1STmLccpFZh91OHDlYu+Rv+Nwr6XoIBZHURdl7F43RiH6FVTm0WmheJwxIVkcGsWqyW/Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541228; c=relaxed/simple;
	bh=8QEL/PuUqtPqPrkYFUEvdVfn7sVnLcu1vHxTF21KFwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwkdKtKSn6v/GogHPkVgKIaqZYsKYh8COMX9m8QbDj2EDb3xgjC/nx3duanY40VmQHCyVPJSu1MVDqwSSJyz9XSIgR8OVbZvTfmKTL+HX5Co2fTalEHx9KJqetWy3991xCfMIKEnIHlXGx69bpxwtptf7zqattihxHN0fRn8r98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIkL+4F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIkL+4F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B617C32782;
	Tue,  9 Jul 2024 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541228;
	bh=8QEL/PuUqtPqPrkYFUEvdVfn7sVnLcu1vHxTF21KFwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIkL+4F8VpEJQOObeHI5cq+apg/G3s9p1F8CDm71WPugVKNQGw8bmXsK5G6PEUmOh
	 F0v7oVnUnU7cEed3u1wUd+XpxNao/FA1LChS28qQgjNQq+tsrAmIJr9CC/W6vBMScs
	 VHcIpV2fiHJOKZNpWSA/i8nWLQXkU+WCZiINW42BWisf90lZQKEVi8eolQl2LhbCdX
	 QSyERWM6wEhzgzjEeL39UZ2A+9bnwgzMno7LmJ8g+ppmGwY4nAb1k/f81hY/qKzZ9w
	 olwrGcgEStMByFhOaeXLqEkjz2/Z09q0vCeCYsTzw+mVFCthP5kTAXnBKmjsq66gfR
	 YluLKz48v8P/w==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 10/13] rust: warn about `bindgen` versions 0.66.0 and 0.66.1
Date: Tue,  9 Jul 2024 18:06:05 +0200
Message-ID: <20240709160615.998336-11-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`bindgen` versions 0.66.0 and 0.66.1 panic due to C string literals with
NUL characters [1]:

    panicked at .cargo/registry/src/index.crates.io-6f17d22bba15001f/bindgen-0.66.0/codegen/mod.rs:717:71:
    called `Result::unwrap()` on an `Err` value: FromBytesWithNulError { kind: InteriorNul(4) }

Thus, in preparation for supporting several `bindgen` versions, add a
version check to warn the user about it.

Since some distributions may have patched it (e.g. Debian did [2]),
check if that seems to be the case (after the version check matches),
in order to avoid printing a warning in that case.

We could make it an error, but 1) it is going to fail anyway later
in the build, 2) we would disable `RUST`, which is also painful, 3)
someone could have patched it in a way that still makes our extra check
fail (however unlikely), 4) the interior NUL may go away in the headers
(however unlikely). Thus just warn about it so that users know why it
is failing.

In addition, add a couple tests for the new cases.

Link: https://github.com/rust-lang/rust-bindgen/pull/2567 [1]
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1069047 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
v2:
  - If the version matches, then also check whether the `bindgen` binary
    fails with a simple interior NUL case, so that we can avoid the
    warning if it has been patched (like Debian's). Update the comment
    for the warning as well, and add a test for it too.
  - Move test later in the series so that the new test does not fail due
    to the "too new" check.
  - Split `if` condition in 2 lines.

 scripts/rust_is_available.sh             | 13 ++++++++++++
 scripts/rust_is_available_bindgen_0_66.h |  2 ++
 scripts/rust_is_available_test.py        | 26 +++++++++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)
 create mode 100644 scripts/rust_is_available_bindgen_0_66.h

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 4531f9dd19d3..5262c56dd674 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -161,6 +161,19 @@ if [ "$rust_bindings_generator_cversion" -lt "$rust_bindings_generator_min_cvers
 	echo >&2 "***"
 	exit 1
 fi
+if [ "$rust_bindings_generator_cversion" -eq 6600 ] ||
+	[ "$rust_bindings_generator_cversion" -eq 6601 ]; then
+	# Distributions may have patched the issue (e.g. Debian did).
+	if ! "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_0_66.h >/dev/null; then
+		echo >&2 "***"
+		echo >&2 "*** Rust bindings generator '$BINDGEN' versions 0.66.0 and 0.66.1 may not"
+		echo >&2 "*** work due to a bug (https://github.com/rust-lang/rust-bindgen/pull/2567),"
+		echo >&2 "*** unless patched (like Debian's)."
+		echo >&2 "***   Your version:     $rust_bindings_generator_version"
+		echo >&2 "***"
+		warning=1
+	fi
+fi

 # Check that the `libclang` used by the Rust bindings generator is suitable.
 #
diff --git a/scripts/rust_is_available_bindgen_0_66.h b/scripts/rust_is_available_bindgen_0_66.h
new file mode 100644
index 000000000000..c0431293421c
--- /dev/null
+++ b/scripts/rust_is_available_bindgen_0_66.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#define A "\0"
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index d6d54b7ea42a..413741037fb3 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -54,23 +54,30 @@ else:
 """)

     @classmethod
-    def generate_bindgen(cls, version_stdout, libclang_stderr):
+    def generate_bindgen(cls, version_stdout, libclang_stderr, version_0_66_patched=False):
         if libclang_stderr is None:
             libclang_case = f"raise SystemExit({cls.bindgen_default_bindgen_libclang_failure_exit_code})"
         else:
             libclang_case = f"print({repr(libclang_stderr)}, file=sys.stderr)"

+        if version_0_66_patched:
+            version_0_66_case = "pass"
+        else:
+            version_0_66_case = "raise SystemExit(1)"
+
         return cls.generate_executable(f"""#!/usr/bin/env python3
 import sys
 if "rust_is_available_bindgen_libclang.h" in " ".join(sys.argv):
     {libclang_case}
+elif "rust_is_available_bindgen_0_66.h" in " ".join(sys.argv):
+    {version_0_66_case}
 else:
     print({repr(version_stdout)})
 """)

     @classmethod
-    def generate_bindgen_version(cls, stdout):
-        return cls.generate_bindgen(stdout, cls.bindgen_default_bindgen_libclang_stderr)
+    def generate_bindgen_version(cls, stdout, version_0_66_patched=False):
+        return cls.generate_bindgen(stdout, cls.bindgen_default_bindgen_libclang_stderr, version_0_66_patched)

     @classmethod
     def generate_bindgen_libclang_failure(cls):
@@ -231,6 +238,19 @@ else:
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
         self.assertIn(f"Rust bindings generator '{bindgen}' is too old.", result.stderr)

+    def test_bindgen_bad_version_0_66_0_and_0_66_1(self):
+        for version in ("0.66.0", "0.66.1"):
+            with self.subTest(version=version):
+                bindgen = self.generate_bindgen_version(f"bindgen {version}")
+                result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })
+                self.assertIn(f"Rust bindings generator '{bindgen}' versions 0.66.0 and 0.66.1 may not", result.stderr)
+
+    def test_bindgen_bad_version_0_66_0_and_0_66_1_patched(self):
+        for version in ("0.66.0", "0.66.1"):
+            with self.subTest(version=version):
+                bindgen = self.generate_bindgen_version(f"bindgen {version}", True)
+                result = self.run_script(self.Expected.SUCCESS, { "BINDGEN": bindgen })
+
     def test_bindgen_libclang_failure(self):
         bindgen = self.generate_bindgen_libclang_failure()
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
--
2.45.2

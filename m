Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0E516F830;
	Mon,  1 Jul 2024 18:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859046; cv=none; b=P6lV3PjLMoWM+fYmt9LYe812oaVZgkp8GWLfoLX1CHsbTNn5ZztYBCt63TCG1zPSNZsiSZS2VnL+qeNmJmKd4dhJpxXEx5jj65pO1OJ/9UZrpKMXSKr1FKmF5qQfGd5sH5fr3+XPC25VFCsl8Olxv6941bWGbg/D+G6Zz7S2Xy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859046; c=relaxed/simple;
	bh=kJiYzZUvKPXTzirN9ohxumOKC4tj/dE8h5tx4X3OoTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD6vff+v51B7BnQUbE5XqOvb5bIjldCRUmAoHQen155ftsli6YjeBTJzZi5+8QIkdpBjey0Y6WGhJ3YTI3Q+aCgYRbD+EWSwRZUGz43cQkTNTL2pGPznTUZ6sMxqpYMZnS6F5dNEsKbuFe/O+2P+nNJmliLawS58eiKgGicb4tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxDow6BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxDow6BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5815C116B1;
	Mon,  1 Jul 2024 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859045;
	bh=kJiYzZUvKPXTzirN9ohxumOKC4tj/dE8h5tx4X3OoTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxDow6BJJOxbCH8tzyZ/Uwq3/qNKPnFbsmAhXKEEBUveDeMaVvPoSP+gAbLI0lJWU
	 pifv9n1YAWWQWz9T5Gt/3oCSKRxH2529oZRuqGuFy04+hl9hvAlmFSZxx0hdbknaLO
	 QxHARyEulGdgJBsAk3gn9H2BfbxeadzDnpd8Iv7IAlNSBYSALM2tkeaPQT9vfL/FiD
	 IVwNGO6U0W3ydsi7W2sD0FJNDoOGRV642m8okc9gCmAd4YlRWj34Z64+uIXH7XFtJW
	 vaIhLWbnrRqS234zeQGKL2LyGRT+vDVZpigI4OcfgqzRaeIr1PGuX4+K1mI+PJKf1N
	 X+PTDHS7Pdh+Q==
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
	patches@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH 09/13] rust: avoid assuming a particular `bindgen` build
Date: Mon,  1 Jul 2024 20:36:19 +0200
Message-ID: <20240701183625.665574-10-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`bindgen`'s logic to find `libclang` (via `clang-sys`) may change over
time, and depends on how it was built (e.g. Linux distributions may decide
to build it differently, and we are going to provide documentation on
installing it via distributions later in this series).

Therefore, clarify that `bindgen` may be built in several ways and
simplify the documentation by only mentioning the most prominent
environment variable (`LIBCLANG_PATH`) as an example on how to tweak the
search of the library at runtime (i.e. when `bindgen` is built as our
documentation explains). This also avoids duplicating the documentation,
like `bindgen` itself does (i.e. it refers to `clang-sys`).

Similarly, replace the test we had for this (which used the real program)
with a mocked one, to avoid depending on the build as well.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/quick-start.rst | 23 +++++++++--------------
 scripts/rust_is_available_test.py  | 25 +++++++++++++++----------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index 139a8a536838..f411cad4cc02 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -106,20 +106,15 @@ Install it via (note that this will download and build the tool from source)::
 
 	cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen-cli
 
-``bindgen`` needs to find a suitable ``libclang`` in order to work. If it is
-not found (or a different ``libclang`` than the one found should be used),
-the process can be tweaked using the environment variables understood by
-``clang-sys`` (the Rust bindings crate that ``bindgen`` uses to access
-``libclang``):
-
-* ``LLVM_CONFIG_PATH`` can be pointed to an ``llvm-config`` executable.
-
-* Or ``LIBCLANG_PATH`` can be pointed to a ``libclang`` shared library
-  or to the directory containing it.
-
-* Or ``CLANG_PATH`` can be pointed to a ``clang`` executable.
-
-For details, please see ``clang-sys``'s documentation at:
+``bindgen`` uses the ``clang-sys`` crate to find a suitable ``libclang`` (which
+may be linked statically, dynamically or loaded at runtime). By default, the
+``cargo`` command above will produce a ``bindgen`` binary that will load
+``libclang`` at runtime. If it is not found (or a different ``libclang`` than
+the one found should be used), the process can be tweaked, e.g. by using the
+``LIBCLANG_PATH`` environment variable. For details, please see ``clang-sys``'s
+documentation at:
+
+	https://github.com/KyleMayes/clang-sys#linking
 
 	https://github.com/KyleMayes/clang-sys#environment-variables
 
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index 2b887098c19d..f5ebafff002c 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -55,10 +55,15 @@ else:
 
     @classmethod
     def generate_bindgen(cls, version_stdout, libclang_stderr):
+        if libclang_stderr is None:
+            libclang_case = f"raise SystemExit({cls.bindgen_default_bindgen_libclang_failure_exit_code})"
+        else:
+            libclang_case = f"print({repr(libclang_stderr)}, file=sys.stderr)"
+
         return cls.generate_executable(f"""#!/usr/bin/env python3
 import sys
 if "rust_is_available_bindgen_libclang.h" in " ".join(sys.argv):
-    print({repr(libclang_stderr)}, file=sys.stderr)
+    {libclang_case}
 else:
     print({repr(version_stdout)})
 """)
@@ -67,6 +72,10 @@ else:
     def generate_bindgen_version(cls, stdout):
         return cls.generate_bindgen(stdout, cls.bindgen_default_bindgen_libclang_stderr)
 
+    @classmethod
+    def generate_bindgen_libclang_failure(cls):
+        return cls.generate_bindgen(cls.bindgen_default_bindgen_version_stdout, None)
+
     @classmethod
     def generate_bindgen_libclang(cls, stderr):
         return cls.generate_bindgen(cls.bindgen_default_bindgen_version_stdout, stderr)
@@ -89,6 +98,7 @@ else:
         cls.rust_default_sysroot = subprocess.check_output(("rustc", "--print", "sysroot")).decode().strip()
 
         cls.bindgen_default_bindgen_version_stdout = f"bindgen {cls.bindgen_default_version}"
+        cls.bindgen_default_bindgen_libclang_failure_exit_code = 42
         cls.bindgen_default_bindgen_libclang_stderr = f"scripts/rust_is_available_bindgen_libclang.h:2:9: warning: clang version {cls.llvm_default_version} [-W#pragma-messages], err: false"
 
         cls.default_rustc = cls.generate_rustc(f"rustc {cls.rustc_default_version}")
@@ -234,15 +244,10 @@ else:
                 self.assertIn(f"Rust bindings generator '{bindgen}' versions 0.66.0 and 0.66.1 may not", result.stderr)
 
     def test_bindgen_libclang_failure(self):
-        for env in (
-            { "LLVM_CONFIG_PATH": self.missing },
-            { "LIBCLANG_PATH": self.missing },
-            { "CLANG_PATH": self.missing },
-        ):
-            with self.subTest(env=env):
-                result = self.run_script(self.Expected.FAILURE, env | { "PATH": os.environ["PATH"], "BINDGEN": "bindgen" })
-                self.assertIn("Running 'bindgen' to check the libclang version (used by the Rust", result.stderr)
-                self.assertIn("bindings generator) failed with code ", result.stderr)
+        bindgen = self.generate_bindgen_libclang_failure()
+        result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
+        self.assertIn(f"Running '{bindgen}' to check the libclang version (used by the Rust", result.stderr)
+        self.assertIn(f"bindings generator) failed with code {self.bindgen_default_bindgen_libclang_failure_exit_code}. This may be caused by", result.stderr)
 
     def test_bindgen_libclang_unexpected_version(self):
         bindgen = self.generate_bindgen_libclang("scripts/rust_is_available_bindgen_libclang.h:2:9: warning: clang version unexpected [-W#pragma-messages], err: false")
-- 
2.45.2


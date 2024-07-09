Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF719DF77;
	Tue,  9 Jul 2024 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541216; cv=none; b=HyqnCwmaXlbFMThlEzyO0Iz+uQNI8JM/2MtTQdtO0M92yj4QrdIb4F4gSe6v4Vs895RpeO4DbHRzWkwKey0dxwmPrKXKvhaO75vOyWeE0/craBJ3iNZU95kfGUCePftZ4aNLBm0s73WBdJID7/jk19yQriuJwYkYcXMfLxE+g64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541216; c=relaxed/simple;
	bh=pi7YG3fAnZQi7Cj4nC9+KKBDACso0SQUfDm0WVNC4lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf5l0xT1gGaCwlLk1rgVMQzjmeVIqXrPHGPnD0e/a88QC/iktQHJOxZkNtYr9D9K9gcO7M4SEG1n57ONWe96BgR4lDDhO3/MPvZjSqpv4O5xXAIR8hJxmtNPvLXi8EYzrWQ4OJ+4YL4dVk1hkyMQQlolcE9NDAn5IhEyWJiHc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6KcHHda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6KcHHda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE934C4AF10;
	Tue,  9 Jul 2024 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541216;
	bh=pi7YG3fAnZQi7Cj4nC9+KKBDACso0SQUfDm0WVNC4lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6KcHHda0G4jh/UDSWd547/uiSjcMEnTaif1WeQPVLDB+grIlEvKIvEAAXo4wfbpn
	 wphL/KF5VewyoN9zphp5baEcg9Id/jtlg4plRGGdA0ZaEhyRCL75ZsJeLg4eHTnSeB
	 9QxsbkNe2ySKhQk1cbgB7owipztAKTxk/xzzu0/cSlzlcvLjzYwtr26UKTSx2nXm4Q
	 p1VgZeov0TdrcRdOyrkewszfEGsYs8Oo01BNCU041OJjMyiRf+XelsZn0fy/X8jMVG
	 BSoQc80ZTX00pqTlSwgvIeH2WCpOItNoQLZSPkKorANdRsSl8FGTu8lPji2Z7YvxvP
	 vJnZAi1DdkV1w==
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
Subject: [PATCH v2 07/13] rust: avoid assuming a particular `bindgen` build
Date: Tue,  9 Jul 2024 18:06:02 +0200
Message-ID: <20240709160615.998336-8-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
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
with a mocked one, to avoid depending on the particular build as well.

Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/quick-start.rst | 23 +++++++++--------------
 scripts/rust_is_available_test.py  | 25 +++++++++++++++----------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index 89bbfde8c96c..5ea8c8914942 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -113,20 +113,15 @@ Install it via (note that this will download and build the tool from source)::
 
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
index a255f79aafc2..0481aab862ec 100755
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
@@ -227,15 +237,10 @@ else:
         self.assertIn(f"Rust bindings generator '{bindgen}' is too new. This may or may not work.", result.stderr)
 
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


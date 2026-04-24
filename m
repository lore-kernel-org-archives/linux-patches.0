Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5433B8D75;
	Fri, 24 Apr 2026 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038295; cv=none; b=ZYyhFPTc2CUcV3OV4fesZKwVliIIAO7vT99V4kTO4KdmoqIN1S4BLuFP+0S3lWTvyfZEUxXbM5D21jFLz/7Q3wh6eHpCTsMXTb52oZR39kwlzUOy8fj3i4dtzRL/7jz4pDvkBluq4nV0lhOluWQgUD4jI7PIX5Rc1nCcA60iEZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038295; c=relaxed/simple;
	bh=OApkhzo6MV6wx5RM73ARnSW/CrS+NWCS1lS2rBHLUoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPQAnSvgglNkCGYHzj910W3GKj+kOby/qE+54PaVH2cqjfBEHym6OZ17yaelo7jXyvnuyktMYVHZ4R0mMBhf2LYsqUVepLl0kY6kRWpZ6fTsh64SYojH2DLy7+axHFE0C3OvJSrqP0uG6Dl080ep1sEd3j9JKzL3jl6gr9XYO2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCSqQyJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCSqQyJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9813DC19425;
	Fri, 24 Apr 2026 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038294;
	bh=OApkhzo6MV6wx5RM73ARnSW/CrS+NWCS1lS2rBHLUoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCSqQyJPf/yqX3N/efg8nszV7+gCysu0Zh7KauCOXlrP0iWtuv0wKSSNo067qtmYz
	 n0tBaah9J/SaVtGEVrdHpl+TBukU1e9ehZ79xLpzCnbjPdyIRwKN1Mk5N/BOQU7DvT
	 6mCNq4/hOhSCh2TkeF0YjL9NL6nQQ79BxvBsW4qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Beasley <code@musicinmybrain.net>,
	NoisyCoil <noisycoil@tutanota.com>,
	Matthias Geiger <werdahias@riseup.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 06/35] rust: warn on bindgen < 0.69.5 and libclang >= 19.1
Date: Fri, 24 Apr 2026 15:31:13 +0200
Message-ID: <20260424132412.936885445@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit b2603f8ac8217bc59f5c7f248ac248423b9b99cb ]

When testing a `clang` upgrade with Rust Binder, Alice encountered [1] a
build failure caused by `bindgen` not translating some symbols related to
tracepoints. This was caused by commit 2e770edd8ce1 ("[libclang] Compute
the right spelling location") changing the behavior of a function exposed
by `libclang`. `bindgen` fixed the regression in commit 600f63895f73
("Use clang_getFileLocation instead of clang_getSpellingLocation").

However, the regression fix is only available in `bindgen` versions
0.69.5 or later (it was backported for 0.69.x). This means that when
older bindgen versions are used with new versions of `libclang`, `bindgen`
may do the wrong thing, which could lead to a build failure.

Alice encountered the bug with some header files related to tracepoints,
but it could also cause build failures in other circumstances. Thus,
always emit a warning when using an old `bindgen` with a new `libclang`
so that other people do not have to spend time chasing down the same
bug.

However, testing just the version is inconvenient, since distributions
do patch their packages without changing the version, so I reduced the
issue into the following piece of code that can trigger the issue:

    #define F(x) int x##x
    F(foo);

In particular, an unpatched `bindgen` will ignore the macro expansion
and thus not provide a declaration for the exported `int`.

Thus add a build test to `rust_is_available.sh` using the code above
(that is only triggered if the versions appear to be affected), following
what we did for the 0.66.x issue.

Moreover, I checked the status in the major distributions we have
instructions for:

  - Fedora 41 was affected but is now OK, since it now ships `bindgen`
    0.69.5.

    Thanks Ben for the quick reply on the updates that were ongoing.

    Fedora 40 and earlier are OK (older `libclang`, and they also now
    carry `bindgen` 0.69.5).

  - Debian Sid was affected but is now OK, since they now ship a patched
    `bindgen` binary (0.66.1-7+b3). The issue was reported to Debian by
    email and then as a bug report [2].

    Thanks NoisyCoil and Matthias for the quick replies. NoisyCoil handled
    the needed updates. Debian may upgrade to `bindgen` 0.70.x, too.

    Debian Testing is OK (older `libclang` so far).

  - Ubuntu non-LTS (oracular) is affected. The issue was reported to Ubuntu
    by email and then as a bug report [3].

    Ubuntu LTS is not affected (older `libclang` so far).

  - Arch Linux, Gentoo Linux and openSUSE should be OK (newer `bindgen` is
    provided). Nix as well (older `libclang` so far).

This issue was also added to our "live list" that tracks issues around
distributions [4].

Cc: Ben Beasley <code@musicinmybrain.net>
Cc: NoisyCoil <noisycoil@tutanota.com>
Cc: Matthias Geiger <werdahias@riseup.net>
Link: https://lore.kernel.org/rust-for-linux/20241030-bindgen-libclang-warn-v1-1-3a7ba9fedcfe@google.com/ [1]
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1086510 [2]
Link: https://bugs.launchpad.net/ubuntu/+source/rust-bindgen-cli/+bug/2086639 [3]
Link: https://github.com/Rust-for-Linux/linux/issues/1127 [4]
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20241111201607.653149-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/rust_is_available.sh                  | 15 ++++++++
 ...ust_is_available_bindgen_libclang_concat.h |  3 ++
 scripts/rust_is_available_test.py             | 34 ++++++++++++++++++-
 3 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 scripts/rust_is_available_bindgen_libclang_concat.h

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 5262c56dd674e..93c0ef7fb3fb2 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -225,6 +225,21 @@ if [ "$bindgen_libclang_cversion" -lt "$bindgen_libclang_min_cversion" ]; then
 	exit 1
 fi
 
+if [ "$bindgen_libclang_cversion" -ge 1900100 ] &&
+	[ "$rust_bindings_generator_cversion" -lt 6905 ]; then
+	# Distributions may have patched the issue (e.g. Debian did).
+	if ! "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang_concat.h | grep -q foofoo; then
+		echo >&2 "***"
+		echo >&2 "*** Rust bindings generator '$BINDGEN' < 0.69.5 together with libclang >= 19.1"
+		echo >&2 "*** may not work due to a bug (https://github.com/rust-lang/rust-bindgen/pull/2824),"
+		echo >&2 "*** unless patched (like Debian's)."
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
diff --git a/scripts/rust_is_available_bindgen_libclang_concat.h b/scripts/rust_is_available_bindgen_libclang_concat.h
new file mode 100644
index 0000000000000..efc6e98d0f1d0
--- /dev/null
+++ b/scripts/rust_is_available_bindgen_libclang_concat.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#define F(x) int x##x
+F(foo);
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index 413741037fb30..4fcc319dea84e 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -54,7 +54,7 @@ else:
 """)
 
     @classmethod
-    def generate_bindgen(cls, version_stdout, libclang_stderr, version_0_66_patched=False):
+    def generate_bindgen(cls, version_stdout, libclang_stderr, version_0_66_patched=False, libclang_concat_patched=False):
         if libclang_stderr is None:
             libclang_case = f"raise SystemExit({cls.bindgen_default_bindgen_libclang_failure_exit_code})"
         else:
@@ -65,12 +65,19 @@ else:
         else:
             version_0_66_case = "raise SystemExit(1)"
 
+        if libclang_concat_patched:
+            libclang_concat_case = "print('pub static mut foofoo: ::std::os::raw::c_int;')"
+        else:
+            libclang_concat_case = "pass"
+
         return cls.generate_executable(f"""#!/usr/bin/env python3
 import sys
 if "rust_is_available_bindgen_libclang.h" in " ".join(sys.argv):
     {libclang_case}
 elif "rust_is_available_bindgen_0_66.h" in " ".join(sys.argv):
     {version_0_66_case}
+elif "rust_is_available_bindgen_libclang_concat.h" in " ".join(sys.argv):
+    {libclang_concat_case}
 else:
     print({repr(version_stdout)})
 """)
@@ -268,6 +275,31 @@ else:
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
         self.assertIn(f"libclang (used by the Rust bindings generator '{bindgen}') is too old.", result.stderr)
 
+    def test_bindgen_bad_libclang_concat(self):
+        for (bindgen_version, libclang_version, expected_not_patched) in (
+            ("0.69.4", "18.0.0", self.Expected.SUCCESS),
+            ("0.69.4", "19.1.0", self.Expected.SUCCESS_WITH_WARNINGS),
+            ("0.69.4", "19.2.0", self.Expected.SUCCESS_WITH_WARNINGS),
+
+            ("0.69.5", "18.0.0", self.Expected.SUCCESS),
+            ("0.69.5", "19.1.0", self.Expected.SUCCESS),
+            ("0.69.5", "19.2.0", self.Expected.SUCCESS),
+
+            ("0.70.0", "18.0.0", self.Expected.SUCCESS),
+            ("0.70.0", "19.1.0", self.Expected.SUCCESS),
+            ("0.70.0", "19.2.0", self.Expected.SUCCESS),
+        ):
+            with self.subTest(bindgen_version=bindgen_version, libclang_version=libclang_version):
+                cc = self.generate_clang(f"clang version {libclang_version}")
+                libclang_stderr = f"scripts/rust_is_available_bindgen_libclang.h:2:9: warning: clang version {libclang_version} [-W#pragma-messages], err: false"
+                bindgen = self.generate_bindgen(f"bindgen {bindgen_version}", libclang_stderr)
+                result = self.run_script(expected_not_patched, { "BINDGEN": bindgen, "CC": cc })
+                if expected_not_patched == self.Expected.SUCCESS_WITH_WARNINGS:
+                    self.assertIn(f"Rust bindings generator '{bindgen}' < 0.69.5 together with libclang >= 19.1", result.stderr)
+
+                bindgen = self.generate_bindgen(f"bindgen {bindgen_version}", libclang_stderr, libclang_concat_patched=True)
+                result = self.run_script(self.Expected.SUCCESS, { "BINDGEN": bindgen, "CC": cc })
+
     def test_clang_matches_bindgen_libclang_different_bindgen(self):
         bindgen = self.generate_bindgen_libclang("scripts/rust_is_available_bindgen_libclang.h:2:9: warning: clang version 999.0.0 [-W#pragma-messages], err: false")
         result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })
-- 
2.53.0




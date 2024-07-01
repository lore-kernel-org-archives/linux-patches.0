Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E7616F0C1;
	Mon,  1 Jul 2024 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859037; cv=none; b=Zfb+/17Pe9lbplfrdSEyf9jm9RZEBXwCHO6DiWIYKUFIjcQa14fR0kHNTTnl16kWqgQgBFzPKfg6ntkyf/JQpzOfkwPzgrqT632AxgjdRtBKNDiPCyiThMUxNrRVODFhm5mJQK5TVUWsse4EH1y2VfyNbNRXZqK0MfczrZ1539k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859037; c=relaxed/simple;
	bh=ERUo/0nQtCjUuD+gINsSy0w+dUleG+hyr1L3usm9JwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UugXp+3B/H4ffrLmYMarvOOBzjSCSownW1ituw6E2rNcKK6NknRCagK3M7ptEg+l4X++YOQXxo2Pv4xuBpX1jhI1uY2U44vi9tUe/albdQG4iVLMc3Vhlp0Z7zUw5FjuAUCCxeUdzuJdw9FsUQsZjN+6GZJe6bIpyznltClnnjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=to93iVOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="to93iVOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27031C116B1;
	Mon,  1 Jul 2024 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859037;
	bh=ERUo/0nQtCjUuD+gINsSy0w+dUleG+hyr1L3usm9JwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to93iVOKeECvr4DqGv52Rdq4SP8qul4SnQbQFBb7l0mbhSVvgggLaxuiXG2alfger
	 PR1wZP41DXvtuGQE5Q0LUlhUqZTnGQwcDHHOsLkgZ5TvZlq8sx1mI+8U4gHsfsxJDd
	 A46wnZC1ssHKxGRMZYAADLHiAL+HVDqr1idJvJGTt8Ixnno/VjktSFLZR1pXku9xTt
	 foDtazmI06Yj70y2Njhzebqz9L2Z++5SP7lmB99OfV6ISHjK5qWtY7ivYFxkCXvuex
	 32i3ZjDJuXdEoJSO7I2JKdjlYZEZ+iHQjKyPyjzm7O7xzvPSlxoEY+SrGfHfDnD/UV
	 uqTZjQd62np9w==
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
Subject: [PATCH 07/13] rust: warn about `bindgen` versions 0.66.0 and 0.66.1
Date: Mon,  1 Jul 2024 20:36:17 +0200
Message-ID: <20240701183625.665574-8-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
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

We could make it an error, but 1) it is going to fail anyway later in the
build, 2) we would disable `RUST` automatically, which is also painful,
3) someone could be using a patched `bindgen` at that version, 4) the
interior NUL may go away in the headers (however unlikely). Thus just
warn about it so that users know why it is failing.

In addition, add a test for the new case.

Link: https://github.com/rust-lang/rust-bindgen/pull/2567 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/rust_is_available.sh      | 8 ++++++++
 scripts/rust_is_available_test.py | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 67cb900124cc..33bbd01ffe51 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -165,6 +165,14 @@ if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cvers
 	echo >&2 "***"
 	warning=1
 fi
+if [ "$rust_bindings_generator_cversion" -eq 6600 ] || [ "$rust_bindings_generator_cversion" -eq 6601 ]; then
+	echo >&2 "***"
+	echo >&2 "*** Rust bindings generator '$BINDGEN' versions 0.66.0 and 0.66.1 may not"
+	echo >&2 "*** work due to a bug (https://github.com/rust-lang/rust-bindgen/pull/2567)."
+	echo >&2 "***   Your version:     $rust_bindings_generator_version"
+	echo >&2 "***"
+	warning=1
+fi
 
 # Check that the `libclang` used by the Rust bindings generator is suitable.
 #
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index a255f79aafc2..2b887098c19d 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -226,6 +226,13 @@ else:
         result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })
         self.assertIn(f"Rust bindings generator '{bindgen}' is too new. This may or may not work.", result.stderr)
 
+    def test_bindgen_bad_version_0_66_0_and_0_66_1(self):
+        for version in ("0.66.0", "0.66.1"):
+            with self.subTest(version=version):
+                bindgen = self.generate_bindgen_version(f"bindgen {version}")
+                result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })
+                self.assertIn(f"Rust bindings generator '{bindgen}' versions 0.66.0 and 0.66.1 may not", result.stderr)
+
     def test_bindgen_libclang_failure(self):
         for env in (
             { "LLVM_CONFIG_PATH": self.missing },
-- 
2.45.2


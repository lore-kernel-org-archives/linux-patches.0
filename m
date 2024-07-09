Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E37A19DF90;
	Tue,  9 Jul 2024 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541224; cv=none; b=Jqv+54y72RG6Kg5kaSnfzm5QQcIzNiSO1D0ZR7q9lBbDkBG1fYU2/OeJhCyqOi0tnP2m+P1vSVAai7pjZ10vGsAXphCmWDUN0JpR3FqhXoS+By9jrsItEzW9X/Rk3dk4NrJrwg9LnvzKvfOFJ+IvdUch0sn3sEJMBnX5KSbNnUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541224; c=relaxed/simple;
	bh=iiJUOVDVh31Jzvb1F9EYN95d7LmQfKBU9rUWA5eyDZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kohf8RExCWg1SQH6x1OPoePHLd0+XA0pGPByufz6ItWG/uaScVgKc8NTDLnlKTMhM14W7RQ8cGBCXSZDU1PZNCY1vkwA6gewxJkPuKU+r6Jq+l+eY1ec/nA3hI8aznE6HCp2D291iW+c4NRPXtpHtLPL2ACTaJerVX5H47eG5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHXkKwez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHXkKwez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD273C32782;
	Tue,  9 Jul 2024 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541224;
	bh=iiJUOVDVh31Jzvb1F9EYN95d7LmQfKBU9rUWA5eyDZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHXkKwezlEcs9yOy6p9FyQ8CMS2Xu6M+ImNWI3xg9n1Q+mCjvlGDXMJmT9DfrzlTH
	 r63H6FkF6P+q5q2mfoASvz/ekmvYzDF2C4L+Q5hrORFQTFZXLQINwLVsH0vrkvH4nG
	 A/7hTHNXFj/dutJtMeKqujW8j1VkELbZG9LkmTmrr/RkyEY3rONtXma+okaeWl6I/g
	 7mt2MHCa1RzuDO1Dw/fjmthtD5AQtbJsHyNLokEHEqB4Djm629ojGGQoml8nqy4yUy
	 x0+P6BWc6K/LimRJxeZ32EjWcIzzigratd5370r7foNvCp4826XmnHFhIwB8ZG+6hl
	 AGK7Qi7u27vOw==
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
Subject: [PATCH v2 09/13] rust: start supporting several `bindgen` versions
Date: Tue,  9 Jul 2024 18:06:04 +0200
Message-ID: <20240709160615.998336-10-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With both the workaround for `bindgen` 0.69.0 and the warning about
0.66.0 and 0.66.1 in place, start supporting several `bindgen` versions,
like it was done for the Rust compiler in a previous patch.

All other versions, including the latest 0.69.4, build without errors.

The `bindgen` project, like Rust, has also agreed to have the kernel
in their CI [1] -- thanks! This should help both projects: `bindgen`
will be able to detect early issues like those mentioned above, and the
kernel will be very likely build with new releases (at least for the
basic configuration being tested).

Link: https://github.com/rust-lang/rust-bindgen/pull/2851 [1]
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
v2:
  - Update suggested `cargo` command to just install the latest, i.e.
    removing the `--version` flag, following the same pattern as Finn's
    suggestion to use `stable `for the `rustup` command.

 Documentation/rust/quick-start.rst | 7 ++++---
 scripts/rust_is_available.sh       | 8 --------
 scripts/rust_is_available_test.py  | 5 -----
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index 5ea8c8914942..66cefbab8f9a 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -107,11 +107,12 @@ bindgen
 *******

 The bindings to the C side of the kernel are generated at build time using
-the ``bindgen`` tool. A particular version is required.
+the ``bindgen`` tool.

-Install it via (note that this will download and build the tool from source)::
+Install it, for instance, via (note that this will download and build the tool
+from source)::

-	cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen-cli
+	cargo install --locked bindgen-cli

 ``bindgen`` uses the ``clang-sys`` crate to find a suitable ``libclang`` (which
 may be linked statically, dynamically or loaded at runtime). By default, the
diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 1881e8f2a2b9..4531f9dd19d3 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -161,14 +161,6 @@ if [ "$rust_bindings_generator_cversion" -lt "$rust_bindings_generator_min_cvers
 	echo >&2 "***"
 	exit 1
 fi
-if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cversion" ]; then
-	echo >&2 "***"
-	echo >&2 "*** Rust bindings generator '$BINDGEN' is too new. This may or may not work."
-	echo >&2 "***   Your version:     $rust_bindings_generator_version"
-	echo >&2 "***   Expected version: $rust_bindings_generator_min_version"
-	echo >&2 "***"
-	warning=1
-fi

 # Check that the `libclang` used by the Rust bindings generator is suitable.
 #
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index 0481aab862ec..d6d54b7ea42a 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -231,11 +231,6 @@ else:
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
         self.assertIn(f"Rust bindings generator '{bindgen}' is too old.", result.stderr)

-    def test_bindgen_new_version(self):
-        bindgen = self.generate_bindgen_version("bindgen 0.999.0")
-        result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })
-        self.assertIn(f"Rust bindings generator '{bindgen}' is too new. This may or may not work.", result.stderr)
-
     def test_bindgen_libclang_failure(self):
         bindgen = self.generate_bindgen_libclang_failure()
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
--
2.45.2

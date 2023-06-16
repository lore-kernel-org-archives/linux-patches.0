Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F197C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 00:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA06C433CA;
	Fri, 16 Jun 2023 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686874617;
	bh=1TOdHb4awwmt33Y2juISrDKX0ZSbj4m/jNHG4AXa3h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j798rhKkKHglydpWr9mK5/3UgZ1jtvcRUJ8DYg1uYFDFdaU1lNH+fUmtvVad8FEsz
	 3VA805uGEmWh6nfTBIXxQgULRenQCk4GEFymOXp6MVDNoPrqA6INQy+mqpBpafABdc
	 bqWF2jYWHl/UBgnsloxtvGdzJbRt10rdKS2Z2+Bd2CX2ryJUxp3AQ6iBYOOPCg3EOg
	 atOm+PjM2xmvAmhVUCbIEdq0Pr6QLpRxYQSCDuhLvjFWAUurQNmWVWJv47vhkCYSEp
	 ok8uB/GPf95kXba80olVD9sNWbds36FgouqhHkN6UwkDHq+hEr7ks0EsUo9gf3nRpv
	 3ZfGZDSIJS0cQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	linux-kbuild@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 01/11] kbuild: rust_is_available: remove -v option
Date: Fri, 16 Jun 2023 02:16:21 +0200
Message-ID: <20230616001631.463536-2-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-1-ojeda@kernel.org>
References: <20230616001631.463536-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

The -v option is passed when this script is invoked from Makefile,
but not when invoked from Kconfig.

As you can see in scripts/Kconfig.include, the 'success' macro suppresses
stdout and stderr anyway, so this script does not need to be quiet.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230109061436.3146442-1-masahiroy@kernel.org
[ Reworded prefix to match the others in the patch series. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile                     |  4 +-
 scripts/rust_is_available.sh | 96 +++++++++++++++---------------------
 2 files changed, 42 insertions(+), 58 deletions(-)

diff --git a/Makefile b/Makefile
index 0d3a9d3e73c1..f0c50c7bd6d2 100644
--- a/Makefile
+++ b/Makefile
@@ -1289,7 +1289,7 @@ prepare0: archprepare
 # All the preparing..
 prepare: prepare0
 ifdef CONFIG_RUST
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/rust_is_available.sh -v
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/rust_is_available.sh
 	$(Q)$(MAKE) $(build)=rust
 endif
 
@@ -1823,7 +1823,7 @@ $(DOC_TARGETS):
 # "Is Rust available?" target
 PHONY += rustavailable
 rustavailable:
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/rust_is_available.sh -v && echo "Rust is available!"
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/rust_is_available.sh && echo "Rust is available!"
 
 # Documentation target
 #
diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index aebbf1913970..f43a010eaf30 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -2,8 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Tests whether a suitable Rust toolchain is available.
-#
-# Pass `-v` for human output and more checks (as warnings).
 
 set -e
 
@@ -23,21 +21,17 @@ get_canonical_version()
 
 # Check that the Rust compiler exists.
 if ! command -v "$RUSTC" >/dev/null; then
-	if [ "$1" = -v ]; then
-		echo >&2 "***"
-		echo >&2 "*** Rust compiler '$RUSTC' could not be found."
-		echo >&2 "***"
-	fi
+	echo >&2 "***"
+	echo >&2 "*** Rust compiler '$RUSTC' could not be found."
+	echo >&2 "***"
 	exit 1
 fi
 
 # Check that the Rust bindings generator exists.
 if ! command -v "$BINDGEN" >/dev/null; then
-	if [ "$1" = -v ]; then
-		echo >&2 "***"
-		echo >&2 "*** Rust bindings generator '$BINDGEN' could not be found."
-		echo >&2 "***"
-	fi
+	echo >&2 "***"
+	echo >&2 "*** Rust bindings generator '$BINDGEN' could not be found."
+	echo >&2 "***"
 	exit 1
 fi
 
@@ -53,16 +47,14 @@ rust_compiler_min_version=$($min_tool_version rustc)
 rust_compiler_cversion=$(get_canonical_version $rust_compiler_version)
 rust_compiler_min_cversion=$(get_canonical_version $rust_compiler_min_version)
 if [ "$rust_compiler_cversion" -lt "$rust_compiler_min_cversion" ]; then
-	if [ "$1" = -v ]; then
-		echo >&2 "***"
-		echo >&2 "*** Rust compiler '$RUSTC' is too old."
-		echo >&2 "***   Your version:    $rust_compiler_version"
-		echo >&2 "***   Minimum version: $rust_compiler_min_version"
-		echo >&2 "***"
-	fi
+	echo >&2 "***"
+	echo >&2 "*** Rust compiler '$RUSTC' is too old."
+	echo >&2 "***   Your version:    $rust_compiler_version"
+	echo >&2 "***   Minimum version: $rust_compiler_min_version"
+	echo >&2 "***"
 	exit 1
 fi
-if [ "$1" = -v ] && [ "$rust_compiler_cversion" -gt "$rust_compiler_min_cversion" ]; then
+if [ "$rust_compiler_cversion" -gt "$rust_compiler_min_cversion" ]; then
 	echo >&2 "***"
 	echo >&2 "*** Rust compiler '$RUSTC' is too new. This may or may not work."
 	echo >&2 "***   Your version:     $rust_compiler_version"
@@ -82,16 +74,14 @@ rust_bindings_generator_min_version=$($min_tool_version bindgen)
 rust_bindings_generator_cversion=$(get_canonical_version $rust_bindings_generator_version)
 rust_bindings_generator_min_cversion=$(get_canonical_version $rust_bindings_generator_min_version)
 if [ "$rust_bindings_generator_cversion" -lt "$rust_bindings_generator_min_cversion" ]; then
-	if [ "$1" = -v ]; then
-		echo >&2 "***"
-		echo >&2 "*** Rust bindings generator '$BINDGEN' is too old."
-		echo >&2 "***   Your version:    $rust_bindings_generator_version"
-		echo >&2 "***   Minimum version: $rust_bindings_generator_min_version"
-		echo >&2 "***"
-	fi
+	echo >&2 "***"
+	echo >&2 "*** Rust bindings generator '$BINDGEN' is too old."
+	echo >&2 "***   Your version:    $rust_bindings_generator_version"
+	echo >&2 "***   Minimum version: $rust_bindings_generator_min_version"
+	echo >&2 "***"
 	exit 1
 fi
-if [ "$1" = -v ] && [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cversion" ]; then
+if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cversion" ]; then
 	echo >&2 "***"
 	echo >&2 "*** Rust bindings generator '$BINDGEN' is too new. This may or may not work."
 	echo >&2 "***   Your version:     $rust_bindings_generator_version"
@@ -110,13 +100,11 @@ bindgen_libclang_min_version=$($min_tool_version llvm)
 bindgen_libclang_cversion=$(get_canonical_version $bindgen_libclang_version)
 bindgen_libclang_min_cversion=$(get_canonical_version $bindgen_libclang_min_version)
 if [ "$bindgen_libclang_cversion" -lt "$bindgen_libclang_min_cversion" ]; then
-	if [ "$1" = -v ]; then
-		echo >&2 "***"
-		echo >&2 "*** libclang (used by the Rust bindings generator '$BINDGEN') is too old."
-		echo >&2 "***   Your version:    $bindgen_libclang_version"
-		echo >&2 "***   Minimum version: $bindgen_libclang_min_version"
-		echo >&2 "***"
-	fi
+	echo >&2 "***"
+	echo >&2 "*** libclang (used by the Rust bindings generator '$BINDGEN') is too old."
+	echo >&2 "***   Your version:    $bindgen_libclang_version"
+	echo >&2 "***   Minimum version: $bindgen_libclang_min_version"
+	echo >&2 "***"
 	exit 1
 fi
 
@@ -125,21 +113,19 @@ fi
 #
 # In the future, we might be able to perform a full version check, see
 # https://github.com/rust-lang/rust-bindgen/issues/2138.
-if [ "$1" = -v ]; then
-	cc_name=$($(dirname $0)/cc-version.sh "$CC" | cut -f1 -d' ')
-	if [ "$cc_name" = Clang ]; then
-		clang_version=$( \
-			LC_ALL=C "$CC" --version 2>/dev/null \
-				| sed -nE '1s:.*version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
-		)
-		if [ "$clang_version" != "$bindgen_libclang_version" ]; then
-			echo >&2 "***"
-			echo >&2 "*** libclang (used by the Rust bindings generator '$BINDGEN')"
-			echo >&2 "*** version does not match Clang's. This may be a problem."
-			echo >&2 "***   libclang version: $bindgen_libclang_version"
-			echo >&2 "***   Clang version:    $clang_version"
-			echo >&2 "***"
-		fi
+cc_name=$($(dirname $0)/cc-version.sh "$CC" | cut -f1 -d' ')
+if [ "$cc_name" = Clang ]; then
+	clang_version=$( \
+		LC_ALL=C "$CC" --version 2>/dev/null \
+			| sed -nE '1s:.*version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
+	)
+	if [ "$clang_version" != "$bindgen_libclang_version" ]; then
+		echo >&2 "***"
+		echo >&2 "*** libclang (used by the Rust bindings generator '$BINDGEN')"
+		echo >&2 "*** version does not match Clang's. This may be a problem."
+		echo >&2 "***   libclang version: $bindgen_libclang_version"
+		echo >&2 "***   Clang version:    $clang_version"
+		echo >&2 "***"
 	fi
 fi
 
@@ -150,11 +136,9 @@ rustc_sysroot=$("$RUSTC" $KRUSTFLAGS --print sysroot)
 rustc_src=${RUST_LIB_SRC:-"$rustc_sysroot/lib/rustlib/src/rust/library"}
 rustc_src_core="$rustc_src/core/src/lib.rs"
 if [ ! -e "$rustc_src_core" ]; then
-	if [ "$1" = -v ]; then
-		echo >&2 "***"
-		echo >&2 "*** Source code for the 'core' standard library could not be found"
-		echo >&2 "*** at '$rustc_src_core'."
-		echo >&2 "***"
-	fi
+	echo >&2 "***"
+	echo >&2 "*** Source code for the 'core' standard library could not be found"
+	echo >&2 "*** at '$rustc_src_core'."
+	echo >&2 "***"
 	exit 1
 fi
-- 
2.41.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7216F7C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 00:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20220C433C9;
	Fri, 16 Jun 2023 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686874631;
	bh=cgdU9EGPRg6prCiiXBlnJGZt5RUNOs2rhZy64y+yRgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy2ENEAr/f8o6ANqBrRm6AEU4+yZtU9A/j7+UT5Sff8RLmebqkp0vQSBp/eCF15pH
	 s8aCj7Lb/siKDnQcXqOUVMYMZ34TOxSKP4Ym2WRFR7/jirD+RxVoXilgirqxD7/J50
	 519N1mXDhUGFqXTasW+85yF03Y68AQ4DABOrhWgJDxX2Te5l8AFKO6OR/2GS7q5BkD
	 xwjRKGVE/obw9oQARJYlZPdA050EWfOse9LiMn/ORztl6jmTnbSu67EIV0Ye/nzrmV
	 DXdD3uVIsUCusggpYa9EZ3KT5T6axCUYzxFVk7ICTXBtZKa0LMaBWlQMtnJF9N+wTp
	 u8zjvh7D4hECQ==
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
	patches@lists.linux.dev,
	Finn Behrens <fin@nyantec.com>
Subject: [PATCH v2 04/11] kbuild: rust_is_available: print docs reference
Date: Fri, 16 Jun 2023 02:16:24 +0200
Message-ID: <20230616001631.463536-5-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-1-ojeda@kernel.org>
References: <20230616001631.463536-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

People trying out the Rust support in the kernel may get
warnings and errors from `scripts/rust_is_available.sh`
from the `rustavailable` target or the build step.

Some of those users may be following the Quick Start guide,
but others may not (likely those getting warnings from
the build step instead of the target).

While the messages are fairly clear on what the problem is,
it may not be clear how to solve the particular issue,
especially for those not aware of the documentation.

We could add all sorts of details on the script for each one,
but it is better to point users to the documentation instead,
where it is easily readable in different formats. It also
avoids duplication.

Thus add a reference to the documentation whenever the script
fails or there is at least a warning.

Reviewed-by: Finn Behrens <fin@nyantec.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/rust_is_available.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 0c9be438e4cd..6b8131d5b547 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -19,6 +19,20 @@ get_canonical_version()
 	echo $((100000 * $1 + 100 * $2 + $3))
 }
 
+# Print a reference to the Quick Start guide in the documentation.
+print_docs_reference()
+{
+	echo >&2 "***"
+	echo >&2 "*** Please see Documentation/rust/quick-start.rst for details"
+	echo >&2 "*** on how to set up the Rust support."
+	echo >&2 "***"
+}
+
+# If the script fails for any reason, or if there was any warning, then
+# print a reference to the documentation on exit.
+warning=0
+trap 'if [ $? -ne 0 ] || [ $warning -ne 0 ]; then print_docs_reference; fi' EXIT
+
 # Check that the Rust compiler exists.
 if ! command -v "$RUSTC" >/dev/null; then
 	echo >&2 "***"
@@ -60,6 +74,7 @@ if [ "$rust_compiler_cversion" -gt "$rust_compiler_min_cversion" ]; then
 	echo >&2 "***   Your version:     $rust_compiler_version"
 	echo >&2 "***   Expected version: $rust_compiler_min_version"
 	echo >&2 "***"
+	warning=1
 fi
 
 # Check that the Rust bindings generator is suitable.
@@ -87,6 +102,7 @@ if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cvers
 	echo >&2 "***   Your version:     $rust_bindings_generator_version"
 	echo >&2 "***   Expected version: $rust_bindings_generator_min_version"
 	echo >&2 "***"
+	warning=1
 fi
 
 # Check that the `libclang` used by the Rust bindings generator is suitable.
@@ -126,6 +142,7 @@ if [ "$cc_name" = Clang ]; then
 		echo >&2 "***   libclang version: $bindgen_libclang_version"
 		echo >&2 "***   Clang version:    $clang_version"
 		echo >&2 "***"
+		warning=1
 	fi
 fi
 
-- 
2.41.0


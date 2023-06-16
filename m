Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EDE7C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 00:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B9EC433CD;
	Fri, 16 Jun 2023 00:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686874650;
	bh=cWinNtrRNqE72MtzHUXpxkJuCIniJrJ/uXuToYRgE8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4pjlbreSJh9xy6s1BVW1nZNWwe/mqd4ae8t1KeqbwB3Ysvqq1EGaav9keNOgmjsP
	 ovdjamLawMDqyYPc60zbyVGqeE6ksaaCP0+QsqurNC3ln7zmMY3453C1HjzVqF6jg7
	 4Dn/mw1QLIjnJ52Xp9kyOq15f6CPoYYu///mZ7jnEP+8Jf42Y78bqCwJ6YIDcCDr9Q
	 V64YSPbKv0IeJLlbaqJxfbXUknmCoGJ0CtfQlCn1y86nX7FobYO2NgY21J5VBtbrEp
	 Sj/WTRvG7JKTfCXw06IkuhgXSJf1K3J4coLC6kmuh4qwjKcL2atUexEQ3Wif7z7ydl
	 50hQVfO2T/qEg==
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
Subject: [PATCH v2 08/11] kbuild: rust_is_available: normalize version matching
Date: Fri, 16 Jun 2023 02:16:28 +0200
Message-ID: <20230616001631.463536-9-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-1-ojeda@kernel.org>
References: <20230616001631.463536-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to match the version string, `sed` is used in a couple
cases, and `grep` and `head` in a couple others.

Make the script more consistent and easier to understand by
using the same method, `sed`, for all of them.

This makes the version matching also a bit more strict for
the changed cases, since the strings `rustc ` and `bindgen `
will now be required, which should be fine since `rustc`
complains if one attempts to call it with another program
name, and `bindgen` uses a hardcoded string.

In addition, clarify why one of the existing `sed` commands
does not provide an address like the others.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/rust_is_available.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 810691af66eb..b7e0781fdea9 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -83,8 +83,7 @@ fi
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
 rust_compiler_version=$( \
 	LC_ALL=C "$RUSTC" --version 2>/dev/null \
-		| head -n 1 \
-		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
+		| sed -nE '1s:.*rustc ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 )
 rust_compiler_min_version=$($min_tool_version rustc)
 rust_compiler_cversion=$(get_canonical_version $rust_compiler_version)
@@ -111,8 +110,7 @@ fi
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
 rust_bindings_generator_version=$( \
 	LC_ALL=C "$BINDGEN" --version 2>/dev/null \
-		| head -n 1 \
-		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
+		| sed -nE '1s:.*bindgen ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 )
 rust_bindings_generator_min_version=$($min_tool_version bindgen)
 rust_bindings_generator_cversion=$(get_canonical_version $rust_bindings_generator_version)
@@ -155,6 +153,9 @@ fi
 
 # `bindgen` returned successfully, thus use the output to check that the version
 # of the `libclang` found by the Rust bindings generator is suitable.
+#
+# Unlike other version checks, note that this one does not necessarily appear
+# in the first line of the output, thus no `sed` address is provided.
 bindgen_libclang_version=$( \
 	echo "$bindgen_libclang_output" \
 		| sed -nE 's:.*clang version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
-- 
2.41.0


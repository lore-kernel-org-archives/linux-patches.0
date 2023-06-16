Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2C7C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 00:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47CCC433C8;
	Fri, 16 Jun 2023 00:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686874622;
	bh=CG+nA737Ne3Ravt2rZwGSjf5nReCzoy15WvmtU+wHWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR3gCslZ4vHZLbRAmDnKtb5u2/yufUzYTAGEMOQQW/VbICIINE5k6cxPy6LY/3egY
	 9r+Ferze24Bqk9vhbg3jE95QIJ+CZ+hQI/zMUSaQzcPHbfLgUMZCkOqjwbkgX8DxcK
	 s4WTNY3jEJiBpZGXkIpLy+xOcMzDqNR026Sr6M0VzRBKga6OCq67RAUbsh+rfXXAC3
	 oms90zuaeA92CdqYFWQeVp77+B6WxjolQHGLJg8QsYO+OWtCqwYiIReG/3EKYAn/uz
	 g5P27JmMgNQMOgnSqaXia+I5jM1Mi2dE38CkrrACVxjaC52vQeZZnxkroIzzvxomBD
	 WRif/mxmxdNZw==
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
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v2 02/11] kbuild: rust_is_available: fix version check when CC has multiple arguments
Date: Fri, 16 Jun 2023 02:16:22 +0200
Message-ID: <20230616001631.463536-3-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-1-ojeda@kernel.org>
References: <20230616001631.463536-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Russell Currey <ruscur@russell.cc>

rust_is_available.sh uses cc-version.sh to identify which C compiler is
in use, as scripts/Kconfig.include does.  cc-version.sh isn't designed to
be able to handle multiple arguments in one variable, i.e. "ccache clang".
Its invocation in rust_is_available.sh quotes "$CC", which makes
$1 == "ccache clang" instead of the intended $1 == ccache & $2 == clang.

cc-version.sh could also be changed to handle having "ccache clang" as one
argument, but it only has the one consumer upstream, making it simpler to
fix the caller here.

Signed-off-by: Russell Currey <ruscur@russell.cc>
Fixes: 78521f3399ab ("scripts: add `rust_is_available.sh`")
Link: https://github.com/Rust-for-Linux/linux/pull/873
[ Reworded title prefix and reflow line to 75 columns. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/rust_is_available.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index f43a010eaf30..0c9be438e4cd 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -113,10 +113,10 @@ fi
 #
 # In the future, we might be able to perform a full version check, see
 # https://github.com/rust-lang/rust-bindgen/issues/2138.
-cc_name=$($(dirname $0)/cc-version.sh "$CC" | cut -f1 -d' ')
+cc_name=$($(dirname $0)/cc-version.sh $CC | cut -f1 -d' ')
 if [ "$cc_name" = Clang ]; then
 	clang_version=$( \
-		LC_ALL=C "$CC" --version 2>/dev/null \
+		LC_ALL=C $CC --version 2>/dev/null \
 			| sed -nE '1s:.*version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
 	)
 	if [ "$clang_version" != "$bindgen_libclang_version" ]; then
-- 
2.41.0


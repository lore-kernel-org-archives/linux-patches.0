Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CEA11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6B8C433C7;
	Mon, 11 Sep 2023 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444973;
	bh=CZDxD//SaIvTmrC0xp2qJTKM3qw5+LMoLp4MXL0ZSTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLRzoWYg60JqdH6jWKUS/tqWHCHT7YqHiUIzEB2wnrv/tO1gKSXjIaSV7oYVD9256
	 CXo54YoFwjGj0kg8slh3Hx85vT6EY/zOqC5jzNGmO+7BAKQ+nc/cyuK6NW4wPbeDt+
	 TGSP/Bz3QACz9eWKke20KuIt4NQzVKF2rVg23uZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	=?UTF-8?q?Fran=C3=A7ois=20Valenduc?= <francoisvalenduc@gmail.com>,
	Alexandru Radovici <msg4alex@gmail.com>,
	Matthew Leach <dev@mattleach.net>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/600] kbuild: rust_is_available: add check for `bindgen` invocation
Date: Mon, 11 Sep 2023 15:43:18 +0200
Message-ID: <20230911134638.477817303@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 52cae7f28ed6c3992489f16bb355f5b623f0912e ]

`scripts/rust_is_available.sh` calls `bindgen` with a special
header in order to check whether the `libclang` version in use
is suitable.

However, the invocation itself may fail if, for instance, `bindgen`
cannot locate `libclang`. This is fine for Kconfig (since the
script will still fail and therefore disable Rust as it should),
but it is pretty confusing for users of the `rustavailable` target
given the error will be unrelated:

    ./scripts/rust_is_available.sh: 21: arithmetic expression: expecting primary: "100000 *  + 100 *  + "
    make: *** [Makefile:1816: rustavailable] Error 2

Instead, run the `bindgen` invocation independently in a previous
step, saving its output and return code. If it fails, then show
the user a proper error message. Otherwise, continue as usual
with the saved output.

Since the previous patch we show a reference to the docs, and
the docs now explain how `bindgen` looks for `libclang`,
thus the error message can leverage the documentation, avoiding
duplication here (and making users aware of the setup guide in
the documentation).

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/rust-for-linux/CAKwvOdm5JT4wbdQQYuW+RT07rCi6whGBM2iUAyg8A1CmLXG6Nw@mail.gmail.com/
Reported-by: François Valenduc <francoisvalenduc@gmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/934
Reported-by: Alexandru Radovici <msg4alex@gmail.com>
Closes: https://github.com/Rust-for-Linux/linux/pull/921
Reported-by: Matthew Leach <dev@mattleach.net>
Closes: https://lore.kernel.org/rust-for-linux/20230507084116.1099067-1-dev@mattleach.net/
Fixes: 78521f3399ab ("scripts: add `rust_is_available.sh`")
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230616001631.463536-6-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/rust_is_available.sh | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 0c9be438e4cd3..c965895d80b97 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -90,8 +90,28 @@ if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cvers
 fi
 
 # Check that the `libclang` used by the Rust bindings generator is suitable.
+#
+# In order to do that, first invoke `bindgen` to get the `libclang` version
+# found by `bindgen`. This step may already fail if, for instance, `libclang`
+# is not found, thus inform the user in such a case.
+bindgen_libclang_output=$( \
+	LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null
+) || bindgen_libclang_code=$?
+if [ -n "$bindgen_libclang_code" ]; then
+	echo >&2 "***"
+	echo >&2 "*** Running '$BINDGEN' to check the libclang version (used by the Rust"
+	echo >&2 "*** bindings generator) failed with code $bindgen_libclang_code. This may be caused by"
+	echo >&2 "*** a failure to locate libclang. See output and docs below for details:"
+	echo >&2 "***"
+	echo >&2 "$bindgen_libclang_output"
+	echo >&2 "***"
+	exit 1
+fi
+
+# `bindgen` returned successfully, thus use the output to check that the version
+# of the `libclang` found by the Rust bindings generator is suitable.
 bindgen_libclang_version=$( \
-	LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null \
+	echo "$bindgen_libclang_output" \
 		| grep -F 'clang version ' \
 		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
 		| head -n 1 \
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A0519DF8C;
	Tue,  9 Jul 2024 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541220; cv=none; b=CL1pN3JbD8c72COI1dqawd+teq4hg9BNYutyDOrgX0dJx86jkYL/rY7fPxndfTlXKlK72B/ejUqWelMqIW1KsfkYoN6MUo4elBmTc+nTabmCgrmIy0Up4/0hgAO8vNBT6wxs7tMgAccfzK9mvS2IkGyam+r9lBkaJ4PMn/Yu91s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541220; c=relaxed/simple;
	bh=HQHUmdnOkscprt/iBjeV6ZSvrG1OA8cuTru0fUXpeso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQmw3SCPp6uhgfHKVpcTbkmeohX6chQcv0wEuzlb7vQ3VR74okHTiu4Dmnn2B90jU/+B0YU8Daz6ISPil0rEsO72zAp+s6UOtP5OBu6jhhJkK7mwgYmVXRu3w/XevI1W10UOM+Gi1ceAKuB5mofCbwG4Lsg6JrQp0XE0bXvfHIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhJp0cc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhJp0cc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC69C3277B;
	Tue,  9 Jul 2024 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541220;
	bh=HQHUmdnOkscprt/iBjeV6ZSvrG1OA8cuTru0fUXpeso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhJp0cc3RSAngRKtvICldpzZuCaQTdwzeVw3UcvwygHBmFsHireRnsMjAYyAnGcUA
	 ulMIXHqW7buyyl/04F0obX1dItNezOxSzgNP+MBL63KW1i/yWErF15yE/DiC4hXs2M
	 /vj4kuBK1dEx+IcLhL9Se8xti6UfABMUgR16kIkLkyCmv/zY32dKweHKzTKRVwKJHL
	 kHItIaNm9VCyhm+C6QIvLNobuVwIdJ225xiooHWw2Hc08kOv/Ik1BMp4yql7wtFxE5
	 CMhDXdqxJVIra7FXpmSSjzyF+3ao6bDcyAcC3SdPTGKw6qikv5HYwXotoDAG9Plf+C
	 5gyPGnf4Tzwkg==
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
	Finn Behrens <me@kloenk.dev>
Subject: [PATCH v2 08/13] rust: work around `bindgen` 0.69.0 issue
Date: Tue,  9 Jul 2024 18:06:03 +0200
Message-ID: <20240709160615.998336-9-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`bindgen` 0.69.0 contains a bug: `--version` does not work without
providing a header [1]:

    error: the following required arguments were not provided:
      <HEADER>

    Usage: bindgen <FLAGS> <OPTIONS> <HEADER> -- <CLANG_ARGS>...

Thus, in preparation for supporting several `bindgen` versions, work
around the issue by passing a dummy argument.

Include a comment so that we can remove the workaround in the future.

Link: https://github.com/rust-lang/rust-bindgen/pull/2678 [1]
Reviewed-by: Finn Behrens <me@kloenk.dev>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 init/Kconfig                 | 5 ++++-
 scripts/rust_is_available.sh | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index febdea2afc3b..94e20d3b99d4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1928,7 +1928,10 @@ config RUSTC_VERSION_TEXT
 config BINDGEN_VERSION_TEXT
 	string
 	depends on RUST
-	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) --version || echo n)
+	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
+	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
+	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
+	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) --version workaround-for-0.69.0 || echo n)
 
 #
 # Place an empty function call at each tracepoint site. Can be
diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 67cb900124cc..1881e8f2a2b9 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -121,8 +121,12 @@ fi
 # Check that the Rust bindings generator is suitable.
 #
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
+#
+# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
+# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
+# the minimum version is upgraded past that (0.69.1 already fixed the issue).
 rust_bindings_generator_output=$( \
-	LC_ALL=C "$BINDGEN" --version 2>/dev/null
+	LC_ALL=C "$BINDGEN" --version workaround-for-0.69.0 2>/dev/null
 ) || rust_bindings_generator_code=$?
 if [ -n "$rust_bindings_generator_code" ]; then
 	echo >&2 "***"
-- 
2.45.2


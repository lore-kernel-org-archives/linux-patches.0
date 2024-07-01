Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8CF16F830;
	Mon,  1 Jul 2024 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859041; cv=none; b=NRGlNvykHtoVVWJ5El9dwHri/ay43r44XI1xLg60qWwDtR1Y47uUYxAPg7yBGOhayNUQHoYR18H0rvKXJMQJOwCtzewV5J7uc9giSn6npf35Wp/zXT91ajD4lGmYDmRiLKm3ziOuOMzWDl55bir9CwSqqYhOwFy9l52bzQqX5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859041; c=relaxed/simple;
	bh=c9RLDd6qSSnktEco55Nlxx1015GlC0Y4G7PgHw0xbCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mka0oyM/b3apihKhWqHuC2GM0a8kY8orT+5d5wWp553cPqQx7uhnuc5G28SUdfBBueKdrDQBp3U0e2MEqQEYEDOzDreL9OYMIZUmBFzXSgB0uz0xK7/Bqms60bOsC7m1f0XNsj4Kp5XoxPG4FbpcKLmRoVvm5XabwgHzc0fcykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8swPgYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8swPgYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05CFC116B1;
	Mon,  1 Jul 2024 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859041;
	bh=c9RLDd6qSSnktEco55Nlxx1015GlC0Y4G7PgHw0xbCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8swPgYJ2g15BNbgEJnPnVTXGbkIQAkkOGFa2JosMlX1T8blY5D45vDnFpNO3fSMd
	 bpHfbjiKkAnYfr17EpfhS6tBhWB2fzoq3Ii1RAPqiuiuVFyZbRQwlbBIGCledDuqH8
	 S5OW/0cBjDGohnTilxiHxPXxRilpJ/8uyQgfWkqrM+nHy8yL7ZAQqagPhdHHLb01hy
	 evygfiCDwbznYjbQrHhoErhGABBbEzZtldL9s76R6/FE7bOwBCqEfkGIs/TeZyVNyV
	 Wnt+VKybr9IRJAMtO8yqX1v8pPa9Zu3nPqULifWGs/X9nm5F/nSlQ8ZoHhVAwNkH0g
	 M/i4lWwJw90BQ==
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
Subject: [PATCH 08/13] rust: work around `bindgen` 0.69.0 issue
Date: Mon,  1 Jul 2024 20:36:18 +0200
Message-ID: <20240701183625.665574-9-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
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
index 33bbd01ffe51..cfda8157dce9 100755
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


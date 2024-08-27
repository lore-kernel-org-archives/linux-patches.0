Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7D1C4EE6;
	Tue, 27 Aug 2024 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772204; cv=none; b=QgIZc4b0tPxLk9KJcgAzyW+w08W6IrEGq5Iynws5PM7he966KGBf936CM64Bk6DXPYzvqUelTlLpL7LJ8BJfSKxh7rkSQBuquJzEdU9RGsJeJxHChmtHrq9QYUINCq90AlNK2FsLU1uevjmY8cW6fgD2wfG82HwAfTTub/svMOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772204; c=relaxed/simple;
	bh=f6vj5LSp7guxAS8rOh6yxhn8WWnxKxVE41TD7sigPEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RW+m/nI7DMp/bfvuDY3MBaaBfz7tyAWPQKMsGMgEHxgjQah4T1MrFhpoDSY1K7atdp/su2czGMc5PZh3dzTg2YsSZGFa1GWotrnCCuFDDk9CAcoygQAeVgbO2u71Ghw25BK7BaDcpTk7smEYHQEExffJYxzOWUJwrbcqlelrhDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xymvl6aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xymvl6aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73304C61064;
	Tue, 27 Aug 2024 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772203;
	bh=f6vj5LSp7guxAS8rOh6yxhn8WWnxKxVE41TD7sigPEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xymvl6aIdENhgYgbAEhuYgOTd531kadEuthGrRsxl02WUTEzHOSB21jO5msMbfDSp
	 9BDtN1+qOqP9i76pufWDIEHHVX7Wo3KccCgmlLvSr78fi52gA6AKlPkqzXL1OD1kk3
	 nr2/T4Ate9Htpx+FnmM4GIihU37eWNGum8BtG0BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/321] rust: work around `bindgen` 0.69.0 issue
Date: Tue, 27 Aug 2024 16:37:33 +0200
Message-ID: <20240827143843.756859183@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 9e98db17837093cb0f4dcfcc3524739d93249c45 ]

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
Link: https://lore.kernel.org/r/20240709160615.998336-9-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 5ce86c6c8613 ("rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig                 | 5 ++++-
 scripts/rust_is_available.sh | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 4cd3fc82b09e5..19de862768239 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1947,7 +1947,10 @@ config RUSTC_VERSION_TEXT
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
index 1c9081d9dbea7..141644c164636 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -76,8 +76,12 @@ fi
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
2.43.0




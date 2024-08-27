Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D01E520;
	Tue, 27 Aug 2024 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771231; cv=none; b=J/B5GnjpEdC/5Mni6vjCvAOUZEQPHzld2Zqkh9q6710um1RdF39mHYvmx0jpAJCNe/ApWBfk7gueNMlkA/A73U3Oq1vpK+vIh2MMxcuBV5RJNTzk6NumzUyaPekN4iJevRjwzMtpyEtiA1+dmR9MN+FtfFMx6yeD6jFg/aP1lg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771231; c=relaxed/simple;
	bh=M4Oig4K/4QXzR3E9wqoEw0Pd8OXUVsGqsyZK9z4ANNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyXYSDtADSQ/VrvxMYGYxLJyTmBffIFvxLiym5HLAKuSN3iWfdTUs0Pp4fzLOVuyQxWeGzuITAoOidSuhf0VQIcI14AEGQ3Eb8gVDSZrI4xeuxf0dFSDbbIhVL3S1Tg+lpRDvYYMBRgMIy+nnmfT0nGdSeV306NE5vHA2Fen/ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VklIDWk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VklIDWk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BCFC4AF55;
	Tue, 27 Aug 2024 15:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771231;
	bh=M4Oig4K/4QXzR3E9wqoEw0Pd8OXUVsGqsyZK9z4ANNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VklIDWk1YRjqyZaqjwuRcm27LURmwWrPsu/HcA7FiRYa7iUuwOD+15GYnXf7vn0IW
	 pUsrdU7LgbQqOBpg6gkKssZ95A1Uyn/YKmkOGvjnhmOFBgFc4RoVNxExAJK8fO7Ayt
	 xdxxcLXZhrIP/hjoAUJ9ocX0HPaPBKoBE0wSTTdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 125/273] rust: work around `bindgen` 0.69.0 issue
Date: Tue, 27 Aug 2024 16:37:29 +0200
Message-ID: <20240827143838.162868859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e97693b675f2..b7683506264f0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1911,7 +1911,10 @@ config RUSTC_VERSION_TEXT
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
index 117018946b577..a6fdcf13e0e53 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -129,8 +129,12 @@ fi
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




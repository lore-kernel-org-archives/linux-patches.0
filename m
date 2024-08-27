Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D84DDC1;
	Tue, 27 Aug 2024 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770118; cv=none; b=oxhM0+CmQN5EWd/urAdXxIGuzl8yB7NTg/waqw3uc+8v6Gt/MKL9TV5I5i0rVIla7fSyZKAIZE+P3SE4qLsQQnd1SLv5ytIdIB6EFFZ2Wg+NbfkKk1DXjic5bTzE7q1Yh3lX3omiByZR5UZDjNtEt4RUddbrR8YA3s6sUIWizBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770118; c=relaxed/simple;
	bh=tDi14tmJw+BAMVmquumWWE/SRWrRemWDdOvStwA5qJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzI3EGbVLtmuGARD/5sY65qHCI5gEY5IP052ESvadMtoJHY74dfqheHnNSONxdnO/1kvwK1uO9cG85Cqye/Nesw3yjDxGHG8FaOcxR3PJjFOxLvtJQffQuRQ3h+UXIv79zE+JpBwqb1ahZQWtE7ZlCthAQAPSi0GzacMX8xwNPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWUDheso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWUDheso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3922C61047;
	Tue, 27 Aug 2024 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770117;
	bh=tDi14tmJw+BAMVmquumWWE/SRWrRemWDdOvStwA5qJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWUDhesobqM6x0GaYj/08FDjlalzH4b6A2n5Of/6wOk58xA9LCKzGTXc/KXYXA1CH
	 UR4ZHRYO3sEgEhEWdPHMi/Jw39ePac3JJvzZl4Izct8T2t0Nm1TZAYCcTihWn+7QDu
	 VnfjJ6MtjUxB7d4ZPgcXzHEhLGaj/b/6MkbpQMHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/341] rust: work around `bindgen` 0.69.0 issue
Date: Tue, 27 Aug 2024 16:36:04 +0200
Message-ID: <20240827143848.480055718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e173364abd6c0..777113dceca55 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1921,7 +1921,10 @@ config RUSTC_VERSION_TEXT
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




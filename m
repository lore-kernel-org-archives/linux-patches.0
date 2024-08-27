Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA3F1C3F19;
	Tue, 27 Aug 2024 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771234; cv=none; b=HaAF5mu3wofGWwoTEnJyK5V+NU+cNR+1vcsyLB+2fs86ut/loTKlN8qBMt+v0oYOyE55nWxKz4oh6cX14Tfm78n7OgA0fwgd7NDb+GHr2CKpOkItYo6Tkozm7y4kapT3ZDpFMelX5QIO2AmDi5s0MoFeOTq7r8pSRUW3BTNpksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771234; c=relaxed/simple;
	bh=1LoZ0vPb1E28HvZrETJT5nRFVfuwb6mq6xNieWtimN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaG7gwdYyW9ExTLv1nDX4gk3S9obB3tSoZa+hYYld/hKwczM4BbdfVTRRktsGZglfelrBAwnv1tX4Q2oet50qFgVzIFPKZDIKvipTg5LTg3nWHB4lHcbqOXgQOziPUemh12/QQITg0zodRWhx5ygTT9lJP5COvE7O+W5hSxyttM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a73jH0e8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a73jH0e8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E344FC4AF55;
	Tue, 27 Aug 2024 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771234;
	bh=1LoZ0vPb1E28HvZrETJT5nRFVfuwb6mq6xNieWtimN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a73jH0e8hOqo//4TvVMiaydJynXUgJfp/VOvuRdaChN3Vfa+nXP8zT85oRwahD3Bg
	 mdtKH3U7t3hTB6LlKBIXlLIRd3zhF6J6x7FCun9BrvioygpmUFxzZa2rXQjJeRe7Kq
	 eUGZInJ7DdP9eaclrpJ23GB5z9wwgWnuzyTgtZnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 126/273] rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
Date: Tue, 27 Aug 2024 16:37:30 +0200
Message-ID: <20240827143838.201137985@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 5ce86c6c861352c9346ebb5c96ed70cb67414aa3 ]

While this is a somewhat unusual case, I encountered odd error messages
when I ran Kconfig in a foreign architecture chroot.

  $ make allmodconfig
  sh: 1: rustc: not found
  sh: 1: bindgen: not found
  #
  # configuration written to .config
  #

The successful execution of 'command -v rustc' does not necessarily mean
that 'rustc --version' will succeed.

  $ sh -c 'command -v rustc'
  /home/masahiro/.cargo/bin/rustc
  $ sh -c 'rustc --version'
  sh: 1: rustc: not found

Here, 'rustc' is built for x86, and I ran it in an arm64 system.

The current code:

  command -v $(RUSTC) >/dev/null 2>&1 && $(RUSTC) --version || echo n

can be turned into:

  command -v $(RUSTC) >/dev/null 2>&1 && $(RUSTC) --version 2>/dev/null || echo n

However, I did not understand the necessity of 'command -v $(RUSTC)'.

I simplified it to:

  $(RUSTC) --version 2>/dev/null || echo n

Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20240727140302.1806011-1-masahiroy@kernel.org
[ Rebased on top of v6.11-rc1. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b7683506264f0..051cbb22968bd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1906,7 +1906,7 @@ config RUST
 config RUSTC_VERSION_TEXT
 	string
 	depends on RUST
-	default $(shell,command -v $(RUSTC) >/dev/null 2>&1 && $(RUSTC) --version || echo n)
+	default $(shell,$(RUSTC) --version 2>/dev/null || echo n)
 
 config BINDGEN_VERSION_TEXT
 	string
@@ -1914,7 +1914,7 @@ config BINDGEN_VERSION_TEXT
 	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
 	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
 	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
-	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) --version workaround-for-0.69.0 || echo n)
+	default $(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null || echo n)
 
 #
 # Place an empty function call at each tracepoint site. Can be
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4567538DC7;
	Tue, 27 Aug 2024 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770121; cv=none; b=mN7gczYguKO5YDk4ZnAMurIwaf8hefMKGtEMTLyGJqNa5OZoZ+ReT4HFtlw9K6MhmepFJr3ADxUxzcQfFj9RxWgW56UO8w95P9mclyty6Vb9id9HbfH52im4lHA1B+X/qP0hyrEFRqIp7mxCfv5Mpl3V6Ah07JGIGdFgq+5vss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770121; c=relaxed/simple;
	bh=PtlrwdTXBHZ7WdmeFVbfLnm9DzGRQotquQz67hU3/iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEQKe4CF3irKj2xf/S3b7TM7eK98642xNM6/D0CL8Rz38PmhOgaHoQkOWfUdHeCur6fXpeT6sG/ySiUxF+MuwYXJi4Z9S3dEDcQLc6+ep6BBuY3LQmC76FIb7szDqGwtGGK/MT245ae+k6uPtg0JTcqvfKmPJG3qa0uBuJMKDeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQs4cDb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQs4cDb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD344C61047;
	Tue, 27 Aug 2024 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770121;
	bh=PtlrwdTXBHZ7WdmeFVbfLnm9DzGRQotquQz67hU3/iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQs4cDb6BS5ExGHtrok//7yTktERSpJtCwGYzOKt6VHsDrPzAWmMqZMX/LGJ0mhWX
	 nU95Tip1L9tF9eM3fjBk6MlJCYC8VPPbnk1elqeNnKXPl1csSkRR7EA49Mk2JbHsTS
	 UxSmcX23E2odCioEwdLPxaJ56/MlgeHn1TAERnDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/341] rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
Date: Tue, 27 Aug 2024 16:36:05 +0200
Message-ID: <20240827143848.517913587@linuxfoundation.org>
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
index 777113dceca55..b5bcc863bf608 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1916,7 +1916,7 @@ config RUST
 config RUSTC_VERSION_TEXT
 	string
 	depends on RUST
-	default $(shell,command -v $(RUSTC) >/dev/null 2>&1 && $(RUSTC) --version || echo n)
+	default $(shell,$(RUSTC) --version 2>/dev/null || echo n)
 
 config BINDGEN_VERSION_TEXT
 	string
@@ -1924,7 +1924,7 @@ config BINDGEN_VERSION_TEXT
 	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
 	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
 	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
-	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) --version workaround-for-0.69.0 || echo n)
+	default $(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null || echo n)
 
 #
 # Place an empty function call at each tracepoint site. Can be
-- 
2.43.0




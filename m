Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE361C5792;
	Tue, 27 Aug 2024 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772207; cv=none; b=bd6ABSAvgB4PvZ1mqoiImRKA+FCVZV3M483Mi0KL63QdKJxZmV1088GgmDdM9NP81ZKpJz7/NGFBgDL+FE9kXjNhA+MbRWMfhDCPALfVM3Em8mqgOSOtIe44w7bv03gperpOciC5SAjefikmeHrSPjWiIsBnT+Ubn97Kfh3TVoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772207; c=relaxed/simple;
	bh=H43b3knOD0FE49V7V1p7NBfC9bClP9vzsdefcml+v04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F01qqO2WSw3x7ElT0zIgzUMBLKOmutFFb6osbypQQWfUeM0PhjHCtrMmwR0aqP7N0vjRY/xq0OjhK6njRYptr2NH+EmFYA4QO2t5ygCkxzbDPb79B5C2G8267GT8ERRyz5q2VdvNSJsMgdDskHmG9wOAxMoe1xj0QQ6gAyg2s7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEjnIALc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEjnIALc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1E3C61062;
	Tue, 27 Aug 2024 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772207;
	bh=H43b3knOD0FE49V7V1p7NBfC9bClP9vzsdefcml+v04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEjnIALcQGycsmOz0qqT3XU3W5LlUGS0vV7GZJEauP1+PhdiaFzVU3cGySlUW5IjM
	 0icbm0RFNeWikSa3a/x7NGwxOKFkvUbjI0D8QQZZyyjbVFYuofP5YdLECdS6TgmMMd
	 Jo4Ang9OUmFZlaXBrlr/IZyiNLalJKZhE1vChZMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/321] rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
Date: Tue, 27 Aug 2024 16:37:34 +0200
Message-ID: <20240827143843.795264988@linuxfoundation.org>
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
index 19de862768239..85e8bf76aeccb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1942,7 +1942,7 @@ config RUST
 config RUSTC_VERSION_TEXT
 	string
 	depends on RUST
-	default $(shell,command -v $(RUSTC) >/dev/null 2>&1 && $(RUSTC) --version || echo n)
+	default $(shell,$(RUSTC) --version 2>/dev/null || echo n)
 
 config BINDGEN_VERSION_TEXT
 	string
@@ -1950,7 +1950,7 @@ config BINDGEN_VERSION_TEXT
 	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
 	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
 	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
-	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) --version workaround-for-0.69.0 || echo n)
+	default $(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null || echo n)
 
 #
 # Place an empty function call at each tracepoint site. Can be
-- 
2.43.0




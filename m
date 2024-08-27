Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD30D1E520;
	Tue, 27 Aug 2024 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771238; cv=none; b=WkBSV9wLY3o3J26hyFPsLEiUP6/Zqel+fSLIRN4xJCKy9ND34M378A8iELOjOZIQZpp7SrOPgUQPOzzrf+GvaGlRb8tzQ9WKIzsyuKXK2WZYYlLNSx3WGvkvOfxNlbEVpeWrCIttwlK7rKElfC187skp0rV382k+FNdQKD1ebdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771238; c=relaxed/simple;
	bh=pcwwzmzmDVQa/NTHxlZmrft2Iw23T64s8MedKO4XgNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7pHMCuZyaeIoKTFmmzAL5ZfOWuGnzJMYiRCtyQ7q1hdU0oo8jktkjcWuEoomfp/WqUCm1v3MZonzylPXPh9BcoPbxikx46k2adbqTWCekBQgJoPY2tB7xuHViPtHeiGBEP+7xEsQs8UExHwPLQFVPz5G/WTRaD4cjsJyLDcDEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCISrxSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCISrxSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE05C4AF55;
	Tue, 27 Aug 2024 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771237;
	bh=pcwwzmzmDVQa/NTHxlZmrft2Iw23T64s8MedKO4XgNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCISrxSLbdyu32od3qFMwqGi0/rtOli0iMVIVYlGMq2oBiG7sari5GMCJIn3IqYB3
	 EthSj5jWitKXJCjPT29DQqA7X8v7k6zcqts0D1Z9PriInxVxqOjyzNaPC1XLQjRURI
	 gi7b3oFlFtViZw5skZ2EvIXdVzaGIPf17a7uy1ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 127/273] rust: fix the default format for CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
Date: Tue, 27 Aug 2024 16:37:31 +0200
Message-ID: <20240827143838.238566877@linuxfoundation.org>
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

[ Upstream commit aacf93e87f0d808ef46e621aa56caea336b4433c ]

Another oddity in these config entries is their default value can fall
back to 'n', which is a value for bool or tristate symbols.

The '|| echo n' is an incorrect workaround to avoid the syntax error.
This is not a big deal, as the entry is hidden by 'depends on RUST' in
situations where '$(RUSTC) --version' or '$(BINDGEN) --version' fails.
Anyway, it looks odd.

The default of a string type symbol should be a double-quoted string
literal. Turn it into an empty string when the version command fails.

Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20240727140302.1806011-2-masahiroy@kernel.org
[ Rebased on top of v6.11-rc1. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 051cbb22968bd..9684e5d2b81c6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1906,7 +1906,7 @@ config RUST
 config RUSTC_VERSION_TEXT
 	string
 	depends on RUST
-	default $(shell,$(RUSTC) --version 2>/dev/null || echo n)
+	default "$(shell,$(RUSTC) --version 2>/dev/null)"
 
 config BINDGEN_VERSION_TEXT
 	string
@@ -1914,7 +1914,7 @@ config BINDGEN_VERSION_TEXT
 	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
 	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
 	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
-	default $(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null || echo n)
+	default "$(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null)"
 
 #
 # Place an empty function call at each tracepoint site. Can be
-- 
2.43.0




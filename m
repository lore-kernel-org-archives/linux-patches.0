Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948281C6F5E;
	Tue, 27 Aug 2024 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770124; cv=none; b=VINB65VUvsyjh5JQarf4IYgEjLmXFSgM0Z0kqlCbeBIfx2M3Z6+l4nObAOO9IxMvGFe2lFf8h2IFWqP1VbIuQNUwiWVhtHCjFsOthyvcT5dREBwJOqrtfqeMls+gt/6uNSmp/8m4HWh29mG72yCON0HPMGgmrVsRfZPaLYNRCPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770124; c=relaxed/simple;
	bh=jP3uh0mYf56CDdar1Dg0HTNI/PSNrxyBq/MiHL/v9OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5jbIpoFGq1qR9ZP8rcvPkkbM0J40TncsZX1pAWY95eRjqHAqz81RtkhC2vlvhK4X/qqX2ws2O08uLQVe27PIl0CiKkwfsWuNxK7Bh2waiK/0Zh8nhl2SbzbxQ5hslqX7ESvQQK5lNWbojjtm9t4uxYZELeeDe+xIWWU66i6wPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKbHwRh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKbHwRh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0283FC61047;
	Tue, 27 Aug 2024 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770124;
	bh=jP3uh0mYf56CDdar1Dg0HTNI/PSNrxyBq/MiHL/v9OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKbHwRh3apl+dG8X5NEqTfrxn+29NIC7eYawXnFw9wk73sn8fy7OQnCgzYcU6Uf3/
	 3xQ0iw/cTnBlqIijNksikVV9PPGbQfbTegDmXtkCXI4tsizHp6HNoZpMTMB9bOj40L
	 ehafaNDNGcdUC5MIRKXcd0U5piTVGc4MUCso9xek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/341] rust: fix the default format for CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
Date: Tue, 27 Aug 2024 16:36:06 +0200
Message-ID: <20240827143848.556067654@linuxfoundation.org>
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
index b5bcc863bf608..6054ba684c539 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1916,7 +1916,7 @@ config RUST
 config RUSTC_VERSION_TEXT
 	string
 	depends on RUST
-	default $(shell,$(RUSTC) --version 2>/dev/null || echo n)
+	default "$(shell,$(RUSTC) --version 2>/dev/null)"
 
 config BINDGEN_VERSION_TEXT
 	string
@@ -1924,7 +1924,7 @@ config BINDGEN_VERSION_TEXT
 	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
 	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
 	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
-	default $(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null || echo n)
+	default "$(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null)"
 
 #
 # Place an empty function call at each tracepoint site. Can be
-- 
2.43.0




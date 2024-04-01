Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F871C129;
	Mon,  1 Apr 2024 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988661; cv=none; b=RW/J0SwmnNoqWwacuTMS1V5p2G7TQD/i3kTRDpgbXnRDFfZedWvmDQHS/YS7YRPbEjK9w1DOigHqdF/TZb/0iJWlAoVN8e6K8aeTNHGvSZ/vcamdMs4Ak7O12M2fGSIdp0zNi/egcUE5bwZ2Rx+SIkOL9uY5EyudHvaP92Y6QZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988661; c=relaxed/simple;
	bh=Jsyg7L1OAhp9889u4D6evZoZWoNpMt6+M/qnaMaw1Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQIU2pW+g93JC89z2nhJlQWBRAE+wJB4Zde4Ph7MPAnwsPEtdHXlEgpWqE9yWsJIdeefKQvNb12oM7AaEL2cZlKkhy83vUNQFK+W8mdz2xvcj+u0CIzwqzBtTqI2wqcN0e5xqW6Djmw+jNXFLW1W5UoOLyMulwX2wUIq55NHWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqA/qI93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqA/qI93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06C3C433F1;
	Mon,  1 Apr 2024 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988661;
	bh=Jsyg7L1OAhp9889u4D6evZoZWoNpMt6+M/qnaMaw1Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqA/qI93VjcvhNiI5fg5uIw2lPpndi8pWif7ipKSs4mo/8OwjEyFnnvdRUJpkQnFu
	 eflYS4/BW58RI/Vo3Uu5sCDuSZNYL/YY6ZqzWigBFtOiOFhMwkj7IO3A3VTjg9UcV6
	 qRy4L5Zul3SvlY8ytXMH3MNtXhzlciDPQTRQn40I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Kees Cook <keescook@chromium.org>,
	Paul Moore <paul@paul-moore.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 251/432] init/Kconfig: lower GCC version check for -Warray-bounds
Date: Mon,  1 Apr 2024 17:43:58 +0200
Message-ID: <20240401152600.625651725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 3e00f5802fabf2f504070a591b14b648523ede13 upstream.

We continue to see false positives from -Warray-bounds even in GCC 10,
which is getting reported in a few places[1] still:

security/security.c:811:2: warning: `memcpy' offset 32 is out of the bounds [0, 0] [-Warray-bounds]

Lower the GCC version check from 11 to 10.

Link: https://lkml.kernel.org/r/20240223170824.work.768-kees@kernel.org
Reported-by: Lu Yao <yaolu@kylinos.cn>
Closes: https://lore.kernel.org/lkml/20240117014541.8887-1-yaolu@kylinos.cn/
Link: https://lore.kernel.org/linux-next/65d84438.620a0220.7d171.81a7@mx.google.com [1]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marc Aurèle La France <tsi@tuyoix.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -876,14 +876,14 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
-# Currently, disable gcc-11+ array-bounds globally.
+# Currently, disable gcc-10+ array-bounds globally.
 # It's still broken in gcc-13, so no upper bound yet.
-config GCC11_NO_ARRAY_BOUNDS
+config GCC10_NO_ARRAY_BOUNDS
 	def_bool y
 
 config CC_NO_ARRAY_BOUNDS
 	bool
-	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC11_NO_ARRAY_BOUNDS
+	default y if CC_IS_GCC && GCC_VERSION >= 100000 && GCC10_NO_ARRAY_BOUNDS
 
 #
 # For architectures that know their GCC __int128 support is sound



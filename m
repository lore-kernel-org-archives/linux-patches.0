Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78EE248191;
	Mon, 23 Jun 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685054; cv=none; b=IETwpjNVaqkuchNgaJS6FlW3SpNcEKSUJfGyzykD4DlkKtt/Jj3JaYpn9WVPZ++yT7Lyyy6+bgf3XwJimknI0OcvryKe7zY2bf1cDpdD/Nvt/HLeOlV3s/yCFiElu3PfIzmWOZVk4YsCwrs3mYeKQ2KKLC2iisat1bNgFXJ6fOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685054; c=relaxed/simple;
	bh=EHZjonKyg07PMaJmxwwjPR5XT45YjD8Y0YNAivxWaSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvmxEqtijtYBZC8/dlwA8Ux1Um/OznHCBP8t6A9cddjCxIqfS+NbROCrtIejdqzTdNnIf/JWeWj1LcC8GKaHhD5vqM1X8DWkBBprFfHiy2vNdr/ToOwhov3pVX2BGy62cs/2pNejvW6VXePfD4amulNuPs7w9zw57ji4XN3+vuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo9+rx67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo9+rx67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6D1C4CEEA;
	Mon, 23 Jun 2025 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685054;
	bh=EHZjonKyg07PMaJmxwwjPR5XT45YjD8Y0YNAivxWaSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo9+rx67M8k/e+w5xbEw1J8pUSrBQy111km0BvISWyiKDOVMgMnSQyU9/l81jr39Z
	 eKKVWU7DemPESysaGAdg9k/7ElOk/0ZBRLS3GonHxGjSfKPPOxVuinKakitxx+/L8r
	 p6s1qq2aXOfCCAl7zT3/IdnGhmm5KGscKBDeY6WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 229/592] Make cc-option work correctly for the -Wno-xyzzy pattern
Date: Mon, 23 Jun 2025 15:03:07 +0200
Message-ID: <20250623130705.737188667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 550ccb178de2f379f5e1a1833dd6f4bdafef4b68 ]

This is the follow-up to commit a79be02bba5c ("Fix mis-uses of
'cc-option' for warning disablement") where I mentioned that the best
fix would be to just make 'cc-option' a bit smarter, and work for all
compiler options, including the '-Wno-xyzzy' pattern that it used to
accept unknown options for.

It turns out that fixing cc-option is pretty straightforward: just
rewrite any '-Wno-xyzzy' option pattern to use '-Wxyzzy' instead for
testing.

That makes the whole artificial distinction between 'cc-option' and
'cc-disable-warning' go away, and we can happily forget about the odd
build rule that you have to treat compiler options that disable warnings
specially.

The 'cc-disable-warning' helper remains as a backwards compatibility
syntax for now, but is implemented in terms of the new and improved
cc-option.

Acked-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.compiler | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
index f4fcc1eaaeaee..65cfa72e376be 100644
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -43,7 +43,7 @@ as-instr = $(call try-run,\
 # __cc-option
 # Usage: MY_CFLAGS += $(call __cc-option,$(CC),$(MY_CFLAGS),-march=winchip-c6,-march=i586)
 __cc-option = $(call try-run,\
-	$(1) -Werror $(2) $(3) -c -x c /dev/null -o "$$TMP",$(3),$(4))
+	$(1) -Werror $(2) $(3:-Wno-%=-W%) -c -x c /dev/null -o "$$TMP",$(3),$(4))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
@@ -57,7 +57,7 @@ cc-option-yn = $(if $(call cc-option,$1),y,n)
 
 # cc-disable-warning
 # Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
-cc-disable-warning = $(if $(call cc-option,-W$(strip $1)),-Wno-$(strip $1))
+cc-disable-warning = $(call cc-option,-Wno-$(strip $1))
 
 # gcc-min-version
 # Usage: cflags-$(call gcc-min-version, 70100) += -foo
-- 
2.39.5




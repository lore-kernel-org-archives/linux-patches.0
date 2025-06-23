Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8FD1F582A;
	Mon, 23 Jun 2025 21:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713118; cv=none; b=OvS6OvpOx5MkS0tcQ1rdMRJJ/TTBQSkMiqynLx8/zuzyZ0ALe0UTRNX4DTaeQTogSSUS9Ot4efxXU+S2PvhyL21MrINwE/Km7RAyLucllB7ZHCUX/OkMv4fUYZw8iXQcqqHc0BvxbdKvT6LoP81Lboa4tQ0bYQrPBi/R9/Nir6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713118; c=relaxed/simple;
	bh=U9+nZoZ3Ay8Fp8YEHNksWYW03FyN6jfEWyWB+5cc1Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxM3D/r2axWOOQP6s0ObGV3XaGkC21mMPBoMWAnJlUwzi482YD70XkvVfCHTPFu/Kb9jzUUlqaSO8m7/bs912O81dW217IFkUJhMtV/3kZ8ATrLKELq+KgQ5oVQOCEcBHsFf3UHYjC//UigJQcq6omQMW1Vsvw+BFKR9Avgywjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHGY0W6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHGY0W6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7F1C4CEF1;
	Mon, 23 Jun 2025 21:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713118;
	bh=U9+nZoZ3Ay8Fp8YEHNksWYW03FyN6jfEWyWB+5cc1Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHGY0W6gGamYDz0JRzkKvH4yD/udCzcBKI3y/G3kcDNxYtyRxqz3JDGzKtHiV3VW0
	 AzBTHjEkhmtQQxH+mYUitTdvxpxCWBJ97Osq/73pXfMw3J5VeWW8/dWwLVd2Eki2Jr
	 bOy9Pq8hhlTusVFcPrZwxo4kbZoCXQNlQyPNPAA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 146/355] mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation
Date: Mon, 23 Jun 2025 15:05:47 +0200
Message-ID: <20250623130631.100605001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 08f6554ff90ef189e6b8f0303e57005bddfdd6a7 upstream.

A future change will move CLANG_FLAGS from KBUILD_{A,C}FLAGS to
KBUILD_CPPFLAGS so that '--target' is available while preprocessing.
When that occurs, the following error appears when building ARCH=mips
with clang (tip of tree error shown):

  clang: error: unsupported option '-mabi=' for target 'x86_64-pc-linux-gnu'

Add KBUILD_CPPFLAGS in the CHECKFLAGS invocation to keep everything
working after the move.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -319,7 +319,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 KBUILD_LDFLAGS		+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif



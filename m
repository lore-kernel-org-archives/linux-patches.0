Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D360637F75B;
	Sat, 12 Sep 2026 19:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240846; cv=none; b=FuHCpRACRT/wxYAv7PY6Yc/GBPd2avSz31Aa4OGkXgIDGUSwPZ2mSX+YMXVA+QKgEpXiDceCvwSAcOjZ2xmKPIaMkP/Amg7lr3KSsRyXxnek0Vm+8jLVs0GzJ2x81V7E80ZeULZDxZ2iC0vFPRs1d4HyKXKRST8SCFHgNFaDSZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240846; c=relaxed/simple;
	bh=0vh5+0rmtcTc/FFt6v3yeSCQ39klK5RJrZwr5R2YWcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpCzp7OYLwXFTnQKjSj1x77UEpaDgvrjI88vvIDu3simEnWmRHYUGAI8TdhRVszMhPfqYIAqTvJXrZwRdRdnkLWke7A3oPshGvOi0r6W6Fgm7NIMuDffH6Cf3Tf/fRWLA2LHFLv43cgFp8Pr2MAEmus9GbMc8CkNgOrP4d+HWP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TH4PtBt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TH4PtBt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4491F000FF;
	Sat, 12 Sep 2026 19:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240844;
	bh=Aowsrdw8/X1pZNe6ObtvNz9bATajI9nCj9DFC0saxdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TH4PtBt66j3FMkfluUcAqaALEaOOyJ/sCTV8Dsv6Sdo8JUj1zWKfD/i0YzMsVtEZX
	 ztPctKKesX17qwlfBfBjm44YJWiigIZ/GXMtjNL8Xn4BYFn5FytJ0tsXbIsQkBEpZ1
	 PYpKbmHQUn1NTydbGmnxFB690hdq0S4mYf5xdBbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joy H.J. Lee" <rkr0k0r@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 008/798] tools/compiler: match glibc 2.42 definition of __attribute_const__
Date: Sat, 12 Sep 2026 08:53:56 +0200
Message-ID: <20260912065517.150691984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Joy H.J. Lee <rkr0k0r@gmail.com>

commit 8700a4761beb219873956666cf91776a2c61e698 upstream.

glibc 2.42 added __attribute_const__ to sys/cdefs.h:

    # define __attribute_const__ __attribute__ ((__const__))

GCC 15 warns when a macro is redefined to a different replacement list
(-Wbuiltin-macro-redefined). Since host tool Makefiles (resolve_btfids,
objtool) pass -Werror, this conflict becomes fatal.

The warning is suppressed on standard native builds because GCC treats
/usr/include as a system header path (-isystem), and macro-redefinition
warnings from system headers are silently suppressed by GCC. It fires
when glibc headers are on a regular include path (-I) instead, which
is the case in cross-compilation setups such as NixOS, where the
sysroot's glibc is passed explicitly via -I rather than -isystem.

Per (C11 6.10.3), identical replacement lists are accepted silently.
Match the glibc definition exactly, including the space before "((", so
the redefinition is accepted without warning regardless of whether
glibc headers are treated as system or non-system includes.

Link: https://lore.kernel.org/20260701200635.3992767-1-rkr0k0r@gmail.com
Signed-off-by: Joy H.J. Lee <rkr0k0r@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -69,7 +69,7 @@
 #define __read_mostly
 
 #ifndef __attribute_const__
-# define __attribute_const__
+# define __attribute_const__ __attribute__ ((__const__))
 #endif
 
 #ifndef __maybe_unused



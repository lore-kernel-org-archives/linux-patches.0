Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648224582D8;
	Sat, 12 Sep 2026 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219651; cv=none; b=fOJHARjizEuBQohhZSjOqrcRe9zcj1bTkbWke7R4vt3EGnPE83aLHsnGQXmre/biyYl634iqMtltoaJ1OCpHLNiYdz11Y2uhHfJCcyh7IZV5KahGbgLI+74NQ4N+aHfVXSKQRezwniSH0gM12pdfRzuGlGAVBormrHhaNDEBhqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219651; c=relaxed/simple;
	bh=/lbj6e7jpkqIfcQs4LlARArpuTSbxBieYsN8rIoWn+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9RBIBx1nVzAMa4bj4A5i/sxRqVUmRKIxKxCTsPfzVlpt9lv/Hzj8qZb+I5SLzkiwQOS5xdYRKqSXW3TdesFdd5ACIYeW2zLKwp4Rgo9qfy4rEp3k7rGAGJW9VFOy/j5zja+2815KJcKt3sRBDWBDLN+FWe6H1oU7aHhIre5Vkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL55Hz8K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL55Hz8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0437E1F000FF;
	Sat, 12 Sep 2026 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219650;
	bh=FtmK0BNKtUUNzSe8CskW6fEdGi8ldK2T4dF1Cfkp6Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vL55Hz8KW36bYPdEiC6xxpv4ISFmpbHw5zcGzwhxAlw3Tr/Xm0kQqzQzRGJ6dvqNg
	 g3/vn2DJWWulSlwV5qCrfBsl6WbfDNhITavwb936EAr024Ub6J5oPaOAif4ipxjvI/
	 5CRzo17PQf53KAXZV+v2ezgKO0pNaFuFnNefPpd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joy H.J. Lee" <rkr0k0r@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0018/1424] tools/compiler: match glibc 2.42 definition of __attribute_const__
Date: Sat, 12 Sep 2026 08:40:50 +0200
Message-ID: <20260912065607.708800079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,7 +79,7 @@
 #define __read_mostly
 
 #ifndef __attribute_const__
-# define __attribute_const__
+# define __attribute_const__ __attribute__ ((__const__))
 #endif
 
 #ifndef __maybe_unused



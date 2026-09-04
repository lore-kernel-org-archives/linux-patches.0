Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490C414A0E;
	Fri,  4 Sep 2026 05:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500426; cv=none; b=YQkRqpnJGRyghqLkGBFVknflisDa2ibIC1Iv+JzUNjAuP89gIHb/KwAawZmKYrV8e8F6V6CY53yab79Ean6yzYXdxGGBWWrtQhez+h7hj/RoXxyhmgu01nHRHOFo2OpjUNu7aMW4Bwlo6BgrPCbXJdZIjQBB6pP4D0SQqXWcvOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500426; c=relaxed/simple;
	bh=fYDyc33E/fvAqoYuSjcMnxKcdT9tN70rtePQ9ivfsfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k02RApTpLd2qa/V/fdlBlQ87QJLVkyB7DucaU8K8jy6z2L+g8EGa+Q9C+3l0BBFE+G8JxH2EsXvj2Qjz3cpblA7GJIRrOo4iZbMWGL84c42bYMs18OGPRwKLXJmOS0psGGWVFYHKkR3+VgGke0CD50JmGYgAQkj6i7F6RaIE9vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5aWFRJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5aWFRJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1891F00A3D;
	Fri,  4 Sep 2026 05:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500424;
	bh=3OvIFK7Dn27kIAhoJI0rF2MS68PlVX5XRHytzZHUvqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5aWFRJUigx2qjP0+79bqshFkJ1Wv332hp1qTmBx2X16drfGPViDcNgHdlvPRlNNG
	 H2TIoKtnYty7Qj9BrbR8iStECf8kY7udiBVqfsLpuyCpNry75+IETNaaWYRodRdTD7
	 2qRavguoXQnfJux7ZGob9NCO5IyOdYlX6r3dcNpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joy H.J. Lee" <rkr0k0r@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 052/552] tools/compiler: match glibc 2.42 definition of __attribute_const__
Date: Fri,  4 Sep 2026 06:53:29 +0200
Message-ID: <20260904045749.019855551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -119,7 +119,7 @@
 #define __read_mostly
 
 #ifndef __attribute_const__
-# define __attribute_const__
+# define __attribute_const__ __attribute__ ((__const__))
 #endif
 
 #ifndef __maybe_unused



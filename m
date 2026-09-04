Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610EB3B6C1E;
	Fri,  4 Sep 2026 05:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498594; cv=none; b=KMtA1M+Vvwg8nl+ovD/TFTIVX4bMbWLs6JVem0kOe/ohqicL3IfEaKHI1CizPf3NwoW293fxjnoGl4jFI9mQTmcBQkeJW2LEG4IT8r2M1z+MxR1rHB09PlM5tnS69LrWgtThMQqW34TXBDVKXfg0hsbcG1DFXXwCHUHjMPdzAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498594; c=relaxed/simple;
	bh=wu2r2C5EGfFZkxQTGd7fTiCglbCDinnHt5813GK1yg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxE9O0yNNdBrL40kXsAuO7H0riHXr/UEer/azz/pwx5/c5A2om+QbpQP1KGovydvVn4NmWe9Uh54E8hVlqX11kirh7mPRSoe9Pv72JfQrksf5PIZi+9e9YGzmitQpXv4OBK9bqZrsPBVnnsyw2oJnCxAC7k2tYbnW0J6FKdScjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRI82kZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRI82kZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8366A1F00A3D;
	Fri,  4 Sep 2026 05:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498593;
	bh=mmP22H8jq3no+6bE+G/u9VIgymdpSSXCVbfRsso9DMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRI82kZmex+KkUjMe1T8FUnagyOgh0b+mGqedS20hDgtU8rtPX4H0RpAeZxiKm0iU
	 JtDzhvULx1QAaSD16t0/kT9jbc8EzS4r0riaogLkRDyCvJQ6XftjAC1woAd1nSa2ai
	 6iSQ6gZE4t9hNBhL95tIhIEMj2fZvQZEYswfxXUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joy H.J. Lee" <rkr0k0r@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 081/713] tools/compiler: match glibc 2.42 definition of __attribute_const__
Date: Fri,  4 Sep 2026 06:50:49 +0200
Message-ID: <20260904045805.655796338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



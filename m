Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896A54E0B8B;
	Thu, 17 Sep 2026 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667561; cv=none; b=cfRf8QceCiqACyWwdufZQHi99IW3zzEU4TovWzpQ1ba6ckEGRyCYTTloUFBi62NU/YHN8wSz8nGUyXWluUWH+hxMBTJWjh4JWhkvqakg7aPturejPZnaBZ0rLyd0if6Ima90PxbqKIG3xoxvoCTUhTMcb9TmmNtBvq6nCMZx/qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667561; c=relaxed/simple;
	bh=on/LdsZHxVA2rUIuziAvozx8UmMy9Ui5EJZiXCjOLtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivyhXcL2yp9QUUTNbw5x2DTBXigsAPmtPDqMW20B5ejPEPA7lWWojLY5GLB3TaKBkEdfqd4u1yEDjeg7jxCHtMqsOh7mOV042MDGJKXTk1UgrQj/cZ2BqH99VfLWoz+vxx85euOQrEGIeoiPm0kfpg9ibPsIOHm45+Ux0cxEF8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDh3y3ze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDh3y3ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5631F000FF;
	Thu, 17 Sep 2026 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667559;
	bh=pbr/i7pIFVMFjCmLcWlfCp1VJdNwnS+4JUT2x/FiMtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDh3y3zeoa84hDUFJL4fo7Hiyt3XtdR8DhfhbDuZ3GZ2eYfom3BhTilGUF1pOvwY1
	 MBa2PyILaY4LrxDwfq7DDDkFtf3hHusoAwJeAe1BoTnsft4GRw6SXwqZ2BTTcxTal4
	 jc4T2bHAoOAQoQ+vpu6ArTOg+87zqhW7b9QmBGnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0085/1102] crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y
Date: Thu, 17 Sep 2026 16:00:28 +0100
Message-ID: <20260917151541.612020282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit c64ba13e2033c3c6dc1a097bf35f9f1fe457c3f7 ]

Andrew reports build breakage of arm allmodconfig, reproducible with gcc
14.2.0 and 15.2.0:

  crypto/ecc.c: In function 'ecc_point_mult':
  crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

gcc aggressively inlines functions called by ecc_point_mult() (without
there being any explicit inline declarations), which pushes stack usage
close to the limit imposed by CONFIG_FRAME_WARN.  allmodconfig implies
CONFIG_KASAN_STACK=y, which increases the stack above that limit.

In the bugzilla entry linked below, gcc maintainers explain that gcc
estimates extra stack usage caused by inlining, but ASAN instrumentation
is added in post-IPA passes and thus the inlining heuristics cannot
account for it.

It could be argued that -Werror=frame-larger-than=1280 instructs the
compiler to avoid inlining beyond that limit lest the build breaks,
which would imply gcc behaves incorrectly.  But gcc maintainers reject
this notion and believe that a warning switch should never affect code
generation, even if it is promoted to an error.

One way to unbreak the build is to limit inlining via -finline-limit=100
or by explicitly declaring some functions noinline.  However while it
does keep stack usage of individual functions below the limit, *total*
stack usage increases.

A longterm solution is to refactor ecc.c for reduced stack usage.  It
currently performs ECC point multiplication with a Montgomery ladder
which uses co-Z (conjugate) addition to trade off memory for speed.
The algorithm is susceptible to timing attacks and needs to be replaced
with a constant time Montgomery ladder, which should consume less memory
and thus resolve the stack usage issue as a side effect.

In the interim, raise the limit for ecc.c, as is already done for
several other files in the source tree.

Constrain to gcc because clang 19.1.7 does not exhibit the issue.  It
makes do with a 724 bytes stack frame even though it inlines almost the
same functions as gcc.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 4c99e5d376f68..6e9facde76a03 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -182,6 +182,11 @@ obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
 
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
+ifeq ($(CONFIG_ARM)$(CONFIG_KASAN_STACK)$(CONFIG_CC_IS_GCC),yyy)
+CFLAGS_ecc.o += $(call cc-option,-Wframe-larger-than=1536)
+endif
+
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
-- 
2.53.0




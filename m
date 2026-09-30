Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726C3D3323;
	Wed, 30 Sep 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790797; cv=none; b=i4Amj1vKH2kcKp34icPFbmMXZv2pbxr4WtqWzBi60IP4UiukOZa55IqFX9CxOODsRaHIYWMjqeKx0uyecPi+TofuL5T5KPHUEOHRJj6/lRN+uqTnfqxl1naCvM9KEG+5x7wLR1zuMe8FHzWcAZqcBjQ4Xt5yeen0qk6Qa21i2A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790797; c=relaxed/simple;
	bh=m/h2c9NR19vzFGPmBm9fZW4x5uWLv4WQ5Ezmki97ya8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6uys5gZbMUJmiJCO2h0KJaTPXNtOvLtRRbPHbpUIpjm6QvYXcRPEFG9MCF35/NRBwE1RYCvjGPR/oNYnRMxCf1F8QBsHeqA+1pLnBRqga53d5fPDkj0cnE5tVsL3jIl1Ch17QSGRa0ZimhvFk1TIoZTkgpaDd0YAFKv7h8i10w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eT9fuyx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eT9fuyx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD811F000FF;
	Wed, 30 Sep 2026 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790796;
	bh=wa6BngBjEypghW6xq+v75HpcFzk1DFV1/OMZDgKhSQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eT9fuyx7hnTQICDcPbXQHXVM+8esNbMquyVIpX9aMKIZShCc0ko8z5OLoaKXgcsld
	 F8TFwhunX8hmuvO28VkqJdDr9I1nbaFodMXzVnXZvuYz3JaZDsAdgVG7gOKDvuS+fl
	 TZFiFqjLbDdpx8EUIvXi3CWF6zoEDq2FeenlUhyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 032/752] crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y
Date: Wed, 30 Sep 2026 17:18:22 +0200
Message-ID: <20260930152358.844548463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 429591ffeb5da..79f986203b6c6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -176,6 +176,11 @@ obj-$(CONFIG_CRYPTO_ECC) += ecc.o
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




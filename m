Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B9B1ADFE6;
	Mon, 14 Oct 2024 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917998; cv=none; b=CwfqmulptvCpHGIcMTxb45j/EsbPtLUHcrhPJpg6UUozA3RQbTu9BnvOFAr3o3pppaClfHI7oPc/0dkZQGihC2z3CCtA+dm+4Dud4IgamkTGvmLfxXVGFSgT9oRChQutQHL/KORI0fue9gFES3MyjLry8jiuGVRc8HsmZLwBGSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917998; c=relaxed/simple;
	bh=reO/x279HnobBsNzja9qn/GwYzq9d+0Sd+IN6G8+Dgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMrYlfFYQZ/cCijTs5f3yR/NP5V6F5IroddUbtY9qLtqI0uxuyEaPSwxRhwn1ac1dU6tua3U+JO0TYUs5CnHPppEHED6E0vvpsqp/PKQADQzEyVNZNGpfoUd+jrKWwzxPAOOQdacW9HFc832hOkFpNUk8QjZepn/9a9XudT/Kz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f578+/Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f578+/Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79B5C4CEC3;
	Mon, 14 Oct 2024 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917998;
	bh=reO/x279HnobBsNzja9qn/GwYzq9d+0Sd+IN6G8+Dgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f578+/Ss7ZoA+KhBpeHgKbbn4+5Mxcown2xDfNP2qGc+F3uA2XzVfkkltefyJxqNz
	 aXUFbNCh8tMje07kc2TQEkssMUSddMRmkX9fBXQvzDl/f8vurf3MJ7pYwf4b374c6k
	 2AezSPT56uZVyJLduRS5K2maI8PMN5+254eEuJeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lasse Collin <lasse.collin@tukaani.org>,
	Sam James <sam@gentoo.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Joel Stanley <joel@jms.id.au>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jubin Zhong <zhongjubin@huawei.com>,
	Jules Maselbas <jmaselbas@zdiv.net>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rui Li <me@lirui.org>,
	Simon Glass <sjg@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 162/798] xz: cleanup CRC32 edits from 2018
Date: Mon, 14 Oct 2024 16:11:56 +0200
Message-ID: <20241014141224.281655513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lasse Collin <lasse.collin@tukaani.org>

[ Upstream commit 2ee96abef214550d9e92f5143ee3ac1fd1323e67 ]

In 2018, a dependency on <linux/crc32poly.h> was added to avoid
duplicating the same constant in multiple files.  Two months later it was
found to be a bad idea and the definition of CRC32_POLY_LE macro was moved
into xz_private.h to avoid including <linux/crc32poly.h>.

xz_private.h is a wrong place for it too.  Revert back to the upstream
version which has the poly in xz_crc32_init() in xz_crc32.c.

Link: https://lkml.kernel.org/r/20240721133633.47721-10-lasse.collin@tukaani.org
Fixes: faa16bc404d7 ("lib: Use existing define with polynomial")
Fixes: 242cdad873a7 ("lib/xz: Put CRC32_POLY_LE in xz_private.h")
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/xz/xz_crc32.c   | 2 +-
 lib/xz/xz_private.h | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/xz/xz_crc32.c b/lib/xz/xz_crc32.c
index 88a2c35e1b597..5627b00fca296 100644
--- a/lib/xz/xz_crc32.c
+++ b/lib/xz/xz_crc32.c
@@ -29,7 +29,7 @@ STATIC_RW_DATA uint32_t xz_crc32_table[256];
 
 XZ_EXTERN void xz_crc32_init(void)
 {
-	const uint32_t poly = CRC32_POLY_LE;
+	const uint32_t poly = 0xEDB88320;
 
 	uint32_t i;
 	uint32_t j;
diff --git a/lib/xz/xz_private.h b/lib/xz/xz_private.h
index bf1e94ec7873c..d9fd49b45fd75 100644
--- a/lib/xz/xz_private.h
+++ b/lib/xz/xz_private.h
@@ -105,10 +105,6 @@
 #	endif
 #endif
 
-#ifndef CRC32_POLY_LE
-#define CRC32_POLY_LE 0xedb88320
-#endif
-
 /*
  * Allocate memory for LZMA2 decoder. xz_dec_lzma2_reset() must be used
  * before calling xz_dec_lzma2_run().
-- 
2.43.0




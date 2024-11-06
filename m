Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BDA1F7556;
	Wed,  6 Nov 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898006; cv=none; b=ST6B1Nq4uCvZBUGM8GOrjUx+i71f3QLAdkUN9vRSQ5cs+Zto9agb+jmW45uCFlrQZLC+A0pUNyt+thFT8+1QCxOA+Aes0dfSeBa6rcgklQkzdyb24qOItLWGqR+/TpeOIIOKblSp88zEgXQ3kWi7UFa0EyNVPBE5l+5F2wzljSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898006; c=relaxed/simple;
	bh=OeJoMWQofA18LaapbcG2NlumlWBGg8gyMqWz4dHhUXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDR7YATA7n+ep/U4JSWW7eKP2Eibg6c0fc2KQSij6PklJIor9hxkw9qu9D0CtGCl0XhabhvVMIIPHithaRDy0ZQoHD7tCmoEoiIbeLlh1kE3wrs6csetcE1WZMaR2CCg6w9oKAsXfB4kvmZNbAku+1I2556yWYGpvBnTB5Wk8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrnAE3/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrnAE3/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94253C4CECD;
	Wed,  6 Nov 2024 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898006;
	bh=OeJoMWQofA18LaapbcG2NlumlWBGg8gyMqWz4dHhUXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrnAE3/0tYuLMpRFFgx5fc05newQ1Ru1cv9l4RRJon2eSzxPW9gAI8RbC1GozNCZ9
	 fXMsDpg0hrrxocqi8aq2E/LDpxRfjaw93NelmMsgsFbgRML0Y23kVtRHqe0AwVZ5Pg
	 PR/EP5p5VQkUwF2WvaL8nQ3Rmy3Bt6YKfadXjomg=
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
Subject: [PATCH 5.4 092/462] xz: cleanup CRC32 edits from 2018
Date: Wed,  6 Nov 2024 12:59:45 +0100
Message-ID: <20241106120333.780309285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 912aae5fa09e1..34532d14fd4c2 100644
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
index 09360ebb510ef..482b90f363fe3 100644
--- a/lib/xz/xz_private.h
+++ b/lib/xz/xz_private.h
@@ -102,10 +102,6 @@
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




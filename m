Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087BB29CE7;
	Wed,  2 Oct 2024 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876022; cv=none; b=WI7iScrAHDqTOqQD3+XTXJXqn+nZ4u4qzlROjiyuRBAoYoItAE2XCgX8zAKArG+7uNKm7gbn39i+k0RO52nxjhz0XcCvVlQJ4mr93PpuSR/LzzkvXbtXk44TXUw9BBKYab0HYLlVF4XP1QAq76by7tJevxuX7p+g+pwkKVs4IMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876022; c=relaxed/simple;
	bh=VfHZmFZwdpKcGs1RWlWtUPja4H7FiI02TcDeywRLvkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs8WMYIv1G5e9LUKHSof4HjBWq3PstF++N+E6HpAX/K8iqTdpKYfw4J21YR97M1jM60u3+4pkgHv8AvICancpEd73a/NdelXWB02q10dySLSBZyC/76rZO4QL2tC+HnOpfnYv8jl6dFzotcWz2DaAb6n9hmLnZBaK2KABZcZ2y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1Ew9tg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1Ew9tg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D1DC4CEC5;
	Wed,  2 Oct 2024 13:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876021;
	bh=VfHZmFZwdpKcGs1RWlWtUPja4H7FiI02TcDeywRLvkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1Ew9tg1yEQMnvaXnqbBZQqLo6ZbRHHLo7WbYc04d9fslulD5Ap6p7QuUbfLvQt8Q
	 Zv8YmwZaLfytvRnKDEDCKAL5gZR52J5FMUqY6PITz6xAboTywOk7yNJ3vxnZrt3wNR
	 gFevdZTK0jl4r+M6GQESNTjpuhdkwbRKYYexW/CY=
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
Subject: [PATCH 6.11 302/695] xz: cleanup CRC32 edits from 2018
Date: Wed,  2 Oct 2024 14:55:00 +0200
Message-ID: <20241002125834.493577643@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFEE308F2C;
	Wed,  3 Dec 2025 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775993; cv=none; b=KOiqrorBao6UpCJSUbUl4T1oMi/zhA70anZnAn0Vfdk9SiWG7aK6Zhj4jglHAqi2fcdBjp8Pn03k5GkDSLTW8GbJZXqgP3L7OtPASIeRUZmD2+5tSOCgmBItr+x5cOrv77PDXGsQyVw/OXARF2x7UHiOLFOxG1eVcSqKfKwb67U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775993; c=relaxed/simple;
	bh=GsK0f0gO4OPAcra/REnJkf4eYaPABkll/waTlWIwmtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlIrULlT3tdnZynSTfjVIPmUK6X+/+bkUzLyTiiuWJcs88ALLmyH3/ayqd8xMEkIInDuKA4b3iNXVfie36snmZVe46QBJqhjG7XqZwvx1fjykvbUcm9ze2YK67a+pzA5Z0G3C25yyoM6YooVVJdcp0qorrzrhwXecLtymT3jfcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLxwJWDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLxwJWDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8531EC4CEF5;
	Wed,  3 Dec 2025 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775992;
	bh=GsK0f0gO4OPAcra/REnJkf4eYaPABkll/waTlWIwmtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLxwJWDstmmffjX3sA+pvQx5kIYcpw6retQ+5epzymn7UXovb6zXYo8deDqTHKRYh
	 EBGTMxq/2BfWBzemopuoIDcG2jZeRQEdZ0NAN7qZCuTNeYq9u0jUvRL6qvLUNYCsZ7
	 yu9AQkpvZeXc0BfNPk8Z93kdRrJ3NYlRXaX4Izh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Vineet Gupta <vgupta@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/300] arc: Fix __fls() const-foldability via __builtin_clzl()
Date: Wed,  3 Dec 2025 16:24:12 +0100
Message-ID: <20251203152402.395722063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit a3fecb9160482367365cc384c59dd220b162b066 ]

While tracking down a problem where constant expressions used by
BUILD_BUG_ON() suddenly stopped working[1], we found that an added static
initializer was convincing the compiler that it couldn't track the state
of the prior statically initialized value. Tracing this down found that
ffs() was used in the initializer macro, but since it wasn't marked with
__attribute__const__, the compiler had to assume the function might
change variable states as a side-effect (which is not true for ffs(),
which provides deterministic math results).

For arc architecture with CONFIG_ISA_ARCV2=y, the __fls() function
uses __builtin_arc_fls() which lacks GCC's const attribute, preventing
compile-time constant folding, and KUnit testing of ffs/fls fails on
arc[3]. A patch[2] to GCC to solve this has been sent.

Add a fix for this by handling compile-time constants with the standard
__builtin_clzl() builtin (which has const attribute) while preserving
the optimized arc-specific builtin for runtime cases. This has the added
benefit of skipping runtime calculation of compile-time constant values.
Even with the GCC bug fixed (which is about "attribute const") this is a
good change to avoid needless runtime costs, and should be done
regardless of the state of GCC's bug.

Build tested ARCH=arc allyesconfig with GCC arc-linux 15.2.0.

Link: https://github.com/KSPP/linux/issues/364 [1]
Link: https://gcc.gnu.org/pipermail/gcc-patches/2025-August/693273.html
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508031025.doWxtzzc-lkp@intel.com/ [3]
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/bitops.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arc/include/asm/bitops.h b/arch/arc/include/asm/bitops.h
index fb98440c0bd4c..325512148c7b8 100644
--- a/arch/arc/include/asm/bitops.h
+++ b/arch/arc/include/asm/bitops.h
@@ -315,6 +315,8 @@ static inline __attribute__ ((const)) int fls(unsigned long x)
  */
 static inline __attribute__ ((const)) int __fls(unsigned long x)
 {
+	if (__builtin_constant_p(x))
+		return x ? BITS_PER_LONG - 1 - __builtin_clzl(x) : 0;
 	/* FLS insn has exactly same semantics as the API */
 	return	__builtin_arc_fls(x);
 }
-- 
2.51.0




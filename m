Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7D2BE655;
	Mon,  1 Dec 2025 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588395; cv=none; b=WFEnPqZZESbkfrPq9P3PVZDuiOUH7v8JS6yFXwv59NQWjVQ0xJ3KjyXiuWmq6D5FbuojF6O9jjXzwUlPnk4YViIjf1XhvkZc9wB2T4kVSUPeCFFQyWkfD/9NIyl6838dAQ1PW8Lx19x4VU4ypF9PI94VNrqv/z2f1+3Q5XqWWTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588395; c=relaxed/simple;
	bh=WZU4z3hhdgurd98XpWWpb4dnQ3PU+0py9e5BQYYnUjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+Yy/NbaKHlrKLJCPnJEE5N6OyvMzVuBMgCJzl7Eyd7b/dDR6NCZgGMZE8QTbZQ9rGGpcikDtoeQN2iT8HXz3pu6VWZnCGLSgU4OaGajglv7qVwyqewDyl8idJUKBbBT5ISSUebR9F1GUDoIXTNUcOJHdjEcvRvDBKkhI0qLpVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pu2GCDRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pu2GCDRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1003C116D0;
	Mon,  1 Dec 2025 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588395;
	bh=WZU4z3hhdgurd98XpWWpb4dnQ3PU+0py9e5BQYYnUjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pu2GCDRiVJ9+/Jf330PCxJLw+lB1epbUAS2cPdmzz7m9TdGzZxkgiiR4wzRhF/KxE
	 tDCqRQf/QXZDU8RNDnflk1x4m0VkPEhItivQktaYPzWnEKTyJf60s/Z1N1ZynRHLiU
	 nOUBCZMkBj8VgBsI0l+nznY7zcsvfpTh9bQj7w14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Vineet Gupta <vgupta@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/187] arc: Fix __fls() const-foldability via __builtin_clzl()
Date: Mon,  1 Dec 2025 12:22:21 +0100
Message-ID: <20251201112242.448798235@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 50eb3f64a77c3..7d6afe5cdb7ac 100644
--- a/arch/arc/include/asm/bitops.h
+++ b/arch/arc/include/asm/bitops.h
@@ -371,6 +371,8 @@ static inline __attribute__ ((const)) int fls(unsigned long x)
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




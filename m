Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289C023B633;
	Tue, 17 Jun 2025 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174427; cv=none; b=hqELdwGMsIv6TycLESt9GIvYBTBajN1UZwX5uFLEJEe8GsfYcdJWIuDB/Xw6l9y+M7IdQGjgSRJi5IlnccW6JxLyeoGMR0IV+nnkDFbaXr/5fib3dcUfKyOxM9yRNb/PXPR0/dT2Gnqfpii4KHE3MHp9+UZHOn/Jx3rLdcqUHSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174427; c=relaxed/simple;
	bh=4wZWHtGHXZwplyCa2QXPQgAoWn5M+8jEsxFN7mf1DBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tC6x2TVLdTnp3nJdMpOtgupY1/zpWy4hDtiIEH4TqjO+IqohB5gqWHhz+UawBoAIBoIWonJRyEOIg/cfaicPERc8FfSlOiIX1pGFAW3lIb6n5zEUpQUUdRsB3MnQHeveb5D5wpzLW4ZbF/01YBAPOjrpUi6VsoMIhgWjFm3LRFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLSMJCgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLSMJCgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8605AC4CEE3;
	Tue, 17 Jun 2025 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174427;
	bh=4wZWHtGHXZwplyCa2QXPQgAoWn5M+8jEsxFN7mf1DBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLSMJCgFwEDW1iO9z/apxTAH9c4h1/WI8RQXBCkfavoHE1hBNU8fWRL5VPdCP/Mzi
	 m78ztzAygG/S8RPNUVDi97TMKBpAtVlABsLi+0ybpUmzR5l5xXFC/XBbWZo72EnSfh
	 pHsfBjfy1NsdDJTLKnvWLRylMob6w/Dcn0ttlzGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/356] arm64: Support ARM64_VA_BITS=52 when setting ARCH_MMAP_RND_BITS_MAX
Date: Tue, 17 Jun 2025 17:23:02 +0200
Message-ID: <20250617152340.924595252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kornel Dulęba <korneld@google.com>

[ Upstream commit f101c56447717c595d803894ba0e215f56c6fba4 ]

When the 52-bit virtual addressing was introduced the select like
ARCH_MMAP_RND_BITS_MAX logic was never updated to account for it.
Because of that the rnd max bits knob is set to the default value of 18
when ARM64_VA_BITS=52.
Fix this by setting ARCH_MMAP_RND_BITS_MAX to the same value that would
be used if 48-bit addressing was used. Higher values can't used here
because 52-bit addressing is used only if the caller provides a hint to
mmap, with a fallback to 48-bit. The knob in question is an upper bound
for what the user can set in /proc/sys/vm/mmap_rnd_bits, which in turn
is used to determine how many random bits can be inserted into the base
address used for mmap allocations. Since 48-bit allocations are legal
with ARM64_VA_BITS=52, we need to make sure that the base address is
small enough to facilitate this.

Fixes: b6d00d47e81a ("arm64: mm: Introduce 52-bit Kernel VAs")
Signed-off-by: Kornel Dulęba <korneld@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250417114754.3238273-1-korneld@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 658c6a61ab6fb..4ecba0690938c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -304,9 +304,9 @@ config ARCH_MMAP_RND_BITS_MAX
 	default 24 if ARM64_VA_BITS=39
 	default 27 if ARM64_VA_BITS=42
 	default 30 if ARM64_VA_BITS=47
-	default 29 if ARM64_VA_BITS=48 && ARM64_64K_PAGES
-	default 31 if ARM64_VA_BITS=48 && ARM64_16K_PAGES
-	default 33 if ARM64_VA_BITS=48
+	default 29 if (ARM64_VA_BITS=48 || ARM64_VA_BITS=52) && ARM64_64K_PAGES
+	default 31 if (ARM64_VA_BITS=48 || ARM64_VA_BITS=52) && ARM64_16K_PAGES
+	default 33 if (ARM64_VA_BITS=48 || ARM64_VA_BITS=52)
 	default 14 if ARM64_64K_PAGES
 	default 16 if ARM64_16K_PAGES
 	default 18
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F0F1A6827;
	Mon,  4 May 2026 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904262; cv=none; b=VohbavXY+LVQf+yZEkCp2bHK1bOKH3tXqpe21grBWgGxn5LvYqHzvGr5hk9MMm1269NbUqIvnwZKxDkFF43tRrQ9smWRzHEw1OOXJ+kAtYGxsXQkLpCAZlyLmb9OIVjWMVyciMy4DGt12dytEse0UFrcEDygEL7/kH8NVF2YHOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904262; c=relaxed/simple;
	bh=fAjYWGij6Ai4L7J+o3l2M+DPhAdNXt3H14zlcd7wbyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdE/ew0YItGK8VTJ9IC2QSN+s4EikJ7INIVfH9/vrBV5pqf0gDX5ybMAVx4NNv+fbdcuIldT2H027onkfUNf3zAdymm90GahI5QSp4bdin8BnkTaRfWDj+vwWWnMOvq3cb4jeUa61mmumjDa3gdxk6GZiLDwTRMFuwWKZVfjgDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLngFZjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLngFZjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB58BC2BCB8;
	Mon,  4 May 2026 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904262;
	bh=fAjYWGij6Ai4L7J+o3l2M+DPhAdNXt3H14zlcd7wbyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLngFZjjWnpOJF+ovOxBRglsP43te8fcc1VTN7ZGqSunX9hMF+ubAfA58THCYGtqR
	 ygLly7dV0wIW93I1826seBCqwxo8CU22tQH+oRFgGPJP3ebT+nUUrDidewlALG66cc
	 d0w8isdvNKnbTzIgWYU5OPun0fMS4BpPwT4fJ04o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/275] arm64: mm: Simplify check in arch_kfence_init_pool()
Date: Mon,  4 May 2026 15:53:07 +0200
Message-ID: <20260504135152.216332108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Kevin Brodsky <kevin.brodsky@arm.com>

[ Upstream commit b7737c38e7cb611c2fbd87af3b09afeb92c96fe7 ]

TL;DR: checking force_pte_mapping() in arch_kfence_init_pool() is
sufficient

Commit ce2b3a50ad92 ("arm64: mm: Don't sleep in
split_kernel_leaf_mapping() when in atomic context") recently added
an arm64 implementation of arch_kfence_init_pool() to ensure that
the KFENCE pool is PTE-mapped. Assuming that the pool was not
initialised early, block splitting is necessary if the linear
mapping is not fully PTE-mapped, in other words if
force_pte_mapping() is false.

arch_kfence_init_pool() currently makes another check: whether
BBML2-noabort is supported, i.e. whether we are *able* to split
block mappings. This check is however unnecessary, because
force_pte_mapping() is always true if KFENCE is enabled and
BBML2-noabort is not supported. This must be the case by design,
since KFENCE requires PTE-mapped pages in all cases. We can
therefore remove that check.

The situation is different in split_kernel_leaf_mapping(), as that
function is called unconditionally regardless of the configuration.
If BBML2-noabort is not supported, it cannot do anything and bails
out. If force_pte_mapping() is true, there is nothing to do and it
also bails out, but these are independent checks.

Commit 53357f14f924 ("arm64: mm: Tidy up force_pte_mapping()")
grouped these checks into a helper, split_leaf_mapping_possible().
This isn't so helpful as only split_kernel_leaf_mapping() should
check both. Revert the parts of that commit that introduced the
helper, reintroducing the more accurate comments in
split_kernel_leaf_mapping().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: f12b435de2f2 ("arm64: mm: Fix rodata=full block mapping support for realm guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -773,18 +773,6 @@ static inline bool force_pte_mapping(voi
 	return rodata_full || arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
-static inline bool split_leaf_mapping_possible(void)
-{
-	/*
-	 * !BBML2_NOABORT systems should never run into scenarios where we would
-	 * have to split. So exit early and let calling code detect it and raise
-	 * a warning.
-	 */
-	if (!system_supports_bbml2_noabort())
-		return false;
-	return !force_pte_mapping();
-}
-
 static DEFINE_MUTEX(pgtable_split_lock);
 
 int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
@@ -792,11 +780,22 @@ int split_kernel_leaf_mapping(unsigned l
 	int ret;
 
 	/*
-	 * Exit early if the region is within a pte-mapped area or if we can't
-	 * split. For the latter case, the permission change code will raise a
-	 * warning if not already pte-mapped.
+	 * !BBML2_NOABORT systems should not be trying to change permissions on
+	 * anything that is not pte-mapped in the first place. Just return early
+	 * and let the permission change code raise a warning if not already
+	 * pte-mapped.
+	 */
+	if (!system_supports_bbml2_noabort())
+		return 0;
+
+	/*
+	 * If the region is within a pte-mapped area, there is no need to try to
+	 * split. Additionally, CONFIG_DEBUG_PAGEALLOC and CONFIG_KFENCE may
+	 * change permissions from atomic context so for those cases (which are
+	 * always pte-mapped), we must not go any further because taking the
+	 * mutex below may sleep.
 	 */
-	if (!split_leaf_mapping_possible() || is_kfence_address((void *)start))
+	if (force_pte_mapping() || is_kfence_address((void *)start))
 		return 0;
 
 	/*
@@ -1095,7 +1094,7 @@ bool arch_kfence_init_pool(void)
 	int ret;
 
 	/* Exit early if we know the linear map is already pte-mapped. */
-	if (!split_leaf_mapping_possible())
+	if (force_pte_mapping())
 		return true;
 
 	/* Kfence pool is already pte-mapped for the early init case. */



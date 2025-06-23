Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E0223DF0;
	Mon, 23 Jun 2025 22:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717055; cv=none; b=W7m/anQe5diUi7FPysak8GcHviHgPGe7p80z20EuAbZQFBX1w8RJq7KWJt3uKPBWZC0zlspV+NGiPwLA2E7fZRXFNwgSQa2BdnBHr0zLYivpuCM4rubxAA2SZ4ee8b8cZYyv0VmgwYeYWLTfHOWgUBBObmcgfAfhWo0t6r393eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717055; c=relaxed/simple;
	bh=GwHYjhU3g7IpkGvWes7KiERcv/xM8cllrP0fGQSf4kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H51BxVCVunuHNY00c4HXQFWlcYiMAIr8GqPdqI5K2goDc7XtIc3V4ttKdll3XlzPLnTMzxMl9G0fry6PFKXSptHNtxLDxsAG6lnO0qIefRJPEliR+SLKfYQdNc5+kkefS1Hg76V6Od+b03OWwBr7fwbCqHDAA+neutQz1f7B374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWsBSb+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWsBSb+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7E7C4CEEA;
	Mon, 23 Jun 2025 22:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717055;
	bh=GwHYjhU3g7IpkGvWes7KiERcv/xM8cllrP0fGQSf4kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWsBSb+FNBOkdUGG9A40P+M1IeZFrjBiXANqgowFhlE8iZKqj0/k1zDeNS7LklcoA
	 grOrZlr1MCCdha5Crj+mFUU5djr/Nxl4ek6joGHN7qmdqB8VdJB6d11WJhk6FWilth
	 L6k66cHtXJ5S4L3DVW9PEq5p249Wp992l6keyaco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 581/592] x86/mm: Fix early boot use of INVPLGB
Date: Mon, 23 Jun 2025 15:08:59 +0200
Message-ID: <20250623130714.256940260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit cb6075bc62dc6a9cd7ab3572758685fdf78e3e20 ]

The INVLPGB instruction has limits on how many pages it can invalidate
at once. That limit is enumerated in CPUID, read by the kernel, and
stored in 'invpgb_count_max'. Ranged invalidation, like
invlpgb_kernel_range_flush() break up their invalidations so
that they do not exceed the limit.

However, early boot code currently attempts to do ranged
invalidation before populating 'invlpgb_count_max'. There is a
for loop which is basically:

	for (...; addr < end; addr += invlpgb_count_max*PAGE_SIZE)

If invlpgb_kernel_range_flush is called before the kernel has read
the value of invlpgb_count_max from the hardware, the normally
bounded loop can become an infinite loop if invlpgb_count_max is
initialized to zero.

Fix that issue by initializing invlpgb_count_max to 1.

This way INVPLGB at early boot time will be a little bit slower
than normal (with initialized invplgb_count_max), and not an
instant hang at bootup time.

Fixes: b7aa05cbdc52 ("x86/mm: Add INVLPGB support code")
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20250606171112.4013261-3-riel%40surriel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4e06baab40bb3..a59d6d8fc71f9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -29,7 +29,7 @@
 
 #include "cpu.h"
 
-u16 invlpgb_count_max __ro_after_init;
+u16 invlpgb_count_max __ro_after_init = 1;
 
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481102E2F0C;
	Tue, 15 Jul 2025 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586809; cv=none; b=qyQ7lA0l58vZtuw5/ntujZBTHudYqJwDqGBmSZEx6Dt1JWoNONSsyD2ERhhWf71SMHAQZ0poqhFLohTpMXdOO5fLM2F/xW+UCoF43DttLa2FOAX9/LoWeEHMJj02bolXOS5wcTnkpGPbX3zHvZ1X4sYpDLjp02oCPiP7JwUrldU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586809; c=relaxed/simple;
	bh=aplGWxuyWnpriI8/kKa7PVnD8iQ34TgUjxhgXLJ3L0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7FK/QOCxwwOFctEJZws4d3VRm5qUCwTSXSnp0zG7hc5vJUzCO3TbUFWFnxHVHck6MfjXR/jGK2na20sZy6K3SIGshHl+Gkoe5/ZONZCfLWClZxFUaI6bxo6MZWiaX8hM7O1jpiUIuREZOD1s7gPsFepLysblHUMiekNeNhSOrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxLnXjex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxLnXjex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D007EC4CEE3;
	Tue, 15 Jul 2025 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586809;
	bh=aplGWxuyWnpriI8/kKa7PVnD8iQ34TgUjxhgXLJ3L0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxLnXjexsxSApLAZy4Zyb+60/q8Ml3bUzyCVlASpY4I8pvgxgkE3yWCRCW0G0CdXT
	 FFjOeYeYbgVuDIwj4fErrdAKGHKEo1q0jQLafqE5DJ6/hUQ1YfVldx1Nj/jWqYVjBY
	 VFLePFkLHCYdxkSQsnsKtXWWcF9Gl6nDymSZu6Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 025/192] arm64/mm: Drop wrong writes into TCR2_EL1
Date: Tue, 15 Jul 2025 15:12:00 +0200
Message-ID: <20250715130815.874397237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 9dd1757493416310a5e71146a08bc228869f8dae ]

Register X0 contains PIE_E1_ASM and should not be written into REG_TCR2_EL1
which could have an adverse impact otherwise. This has remained undetected
till now probably because current value for PIE_E1_ASM (0xcc880e0ac0800000)
clears TCR2_EL1 which again gets set subsequently with 'tcr2' after testing
for FEAT_TCR2.

Drop this unwarranted 'msr' which is a stray change from an earlier commit.
This line got re-introduced when rebasing on top of the commit 926b66e2ebc8
("arm64: setup: name 'tcr2' register").

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Fixes: 7052e808c446 ("arm64/sysreg: Get rid of the TCR2_EL1x SysregFields")
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250704063812.298914-1-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/proc.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index fb30c8804f87b..46a18af52980d 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -533,7 +533,6 @@ alternative_else_nop_endif
 #undef PTE_MAYBE_SHARED
 
 	orr	tcr2, tcr2, TCR2_EL1_PIE
-	msr	REG_TCR2_EL1, x0
 
 .Lskip_indirection:
 
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721C91DDC36;
	Mon,  6 Jan 2025 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178791; cv=none; b=mdrx3gStMiMR9+cwpfBApS8soDR/vp/X8uZIeN17T8FJCWpD3B+1B27lcJlYaZJd5ZRqlAyUOKz5eV7i1vphC0ngonT8GHpym33ZXOU3oJ9zTZOVuZZfJYAJHhyIzZVVZnjYFl+X3/Rcmpf8485sCjL/miFEp1prd/rTJkqKWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178791; c=relaxed/simple;
	bh=ccsDKME1LCsX1XmeMxGeVLKBlnmxULuHU3KsQvSQhuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB6BHC2q4hCKpQXjHXL7ej2mgBIFEkYQ0nVygfa3Sh+7328I2CoSvdsBHpbkMdLtvvMjtOQYl9kDRJ/neLn61t8U+tgPZAhi3Xz4aRVPuEv5ST+loZopSuNyrkW6D3m4P/+Lg8+K1mIas/m7TQYAbwvsKip/rk+riheuwh2KeAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJ7i3Q5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJ7i3Q5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D8C4CED2;
	Mon,  6 Jan 2025 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178791;
	bh=ccsDKME1LCsX1XmeMxGeVLKBlnmxULuHU3KsQvSQhuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJ7i3Q5hVH6DZbVMV1QgZgXHeJUX+ElxAFfLIGkhHSFGNA+F38S+kA2z56UGd7VO2
	 QKgddEyRCfbuZLh9QhqzuxrodSAb8EHt6T8pPrM4gM3Ou+1ItGfvHaCqJYg95Tc3bz
	 X/gX9cUylxEqCxn57AazKR/yKCw0eFgRuLhKVLGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/168] arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs
Date: Mon,  6 Jan 2025 16:16:41 +0100
Message-ID: <20250106151141.976873488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit c0900d15d31c2597dd9f634c8be2b71762199890 ]

Linux currently sets the TCR_EL1.AS bit unconditionally during CPU
bring-up. On an 8-bit ASID CPU, this is RES0 and ignored, otherwise
16-bit ASIDs are enabled. However, if running in a VM and the hypervisor
reports 8-bit ASIDs (ID_AA64MMFR0_EL1.ASIDBits == 0) on a 16-bit ASIDs
CPU, Linux uses bits 8 to 63 as a generation number for tracking old
process ASIDs. The bottom 8 bits of this generation end up being written
to TTBR1_EL1 and also used for the ASID-based TLBI operations as the
upper 8 bits of the ASID. Following an ASID roll-over event we can have
threads of the same application with the same 8-bit ASID but different
generation numbers running on separate CPUs. Both TLB caching and the
TLBI operations will end up using different actual 16-bit ASIDs for the
same process.

A similar scenario can happen in a big.LITTLE configuration if the boot
CPU only uses 8-bit ASIDs while secondary CPUs have 16-bit ASIDs.

Ensure that the ASID generation is only tracked by bits 16 and up,
leaving bits 15:8 as 0 if the kernel uses 8-bit ASIDs. Note that
clearing TCR_EL1.AS is not sufficient since the architecture requires
that the top 8 bits of the ASID passed to TLBI instructions are 0 rather
than ignored in such configuration.

Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241203151941.353796-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index bbc2708fe928..d160100c8dab 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -32,9 +32,9 @@ static unsigned long nr_pinned_asids;
 static unsigned long *pinned_asid_map;
 
 #define ASID_MASK		(~GENMASK(asid_bits - 1, 0))
-#define ASID_FIRST_VERSION	(1UL << asid_bits)
+#define ASID_FIRST_VERSION	(1UL << 16)
 
-#define NUM_USER_ASIDS		ASID_FIRST_VERSION
+#define NUM_USER_ASIDS		(1UL << asid_bits)
 #define ctxid2asid(asid)	((asid) & ~ASID_MASK)
 #define asid2ctxid(asid, genid)	((asid) | (genid))
 
-- 
2.39.5




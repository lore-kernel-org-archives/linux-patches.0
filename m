Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465F81DE2A5;
	Mon,  6 Jan 2025 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178317; cv=none; b=oSTIMvTZn2ggwhRsXFETgMLBPwl5oS1JyvYKh/9j7KwfqS4y4Fqo2yNQjmB3/t85lRXRSmK/DCtfds+j7OPvANUYx0YpgmkJlZ6wKv2rsZS/ld1zEkyNhNYBb8JfcNLvfY6gGEpulTlIzspF6oMgfZbjUTCki1KZQIuFZXuJkfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178317; c=relaxed/simple;
	bh=59l+HHomKtPCXumSaZBUskFSWeLzU5yOaCEBreLzbB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElMSPuOTNi0n2uSoshzTA4G4YgzpqHE7OGTwYLnyDLgUG+KSk8iH+lUH0XZ7/WZWGJ6K7EsemFOrgts7Gh9HQIXpNEd1mUYuRIk0CMw/pCgsZptPcgclrCfA/s5+waottjM0AuNrK6aUdUQlvss34wr3OxGHu39mmOhR8Iz8qbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZMHFBuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZMHFBuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05CBC4CED6;
	Mon,  6 Jan 2025 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178317;
	bh=59l+HHomKtPCXumSaZBUskFSWeLzU5yOaCEBreLzbB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZMHFBuS4NoVeTa4Pq94rSjiswRXYsfsoJuNi9jfNOiKfyF8MblCpNkoo/Nbk2GGA
	 VGhN6o1CwBA79BGhxeNd0ekFupLyU80hdgU6X2orynhzykV0vtdwlWtCtzaYDlVcXC
	 Fp2+UohtYYGNJ4OvDEoTixOJYJ0PLdfN2cbEK3z4=
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
Subject: [PATCH 5.10 077/138] arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs
Date: Mon,  6 Jan 2025 16:16:41 +0100
Message-ID: <20250106151136.147611991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 171f2fcd3cf2..4115c40a3ccc 100644
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




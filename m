Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498D21C4613;
	Tue,  8 Oct 2024 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391700; cv=none; b=i0QgdKf+atoVaTGT/Mg6Ce3bNDELnvS0sJthpcXWHZK6zS3HkoJhmHu7BA+p3aTV9aamnYZq2OVtFSJ6qigHu/H6PDUJcHUjjBubR5VVPAp6cv6lEnN4xa0TtBlxEOVKSLqmY4jMIaWUmC3nTotINjRFR87XxE7T+KASSpOokQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391700; c=relaxed/simple;
	bh=vjMQ8MLHwQ3PcpKHtEKhuA5HvEfp2EexcbYYtbBfNT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvsHSHymIfiFeA6yHIhJ17pRrv40jESjRYyKmj2prhBUZJ52/t/jLz7ogwl5UXXbUFmVg0gM9YcI6pSrOgDNBmrWGi/GlssX+g6teuRnDPslXj70ar96sxRwhBkCkpqHnhHrummSYsmkujCH8M3PBcP3R79KGd2BZl0wELT9Bd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQOS0g0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQOS0g0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D6BC4CEC7;
	Tue,  8 Oct 2024 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391700;
	bh=vjMQ8MLHwQ3PcpKHtEKhuA5HvEfp2EexcbYYtbBfNT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQOS0g0J6HnZdqGOupCh4z2woc3lvI5oczmofW1Gw+mmFuE2fA70qfqniYVFPge/l
	 fPpRQYu/xTo1dkC+rzOeVORZmUrZAc3gSBObROhsg0oD7BWImAl2dNgoYhwPioQ0OI
	 T+PadusnmoCCh7uZiS21+kz8s+r0Zn8sjlIBEAmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 196/558] iommu/arm-smmu-v3: Match Stall behaviour for S2
Date: Tue,  8 Oct 2024 14:03:46 +0200
Message-ID: <20241008115710.063802837@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit ce7cb08e22e09f43649b025c849a3ae3b80833c4 ]

According to the spec (ARM IHI 0070 F.b), in
"5.5 Fault configuration (A, R, S bits)":
    A STE with stage 2 translation enabled and STE.S2S == 0 is
    considered ILLEGAL if SMMU_IDR0.STALL_MODEL == 0b10.

Also described in the pseudocode “SteIllegal()”
    if STE.Config == '11x' then
        [..]
        if eff_idr0_stall_model == '10' && STE.S2S == '0' then
            // stall_model forcing stall, but S2S == 0
            return TRUE;

Which means, S2S must be set when stall model is
"ARM_SMMU_FEAT_STALL_FORCE", but currently the driver ignores that.

Although, the driver can do the minimum and only set S2S for
“ARM_SMMU_FEAT_STALL_FORCE”, it is more consistent to match S1
behaviour, which also sets it for “ARM_SMMU_FEAT_STALL” if the
master has requested stalls.

Also, since S2 stalls are enabled now, report them to the IOMMU layer
and for VFIO devices it will fail anyway as VFIO doesn’t register an
iopf handler.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Link: https://lore.kernel.org/r/20240830110349.797399-2-smostafa@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 1 +
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f490385c13605..d271525fa3917 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1012,7 +1012,8 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
-				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
+				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2S |
+				    STRTAB_STE_2_S2R);
 		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
 	}
 
@@ -1646,6 +1647,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		STRTAB_STE_2_S2ENDI |
 #endif
 		STRTAB_STE_2_S2PTW |
+		(master->stall_enabled ? STRTAB_STE_2_S2S : 0) |
 		STRTAB_STE_2_S2R);
 
 	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
@@ -1739,10 +1741,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 		return -EOPNOTSUPP;
 	}
 
-	/* Stage-2 is always pinned at the moment */
-	if (evt[1] & EVTQ_1_S2)
-		return -EFAULT;
-
 	if (!(evt[1] & EVTQ_1_STALL))
 		return -EOPNOTSUPP;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 14bca41a981b4..0dc7ad43c64c0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -267,6 +267,7 @@ struct arm_smmu_ste {
 #define STRTAB_STE_2_S2AA64		(1UL << 51)
 #define STRTAB_STE_2_S2ENDI		(1UL << 52)
 #define STRTAB_STE_2_S2PTW		(1UL << 54)
+#define STRTAB_STE_2_S2S		(1UL << 57)
 #define STRTAB_STE_2_S2R		(1UL << 58)
 
 #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
-- 
2.43.0




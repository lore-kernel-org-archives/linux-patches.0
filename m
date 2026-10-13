Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE804EE845;
	Tue, 13 Oct 2026 11:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892545; cv=none; b=e0PnkPAOgsogwgvuR4kjOCZyufE9gp/boTPv1J3/16QZ2klZTGQkN116pDrg7kF64V/zKkus6AhXoAG63RrwLCoM224rFNCcdCC/y7QFhmov7DWmBiwbP12tnHcr59/UGE74CwLMFA2PqML6CnqKuXtl6SNfWCv7ld9Xpzs6SxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892545; c=relaxed/simple;
	bh=DjMbwTX/0YU2kyaole2meKjTh1p6IYWYgPVQfumE+Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0qq4len6wUNYExEgO2Oy89EmAzN06GHERUuC89RAVpf4o3O3mNaynHM5Q5liWSrDXX+pHjmtfsGEhw3iq1YMC3aJ1tOJN78WWxPwqyl4p719jHSjEKpvjpfQQXOXJgZkpXYes6IlggVyLepBEAvNW/kXL0A+IP5XTiYCuuH0Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4Wuh2x/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4Wuh2x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538941F000FF;
	Tue, 13 Oct 2026 11:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892544;
	bh=fY6npDr5JbQD16IWCgmw3vh9iLM6DDr5ehwrODtIgNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4Wuh2x/ktCmTSPuzD7QGWE4uMQ4ortrNQr05rgMHYbFBkaBVrf4NhaVEDuI2oKLm
	 B0pf2uOApe+2K087kuw3mZnQdn33/quY6QIS/ZF7NqyD2LAbZ4fZq1lzcN358mEyJY
	 o/BEq2YHiAv3bLWzeKIDmTnoXJIaExI5li1xGqTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Bradley Morgan <brads@mainlining.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 208/281] arm64/boot: Dont set PMUv3p9 FGT2 bits without PMUv3
Date: Tue, 13 Oct 2026 13:38:44 +0200
Message-ID: <20261013112900.211143008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit b52ef450139f5632d7e53e6fd5f5ec46c7029dac ]

On a CPU with FGT2 and an IMPLEMENTATION DEFINED PMU (PMUVer 0b1111),
__init_el2_fgt2 sets the PMUv3p9 bits in HDFGRTR2_EL2 and HDFGWTR2_EL2,
which are RES0 there. The macro only checks that PMUVer is at least
PMUv3p9, and 0b1111 passes.

Exclude 0b1111 before the compare, as __init_el2_debug does.

Fixes: 858c7bfcb35e1 ("arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 87560d8b254e6..1da277baacf78 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -421,8 +421,9 @@
 	mov	x2, xzr
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
-	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
-	b.lt	.Lskip_pmuv3p9_\@
+	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	ccmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9, #8, ne
+	b.lt	.Lskip_pmuv3p9_\@		// Skip if < PMUv3p9 or IMP_DEF
 
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
-- 
2.53.0




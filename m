Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690F8301F0D;
	Sat, 28 Feb 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301414; cv=none; b=Nsh3VelUnVxnqcyy9pQhdtBzSYRlKMUsEJh+/s31XMaBimWZSMO4W+0pqQTMsm1tXmlYamkXunDo1Y/WuYcvBqyf3/imO/cV8U6/nJb2/S8a/Gf5C1jmnRsniQTgmCSAlUl8CV2yh+65GZMLS+C+n9S4UZx6p84V7pYSCD+a+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301414; c=relaxed/simple;
	bh=rwpnN65rYIVoqLu8TfEfLFo5uFAQg+Ke2vYqkzMDlU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcN/uVy6vVWA3jwvHaVn8V2IJBRfOV7Pv6iddQ0YYVfPXeeY8oQAabaLd9ByBOpCVBXXP5ntw7Q4/veWwd6WByhRm+sKwhzxz2NEzJZIXIGIgsmgFOsThFpUBWMZUKc1HQZMxBmFoTZUfhPXc2Q0CPUE8lzZn4q84yqx32HODWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxjsZ2u5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxjsZ2u5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1FFC19423;
	Sat, 28 Feb 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301414;
	bh=rwpnN65rYIVoqLu8TfEfLFo5uFAQg+Ke2vYqkzMDlU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxjsZ2u5fUyKFG3wP59tLJzDj9/lcS2Pvdfe6Bh194eAg+fytPMYsNkLrC+lZaKPc
	 g5rCpBwcRh/dd8m2eKwM0J+igz8Nv0jGhDS4zs/IHJ1i2LsGMD50eeZhzT9BFjeA7+
	 6fKS98/OYo2Xda5yjQlAGyVnVFrJXmPp2S/a6KWKSbc8g9pDg9jtB+Mpk3mBU8fhPe
	 rnQ1Jk7D3QqouQrOvDpXrbM52DmAcO4Ul2yXg4R0QcFVUIo3kbLffqe1/SvDsFQao+
	 ZjHrQx6yBJLoaBiwVpNxMKPtK8swA2Qbm9Xnr9NqBl7WS8F/e+SEZj5ymxMmFn2/QZ
	 H1GZR+YsQ3FlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	stable@vger.kernel.org,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 603/752] iommu/arm-smmu-v3: Mark EATS_TRANS safe when computing the update sequence
Date: Sat, 28 Feb 2026 12:45:14 -0500
Message-ID: <20260228174750.1542406-603-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 7cad800485956a263318930613f8f4a084af8c70 ]

If VM wants to toggle EATS_TRANS off at the same time as changing the CFG,
hypervisor will see EATS change to 0 and insert a V=0 breaking update into
the STE even though the VM did not ask for that.

In bare metal, EATS_TRANS is ignored by CFG=ABORT/BYPASS, which is why this
does not cause a problem until we have the nested case where CFG is always
a variation of S2 trans that does use EATS_TRANS.

Relax the rules for EATS_TRANS sequencing, we don't need it to be exact as
the enclosing code will always disable ATS at the PCI device when changing
EATS_TRANS. This ensures there are no ATS transactions that can race with
an EATS_TRANS change so we don't need to carefully sequence these bits.

Fixes: 1e8be08d1c91 ("iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 +++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bb755c7ef9a79..1e47da0ce6b9b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1097,6 +1097,32 @@ VISIBLE_IF_KUNIT
 void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
 				  __le64 *safe_bits)
 {
+	const __le64 eats_s1chk =
+		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_S1CHK);
+	const __le64 eats_trans =
+		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_TRANS);
+
+	/*
+	 * When an STE changes EATS_TRANS, the sequencing code in the attach
+	 * logic already will have the PCI cap for ATS disabled. Thus at this
+	 * moment we can expect that the device will not generate ATS queries
+	 * and so we don't care about the sequencing of EATS. The purpose of
+	 * EATS_TRANS is to protect the system from hostile untrusted devices
+	 * that issue ATS when the PCI config space is disabled. However, if
+	 * EATS_TRANS is being changed, then we must have already trusted the
+	 * device as the EATS_TRANS security block is being disabled.
+	 *
+	 *  Note: now the EATS_TRANS update is moved to the first entry_set().
+	 *  Changing S2S and EATS might transiently result in S2S=1 and EATS=1
+	 *  which is a bad STE (see "5.2 Stream Table Entry"). In such a case,
+	 *  we can't do a hitless update. Also, it should not be added to the
+	 *  safe bits with STRTAB_STE_1_EATS_S1CHK, because EATS=0b11 would be
+	 *  effectively an errant 0b00 configuration.
+	 */
+	if (!((cur[1] | target[1]) & cpu_to_le64(eats_s1chk)) &&
+	    !((cur[2] | target[2]) & cpu_to_le64(STRTAB_STE_2_S2S)))
+		safe_bits[1] |= cpu_to_le64(eats_trans);
+
 	/*
 	 * MEV does not meaningfully impact the operation of the HW, it only
 	 * changes how many fault events are generated, thus we can relax it
-- 
2.51.0


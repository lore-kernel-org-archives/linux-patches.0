Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41CD83A17;
	Tue, 30 Jul 2024 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358816; cv=none; b=JjJ3+FH0pnBv++VCRA7Ylkqq3IzpZmQB9OpGfH4/cgXiwS1STS6SaEC/TFW1bXDxDAw0K2VsmqZ13LNa45KMfjXKwrkOJOaRx3Dxb2JKH/SBU+74aS2je2DmqzYqfcnliWtlKE6+ZCrCPuHP3Hgjsn6Xigg2efWkBSL+wn3FHLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358816; c=relaxed/simple;
	bh=ltQa8xFjd1cWd/C6yZ3oCT4Ry971ly0g3tD1unS2yHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USAH8H8rbpMTFiTizKcDlMbYZmPbfPwZS4G5uhUNUNAglL8wddCsx9jlW3fyQqavpL5xyhJnSnOMyb80lyyYh1tzlqxysLXT1Idg2lo+fb6IhOXdKDspVXGDL87Mhz7w1MfAbOn5JzRo0MURessIRki+FWpHYnul5O6FKiZ3syw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDIR/Z9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDIR/Z9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F5AC32782;
	Tue, 30 Jul 2024 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358816;
	bh=ltQa8xFjd1cWd/C6yZ3oCT4Ry971ly0g3tD1unS2yHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDIR/Z9zVd19UxW1gy9M0RDCOjw3yrCzNb0hzphDLF0tZwSdKEVz/Hjp+rPIyG1SY
	 tQl84XuA89agxaFNqeJ6aDEQLOJNmtVmoLk5HSeyW+HX2Lhhj4OHtDI2kQxTA7PTW8
	 2UCJvTY+9GTKID1h1Q5Fll5Fesc8dL0KiCg2q/Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 399/809] iommu/arm-smmu-v3: Avoid uninitialized asid in case of error
Date: Tue, 30 Jul 2024 17:44:35 +0200
Message-ID: <20240730151740.444912636@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit d3867e7148318e12b5d69b64950622f5ed06fe86 ]

Static checker is complaining about the ASID possibly set uninitialized.
This only happens in case of error and this value would be ignored anyway.

A simple fix would be just to initialize the local variable to zero,
this path will only be reached on the first attach to a domain where
the CD is already initialized to zero.
This avoids having to bloat the function with an error path.

Closes: https://lore.kernel.org/linux-iommu/849e3d77-0a3c-43c4-878d-a0e061c8cd61@moroto.mountain/T/#u
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Fixes: 04905c17f648 ("iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20240604185218.2602058-1-smostafa@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ab415e107054c..f456bcf1890ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2302,7 +2302,7 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 				       struct arm_smmu_domain *smmu_domain)
 {
 	int ret;
-	u32 asid;
+	u32 asid = 0;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
 	refcount_set(&cd->refs, 1);
-- 
2.43.0




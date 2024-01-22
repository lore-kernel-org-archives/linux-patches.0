Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A7421340;
	Tue, 23 Jan 2024 00:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969832; cv=none; b=EWGlMIlwKqmHsg6xYy/jjMB4RFK5+4dGLsmcrNlUbTYqEJ9UahiencNFlDl/3jDbjkoSRRTpv/9LRETgh4+fzNU1BMs9ybjmz8a7Xj9CCV6P3UjzZ2WA+R7+PtLgZOfpOEbmtVLjm3AfZXWZsLk8RL06UeoBRKZ6pHur78EeDMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969832; c=relaxed/simple;
	bh=ONA8VCsmsxZuh8ycUL95gPH3kvgW3U3U9LXr0xDVITg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQR+anTEOHF3Jd2Y7Arb6csJ1vmgPRUQxtyh8rWaIveNR4UYteHEGq2yxmIYYMfJ7UMOzdEC1+PGNovvYHflXHEjrVZJroMEgGeFlVwIPDbiZzLgmTxOCh8Qz+OsCpeNhvXnRhiwk+L19zzq7SSfIScD1pqY+G4GccsUJpG3x4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7d8mZp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7d8mZp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77538C43390;
	Tue, 23 Jan 2024 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969831;
	bh=ONA8VCsmsxZuh8ycUL95gPH3kvgW3U3U9LXr0xDVITg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7d8mZp/UAr9FB/WCqkJOM9LcSIj1tR+m5j9yTb01QVxAPbUB+LsQnYnEQsKdeL6+
	 ygv+MGUPBu36YLYxlqgOcMmLQOiOYChtQ00+AiZz/qWgsuYF59xxlxc95NK4crOWAZ
	 Zwp3dT0i1954GcEYRENL1og98hLK3AMmCbkiVnCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.7 452/641] iommu/arm-smmu-qcom: Add missing GMU entry to match table
Date: Mon, 22 Jan 2024 15:55:56 -0800
Message-ID: <20240122235832.166172745@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

commit afc95681c3068956fed1241a1ff1612c066c75ac upstream.

In some cases the firmware expects cbndx 1 to be assigned to the GMU,
so we also want the default domain for the GMU to be an identy domain.
This way it does not get a context bank assigned.  Without this, both
of_dma_configure() and drm/msm's iommu_domain_attach() will trigger
allocating and configuring a context bank.  So GMU ends up attached to
both cbndx 1 and later cbndx 2.  This arrangement seemingly confounds
and surprises the firmware if the GPU later triggers a translation
fault, resulting (on sc8280xp / lenovo x13s, at least) in the SMMU
getting wedged and the GPU stuck without memory access.

Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20231210180655.75542-1-robdclark@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -243,6 +243,7 @@ static int qcom_adreno_smmu_init_context
 
 static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,adreno" },
+	{ .compatible = "qcom,adreno-gmu" },
 	{ .compatible = "qcom,mdp4" },
 	{ .compatible = "qcom,mdss" },
 	{ .compatible = "qcom,sc7180-mdss" },



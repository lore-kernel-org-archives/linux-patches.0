Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525014B084;
	Fri,  6 Dec 2024 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496201; cv=none; b=HXgV2GtFCIkKECmn/mH+aWeTyOiDm/kA0Bwiny3wqLaUGZi+YcQWhss0U5fIluKjYe22OdOAk3BzkXftWuLt7pSh6p9vBHUBCzgOMmEA8FoKwb25VaFNamMrUMlZx4ztJ0x42gIZlxJq37bYZHaJG6k2I0eap4IN2hTIauOsSFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496201; c=relaxed/simple;
	bh=nlpaO/EM0+Cmt+aujYHUZGtf16ii7YIwVIA5+W+6hdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T64Ohkl48MCj6Ie6tHM2qTY54JeISIM7SskPQWQx5NIQAq4ppEaDeHz2AeY+904pIzcAvdoQpm9FenDNHAQH53IMUgzU4us82hVHvmDm95SSAPq0N3RqyVkav5RPyTPn98fYLG1Qj0iF7A/xgMguH9j/WvIJXhzrwlgJqgEFk8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NY/g2+gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NY/g2+gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888C2C4CED1;
	Fri,  6 Dec 2024 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496201;
	bh=nlpaO/EM0+Cmt+aujYHUZGtf16ii7YIwVIA5+W+6hdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NY/g2+gqlCumLjAsbhfbguXumZ6YK30P3R/QYYF+hkbHHkpDA6YfpQ5e6ya9HmLnb
	 hJzSmM3JEs/VLX98VQEEJ22eeVwsJ4U6Yd9cZqEg2qAAD/ah4zu455xgIh4z9VBjJ3
	 itnocWMasLOUbIFOgn0fZxPa9St+XCWvxijUPqCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prakash Gupta <quic_guptap@quicinc.com>,
	Pratyush Brahma <quic_pbrahma@quicinc.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 049/146] iommu/arm-smmu: Defer probe of clients after smmu device bound
Date: Fri,  6 Dec 2024 15:36:20 +0100
Message-ID: <20241206143529.552199607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Brahma <quic_pbrahma@quicinc.com>

commit 229e6ee43d2a160a1592b83aad620d6027084aad upstream.

Null pointer dereference occurs due to a race between smmu
driver probe and client driver probe, when of_dma_configure()
for client is called after the iommu_device_register() for smmu driver
probe has executed but before the driver_bound() for smmu driver
has been called.

Following is how the race occurs:

T1:Smmu device probe		T2: Client device probe

really_probe()
arm_smmu_device_probe()
iommu_device_register()
					really_probe()
					platform_dma_configure()
					of_dma_configure()
					of_dma_configure_id()
					of_iommu_configure()
					iommu_probe_device()
					iommu_init_device()
					arm_smmu_probe_device()
					arm_smmu_get_by_fwnode()
						driver_find_device_by_fwnode()
						driver_find_device()
						next_device()
						klist_next()
						    /* null ptr
						       assigned to smmu */
					/* null ptr dereference
					   while smmu->streamid_mask */
driver_bound()
	klist_add_tail()

When this null smmu pointer is dereferenced later in
arm_smmu_probe_device, the device crashes.

Fix this by deferring the probe of the client device
until the smmu device has bound to the arm smmu driver.

Fixes: 021bb8420d44 ("iommu/arm-smmu: Wire up generic configuration support")
Cc: stable@vger.kernel.org
Co-developed-by: Prakash Gupta <quic_guptap@quicinc.com>
Signed-off-by: Prakash Gupta <quic_guptap@quicinc.com>
Signed-off-by: Pratyush Brahma <quic_pbrahma@quicinc.com>
Link: https://lore.kernel.org/r/20241004090428.2035-1-quic_pbrahma@quicinc.com
[will: Add comment]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1437,6 +1437,17 @@ static struct iommu_device *arm_smmu_pro
 			goto out_free;
 	} else {
 		smmu = arm_smmu_get_by_fwnode(fwspec->iommu_fwnode);
+
+		/*
+		 * Defer probe if the relevant SMMU instance hasn't finished
+		 * probing yet. This is a fragile hack and we'd ideally
+		 * avoid this race in the core code. Until that's ironed
+		 * out, however, this is the most pragmatic option on the
+		 * table.
+		 */
+		if (!smmu)
+			return ERR_PTR(dev_err_probe(dev, -EPROBE_DEFER,
+						"smmu dev has not bound yet\n"));
 	}
 
 	ret = -EINVAL;



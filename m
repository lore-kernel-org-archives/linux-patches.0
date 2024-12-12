Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465522B58A;
	Thu, 12 Dec 2024 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023238; cv=none; b=hbb0cLFLCTaI0MimqypuYtwWJQkY1EV1CXd2PxLkB99qTjiQEf71IOTlEtmHSfwUpIueVnm9wGL06fFCo2dkzPPVKaoen/z5Pr7gmne45RSreBbv9zp8w49Q7/tfs+BKbJmsWtvT4LRSxLh3xemZuiUzFKXXUI9aqtN1u7487dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023238; c=relaxed/simple;
	bh=ZI5OdUy1G8+fFSyvJ1+2Cc/A3IMvvaWkh3SnkDtI4RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXkuJWlNLMwqNdCrlYOFPZpHFLgihTm088PA62MkB+KAJBZBh4aM4zizi2KSIHL/6qZhsLXJi2vG8i/tRASNjY6sLZOPtXtLdObuPkFc+jFGDJf0uNSnVYW+/8fYgdNHW7S0lchNWudh38UsVG1vWj0teBWVFH4e9zEQT51Asmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blp2BJLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blp2BJLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7430FC4CED4;
	Thu, 12 Dec 2024 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023237;
	bh=ZI5OdUy1G8+fFSyvJ1+2Cc/A3IMvvaWkh3SnkDtI4RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blp2BJLmcWe8I+tYkVnTkEjz1XSItQD//XjvoPzdGfYClJqvn5Lm9LKiMNmrphlfe
	 O3XPbB+X6xWAjklDVZaH1bFBnmKdTT8l93xztbO+DT1LPIJ9kx1FHBnpT/lT5hyPzM
	 CuWjc640a2H9f8sil41gLELuLebL7gN24ewWk8rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prakash Gupta <quic_guptap@quicinc.com>,
	Pratyush Brahma <quic_pbrahma@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 5.15 468/565] iommu/arm-smmu: Defer probe of clients after smmu device bound
Date: Thu, 12 Dec 2024 16:01:03 +0100
Message-ID: <20241212144330.235117742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[rm: backport for context conflict prior to 6.8]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1375,6 +1375,17 @@ static struct iommu_device *arm_smmu_pro
 			goto out_free;
 	} else if (fwspec && fwspec->ops == &arm_smmu_ops) {
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
 	} else {
 		return ERR_PTR(-ENODEV);
 	}



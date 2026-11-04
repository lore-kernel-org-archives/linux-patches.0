Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827174;
	b=RnTzd9Jy2m8Io+bAVcEaRt8h38BOJup17LRj/aKhU4O+0RfCuP5ren0tylMHwtnzAwHy
	 16yE3+RiBKleaFc3BeBb4E/6VFB+9vQX0RR3zvh56IetD3OgbCromDu3QVkrheU2Bipt4
	 88aoYINQ/35SxxJRqFccsQZhC86kDiZjaIN0SFLyQWMAD62j1A4zFJncLdOiWyytXUjmv
	 oDrnyXkY2VcxDraLpS7POxmhQT/Qh1W3WQQYlrO769V5CyG2XXDaHBpqxwGxs/C2tlliT
	 pEimxJjvmUGacxZcJosJ0kukjgqOxN7pbCKYnHM6wTJHMCCsaMRUPIpjjGmTfNwqY9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8XCmfzg/PyYYdrTg0vD7sbM4oY+AkDAyC2L5EtPRKCM=;
	b=UcNI31ovII2BNXkD+XdOgWbABhLj/oTmbTDcyHgoD8TErMi1BECEI9VkMSwDin+XBCNo
	 eHexV+1QbLCr3Q8rYNRKnQwGYO5fq+e4Z91Z2Yjm0kSNFCfplZM8RuR6HfJF/qoVmEcxD
	 jNtqIlawfKZYX/Ceg4ZAaQr1jXFUzTu+MJSRHsDSur7cNMKfnTRCuNB27OQSO1GTlkwnd
	 E4W9+RSql+fi1unwPdr7fAIEMHHgQbNvTP7Xs6e5D8n4eRB3PyMQ0/drZdjL2DuZeWGrt
	 2VS51gDFZy6lNZ0n+9R57fbD/IGvGksz18XGoSVXUnLWcfSGEWU590cYA5oPFWhNTDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v2+Chv/2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0026075241;
	Wed,  4 Nov 2026 21:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2+Chv/2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54851F000C1;
	Wed,  4 Nov 2026 21:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827174;
	bh=8XCmfzg/PyYYdrTg0vD7sbM4oY+AkDAyC2L5EtPRKCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2+Chv/2vlDqDiE0KkDX5l8h2uSOIbQmVM+NieSvkT8gEkirZJRRf/7/+pJb1gti7
	 Uju68B68LQgQApgy3XI7NSODSQztxmw679fIZ3CZCmuRpL0J3Og9tWYaZ7apSyFTu3
	 Pt9J7R/dU/Ju0+oZxQ7wrY1OiYqJS391fy2GseTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.3 221/547] iommu/arm-smmu-v3: Disable the impl before disabling the SMMU on shutdown
Date: Wed,  4 Nov 2026 16:06:45 -0500
Message-ID: <20261104211044.433161684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit ab0dbf411aced59c04ce86fd8443faf13bdc9936 upstream.

arm_smmu_device_shutdown() only calls arm_smmu_device_disable(), and never
the impl_ops->device_disable() hook. On tegra241-cmdqv, that hook quiesces
every VINTF through tegra241_vintf_hw_deinit(), which issues a CMD_SYNC on
the shared CMDQ while it is still enabled.

arm_smmu_disable_action() already runs this hook before disabling the SMMU,
to cover an unbind or a probe failure, and no devres release ever follows a
reboot or a kexec to run it again. Have arm_smmu_device_shutdown() call it
directly, instead of reimplementing part of what it already does.

Fixes: 9ff145a25c5c ("iommu/tegra241-cmdqv: Fix CMD_SYNC use-after-free on teardown")
Cc: stable@vger.kernel.org
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -5633,7 +5633,7 @@ static void arm_smmu_device_shutdown(str
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	arm_smmu_device_disable(smmu);
+	arm_smmu_disable_action(smmu);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {



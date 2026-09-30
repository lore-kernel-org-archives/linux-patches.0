Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF108515964;
	Wed, 30 Sep 2026 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786816; cv=none; b=lVfXr+OY4EcZ2mijazNbS2HetnDWrOOWOtOfK5ofWR9ONpQ5l5rKM6/pnSe2jXxZwU9BafTUFaF4isNRAFsEeY4YJgCGGSof70i23j/93JZAbreOsuuaribB8VNV2caa1w9N5hdQJENlmoNFy2dwbOlwnFhuA+7HIZUkZkpbaxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786816; c=relaxed/simple;
	bh=S0Z9PPmfVj0y6hswtPeFOutxafG6sNffn3V1j++OrYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixCvgg39wiJCOzk/Rm3XyM64YsGVhHGKbREJsSN8n7vyqKEnu2d8oQRmAIWGGG2vtmdaCtf9FRoseIC7c31sNtVs0z7YUE0dKjaiItRI0MiGUP77y7jIbRTLE1nd3r7m70+dInNfgI8RpSBYFBHGbDzICYShUxQ3QST0i+VlOIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssEcRVSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssEcRVSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D451F0089A;
	Wed, 30 Sep 2026 16:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786815;
	bh=PCqHMY2U3j5+XmaddKgBpNG0noxWPqqr3TjgKkJ6SLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssEcRVScZ1LLC56GPBpYkAIb1q+DPN4QOwi0LcnV4DiTMW50xF/xYUsKS+8OiLCUU
	 JoqNztm/01tPAtt+nFe6d2g0A1HrK/0hkoFgdlrbbU7DUp+WDWBPFW9dEWR3jMplBY
	 GUwK6yTTmvIN1fEa/RQ9xJV5lSrb4Dz7V8c+PtLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 005/457] remoteproc: qcom_q6v5_adsp: Fix iommu_unmap() usage
Date: Wed, 30 Sep 2026 17:21:50 +0200
Message-ID: <20260930152346.147787141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 0d8e2195bce6f08c1c53c5ef4d7347fe46418101 ]

During adsp_map_carveout, the IOVA is computed by combining the
physical address and the SID:
    iova = adsp->mem_phys | (sid << 32);

However, adsp_unmap_carveout() uses the physical address and not
the IOVA in iommu_unmap(), causing the unmap to fail or leak
mappings because the address doesn't match the original IOVA.

Cache the constructed IOVA within the qcom_adsp device struct
during mapping and use it during unmapping.

Fixes: f22eedff28af ("remoteproc: qcom: Add support for memory sandbox")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Link: https://lore.kernel.org/r/20260827203055.640116-1-smostafa@google.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index c81e6c33c7479..9c5dedf0aa605 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -104,6 +104,7 @@ struct qcom_adsp {
 	struct completion stop_done;
 
 	phys_addr_t mem_phys;
+	unsigned long iova;
 	phys_addr_t mem_reloc;
 	void *mem_region;
 	size_t mem_size;
@@ -333,7 +334,7 @@ static void adsp_unmap_carveout(struct rproc *rproc)
 	struct qcom_adsp *adsp = rproc->priv;
 
 	if (adsp->has_iommu)
-		iommu_unmap(rproc->domain, adsp->mem_phys, adsp->mem_size);
+		iommu_unmap(rproc->domain, adsp->iova, adsp->mem_size);
 }
 
 static int adsp_map_carveout(struct rproc *rproc)
@@ -341,7 +342,6 @@ static int adsp_map_carveout(struct rproc *rproc)
 	struct qcom_adsp *adsp = rproc->priv;
 	struct of_phandle_args args;
 	long long sid;
-	unsigned long iova;
 	int ret;
 
 	if (!adsp->has_iommu)
@@ -358,9 +358,9 @@ static int adsp_map_carveout(struct rproc *rproc)
 	of_node_put(args.np);
 
 	/* Add SID configuration for ADSP Firmware to SMMU */
-	iova =  adsp->mem_phys | (sid << 32);
+	adsp->iova = adsp->mem_phys | (sid << 32);
 
-	ret = iommu_map(rproc->domain, iova, adsp->mem_phys,
+	ret = iommu_map(rproc->domain, adsp->iova, adsp->mem_phys,
 			adsp->mem_size,	IOMMU_READ | IOMMU_WRITE,
 			GFP_KERNEL);
 	if (ret) {
-- 
2.53.0




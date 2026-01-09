Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F0435CBB4;
	Fri,  9 Jan 2026 12:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963113; cv=none; b=a9am0oKKCa4VyYMMGmJKj4BzwK51y+SaGyoGMmw3Vsr6guk2NARVcVVnPo1QPWt5GNUrY2Rfl0Tme9knaX5FopdFGmMHynk4UZcMy5hIz+OdOZByVnxdDzxDzItVOEQGiyEgqwEPK1Fo4BINfAmzMgGtuMi/T90Oayi4h3D8YLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963113; c=relaxed/simple;
	bh=MKzxBzko7SSpch+PpsKGaKdPwfugIiBKz1npz2dx1QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJhZOrBO6jeMGiFCtcza0nMmINc/qAPrlXQ3mqjc5rUUEXxq5h65VvfNbtJpmfHSemXjtN4a4v2Bo9Hf5MouqPBY4YXs6ruuc9CkpBaqZpL2Zqqc2Rcda6AMzfCsOlIOfxuQZ/Aoatw65uJZfb62Pfkia6SiRRszQJxcAMzGwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qi6H5WcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qi6H5WcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A9C16AAE;
	Fri,  9 Jan 2026 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963113;
	bh=MKzxBzko7SSpch+PpsKGaKdPwfugIiBKz1npz2dx1QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qi6H5WcLlOvmYyhJXOPY5hliFNEI7eu2eCzu2m42xjm0cylmaA8AAvqlC+1PeM90s
	 tLu1jHJbEyuAIyQ36dQJ6g/qEwX2/97ocxJW6VWYeUgy1ECgaBwJYnpWmSVTZJD1yT
	 W1+S5g1NNTDaYynxCYwRrh6VjbfjW/QJFTyKz5Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 602/634] iommu/qcom: Use the asid read from device-tree if specified
Date: Fri,  9 Jan 2026 12:44:40 +0100
Message-ID: <20260109112140.279466614@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit fcf226f1f7083cba76af47bf8dd764b68b149cd2 ]

As specified in this driver, the context banks are 0x1000 apart but
on some SoCs the context number does not necessarily match this
logic, hence we end up using the wrong ASID: keeping in mind that
this IOMMU implementation relies heavily on SCM (TZ) calls, it is
mandatory that we communicate the right context number.

Since this is all about how context banks are mapped in firmware,
which may be board dependent (as a different firmware version may
eventually change the expected context bank numbers), introduce a
new property "qcom,ctx-asid": when found, the ASID will be forced
as read from the devicetree.

When "qcom,ctx-asid" is not found, this driver retains the previous
behavior as to avoid breaking older devicetrees or systems that do
not require forcing ASID numbers.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
[Marijn: Rebased over next-20221111]
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230622092742.74819-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 6a3908ce56e6 ("iommu/qcom: fix device leak on of_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -563,7 +563,8 @@ static int qcom_iommu_of_xlate(struct de
 	 * index into qcom_iommu->ctxs:
 	 */
 	if (WARN_ON(asid < 1) ||
-	    WARN_ON(asid > qcom_iommu->num_ctxs)) {
+	    WARN_ON(asid > qcom_iommu->num_ctxs) ||
+	    WARN_ON(qcom_iommu->ctxs[asid - 1] == NULL)) {
 		put_device(&iommu_pdev->dev);
 		return -EINVAL;
 	}
@@ -650,7 +651,8 @@ free_mem:
 
 static int get_asid(const struct device_node *np)
 {
-	u32 reg;
+	u32 reg, val;
+	int asid;
 
 	/* read the "reg" property directly to get the relative address
 	 * of the context bank, and calculate the asid from that:
@@ -658,7 +660,17 @@ static int get_asid(const struct device_
 	if (of_property_read_u32_index(np, "reg", 0, &reg))
 		return -ENODEV;
 
-	return reg / 0x1000;      /* context banks are 0x1000 apart */
+	/*
+	 * Context banks are 0x1000 apart but, in some cases, the ASID
+	 * number doesn't match to this logic and needs to be passed
+	 * from the DT configuration explicitly.
+	 */
+	if (!of_property_read_u32(np, "qcom,ctx-asid", &val))
+		asid = val;
+	else
+		asid = reg / 0x1000;
+
+	return asid;
 }
 
 static int qcom_iommu_ctx_probe(struct platform_device *pdev)



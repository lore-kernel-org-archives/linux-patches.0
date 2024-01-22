Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA712F59D;
	Tue, 23 Jan 2024 01:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971870; cv=none; b=ES14bj8gsvpJgazUqbUIRmkLZx1fWMAfWeTkA7w1lhY53BrIuAmLbOOmEv7V/6c5GAtOFCslIZFuFBLbuZmSx2VK3hdX73xU0R9uuCQMPDm3WZgyZyfTYtfHbjk1kcE3gD5tJLxltt+b+hEf8e8PJAcnoV1l4c3DaPMdoZnoS5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971870; c=relaxed/simple;
	bh=EsWGJTWFIIU3vjNucytyAqgeF9g/LYJgb4PFADgbqEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzBSeJyr4YgK3LoWs38SjRFThLyE+DrEnMiqVHWOVN16BHgqfcIbZKWPi9t3HjkM+dXI+48zjeawZB2I/xIjnKH2FQwsxMMi2g0x/IA2JFpV+6kPBC/ZT1jvd+UTlZ5d2M2mBALnnICIoz4rV6vrul/9rE7BnRbrPzbn5yo7a/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MqxQ3gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MqxQ3gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A793C433F1;
	Tue, 23 Jan 2024 01:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971870;
	bh=EsWGJTWFIIU3vjNucytyAqgeF9g/LYJgb4PFADgbqEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MqxQ3gRrN8N9Fnv0iQRCeoUK6gFeVJKRKRjx7tfOFUZmt5o6+wubz7vYQoU82xsq
	 69XBK7OUyynkWT/eH2+ja924eIaJV87TyiX0DNhp1cRTzZOiUBE2JVLhBL1Ug20rEi
	 5dbD2pxaKONdz/rRpkQ75tYb5y11XYnpvNIvAKvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 227/286] iommu/arm-smmu-qcom: Add missing GMU entry to match table
Date: Mon, 22 Jan 2024 15:58:53 -0800
Message-ID: <20240122235740.817334403@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -21,6 +21,7 @@ static struct qcom_smmu *to_qcom_smmu(st
 
 static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,adreno" },
+	{ .compatible = "qcom,adreno-gmu" },
 	{ .compatible = "qcom,mdp4" },
 	{ .compatible = "qcom,mdss" },
 	{ .compatible = "qcom,sc7180-mdss" },



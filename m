Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48E429403;
	Tue, 23 Jan 2024 01:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974742; cv=none; b=BjZh/Rxwz3FFl5jEhJRdQ+pZB5u3VYJg0MQzciorei+34AE8GxNfo3ZDVQ/X+rLO/h3o3F2uPETFt1JTKKJLZUfkDAonrnwtn2z3ZQqMLkQFw1w5u9pnQcF2xqCKENvz/3YHHkQffXt/5c9Zg/61lChtTRWLpKYSb6x3oIhwrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974742; c=relaxed/simple;
	bh=qCx2JOvjUP3Nr16p8wN6OM1PVokLPcptMok1We+RYIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsCQNnXYu0OJt1nb5f21MBvi1DJ7QUBD9Z3WKmmnZxMvwhSt2XMrCVqJJblu4tKaFr7XoZffSC+iLwKRIOAOGsLHaTB3oU9GdFl3eEjF3AShP5rebemMn7uIbkaDauZNbbXJick4v1o2HY7w6utMbL1iqdw5veLsIeX5l7jgsmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHYtOoG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHYtOoG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95DBC43394;
	Tue, 23 Jan 2024 01:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974741;
	bh=qCx2JOvjUP3Nr16p8wN6OM1PVokLPcptMok1We+RYIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHYtOoG3mKrxuIKGJQtzQZ+Ho8BRPg4GINkwE+4m5aZXUMVCKovlPTtMlM39SCU9S
	 JYCO2khN+R51n2Zx/EsSXEsmg1XrVP40f9Rf5K2Gn8aD4VbyskUt6lA17GkAk8gIbB
	 3MceH6asEqajiU2YK3dINCG53PAJhtBZFarK/1ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 276/374] iommu/arm-smmu-qcom: Add missing GMU entry to match table
Date: Mon, 22 Jan 2024 15:58:52 -0800
Message-ID: <20240122235754.374657615@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
@@ -226,6 +226,7 @@ static int qcom_adreno_smmu_init_context
 
 static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,adreno" },
+	{ .compatible = "qcom,adreno-gmu" },
 	{ .compatible = "qcom,mdp4" },
 	{ .compatible = "qcom,mdss" },
 	{ .compatible = "qcom,sc7180-mdss" },



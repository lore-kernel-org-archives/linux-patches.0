Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FF1A618E;
	Tue, 30 Jul 2024 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356641; cv=none; b=LE0FWpE3Uf7jZIWqjb5oeK8BWU5hGj75qAQvxY8CGPtDZQ4/lruRN9Gf3hdDDt31mggzz26jsjYPaqqCMosQoMPbIrW8y45jTVsQV8fIFZns+mWnTge1rm3xHpZo2xCCYk1oSnsYuHkkSh15nPLx91Lq/201EdE0V4qR2eKPyys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356641; c=relaxed/simple;
	bh=SCTSqtRT9pd3mKe4h62r359eYHeiovHdsl4xFlSAG1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4gkaAQCSCKiCW8fOAuIU6R0kOAuXkXAv+qXyJYN05mg+/KqIlyLNCVteBHPELjQsqzHbunzcYbZjlNSudYjLZNV7HWa89/IbyNeCEP1bM3dIBccetLeV0tzAONVUNXXbHibkTeiGUM63Sb0rplzAA8tDq3DKYP8LyBy70cVMRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a72KZbQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a72KZbQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BCCC32782;
	Tue, 30 Jul 2024 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356641;
	bh=SCTSqtRT9pd3mKe4h62r359eYHeiovHdsl4xFlSAG1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a72KZbQiKqdfDGRksdkEcK/qdrkPmp4ulfkXUA9YW+petY9aoRYvmpawiezcuOwZw
	 wu+yhymM/oBdFvotGUFr8KL2myfbtYgVFzSpUYZxK6E/cklE21fHUGf93nyWU9ea/g
	 ZI4rmszYfVwg+o3se647pH172+98fL+qC4UbteaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/440] ASoC: qcom: Adjust issues in case of DT error in asoc_qcom_lpass_cpu_platform_probe()
Date: Tue, 30 Jul 2024 17:47:15 +0200
Message-ID: <20240730151623.760960957@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit f9f7f29f64454bb20896c7d918c3abc3a1aa487b ]

If IORESOURCE_MEM "lpass-rxtx-cdc-dma-lpm" or "lpass-va-cdc-dma-lpm"
resources is not provided in Device Tree due to any error,
platform_get_resource_byname() will return NULL which is later
dereferenced. According to sound/qcom,lpass-cpu.yaml, these resources
are provided, but DT can be broken due to any error. In such cases driver
must be able to protect itself, since the DT is external data for the
driver.
Adjust this issues by adding NULL return check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b138706225c9 ("ASoC: qcom: Add regmap config support for codec dma driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://patch.msgid.link/20240605104953.12072-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index dbdaaa85ce481..4387cca893c5d 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1160,9 +1160,13 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 		}
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lpass-rxtx-cdc-dma-lpm");
+		if (!res)
+			return -EINVAL;
 		drvdata->rxtx_cdc_dma_lpm_buf = res->start;
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lpass-va-cdc-dma-lpm");
+		if (!res)
+			return -EINVAL;
 		drvdata->va_cdc_dma_lpm_buf = res->start;
 	}
 
-- 
2.43.0




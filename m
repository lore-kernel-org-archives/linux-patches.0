Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1A1A619B;
	Tue, 30 Jul 2024 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357630; cv=none; b=MavppEdRUSlPV34xqSaSdND2knx/COStTxNcoz1f4qRsJaHLEKL4c/K3SB7ltaR7t9f1dG66V6mZJZOvTYvKH46/dCludIdk4n7jrFdW5NNxP9KqcB/EUtfp4mtKYJxNVsRdAeRhsrfsbwW+i3wQvJ8kK96uyzD1sHxXnnUEJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357630; c=relaxed/simple;
	bh=W4JUBtHfw+o/CMhEqsJm2SCfaUAYtozPjKOM3agHihg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0jMiU7dj4BW1gsWZcewN/sjTwfphpFcMsumijMtxsMBF1nED9P0UWHgdzgaizeVje/QE7M07Ah4m0EvcoiDeqXZ77lqHsXL1qnGJANGDOfv1MPryO9B9BsWm4xhbQcGx2MjOsoyAjM5q5kyywURfWhTmeBlzzgpJ0y2tPyxUsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLL+kjLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLL+kjLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528BAC4AF0E;
	Tue, 30 Jul 2024 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357630;
	bh=W4JUBtHfw+o/CMhEqsJm2SCfaUAYtozPjKOM3agHihg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLL+kjLJGZmf7u/MlpP9pR4EMPK3G2X1cksKvB+quQCUxa0447PQPyosOUIaVzGr+
	 zyCLuQX2ZDutOnziTPVWEgtqFK90HcmMC5FQRTlJlz4FFIBo8vbWWoinU2UqA0Ilc4
	 a2/jwbXYRn3fk/UV1RZ84cucsqmZ3tb2KFakda8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/568] ASoC: qcom: Adjust issues in case of DT error in asoc_qcom_lpass_cpu_platform_probe()
Date: Tue, 30 Jul 2024 17:46:23 +0200
Message-ID: <20240730151650.667144375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39571fed40019..73b42d9ee2447 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1170,9 +1170,13 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
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




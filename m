Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCFB4369A;
	Wed, 25 Feb 2026 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982975; cv=none; b=HWwObYkQebQgOmvgcwiYQyXUdjNXljnjXnaGOwh+PUiLI2pCRv6PDorD1L0hRvfdujf/YGdfGldM8DEh5ffzXAanlkPqZViqUuNYWZmDaN0UAmisIC7/hAQTmcXupl6O5w1A/HZbZK8eCSjnfHhrF7r+5CEn5WfWf05rm3TnZmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982975; c=relaxed/simple;
	bh=EKLZ7VUTGrkpJAxTL1iuwl7BCadnd+BpIMEeusOGf/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8CWeu6EINnBXrsjkPRhr/Hm0DIvxElmNtheTE5EfQzm5zJQWmd/9sfWHZHW0183Nl6XIUfDBaq9SsHunSFjMhWEyQ0GGNFvXvIEcBnRx6aj/kAWA0s21Z9vIJIlwXFtrjkwxESufmyC4xGoyWJj58ddhzb7lE0s+WgDBGDRePc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P61fGDOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P61fGDOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBBDC19423;
	Wed, 25 Feb 2026 01:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982975;
	bh=EKLZ7VUTGrkpJAxTL1iuwl7BCadnd+BpIMEeusOGf/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P61fGDOWEodRVNnWZigbewkC5qHuM2JVPTeRq/SLyJ4/dhEEzE6kLb1zueXlbz9d+
	 8P3zZGQXeapYDQ7Cj4IpQBZcpWVfwtHuAglpk0X2QHB/CgwW1lWBpLfZeSSG+lWuxs
	 7A7zvrpFNo+Q/Ofo4mOpyfrBwCIEcymNnmocHxK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 149/781] clk: qcom: Return correct error code in qcom_cc_probe_by_index()
Date: Tue, 24 Feb 2026 17:14:18 -0800
Message-ID: <20260225012403.318529865@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1e07ebe744fb522983bd52a4a6148601675330c7 ]

When devm_platform_ioremap_resource() fails, it returns various
error codes. Returning a hardcoded -ENOMEM masks the actual
failure reason.

Use PTR_ERR() to propagate the actual error code returned by
devm_platform_ioremap_resource() instead of -ENOMEM.

Fixes: 75e0a1e30191 ("clk: qcom: define probe by index API as common API")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251217041338.2432-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 1215918867741..eec369d2173b5 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -454,7 +454,7 @@ int qcom_cc_probe_by_index(struct platform_device *pdev, int index,
 
 	base = devm_platform_ioremap_resource(pdev, index);
 	if (IS_ERR(base))
-		return -ENOMEM;
+		return PTR_ERR(base);
 
 	regmap = devm_regmap_init_mmio(&pdev->dev, base, desc->config);
 	if (IS_ERR(regmap))
-- 
2.51.0




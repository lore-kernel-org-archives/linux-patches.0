Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCB223E75;
	Thu, 12 Dec 2024 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024988; cv=none; b=Zyaq7dC+xIOJqUWI4wnmUMVtbdRoaRDUz0j4Ri9MPTOsq+huwV54+YriHarlV5INkn4JQFC60/vreMT9x7wiluDdGYO2tGzlzMH3VSFRt6wqOG+l7p2+kMHV3XnwPm2ghm+poj4rGixDmacxrVIc1slgLKCJkbLuVpLWatyVbts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024988; c=relaxed/simple;
	bh=vyitnWBR2zwucku0GsfeMrKODNCQJeJd0RGEoSWR//0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxeQ0LHviJQJcX5g4IlpNjEw1CT2XSVSXsXFdQOWywufB5NFecNUPzWJii7BFdRFyOw0fwnBZytRza55LGU9Rq/achH14G19D4dYYui7OvaDUlPVNhuulUzyF03cC4d9VK7CRGS4w9CfSNANMilbDkoh6aVrg/FolL54o0yxzHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cNLtxJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cNLtxJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B657BC4CED0;
	Thu, 12 Dec 2024 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024988;
	bh=vyitnWBR2zwucku0GsfeMrKODNCQJeJd0RGEoSWR//0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cNLtxJHsnwrnSnpKcTlndhzb3DuE2Dp5IpnF9Mxa8aGwO/v+Gh+lZOJvwaVJiIp8
	 znUH2+BDmS3fealuQbWOIAHEqxNhSuuKLpIgCag9rodrBjNMb/5jPE1l4iVxQwDRAP
	 LLt9ou/bbHgw7R/n62+AqNKIY1Xerly7gelbHOsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/321] soc: qcom: Add check devm_kasprintf() returned value
Date: Thu, 12 Dec 2024 15:58:57 +0100
Message-ID: <20241212144230.404776041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit e694d2b5c58ba2d1e995d068707c8d966e7f5f2a ]

devm_kasprintf() can return a NULL pointer on failure but this
returned value in qcom_socinfo_probe() is not checked.

Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20240929072349.202520-1-hanchunchao@inspur.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 3303bcaf67154..8a9f781ba83f7 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -433,10 +433,16 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
 	qs->attr.revision = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%u.%u",
 					   SOCINFO_MAJOR(le32_to_cpu(info->ver)),
 					   SOCINFO_MINOR(le32_to_cpu(info->ver)));
-	if (offsetof(struct socinfo, serial_num) <= item_size)
+	if (!qs->attr.soc_id || qs->attr.revision)
+		return -ENOMEM;
+
+	if (offsetof(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));
+		if (!qs->attr.serial_number)
+			return -ENOMEM;
+	}
 
 	qs->soc_dev = soc_device_register(&qs->attr);
 	if (IS_ERR(qs->soc_dev))
-- 
2.43.0




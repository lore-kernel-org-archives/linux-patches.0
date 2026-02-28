Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79528301EEF;
	Sat, 28 Feb 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301405; cv=none; b=QjhskAqXzqjd96DrJWJAoNQtc5NwNeBeuoHgRTfmqCjD/dGFYlrYODjaXGnUtwCdwnxJxmWJNXONoQbFVpBHCzOVp6oJICGXinB57QQZTDAMgqyFj6LmpVU2Jgf+yegaVUqHCt3Th/pb3DKyMefi4GeqB/7QiVNyKCjqB0DLxg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301405; c=relaxed/simple;
	bh=YwH7ocqVR6BTEcFleyAorSaH1+d3lxPTj54krC2x6Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2qYC8LDVVc9z47WNep/l60PbZXzFOHFTJmJOyMgCFQKUfQ/bXVLn9U4qzK3JQstd8MVIQa0/rIen6IQzYmiQV/+ot30Qz9wpQ+d0jTO8Uw0BPDBULlqHkMdrEyVFfreW9Ukszze+jlkclfnol7OcjqnPJ7Tb7KNvqD2s0sWH1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5baiLJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5baiLJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD93C19423;
	Sat, 28 Feb 2026 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301405;
	bh=YwH7ocqVR6BTEcFleyAorSaH1+d3lxPTj54krC2x6Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5baiLJWDZbwOwLVBtY/otjq8P+Ghw9ueZl/mrv5arcnQrQdaign7YwVyif1GhoSA
	 XouyT+o0wVvvZhkHIP0KY/xYSY1JcwFov2OOS+Q6kJ+dIaqUKMnOuokP/0j5lOWbV2
	 2YiCq7/UvA/gCeksSnTmL0OnPNxUqiyQlJ8fAB8/Xkmwt41peFbRuYtIfOtyQiCPEC
	 /MEwehe9OfzmLEN7HOH+P6GyhvgblD4+nxrCFsukk6lndgdz8CJnw7YJ11diJfWdS+
	 LzrvjNahmmJdAbsa8eQLuyQ06ytcixQ91OJsT/O/KPJ1f0ELjZP0Kzn1L83vHPFeal
	 RynI5GycmQBng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Johan Hovold <johan@kernel.org>,
	stable@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 594/752] mfd: qcom-pm8xxx: Fix OF populate on driver rebind
Date: Sat, 28 Feb 2026 12:45:05 -0500
Message-ID: <20260228174750.1542406-594-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 27a8acea47a93fea6ad0e2df4c20a9b51490e4d9 ]

Since commit c6e126de43e7 ("of: Keep track of populated platform
devices") child devices will not be created by of_platform_populate()
if the devices had previously been deregistered individually so that the
OF_POPULATED flag is still set in the corresponding OF nodes.

Switch to using of_platform_depopulate() instead of open coding so that
the child devices are created if the driver is rebound.

Fixes: c6e126de43e7 ("of: Keep track of populated platform devices")
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20251219110947.24101-1-johan@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qcom-pm8xxx.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/mfd/qcom-pm8xxx.c b/drivers/mfd/qcom-pm8xxx.c
index 1149f7102a365..0cf374c015ce7 100644
--- a/drivers/mfd/qcom-pm8xxx.c
+++ b/drivers/mfd/qcom-pm8xxx.c
@@ -577,17 +577,11 @@ static int pm8xxx_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int pm8xxx_remove_child(struct device *dev, void *unused)
-{
-	platform_device_unregister(to_platform_device(dev));
-	return 0;
-}
-
 static void pm8xxx_remove(struct platform_device *pdev)
 {
 	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
 
-	device_for_each_child(&pdev->dev, NULL, pm8xxx_remove_child);
+	of_platform_depopulate(&pdev->dev);
 	irq_domain_remove(chip->irqdomain);
 }
 
-- 
2.51.0


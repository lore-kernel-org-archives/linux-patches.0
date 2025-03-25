Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3571BF9E6;
	Tue, 25 Mar 2025 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906234; cv=none; b=kORHi1pI4L3lL+QmYROKtoIoftfKtHW+u/21LEDhvwtxMaQFW0Hhbc6Gev+eEGPpgJqTFe/yDSXUE/yKtlQUfv3Tnda1QZIo2Y2p74ChE/R3S1GXCK5Ya4JOAUcVLxUeoze5ZqFnTL8P2isbMMtTcI8OKnIP4QS8umP4vP2q3ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906234; c=relaxed/simple;
	bh=JsEOCXT3QO0V8hQTSdiD45aoAG3taYBdb7gLJse+UIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IL3Vm2QWJAMqlDNGHm9lnQJI+AtT5nRgbHWHIJZ8oYfXceoZDMRkkttiCttmPx6R+GD66m/U9YQ9zDyv0Kfz4yPtDtpL/nM8aOVG8qrE+B3I5AyLrU3/+6UFej43wJBcyQRdgfr7E+3VlXd33Cyb1NfkArefm7ti6f1sMYo/9uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QesZm273; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QesZm273"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0693C4CEE4;
	Tue, 25 Mar 2025 12:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906234;
	bh=JsEOCXT3QO0V8hQTSdiD45aoAG3taYBdb7gLJse+UIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QesZm2734uFoSDCJNMmbsTnRJtrnjNBVu1QyASZk+FcAgUd3XVrCJTlWFvg4bUMYk
	 CEqm8/KCryUfen+gYS1WxXZd6CfYxLOJRfL4MCb0uiDig5aVyWls4Jesl0QOx2BLGv
	 bjavyeLod87VCIZhKygIDMBjqFHlU2Sr9QESPtb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/116] firmware: qcom: scm: Fix error code in probe()
Date: Tue, 25 Mar 2025 08:21:28 -0400
Message-ID: <20250325122149.246645726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7f048b202333b967782a98aa21bb3354dc379bbf ]

Set the error code if devm_qcom_tzmem_pool_new() fails.  Don't return
success.

Fixes: 1e76b546e6fc ("firmware: qcom: scm: Cleanup global '__scm' on probe failures")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/a0845467-4f83-4070-ab1e-ff7e6764609f@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 2e093c39b610a..23aefbf6fca58 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2054,8 +2054,8 @@ static int qcom_scm_probe(struct platform_device *pdev)
 
 	__scm->mempool = devm_qcom_tzmem_pool_new(__scm->dev, &pool_config);
 	if (IS_ERR(__scm->mempool)) {
-		dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
-			      "Failed to create the SCM memory pool\n");
+		ret = dev_err_probe(__scm->dev, PTR_ERR(__scm->mempool),
+				    "Failed to create the SCM memory pool\n");
 		goto err;
 	}
 
-- 
2.39.5




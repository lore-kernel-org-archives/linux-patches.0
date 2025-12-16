Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566E534B191;
	Tue, 16 Dec 2025 11:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885232; cv=none; b=QDlWonpgHiZRmjHlbbhEwjloA8xVmu4mcqlzX5LuG5pskbzUdo5v81P6wYuT4o9ti9aoguCYArrnHRokKs2EoPP93ILscO4liMMHSCPViKU9UKCRZW9Hc5GLu7HDjaWmPf9xUZ/l4HUgxEY7wRbDUWAB/cBnC/3gxcchGwkN2mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885232; c=relaxed/simple;
	bh=O2RvOqVAFylLdn1xUlsE4TG1Eoz3b9dTi5fJhpA9gf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7Z3U3VrYgnnRX+OBptuqTKxNHXmamRRceFB0E1ob7jTGBgfgdP/NnjOgxqwAkkhqMKZx6SESuENjYdRils5ZlgGFI5KQOkxzDzB7fQSCWRrnkggrN4k94dqXavz/kahca2RxRrc07YyqyaQAKj3GLDWi6BLp02wCRTw6JKDccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRJrJA4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRJrJA4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B17C4CEF5;
	Tue, 16 Dec 2025 11:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885232;
	bh=O2RvOqVAFylLdn1xUlsE4TG1Eoz3b9dTi5fJhpA9gf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRJrJA4RtxM3mz7qcTIEXCaHOb7NJXiZX2dwCr5ZFzdsbFVpmpln9JROrhSP8TdLV
	 1mfMXcB2vHiheStoWkjUtbp4lrD3tnhx+ETWKQkIKdFyNAl1zQ16B3na2L2kqUHbPB
	 yZwIt6iWgqJEI0q/rJT09YM5LfBK92RakpTTRlqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/507] soc: qcom: gsbi: fix double disable caused by devm
Date: Tue, 16 Dec 2025 12:08:39 +0100
Message-ID: <20251216111348.368771699@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2286e18e3937c69cc103308a8c1d4898d8a7b04f ]

In the commit referenced by the Fixes tag, devm_clk_get_enabled() was
introduced to replace devm_clk_get() and clk_prepare_enable(). While
the clk_disable_unprepare() call in the error path was correctly
removed, the one in the remove function was overlooked, leading to a
double disable issue.

Remove the redundant clk_disable_unprepare() call from gsbi_remove()
to fix this issue. Since all resources are now managed by devres
and will be automatically released, the remove function serves no purpose
and can be deleted entirely.

Fixes: 489d7a8cc286 ("soc: qcom: use devm_clk_get_enabled() in gsbi_probe()")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/stable/20251020160215.523-1-vulab%40iscas.ac.cn
Link: https://lore.kernel.org/r/20251020160215.523-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_gsbi.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
index 8f1158e0c6313..a25d1de592f06 100644
--- a/drivers/soc/qcom/qcom_gsbi.c
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -212,13 +212,6 @@ static int gsbi_probe(struct platform_device *pdev)
 	return of_platform_populate(node, NULL, NULL, &pdev->dev);
 }
 
-static void gsbi_remove(struct platform_device *pdev)
-{
-	struct gsbi_info *gsbi = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(gsbi->hclk);
-}
-
 static const struct of_device_id gsbi_dt_match[] = {
 	{ .compatible = "qcom,gsbi-v1.0.0", },
 	{ },
@@ -232,7 +225,6 @@ static struct platform_driver gsbi_driver = {
 		.of_match_table	= gsbi_dt_match,
 	},
 	.probe = gsbi_probe,
-	.remove = gsbi_remove,
 };
 
 module_platform_driver(gsbi_driver);
-- 
2.51.0




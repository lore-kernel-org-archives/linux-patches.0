Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE023F417;
	Fri,  9 Jan 2026 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961691; cv=none; b=RYQQQzuM4IGXGzOiJG7j5uQvDsbaUwqXMRMReSxlLO+QG79CblXNNwl8OMI+TzF6CLdosNOk0AkSH7gW9sqO70ZVw502HPbXwL5wb0PKmi674LYx5MxedQYHoEPOAEGFak6+bLgCt/bGFOpNo64tSaz4czcqtO42/hkX/kjwSv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961691; c=relaxed/simple;
	bh=yI64JihuP2h9PgVOtQ3BLRljZTkJSflKwOJ/cbJT3oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbqWuCRrVb3n8b7OD/vamqADRTYw2Upi0t3Yyd5TVf81bk0Vy5jeBRWq0/8XebNPFuHPHV4XcFzKp5HcmEh58C/5jeGPsFueANFCRRZ5zu0rasysSHl9cvu6/q45TmppKsGBqI6GAwKBMYiJyrdSHmfjOyLMWQvks6bLGNZM+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhbMnXvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhbMnXvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ECBC4CEF1;
	Fri,  9 Jan 2026 12:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961691;
	bh=yI64JihuP2h9PgVOtQ3BLRljZTkJSflKwOJ/cbJT3oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhbMnXvJiwGB6fPaVAMuAM9yI+GebhiH+dQ33ym7d2QtqFyiRSqDs4pI2RPkBowA9
	 FHhb9vOAbsaVaeKiwDa9kq59C7Tv4oCwtOG/2P6AQW+Cmu7y6kvUAstOGsiHYNQOBo
	 rHe6jpS5B2Uhu2QD/eApgOy0x9GSP+5aAzhKn84Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/634] soc: qcom: smem: fix hwspinlock resource leak in probe error paths
Date: Fri,  9 Jan 2026 12:35:48 +0100
Message-ID: <20260109112120.078486273@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit dc5db35073a19f6d3c30bea367b551c1a784ef8f ]

The hwspinlock acquired via hwspin_lock_request_specific() is not
released on several error paths. This results in resource leakage
when probe fails.

Switch to devm_hwspin_lock_request_specific() to automatically
handle cleanup on probe failure. Remove the manual hwspin_lock_free()
in qcom_smem_remove() as devm handles it automatically.

Fixes: 20bb6c9de1b7 ("soc: qcom: smem: map only partitions used by local HOST")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251029022733.255-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index e4e6c6d69bf55..06958de43f8ca 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1105,7 +1105,7 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		return hwlock_id;
 	}
 
-	smem->hwlock = hwspin_lock_request_specific(hwlock_id);
+	smem->hwlock = devm_hwspin_lock_request_specific(&pdev->dev, hwlock_id);
 	if (!smem->hwlock)
 		return -ENXIO;
 
@@ -1158,7 +1158,6 @@ static int qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
 
-	hwspin_lock_free(__smem->hwlock);
 	__smem = NULL;
 
 	return 0;
-- 
2.51.0




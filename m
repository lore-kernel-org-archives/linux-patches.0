Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1292BF000;
	Tue, 16 Dec 2025 11:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885401; cv=none; b=quHVcpYc++GzlhX5pskXOuTw6TVm1DXUtqGRVFRkQvHC7FptypopjfJzMowlM4yGp14nqH8/pC6nAMsrvuwDMSNPKY1UL3QMwpvliVChCN8kIaO4YHWq8hOTMqhkhtmQ8HyeVhDKvIt5FOQIkGEN8AEWmQF3UhmNs3KF5Qe9NG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885401; c=relaxed/simple;
	bh=PcSLF8yZ6G33L7YsLl17AIXVJ3+C7Mu5akv7DBc1q8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKoi+OzsrVXFDDC1aAr0/MqJcu/tvQ7uG9hd9FJ82DRLv1ZxBVX/whKmW78RZUY6gMZP3dOCpzVXOsG+1a0JKCpKTXmjA6iyKcbKadkFmnW9MEp5in+w88UGbBWRy8UuTlhHUGiQZXv8OGwMhoejoa1xvjEE8mcGv5q+zhuc9Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqY8/QtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqY8/QtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CF0C4CEF1;
	Tue, 16 Dec 2025 11:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885401;
	bh=PcSLF8yZ6G33L7YsLl17AIXVJ3+C7Mu5akv7DBc1q8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqY8/QtZ18nClMg32eWa1fbw/IPjEDEf872WlRv7MbJEN7VV9GVO7g0hkSGlJAe1Q
	 GzTaftAn3gl98JI6TNF11NO+NMP35pFAOuthMR0fIYhsBFIQwXBslPFJNFZ9pi2MiH
	 ZSpnEAN8Ub1VXlBNqfuF9oTS4PcvduwStUa6e5bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/507] soc: qcom: smem: fix hwspinlock resource leak in probe error paths
Date: Tue, 16 Dec 2025 12:09:28 +0100
Message-ID: <20251216111350.132452282@linuxfoundation.org>
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
index c4c45f15dca4f..f1d1b5aa5e4db 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1190,7 +1190,7 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, hwlock_id,
 				     "failed to retrieve hwlock\n");
 
-	smem->hwlock = hwspin_lock_request_specific(hwlock_id);
+	smem->hwlock = devm_hwspin_lock_request_specific(&pdev->dev, hwlock_id);
 	if (!smem->hwlock)
 		return -ENXIO;
 
@@ -1243,7 +1243,6 @@ static void qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
 
-	hwspin_lock_free(__smem->hwlock);
 	__smem = NULL;
 }
 
-- 
2.51.0




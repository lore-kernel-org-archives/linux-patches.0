Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8C71DE4CC;
	Tue,  8 Oct 2024 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392985; cv=none; b=jlw8Mh+nCECSlPCYxWk2J4xt5McoEuRNseioSfXE6Wq8Pbps2L/Z1n7687Bggn270CWM4NPh3oXVvVCrLAcCRVgYdkPgVg66ZvRpUge7bdnFX+4Bf4hdb3WgjsrBYt82UtMhL3NGNg9jvLnsD+5Eld9/8Qmw3z+rejHH/HCiK5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392985; c=relaxed/simple;
	bh=vaZ/pAUdS+N1XtJo5RlieC8mw8NZIEqP9IFO0NRXTOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h48KMOR/SR3d8I28XeYlUvVRKZD5bWcq7VlQ0M/8PnZZNY9BZYgMnBCS8suv/byzQeGmEE2BjndHq+Efy9sOUXxkP8KyA6S1r5HUyF585HKGTsGZSkrvZgAh96Pu/MbuliC8b9GOAYbVjaW4vwKrVXoPZEyqcZ196kI+RzPVTgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oIsOKzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oIsOKzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10DBC4CEC7;
	Tue,  8 Oct 2024 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392985;
	bh=vaZ/pAUdS+N1XtJo5RlieC8mw8NZIEqP9IFO0NRXTOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oIsOKznn+4bO00OGZzMHc278C7JBxFR12dXlwSfRTp7AvctEdlQrgXIARfBz7fi/
	 tJZi/eM1YTz0ICeLNIYFWuyhaDkb3U9Te169dnxBzQ4AOVqBKm+zmRW39wRHQyUxOL
	 eT+t8rvtdEWXhazb08auihrHaJcyMf5D4CJy24pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/386] net: wwan: qcom_bam_dmux: Fix missing pm_runtime_disable()
Date: Tue,  8 Oct 2024 14:04:24 +0200
Message-ID: <20241008115630.081005212@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit d505d3593b52b6c43507f119572409087416ba28 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time.

But the pm_runtime_disable() and pm_runtime_dont_use_autosuspend()
is missing in the error path for bam_dmux_probe(). So add it.

Found by code review. Compile-tested only.

Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/qcom_bam_dmux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/qcom_bam_dmux.c b/drivers/net/wwan/qcom_bam_dmux.c
index 17d46f4d29139..174a9156b3233 100644
--- a/drivers/net/wwan/qcom_bam_dmux.c
+++ b/drivers/net/wwan/qcom_bam_dmux.c
@@ -823,17 +823,17 @@ static int bam_dmux_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(dev, pc_ack_irq, NULL, bam_dmux_pc_ack_irq,
 					IRQF_ONESHOT, NULL, dmux);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	ret = devm_request_threaded_irq(dev, dmux->pc_irq, NULL, bam_dmux_pc_irq,
 					IRQF_ONESHOT, NULL, dmux);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	ret = irq_get_irqchip_state(dmux->pc_irq, IRQCHIP_STATE_LINE_LEVEL,
 				    &dmux->pc_state);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	/* Check if remote finished initialization before us */
 	if (dmux->pc_state) {
@@ -844,6 +844,11 @@ static int bam_dmux_probe(struct platform_device *pdev)
 	}
 
 	return 0;
+
+err_disable_pm:
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+	return ret;
 }
 
 static int bam_dmux_remove(struct platform_device *pdev)
-- 
2.43.0




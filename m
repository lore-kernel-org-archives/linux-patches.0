Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6084350A3C;
	Fri, 21 Nov 2025 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732561; cv=none; b=Z6kd2CGMvJP8t8uDoUdJRk3P7CpTVaasKWzyMs2Hbqvy0aJhPfWyKzwb9iFqNbvAq0HN6kMAnkFIk/GzKLdJVD+zS2bg8CF0YE+viEElGMuAz1cJwtj0JB4QJjsFtdYe0hyQmeAVeVobKwaOD6RUPgJGy+983mnkqTxMF+bod2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732561; c=relaxed/simple;
	bh=zo02in31dwsRRncBTF8KPyHQ6IjGrV05MRxencS1jX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/9ovdr4zyVo4D3weh5NcM60rk9XxDQsNF1QQF06MsVOxbUi85uAUIiPD/GQYQqwiFF+dxjwPR+LUXR2zW9z+08iNDhl6mbfq1IruA/wMnCk6JFgUay7X/rRgGvBowIlI4M/9WHQvuoet/6R4l0PyZXSU/Wfahpk1s/RTfsZCNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM+e00+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM+e00+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E52AC4CEF1;
	Fri, 21 Nov 2025 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732561;
	bh=zo02in31dwsRRncBTF8KPyHQ6IjGrV05MRxencS1jX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM+e00+aYtBWdKxl3ephnFAfYCD2cHJh+RP/gToBytl95SQSRynIIff3ovNzvxM6D
	 fWA3OAVNVporXvwzyBj/WVAAPvRR6ECWAGFkpL+kC35AkCfxGzTKlHlbA6QKcmr8K3
	 vdss0HbwUaVwPLn6rGCNRGpDv3VjpzIWE6jqko+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/529] extcon: adc-jack: Fix wakeup source leaks on device unbind
Date: Fri, 21 Nov 2025 14:07:42 +0100
Message-ID: <20251121130236.820261816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 78b6a991eb6c6f19ed7d0ac91cda3b3b117fda8f ]

Device can be unbound, so driver must also release memory for the wakeup
source.  Do not use devm interface, because it would change the order of
cleanup.

Link: https://lore.kernel.org/lkml/20250501-device-wakeup-leak-extcon-v2-1-7af77802cbea@linaro.org/
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-adc-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 0317b614b6805..ea06cd4340525 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -162,6 +162,7 @@ static int adc_jack_remove(struct platform_device *pdev)
 {
 	struct adc_jack_data *data = platform_get_drvdata(pdev);
 
+	device_init_wakeup(&pdev->dev, false);
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
 
-- 
2.51.0




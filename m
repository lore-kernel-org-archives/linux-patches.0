Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1686332EA3;
	Fri, 21 Nov 2025 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733161; cv=none; b=cjLMuHmpNPJdoi4LDYN9GogKAvWZNhuyIK9VRrBHIiNGRAphZibV0kh+jfESoo8Eet1/wxxEYcmFA1qF0bwxLy7Who2ihmo9MQ1thRfhspMAtw3BFysTSII2wTNVgbgsOLS8tgUKyPR8GliJcrqaPVi5hrZLd2sgoH6evc3mXdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733161; c=relaxed/simple;
	bh=cn/dQGCV1G9al0Dwri6liqBIfQOwqnSnXoJCsKjzpE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcF6Q9knT+9EKgvS22UeF0f21aIJH1lhSejXh37Fod+Em59Iuo+gvg+IToz99MaibmHbEZCbNXJEh/wWXBGmgd1mkARFtJmNaYmHwfKQS/9hvm+oUaw2UhETJw47b6QLMEYhNtI5I3LYb2J/FyZkFrXoZENcWumHKSnxXcCfpwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOCQ2PQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOCQ2PQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642A6C4CEF1;
	Fri, 21 Nov 2025 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733160;
	bh=cn/dQGCV1G9al0Dwri6liqBIfQOwqnSnXoJCsKjzpE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOCQ2PQGRjpHec+0y0ggoRBEhTqJ1fTcKQS0bUVLNcKPUqWRKF9AW+AEngCmTJ+07
	 4cbwKYJwInkTEHw+C25ZeullDCn7HwBDTyIabMYZEuvszC+GtJG3c5Blpt5NzBtFno
	 73h+YhImyzVBCZj+JcZbG3+unXNO5I7MhV1pSsUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.6 372/529] extcon: adc-jack: Cleanup wakeup source only if it was enabled
Date: Fri, 21 Nov 2025 14:11:11 +0100
Message-ID: <20251121130244.263031839@linuxfoundation.org>
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

commit 92bac7d4de9c07933f6b76d8f1c7f8240f911f4f upstream.

Driver in the probe enables wakeup source conditionally, so the cleanup
path should do the same - do not release the wakeup source memory if it
was not allocated.

Link: https://lore.kernel.org/lkml/20250509071703.39442-2-krzysztof.kozlowski@linaro.org/
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Closes: https://lore.kernel.org/r/22aaebb7-553b-4571-8a43-58a523241082@wanadoo.fr/
Fixes: 78b6a991eb6c ("extcon: adc-jack: Fix wakeup source leaks on device unbind")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-adc-jack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -162,7 +162,8 @@ static int adc_jack_remove(struct platfo
 {
 	struct adc_jack_data *data = platform_get_drvdata(pdev);
 
-	device_init_wakeup(&pdev->dev, false);
+	if (data->wakeup_source)
+		device_init_wakeup(&pdev->dev, false);
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
 



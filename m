Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D532ED43;
	Wed,  3 Dec 2025 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779682; cv=none; b=ExmvWDPoBlze3jMIAp3DmtCeIp8Gd+scMpupJxTvjy+c6P8qE3aPDRdqT84eG9w7dXNIFcSecvmVbL/4qPqsdxtsIC8Psl2Lsf5Oq9Ggb3mcpB99dEDM8wcv7gatSnOffzIx8HWDyn9P3lk7x5JFnf+l5Ii34iV18nZwmmvyhYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779682; c=relaxed/simple;
	bh=FsQcMRRa/uD5gMXXOpMkuZVRQPJEFf21vBQQMklPQx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/sZANPpXtTXLT4bN7xutZ9QlolWjqJ3MmhlU6nU+I1chcCMZExmNaPIx5mwecxl/O5FbG93wFtMePL1pEqeH5JpAPuKKbUeS8lZ/njd1ohsmpCJ+0WAYd/cDZhuyn7lUQrWkL0JN57FT7SQsMogWwTvBTw7IiCtAu7GAcCPErU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYabqluE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYabqluE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4755AC4CEF5;
	Wed,  3 Dec 2025 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779681;
	bh=FsQcMRRa/uD5gMXXOpMkuZVRQPJEFf21vBQQMklPQx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYabqluEDDxEy+eeYt1Q27T+tTjI7I72iUwV7v8/JCWd56EW+uGEtW3ko5/zKoKOl
	 6lnAe+0y12jn+zs9HbRuIOm/pPVdU6QXTXhFwbx6mnsIciDdc+zkaVUBjUF4kvlOPp
	 2OOLaO6h4Di24nR708WS9e8yAazPVM/FkoH7GGQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.1 330/568] extcon: adc-jack: Cleanup wakeup source only if it was enabled
Date: Wed,  3 Dec 2025 16:25:32 +0100
Message-ID: <20251203152452.796265075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
 



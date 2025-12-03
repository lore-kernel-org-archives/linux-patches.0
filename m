Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4438F314A9D;
	Wed,  3 Dec 2025 15:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776511; cv=none; b=lOI+AKKJ3Cr1eVGPOuT/1V3Pu/QMDBxQtn4X8S0SuXAz9tDDLGVxuxRCzo2tP9QRQNFHEJlaq4F1IrGwaWpshNffIZ9ZSxvnU/frA17iIBuhMN5jFTPGyeddYY2thCnLxNjYus6EzHQfGkWBQmU2b/Wrl2KzKdpwcaMHx+BgA6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776511; c=relaxed/simple;
	bh=1dVussKkDWVT1Mno4T8YRCWQyTkHcuJuGwiZnzNXzd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPzIDTmnKXg/ArCJdrRUaTj/zrdkylzSHb/Ap9ymL3JjznFwDofz6Ol+qvW1DVQKOBDF1J691e6v39L465xdgUIGon3KvhzFkZaHOHZUoD1oOKs+UdvHxEFkwq61uQxiPUct6th7fuCsFy0KOsEV5ArRJGhMAzshyCrCzeJ7ZQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhOOCIuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhOOCIuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37BEC4CEF5;
	Wed,  3 Dec 2025 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776511;
	bh=1dVussKkDWVT1Mno4T8YRCWQyTkHcuJuGwiZnzNXzd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhOOCIuSk/dvqyAG4w/TCip8xs0NvNgtOKvP9ZERahJ+hCIbMXkFIHeilUhSCWSks
	 yJyLk7+GyjHGKHbKs/MIT17fhuXUCoKaskbaHI6KsRfOJG6BRU7LuKqdymw7i3adIG
	 0cOT9bzNPdEACtW0cXrf4vcI9O4dpa4ExR7MC4qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.10 172/300] extcon: adc-jack: Cleanup wakeup source only if it was enabled
Date: Wed,  3 Dec 2025 16:26:16 +0100
Message-ID: <20251203152406.992619057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F2425A633;
	Mon,  1 Dec 2025 11:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588749; cv=none; b=Ee2EzA/vfpjV2qa8TIn49yE8MlOlZjlgfAjuyxPhZu4UIdnf58ffMzxhn8ZA1rvCcEEhraqsBIK0DxvpLR5pd2w1GzsKl//1TbnpFzoAHFpd7FXZDvQnrbDOtJQVXD69SDOOQYMWOKR9OI99ygtVebssv1NAjcJ4Ka6DjsuapXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588749; c=relaxed/simple;
	bh=caRlzKNiyavs3ROUE1b/5xsDT/pglL1FT/ekR0Pk8g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auPWDGucv0yJBYfIQqNDT2ErOedPx0NY5gzZduj0HeTj7/U7KJl8JxuxACvdiac/pOW6GoDtZ6vtKOndQzyUOKyd7zJuuSfSG1hqiBcTgRVwpADy3cIHUOutvCFqqUjQwOH+s0Wc6vJIF5Ek2CPD/K0iBKVnIQChvahK1glfthQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhV65RE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhV65RE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD528C4CEF1;
	Mon,  1 Dec 2025 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588749;
	bh=caRlzKNiyavs3ROUE1b/5xsDT/pglL1FT/ekR0Pk8g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhV65RE11JCP3rlzhh1AJXriTzCiLyX43q600XqafWoPl8L03XIaXb8VHFw0mJcpo
	 QMBgTKElCb4HFI/OXlHDkC18BbkdpQhipuWQNplvRUkAn1nZu4wZm9B0xjTwa8NNN0
	 hlP1ZyPLhaHyLldGrEVPx52+zkC+Z9riOtfA7S0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.4 124/187] extcon: adc-jack: Cleanup wakeup source only if it was enabled
Date: Mon,  1 Dec 2025 12:23:52 +0100
Message-ID: <20251201112245.707300380@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 



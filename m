Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F53128C5;
	Wed,  3 Dec 2025 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776147; cv=none; b=TjKTvYg4RPRWj5lD4GzdLjRVqbEsV7QWrH/ufD+hdLUb9Pk1zBDoiH70N8KyrFPvui4/RRnrOdocJwpkuW6UFw3SiJwrygdIbsJH9MS1A+LYb4wkBZt5nYmFrUwqP22Ytrz55l5VL23fTVX85yjXKkSASl9I8CfdzpBIKrHLatA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776147; c=relaxed/simple;
	bh=EXRyUFwGptQcXyrp5h7wBz6A9eNIQv7g2/mp2c83uu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8vHhvUSHd4VhghfNRSB1pa0qxeb1SD0714ytFms8QFjw5QYpdZ90WpcRcm7scbg/IGgD3gY6gEt0pbTaFNQb8bMmi+zQffagA/oGv+9smIJBra6mBdDGRMEi7EgeBMOdKo2NgaXAtKMl3EhI9qRf90OABymHSIJ2iw5eQZQ2m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXpWPiNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXpWPiNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F57C4CEF5;
	Wed,  3 Dec 2025 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776146;
	bh=EXRyUFwGptQcXyrp5h7wBz6A9eNIQv7g2/mp2c83uu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXpWPiNERwKbO6/km70gJ3tdlc8xqXvzPbB5sOyjtA//qO9d8V8ubSMganpd7Mfb9
	 8FW/tm1SJa5v2T2/dYOqSTKgTp8jHnttDSwzVWpAKi/fBEDlkPSOzjytJgZ6/0HyTv
	 YXVMzRaARQy8VRD9lXXq2r5/wI9RLttQIsJxupvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/300] extcon: adc-jack: Fix wakeup source leaks on device unbind
Date: Wed,  3 Dec 2025 16:24:57 +0100
Message-ID: <20251203152404.070199345@linuxfoundation.org>
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6F9274FF1;
	Tue, 11 Nov 2025 01:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823468; cv=none; b=lKs/3aOsjf5fyaXAlIcHFB8ushsBIT4X34qtpi/mnX/paEtOUB1VO1TYbcnkDzV5So4BJ0seXv9evFu7ST4JSoZDXQxQe2VXrC0Orj4SnQmu2vs5l0C3eRGVzkL3YHBGwztUPotDk6xEvRG8gRep0YuIVRPeEUiY9eIv0znWk5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823468; c=relaxed/simple;
	bh=aVNAsh1kefvhA7Nfk/q+5WcJ8xI5+0r2coj3X/JyDc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPitsHbkvFWBYrHhQY3nw/Sxb2svLFvMxQ7uadVQXG28OVhiofT8fDXkfQfJx5GezjsZMPVE7AMhtrVd95Pg3ZA3qty4xRfHEaQPdUHyCv0ph0g44yKrTQemKEiXFJAKA8TEf/eLfIMWYwt7MAuWONLzVUfgPBYtaXtFLotuNc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEQeWJ5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEQeWJ5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2566C116B1;
	Tue, 11 Nov 2025 01:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823468;
	bh=aVNAsh1kefvhA7Nfk/q+5WcJ8xI5+0r2coj3X/JyDc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEQeWJ5FIIemVbc8EZBhXmPlXG+iixobf6ffKDQCs1gkDsjzpnM+QAvgr97m9sAcg
	 uZwK8H3l8ZAIyqogeDl9mrUflXCaf7sByBm2jNdIu/OrCFqIq1TULGSwwUZhs10z8A
	 QzDP/U6k2L19F9wpJkpvEuJ9Oq/GXAajlYjsp6FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/565] extcon: adc-jack: Fix wakeup source leaks on device unbind
Date: Tue, 11 Nov 2025 09:41:48 +0900
Message-ID: <20251111004532.575717360@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 125016da7fde3..c7b5f3f0da2ef 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -164,6 +164,7 @@ static void adc_jack_remove(struct platform_device *pdev)
 {
 	struct adc_jack_data *data = platform_get_drvdata(pdev);
 
+	device_init_wakeup(&pdev->dev, false);
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
 }
-- 
2.51.0




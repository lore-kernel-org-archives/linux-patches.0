Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B268E302CD6;
	Mon,  1 Dec 2025 11:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588489; cv=none; b=FcU3vakOd0pJXiubs+9srO4KRLyym7P5WkqBQ0yKjZ2a6rdehTlHTrVWsdkUBMHOJOioYqQ2wIqvVVytuE98ByLZn7zk2xtFZ83kti0vwbZpmroPoIN/vv71J+ZE+QbbKccUckZJWDkVMNVCGFLNZWHi2qTx90NuUTWxVpH32bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588489; c=relaxed/simple;
	bh=4KlpuS7RMKQAPkdCK8X0SAi6ijyn2NTdyfCDBhOYwjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ew/O3ELIf5fiaicDZcNFqqQEvRK0F5oUL8TlAvDzwV73OKvZXNn+VhRGWeYJv5jnxUd83VzscZt1YN4MPHmbyJ8CP7LOO41aRBtJprY7TIjfgQT6hRJfYjnpiEWnicGMa/zwOFsyMlBcNNQpw+9nT4UhOHEuBexKnUuaB+tv6C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSqhgXsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSqhgXsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4272AC4CEF1;
	Mon,  1 Dec 2025 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588489;
	bh=4KlpuS7RMKQAPkdCK8X0SAi6ijyn2NTdyfCDBhOYwjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSqhgXswFH6TQclsRJvYjQ61uX5VMxlv/0OBgnbPoAFHkopReMY1s7n0AElMt8xES
	 iChZFtZF4lv0VZxUBF0BK1tyuBibYJniwglt5EArSPbN0uKqajz67D30POpmEPt5ok
	 PnCkPxd7n/rwWzJSg4QXXuCz9VW70PzX0Zc5K7bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/187] extcon: adc-jack: Fix wakeup source leaks on device unbind
Date: Mon,  1 Dec 2025 12:22:54 +0100
Message-ID: <20251201112243.624613599@linuxfoundation.org>
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




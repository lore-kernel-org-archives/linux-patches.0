Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DB3424D72;
	Mon, 31 Aug 2026 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184572; cv=none; b=F1rRwWtC86iiPTstoE/XR2iQSDYsvBJpJgrQGP90Nukt0slA7QdbmQrbfVQDePOWoqgzcTEjjemNvh+JYly4BCfnrdF5SpZdHX/b3jpjQ8dPMJASwwmEGbqzV5AXvpuUcQmdvQY9wcdNv5c63WOWzyWEK/IENU02A0ipWqBbo5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184572; c=relaxed/simple;
	bh=Ilaltfg7CNjGRby10f6cx2CQ2YrN9CBccYN/jDYg5js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFpvBcBfvVuWFKVe5GTWO3OlvHv8Vh6aqqt61WNLyYqBX9SbNTDtl2Mp0CWbauzH6UnOtDKPFWi6ngGtabio9CfRE8rregx7njggkOIv5ruJMxJghB8bzkebfnQoE7jIeZbmdlcCRyo94qQKXO4cbXMexZna2uE+EXlbnRL5Ono=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDTlwUyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDTlwUyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682451F000E9;
	Mon, 31 Aug 2026 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184571;
	bh=+b89g7RM3YPftYhydTOb5ZhAKQWmlMRlHXml+j5vnAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDTlwUyxrFjqngTIsEbaDxZwp9Sx+kc6StBdR/80s/KmPMJNnhpQeaT2ukknaI6dW
	 Ya7xdU2ZqhYD44MAIdP+gh6L4OaK1Te+azU21LldjZM1+3OyzfGnZ6gE0JVPuCh12X
	 0755n/HTZAPFV1Z4xIFWRxwq+Z35gzmT/8l2aHuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/91] ASoC: nau8821: Cancel pending work before suspend
Date: Mon, 31 Aug 2026 15:34:15 +0200
Message-ID: <20260831133401.076649153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 7786b10688ac0ebeaff655923cbb2c7d34a98995 ]

A jack detection work that is unscheduled or in progress while executing
the suspend handler could trigger a race condition.

Ensure state consistency by cancelling any pending work or wait for its
execution to complete before processing the suspend.  Since driver
(re)enables both insert and eject interrupts on resume, there is no risk
to miss the related jack events.  Therefore, flush_delayed_work() is not
required here.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Fixes: ee70bacef1c6 ("ASoC: nau8821: Avoid unnecessary blocking in IRQ handler")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251231-nau8821-cleanup-v1-3-6b0b76cbbb64@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 0bfb4601fe333..f20a0e1ba5320 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1617,6 +1617,10 @@ static int __maybe_unused nau8821_suspend(struct snd_soc_component *component)
 
 	if (nau8821->irq)
 		disable_irq(nau8821->irq);
+
+	if (nau8821->jdet_active)
+		cancel_delayed_work_sync(&nau8821->jdet_work);
+
 	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_OFF);
 	/* Power down codec power; don't support button wakeup */
 	snd_soc_component_disable_pin(component, "MICBIAS");
-- 
2.53.0




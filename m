Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25207472521;
	Mon, 31 Aug 2026 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184226; cv=none; b=W9AhDA2h1pikKJqpw/n0ZLVN4Rpa5de1XTtz+FmcHYHM6rSCjqHeXTv3jgRQQ24jt7h2hN29fmx+Cwsf7GSjTs99A0R0yKgFVuIsHCl7wGEUVHIeaCU3qCGTmMgrJ2pqhZofnYIFRxsHgUn6j4MsSRvxLQJK3b9cD861IFcSow4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184226; c=relaxed/simple;
	bh=k1qxrRcLNiI5+XEQr4q8YgItKG2jOEgCRZt7dlpTL40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHIZm565IhUVQQYoSu/Gy7TJEV22XULR6MmsSM2/HdLqUKtjaecH9zGUlz5VuDyXwdMoLJNJIdB14clSyeSpKrBAMZ6Q2Tkv7/SBmuRCmGrpcjsjOV9ADbCd6PAD1RBwB8UIujDvkCIeWwjnJtarlbOgQOl582ksELGz07zyQ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADX76GZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADX76GZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744581F00ADF;
	Mon, 31 Aug 2026 13:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184225;
	bh=GzgpXInK/jxZE3Rwf7IDcCtkCjIEHGR4u8vWQZx4LF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADX76GZK9s7/tp5wNgzXLB8dPMVwPQ4tHA2C+k8ew5qs9cHzn/dSxy+aRN6AWcOSJ
	 brrrIoPJ8PXmJNn1CMjzDZTbifP3hMD4DQ+f/ov70KNIyCd/aMdXqrV5coz5D2QiNJ
	 F1XuOPQxcS+uNsLXMDAu0jfMQ9z2Pp+OzYYS7RLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 34/99] ASoC: nau8821: Cancel pending work before suspend
Date: Mon, 31 Aug 2026 15:34:03 +0200
Message-ID: <20260831133401.716001705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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
index 650170edab39d..e235142489b6f 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1612,6 +1612,10 @@ static int __maybe_unused nau8821_suspend(struct snd_soc_component *component)
 
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




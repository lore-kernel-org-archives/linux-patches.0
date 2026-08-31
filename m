Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F67747F764;
	Mon, 31 Aug 2026 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184761; cv=none; b=TzLz4KxT2iD5Ch2Twt9ovmSXiHsWfhS0cobs+MZ2Dq4xSwO1xiqwqlsWkdz9dVSJEZv5ScNQU5a8upJdwmj49PlAOpS4X/tf3nBMpuFP7HmaRRrMveDGdyG5qogdAZdx4r4xXIJHvHe1NictqKaicruWvDNDreYzaeKftnOnYkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184761; c=relaxed/simple;
	bh=Mjl6Pi0GbyhLYSRKTjrlXnBhx8ln03DbKh7kENS65hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWL5k7T6M8Y9bVAxuIyJ5pD/Lhf7SrsfWldtl9UmuqcYXAoi0cqn6VpA4CQdHL4ZH3xW3u/YRt4bEoYBQ4Ys50GwdJlN6+9oUoIpi/VFAcA8oisxCfQ0c9stpni2MkyhREW2VqM0rXBTbbDkzj13gY7vLsxQEr6DjIxsQMVtyDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYYRoiLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYYRoiLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB15B1F000E9;
	Mon, 31 Aug 2026 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184759;
	bh=NLTqwG8LZoSV3dBYY+bGsOVZZdwQkA6HyFHEXX1DhG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYYRoiLMMW0NIpEexZDE7Mq8UmpC9zqWAEBFRJMB7U0+tSJZYt19040FJPapuOuCH
	 waJ0q6kZDYN9w1E6EW4h31DrfQrLYd2LNs+x+KHV8VddYc1r3BVWgr+cfEsTtgDV6+
	 l2fTJrSSsYuF2aM/0ABDu5H+evDGCnp12grjCgPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/92] ASoC: nau8821: Cancel pending work before suspend
Date: Mon, 31 Aug 2026 15:34:27 +0200
Message-ID: <20260831133401.178472160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
index 8c015d114cac3..bb4e594910a90 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1489,6 +1489,10 @@ static int __maybe_unused nau8821_suspend(struct snd_soc_component *component)
 
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




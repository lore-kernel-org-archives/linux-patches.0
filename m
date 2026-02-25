Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77EE1D5ABA;
	Wed, 25 Feb 2026 01:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983072; cv=none; b=sc6VnqY1AKiCHDLw1tVwcTtmSqIoKctDxGEEHrRg8kH/13nUdH6puJbWOaweVql89Ob0ARthS3pG4Qj6WNm0tNHoO4Ns6Hai31bkNk4WyPX2rTdpJ1ZcVA7ytQefHCFY07f73a/IBV99ZGkhZKiG9Tn5YUNcSr5OrXPjRADQ3IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983072; c=relaxed/simple;
	bh=3DOU/fnw3J2NTnlkN/tRTZI8nfVRzd0MpUjKKuUT16k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFQEbjHHdkWjBkB7UNcoovwivPNFWZWVpcIvdAhuuft+Z8voiHSTs3h7BRnKPFOYJYwjuNjQRRHmLtjIXNLbHte9aFmV7oSmTFjGoGuKhCyubAj0ocZFpAreY8PNtqAAV+BWAoOiC/Bid6jDRGzyu/gD7xhlBH5+5m3lYcRw4hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD0FJAuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD0FJAuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDF2C116D0;
	Wed, 25 Feb 2026 01:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983071;
	bh=3DOU/fnw3J2NTnlkN/tRTZI8nfVRzd0MpUjKKuUT16k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD0FJAuDAfr1fZ4BrKpRWgMNopy3JZU4rxkVNAvuQBkca4MlyI8HFTfe1lsB8NJv0
	 Le7D1aMi5usILPOW063RdScZTz8TYglFhJrpdHsnizaZpRpWlaWHTx2V0XmjH14aPC
	 J0lEiu0/YtLCweldJjwzTVJ75U9rnzN2BZf70VGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 234/781] ASoC: nau8821: Cancel delayed work on component remove
Date: Tue, 24 Feb 2026 17:15:43 -0800
Message-ID: <20260225012405.450129879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit dbd3fd05cddfdeec1e49b0a66269881c09eebd17 ]

Attempting to unload the driver while a jack detection work is pending
would likely crash the kernel when it is eventually scheduled for
execution:

[ 1984.896308] BUG: unable to handle page fault for address: ffffffffc10c2a20
[...]
[ 1984.896388] Hardware name: Valve Jupiter/Jupiter, BIOS F7A0131 01/30/2024
[ 1984.896396] Workqueue: events nau8821_jdet_work [snd_soc_nau8821]
[ 1984.896414] RIP: 0010:__mutex_lock+0x9f/0x11d0
[...]
[ 1984.896504] Call Trace:
[ 1984.896511]  <TASK>
[ 1984.896524]  ? snd_soc_dapm_disable_pin+0x26/0x60 [snd_soc_core]
[ 1984.896572]  ? snd_soc_dapm_disable_pin+0x26/0x60 [snd_soc_core]
[ 1984.896596]  snd_soc_dapm_disable_pin+0x26/0x60 [snd_soc_core]
[ 1984.896622]  nau8821_jdet_work+0xeb/0x1e0 [snd_soc_nau8821]
[ 1984.896636]  process_one_work+0x211/0x590
[ 1984.896649]  ? srso_return_thunk+0x5/0x5f
[ 1984.896670]  worker_thread+0x1cd/0x3a0

Cancel unscheduled jdet_work or wait for its execution to finish before
the component driver gets removed.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Fixes: ee70bacef1c6 ("ASoC: nau8821: Avoid unnecessary blocking in IRQ handler")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251231-nau8821-cleanup-v1-2-6b0b76cbbb64@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 2d25a182f4abe..2e2714b475012 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1264,6 +1264,14 @@ static int nau8821_component_probe(struct snd_soc_component *component)
 	return 0;
 }
 
+static void nau8821_component_remove(struct snd_soc_component *component)
+{
+	struct nau8821 *nau8821 = snd_soc_component_get_drvdata(component);
+
+	if (nau8821->jdet_active)
+		cancel_delayed_work_sync(&nau8821->jdet_work);
+};
+
 /**
  * nau8821_calc_fll_param - Calculate FLL parameters.
  * @fll_in: external clock provided to codec.
@@ -1621,6 +1629,7 @@ static int __maybe_unused nau8821_resume(struct snd_soc_component *component)
 
 static const struct snd_soc_component_driver nau8821_component_driver = {
 	.probe			= nau8821_component_probe,
+	.remove			= nau8821_component_remove,
 	.set_sysclk		= nau8821_set_sysclk,
 	.set_pll		= nau8821_set_fll,
 	.set_bias_level		= nau8821_set_bias_level,
-- 
2.51.0




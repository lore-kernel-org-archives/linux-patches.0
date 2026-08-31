Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E138A483800;
	Mon, 31 Aug 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184862; cv=none; b=BRbHCPqGuM10nsrzmnYEK5gJz4UTKjnb2WMBylY4CccopvpThc/IQfuZDW2IAys6rEJFZ5hbnynedb8kXgRISfRupYrvSXVeHcQ+B6vH3gWgFl7kaumgT3UEiyHDgzabG9HRbUqxgd/yH3JWjqzzIJz0cZ1KEqolWG4MlSuhJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184862; c=relaxed/simple;
	bh=rvaGAMzKY0c3W/razNyIxQ3OC1LOhR5LJpzTd9WdNRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oytlarGkRfPRaM5sdsl+s4YHne2q0GypU+2Dxuv5Abus2BWgt2fEpbaBdb9eygIbawod3w/mD+WeHjdxZ5Pknit9XggN+p6EMTgblih+WM/qyQQZiAfc6edSeeh5zKzPPB0YoCIKay75Kk8puGL75V7B5bTXt0/RjnOegR6bSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qKZsF5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qKZsF5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059BD1F00A3D;
	Mon, 31 Aug 2026 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184860;
	bh=3sMzx8vg/pxjnXCkSAaFcSC7GA6tVaGzWvUXwcWdsvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qKZsF5BWoF3Y2BkQ/Mljn8DWzl4aA04RxlHPO4+ih9FaAphme0rMCSPAldN0+hz4
	 GFmPvb58f0WSmIApYrjD9fpVV9wVZjvg/0YLxWRoVSMfikHXYTAdL1e6ff5iH/PNR7
	 OXwJjNqQeHotvg89mv2Tzr2NzVTP4y2w8Dw9dDJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/92] ASoC: nau8821: Cancel delayed work on component remove
Date: Mon, 31 Aug 2026 15:34:23 +0200
Message-ID: <20260831133400.932302930@linuxfoundation.org>
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
index f464c70011a15..8c015d114cac3 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1147,6 +1147,14 @@ static int nau8821_component_probe(struct snd_soc_component *component)
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
@@ -1505,6 +1513,7 @@ static int __maybe_unused nau8821_resume(struct snd_soc_component *component)
 
 static const struct snd_soc_component_driver nau8821_component_driver = {
 	.probe			= nau8821_component_probe,
+	.remove			= nau8821_component_remove,
 	.set_sysclk		= nau8821_set_sysclk,
 	.set_pll		= nau8821_set_fll,
 	.set_bias_level		= nau8821_set_bias_level,
-- 
2.53.0




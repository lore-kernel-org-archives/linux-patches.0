Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536ED15AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98DDC433C9;
	Tue, 25 Jul 2023 10:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282244;
	bh=ej7toLlbG+n4n24AN0TO8PJP/e7IERNfVL3iDT9ue7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/BA2zk5YMsYFfk/OjIhXjpAHlL3gbceUp+4llDj0uIDi/ba3VgDUDuzWnXhCzaBr
	 zqXWaIXw1ocXahrZ8RDxKrKAfs2NUBH0bxiWaSR1CtrjSMM+TPNA0CxcYZ+pfnGAQk
	 15b6eBLcGgxDIvCHidXYMjyh1lG3ithTXozDXDRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Sameer Pujar <spujar@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.4 059/227] ASoC: rt5640: Fix sleep in atomic context
Date: Tue, 25 Jul 2023 12:43:46 +0200
Message-ID: <20230725104517.204093481@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sameer Pujar <spujar@nvidia.com>

commit 70a6404ff610aa4889d98977da131c37f9ff9d1f upstream.

Following prints are observed while testing audio on Jetson AGX Orin which
has onboard RT5640 audio codec:

  BUG: sleeping function called from invalid context at kernel/workqueue.c:3027
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/0
  preempt_count: 10001, expected: 0
  RCU nest depth: 0, expected: 0
  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:159 __handle_irq_event_percpu+0x1e0/0x270
  ---[ end trace ad1c64905aac14a6 ]-

The IRQ handler rt5640_irq() runs in interrupt context and can sleep
during cancel_delayed_work_sync().

Fix this by running IRQ handler, rt5640_irq(), in thread context.
Hence replace request_irq() calls with devm_request_threaded_irq().

Fixes: 051dade34695 ("ASoC: rt5640: Fix the wrong state of JD1 and JD2")
Cc: stable@vger.kernel.org
Cc: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1688015537-31682-4-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5640.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2567,9 +2567,10 @@ static void rt5640_enable_jack_detect(st
 	if (jack_data && jack_data->use_platform_clock)
 		rt5640->use_platform_clock = jack_data->use_platform_clock;
 
-	ret = request_irq(rt5640->irq, rt5640_irq,
-			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-			  "rt5640", rt5640);
+	ret = devm_request_threaded_irq(component->dev, rt5640->irq,
+					NULL, rt5640_irq,
+					IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"rt5640", rt5640);
 	if (ret) {
 		dev_warn(component->dev, "Failed to reguest IRQ %d: %d\n", rt5640->irq, ret);
 		rt5640_disable_jack_detect(component);
@@ -2622,8 +2623,9 @@ static void rt5640_enable_hda_jack_detec
 
 	rt5640->jack = jack;
 
-	ret = request_irq(rt5640->irq, rt5640_irq,
-			  IRQF_TRIGGER_RISING | IRQF_ONESHOT, "rt5640", rt5640);
+	ret = devm_request_threaded_irq(component->dev, rt5640->irq,
+					NULL, rt5640_irq, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					"rt5640", rt5640);
 	if (ret) {
 		dev_warn(component->dev, "Failed to reguest IRQ %d: %d\n", rt5640->irq, ret);
 		rt5640->irq = -ENXIO;



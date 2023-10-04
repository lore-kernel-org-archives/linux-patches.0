Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61F81D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwBQCY/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37366C433CA;
	Wed,  4 Oct 2023 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443899;
	bh=YgPdYLd3FY2rhclfg+XsFvwkTWMPOAFynDa4/PKkrUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwBQCY/epe1FKzS3IoCNruvuGK5d/ydBm7Gc7YpEye2kv2MINO2v3iw1IFInYx/6m
	 FK4XlhGBi+fimyMxNrbaNX99uDSZunWSNdvceKED+Ngq84zCad0yYM8zV1aTmYjXzY
	 oXddHKGwJ4+uASs1aO77cgIsJTib0N0opLUUcrVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sameer Pujar <spujar@nvidia.com>,
	Oder Chiou <oder_chiou@realtek.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 031/321] ASoC: rt5640: Revert "Fix sleep in atomic context"
Date: Wed,  4 Oct 2023 19:52:56 +0200
Message-ID: <20231004175230.601206439@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fa6a0c0c1dd53b3949ca56bf7213648dfd6a62ee ]

Commit 70a6404ff610 ("ASoC: rt5640: Fix sleep in atomic context")
not only switched from request_irq() to request_threaded_irq(),
to fix the sleep in atomic context issue, but it also added
devm management of the IRQ by actually switching to
devm_request_threaded_irq() (without any explanation in the commit
message for this change).

This is wrong since the IRQ was already explicitly managed by
the driver. On unbind the ASoC core will call rt5640_set_jack(NULL)
which in turn will call rt5640_disable_jack_detect() which
frees the IRQ already. So now we have a double free.

Besides the unexplained switch to devm being wrong, the actual fix
for the sleep in atomic context issue also is not the best solution.

The only thing which rt5640_irq() does is cancel + (re-)queue
the jack_work delayed_work. This can be done in a single non sleeping
call by replacing queue_delayed_work() with mod_delayed_work(),
which does not sleep. Using mod_delayed_work() is a much better fix
then adding a thread which does nothing other then queuing a work-item.

This patch is a straight revert of the troublesome changes, the switch
to mod_delayed_work() is done in a separate follow-up patch.

Fixes: 70a6404ff610 ("ASoC: rt5640: Fix sleep in atomic context")
Cc: Sameer Pujar <spujar@nvidia.com>
Cc: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230912113245.320159-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index eceed82097877..7ec930fb9aab5 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2566,10 +2566,9 @@ static void rt5640_enable_jack_detect(struct snd_soc_component *component,
 	if (jack_data && jack_data->use_platform_clock)
 		rt5640->use_platform_clock = jack_data->use_platform_clock;
 
-	ret = devm_request_threaded_irq(component->dev, rt5640->irq,
-					NULL, rt5640_irq,
-					IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					"rt5640", rt5640);
+	ret = request_irq(rt5640->irq, rt5640_irq,
+			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+			  "rt5640", rt5640);
 	if (ret) {
 		dev_warn(component->dev, "Failed to reguest IRQ %d: %d\n", rt5640->irq, ret);
 		rt5640_disable_jack_detect(component);
@@ -2622,9 +2621,8 @@ static void rt5640_enable_hda_jack_detect(
 
 	rt5640->jack = jack;
 
-	ret = devm_request_threaded_irq(component->dev, rt5640->irq,
-					NULL, rt5640_irq, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-					"rt5640", rt5640);
+	ret = request_irq(rt5640->irq, rt5640_irq,
+			  IRQF_TRIGGER_RISING | IRQF_ONESHOT, "rt5640", rt5640);
 	if (ret) {
 		dev_warn(component->dev, "Failed to reguest IRQ %d: %d\n", rt5640->irq, ret);
 		rt5640->irq = -ENXIO;
-- 
2.40.1




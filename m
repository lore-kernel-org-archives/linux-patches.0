Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D60E8462;
	Tue, 26 Aug 2025 12:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212839; cv=none; b=jyh+5ffiU8BnmOJ70bsD6xBEZWwmGjinxK1RIpBs54KKBR3NhTYBf8Cf2DADWcixC76UMh6E0GC1vNowFOrvM1DbHr/wg6D07hzPfO/fyxy/zHfzj/uUiqc9X3YdraBFY77FmbnyyZrc6W4fv81CEvYA2X39U58KYY3t8XIjQqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212839; c=relaxed/simple;
	bh=5/UbnmvEo8+EsKwY6YaSVMeAHehSBFU/3aTWySaz4ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4n8GR4gGG8EsGYdhcFyrSTB87Q7jS+qtPQp56GdTyYKxW62nknI7winolZlYjVuMjUX4JfcFFzSXi0Li0dPRMDddHCq5I7e2t0X4Zq/HVxmjdEQ6GLbhgMBZazpJ7QSEC8PnTKk4N64xVnmfLMIe3hL7869u7EAfOqrVgFoKyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uP7i3Gqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP7i3Gqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C308C4CEF1;
	Tue, 26 Aug 2025 12:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212838;
	bh=5/UbnmvEo8+EsKwY6YaSVMeAHehSBFU/3aTWySaz4ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP7i3GqwR7//gdzPXOHfLM4ePE7vk+mE4B2IqTPMGeiGe4J0Ng/Hp4WiDKmQH0MDx
	 2pyoPHGs77R0Asxl010PlCuIXOzcuvc7lotG3DgsHfGxDWfD5OCQ3PmjW9VfejEykJ
	 Equ3PsAOb23s5x5okudVL/cvaRE/xlbpgVk8FV98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/587] ALSA: hda: Handle the jack polling always via a work
Date: Tue, 26 Aug 2025 13:04:29 +0200
Message-ID: <20250826110956.015017752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5f7e54b23e4d253eff3b10b12d6fa92d28d7dddc ]

We used to call directly hda_jackpoll_work() from a couple of places
for updating the jack and notify to user-space, but this makes rather
the code flow fragile.  Namely, because of those direct calls,
hda_jackpoll_work() uses snd_hda_power_up_pm() and *_down_pm() calls
instead of the standard snd_hda_power_up() and *_down() calls.  The
latter pair assures the runtime PM resume sync, so it can avoid the
race against the PM callbacks gracefully, while the former pair may
continue if called concurrently, hence it may race (by design).

In this patch, we change the call pattern of hda_jackpoll_work(); now
all callers are replaced with the standard snd_hda_jack_report_sync()
and the additional schedule_delayed_work().

Since hda_jackpoll_work() is called only from the associated work,
it's always outside the PM code path, and we can safely use
snd_hda_power_up() and *_down() there instead.  This allows us to
remove the racy check of power-state in hda_jackpoll_work(), as well
as the tricky cancel_delayed_work() and rescheduling at
hda_codec_runtime_suspend().

Reported-by: Joakim Zhang <joakim.zhang@cixtech.com>
Closes: https://lore.kernel.org/20250619020844.2974160-1-joakim.zhang@cixtech.com
Tested-by: Joakim Zhang <joakim.zhang@cixtech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250623131437.10670-4-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 41 +++++++++++++--------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index aa6dc00985b5..2d4b7527b840 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -641,24 +641,16 @@ static void hda_jackpoll_work(struct work_struct *work)
 	struct hda_codec *codec =
 		container_of(work, struct hda_codec, jackpoll_work.work);
 
-	/* for non-polling trigger: we need nothing if already powered on */
-	if (!codec->jackpoll_interval && snd_hdac_is_power_on(&codec->core))
+	if (!codec->jackpoll_interval)
 		return;
 
 	/* the power-up/down sequence triggers the runtime resume */
-	snd_hda_power_up_pm(codec);
+	snd_hda_power_up(codec);
 	/* update jacks manually if polling is required, too */
-	if (codec->jackpoll_interval) {
-		snd_hda_jack_set_dirty_all(codec);
-		snd_hda_jack_poll_all(codec);
-	}
-	snd_hda_power_down_pm(codec);
-
-	if (!codec->jackpoll_interval)
-		return;
-
-	schedule_delayed_work(&codec->jackpoll_work,
-			      codec->jackpoll_interval);
+	snd_hda_jack_set_dirty_all(codec);
+	snd_hda_jack_poll_all(codec);
+	schedule_delayed_work(&codec->jackpoll_work, codec->jackpoll_interval);
+	snd_hda_power_down(codec);
 }
 
 /* release all pincfg lists */
@@ -2920,12 +2912,12 @@ static void hda_call_codec_resume(struct hda_codec *codec)
 		snd_hda_regmap_sync(codec);
 	}
 
-	if (codec->jackpoll_interval)
-		hda_jackpoll_work(&codec->jackpoll_work.work);
-	else
-		snd_hda_jack_report_sync(codec);
+	snd_hda_jack_report_sync(codec);
 	codec->core.dev.power.power_state = PMSG_ON;
 	snd_hdac_leave_pm(&codec->core);
+	if (codec->jackpoll_interval)
+		schedule_delayed_work(&codec->jackpoll_work,
+				      codec->jackpoll_interval);
 }
 
 static int hda_codec_runtime_suspend(struct device *dev)
@@ -2937,8 +2929,6 @@ static int hda_codec_runtime_suspend(struct device *dev)
 	if (!codec->card)
 		return 0;
 
-	cancel_delayed_work_sync(&codec->jackpoll_work);
-
 	state = hda_call_codec_suspend(codec);
 	if (codec->link_down_at_suspend ||
 	    (codec_has_clkstop(codec) && codec_has_epss(codec) &&
@@ -2946,10 +2936,6 @@ static int hda_codec_runtime_suspend(struct device *dev)
 		snd_hdac_codec_link_down(&codec->core);
 	snd_hda_codec_display_power(codec, false);
 
-	if (codec->bus->jackpoll_in_suspend &&
-		(dev->power.power_state.event != PM_EVENT_SUSPEND))
-		schedule_delayed_work(&codec->jackpoll_work,
-					codec->jackpoll_interval);
 	return 0;
 }
 
@@ -3118,10 +3104,11 @@ int snd_hda_codec_build_controls(struct hda_codec *codec)
 	if (err < 0)
 		return err;
 
+	snd_hda_jack_report_sync(codec); /* call at the last init point */
 	if (codec->jackpoll_interval)
-		hda_jackpoll_work(&codec->jackpoll_work.work);
-	else
-		snd_hda_jack_report_sync(codec); /* call at the last init point */
+		schedule_delayed_work(&codec->jackpoll_work,
+				      codec->jackpoll_interval);
+
 	sync_power_up_states(codec);
 	return 0;
 }
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497A23A984;
	Tue, 26 Aug 2025 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214326; cv=none; b=Ig7PHg1j3b8BEgKjMcrW+BP3eQHWTkUFUr6YgZhclYvx6rPJz8usVTFqTo3lWyzS4gLNO0pEYWPuAksOn7lNfyTs4gsKjrVi4j+HUPcGX4rpg0KEbFKE2wMTbOVgwdRB9vv6wd+MdDvGYzPy61VCOcfDY9KusT7B5jUfXfGWpC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214326; c=relaxed/simple;
	bh=H9RbVAYNn2YLLoUmolOXY8tNEB2OtFRjadaIx1dLsQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyMh5mSwKB1+z7zA4NhLNftcd4TExzCkkZwVX96v4R4aucZVzKxb8GpC5aP38kDZzy3YLVq6CR77crMvlo4pGc4JOmroxxbrfBERiIp28bN3j1Vcn3rww/VT/WpP5LPx/tuoJ+Vibbky1mp1eJqYtu0h4A2nrvFLaW72wq57Txw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZ8rN5/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZ8rN5/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5B5C4CEF1;
	Tue, 26 Aug 2025 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214326;
	bh=H9RbVAYNn2YLLoUmolOXY8tNEB2OtFRjadaIx1dLsQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZ8rN5/i4R4QI49WYy2YlbNRhJbLBHNxHUvmZd52EF69yfqgIAIfeVZ+xigrCGiLR
	 pxTYRP0quM8dch1g6W7MRIuY/cPM0/4xju3HnKfkNMBDF6PsRJy8yEgoxcWgQd0O6M
	 f2+rFa/tWTJWl5sEnowBDjUrXFb7JhCR3vhFmB9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/482] ALSA: hda: Handle the jack polling always via a work
Date: Tue, 26 Aug 2025 13:05:50 +0200
Message-ID: <20250826110933.224848705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d7d99b584fe..94b3732e6cb2 100644
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
@@ -2922,12 +2914,12 @@ static void hda_call_codec_resume(struct hda_codec *codec)
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
@@ -2939,8 +2931,6 @@ static int hda_codec_runtime_suspend(struct device *dev)
 	if (!codec->card)
 		return 0;
 
-	cancel_delayed_work_sync(&codec->jackpoll_work);
-
 	state = hda_call_codec_suspend(codec);
 	if (codec->link_down_at_suspend ||
 	    (codec_has_clkstop(codec) && codec_has_epss(codec) &&
@@ -2948,10 +2938,6 @@ static int hda_codec_runtime_suspend(struct device *dev)
 		snd_hdac_codec_link_down(&codec->core);
 	snd_hda_codec_display_power(codec, false);
 
-	if (codec->bus->jackpoll_in_suspend &&
-		(dev->power.power_state.event != PM_EVENT_SUSPEND))
-		schedule_delayed_work(&codec->jackpoll_work,
-					codec->jackpoll_interval);
 	return 0;
 }
 
@@ -3120,10 +3106,11 @@ int snd_hda_codec_build_controls(struct hda_codec *codec)
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




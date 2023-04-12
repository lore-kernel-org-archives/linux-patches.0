Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704CA2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0CBC433EF;
	Wed, 12 Apr 2023 08:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289329;
	bh=LwYiKpVI7U1V7BfG1v/KuTbzsmNUe1U52wW6R+vDd+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWS5JdTE4xjixV3XU7uJ0V2RJbHraPO7Gl+bs2go9VajYxdJ2dQgV4n5CqBELBN3J
	 qG2gvHQE3IOnQk453shlMkpgEKyi1vsWEWFXTdPTHMN4WYDphlKHTPXcWjWlaZUs57
	 VbThKZUZjaIzuIWYKlo4ZR+xbX9FtDCCsfgteRuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 028/173] ALSA: hda/hdmi: Preserve the previous PCM device upon re-enablement
Date: Wed, 12 Apr 2023 10:32:34 +0200
Message-Id: <20230412082839.233246170@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f785f5ee968f7045268b8be6b0abc850c4a4277c ]

When a DRM driver turns on or off the screen with the audio
capability, it notifies the ELD to HD-audio HDMI codec driver via
component ops.  HDMI codec driver, in turn, attaches or detaches the
PCM stream for the given port on the fly.

The problem is that, since the recent code change, the HDMI driver
always treats the PCM stream assignment dynamically; this ended up the
confusion of the PCM device appearance.  e.g. when a screen goes once
off and on again, it may appear on a different PCM device before the
screen-off.  Although the application should treat such a change, it
doesn't seem working gracefully with the current pipewire (maybe
PulseAudio, too).

As a workaround, this patch changes the HDMI codec driver behavior
slightly to be more consistent.  Now it remembers the previous PCM
slot for the given port and try to assign to it.  That is, if a port
is re-enabled, the driver tries to use the same PCM slot that was
assigned to that port previously.  If it conflicts, a new slot is
searched and used like before, instead.

Note that multiple monitor connections are the only typical case where
the PCM slot preservation is effective.  As long as only a single
monitor is connected, the behavior isn't changed, and the first PCM
slot is still assigned always.

Fixes: ef6f5494faf6 ("ALSA: hda/hdmi: Use only dynamic PCM device allocation")
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217259
Link: https://lore.kernel.org/r/20230331142217.19791-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 9ea633fe93393..4ffa3a59f419f 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -81,6 +81,7 @@ struct hdmi_spec_per_pin {
 	struct delayed_work work;
 	struct hdmi_pcm *pcm; /* pointer to spec->pcm_rec[n] dynamically*/
 	int pcm_idx; /* which pcm is attached. -1 means no pcm is attached */
+	int prev_pcm_idx; /* previously assigned pcm index */
 	int repoll_count;
 	bool setup; /* the stream has been set up by prepare callback */
 	bool silent_stream;
@@ -1380,9 +1381,17 @@ static void hdmi_attach_hda_pcm(struct hdmi_spec *spec,
 	/* pcm already be attached to the pin */
 	if (per_pin->pcm)
 		return;
+	/* try the previously used slot at first */
+	idx = per_pin->prev_pcm_idx;
+	if (idx >= 0) {
+		if (!test_bit(idx, &spec->pcm_bitmap))
+			goto found;
+		per_pin->prev_pcm_idx = -1; /* no longer valid, clear it */
+	}
 	idx = hdmi_find_pcm_slot(spec, per_pin);
 	if (idx == -EBUSY)
 		return;
+ found:
 	per_pin->pcm_idx = idx;
 	per_pin->pcm = get_hdmi_pcm(spec, idx);
 	set_bit(idx, &spec->pcm_bitmap);
@@ -1398,6 +1407,7 @@ static void hdmi_detach_hda_pcm(struct hdmi_spec *spec,
 		return;
 	idx = per_pin->pcm_idx;
 	per_pin->pcm_idx = -1;
+	per_pin->prev_pcm_idx = idx; /* remember the previous index */
 	per_pin->pcm = NULL;
 	if (idx >= 0 && idx < spec->pcm_used)
 		clear_bit(idx, &spec->pcm_bitmap);
@@ -1924,6 +1934,7 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 
 		per_pin->pcm = NULL;
 		per_pin->pcm_idx = -1;
+		per_pin->prev_pcm_idx = -1;
 		per_pin->pin_nid = pin_nid;
 		per_pin->pin_nid_idx = spec->num_nids;
 		per_pin->dev_id = i;
-- 
2.39.2




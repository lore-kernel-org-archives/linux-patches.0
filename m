Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903EE46D54B;
	Tue, 21 Jul 2026 18:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659455; cv=none; b=KczaRD9X1jrhXOgsHt08c4QfvwE0G4JuRSQxmrmu8x7CvQtIpkeEGJKbLkBI52seFKHMtw8nWDOhrSlpqpLZwMPSct92XH+Zt0KbOJLykYOi0nJwcSWuvDNSV36dK3lDdNzadlcOVAbg/YVdtnGvNqEmyPp7xFPrWuBPcki/Wh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659455; c=relaxed/simple;
	bh=yK1vKgjxVu+/+jPz2pFhxCHIo9Wf2CvCiUMRZygOU24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beDlamv4A0xWsREq22/L/PsB7BJZ5YeZ2Fx4XsY6qrbp183S36hvLOnqkzZAKY40ZplTsJAeXj4rnlyEq20tn+9Y5KcBnv5CcGgjT4iLA4isYccqDRgKdlxTG95qLSnGHiXgKk+IGm+QJNv3dHnmel9Rh2ym/4fEESOU9ElZsVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oR0gtsI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oR0gtsI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0220A1F00A3E;
	Tue, 21 Jul 2026 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659454;
	bh=SoSQJsXp6U/BfjWCmfgEdnZcwj9X0/HOaQkgLhkzXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oR0gtsI+oGT/8jHGjQmm4616bhrVIa6DAhmZmtYEwd55h39l7hEK5swc3+1Mk2DWM
	 5HF0mWXgnZ1whiAYlYP/pF3G0xs+3PcQCqKSta8hc3mwWxmdFb4z9j6+MPpZVWoJfE
	 G86I3x6e87WKKdYpZNJYc/0pK1w0azGejs2D4eYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1525/1611] ALSA: hda/tas2781: Cancel async firmware request at unbind
Date: Tue, 21 Jul 2026 17:27:21 +0200
Message-ID: <20260721152549.748484457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 5367e2ad14f0ae9350a7aaf2e77c87de39a43ae9 ]

TAS2781 HDA I2C and SPI queue RCA firmware loading from component
bind with request_firmware_nowait(). The firmware loader keeps the
callback module pinned and holds a device reference, but the callback
still uses driver-private HDA state.

Component unbind removes controls and DSP state immediately. Later
device removal tears down the TAS2781 private data, including
codec_lock. If the async firmware callback runs after unbind has
started, it can operate on state that is being torn down.

Cancel or synchronize the async firmware request before removing
controls and DSP state. A queued callback is cancelled, and an
already-running callback is allowed to finish before unbind continues.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Fixes: bb5f86ea50ff ("ALSA: hda/tas2781: Add tas2781 hda SPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260505-alsa-hda-tas2781-fw-callback-teardown-v4-2-e7c4bf930dc8@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c |    3 +++
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -616,6 +616,9 @@ static void tas2781_hda_unbind(struct de
 		comp->playback_hook = NULL;
 	}
 
+	request_firmware_nowait_cancel(tas_hda->priv->dev, tas_hda->priv,
+				       tasdev_fw_ready);
+
 	tas2781_hda_remove_controls(tas_hda);
 
 	tasdevice_config_info_remove(tas_hda->priv);
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -753,6 +753,9 @@ static void tas2781_hda_unbind(struct de
 		comp->playback_hook = NULL;
 	}
 
+	request_firmware_nowait_cancel(tas_priv->dev, tas_priv,
+				       tasdev_fw_ready);
+
 	tas2781_hda_remove_controls(tas_hda);
 
 	tasdevice_config_info_remove(tas_priv);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7750258;
	Tue, 23 Jan 2024 01:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974651; cv=none; b=ApEOG2Q/SUJ5QPPBqvrI6AyLhyFpquU+V6PcxifjR7caqSojDrIKlxDhiAoQiQI7l8293FpJOyio64/fqN06IQuyvY1lfm2oXnPmC72CneEf6Cnq9akGZ5GFj2PDMN4m9EaNzROybtJyt5D89feUrzuMEqH8AmYBCYvtT68MvZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974651; c=relaxed/simple;
	bh=ibjWYXDbx9NkS2W/B4surKj1UcwM2NLdmLH6VMWDtow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaHHfsdUHQZb/LOO5TU8rDzprHvZKUUAUnfeaCvj9WDUyQp/RjZcWfUJTpXQIOXwfZTorg7KdvJv0gjy8UhsjhY6hvEQunDU22ypxjzicJXFa3Lhp21Kie3/pdAIKPhLAigDxz3M8wpboRrPeoanzA5g7S/F0ikIF4o1iVG/fHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIWbFKB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIWbFKB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1A6C433C7;
	Tue, 23 Jan 2024 01:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974650;
	bh=ibjWYXDbx9NkS2W/B4surKj1UcwM2NLdmLH6VMWDtow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIWbFKB36Z/Xeg3/4Vr9mnlP2/1e2Dg8cp1AeSvWN9Ak6OKcfBngQh2sNqGSDC5X4
	 tjQnDrsLnrdY/6zJFvFTrVCdE29JLHQ+tzHUnHW+D8kBTZ0r86xosaEq2Jf595gmON
	 8g6o49xhs9wBeVyCffnrXdaGx+lAaPQS6GK4HMuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/374] ALSA: scarlett2: Allow passing any output to line_out_remap()
Date: Mon, 22 Jan 2024 15:58:09 -0800
Message-ID: <20240122235752.822269691@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 2190b9aea4eb92ccf3176e35c17c959e40f1a81b ]

Line outputs 3 & 4 on the Gen 3 18i8 are internally the analogue 7 and
8 outputs, and this renumbering is hidden from the user by
line_out_remap(). By allowing higher values (representing non-analogue
outputs) to be passed to line_out_remap(), repeated code from
scarlett2_mux_src_enum_ctl_get() and scarlett2_mux_src_enum_ctl_put()
can be removed.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/3b70267931f5994628ab27306c73cddd17b93c8f.1698342632.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 50603a67daef ("ALSA: scarlett2: Add missing error checks to *_ctl_get()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index f8787a4b1e13..ad46a0d3e33b 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1777,9 +1777,16 @@ static int scarlett2_master_volume_ctl_get(struct snd_kcontrol *kctl,
 static int line_out_remap(struct scarlett2_data *private, int index)
 {
 	const struct scarlett2_device_info *info = private->info;
+	const int (*port_count)[SCARLETT2_PORT_DIRNS] = info->port_count;
+	int line_out_count =
+		port_count[SCARLETT2_PORT_TYPE_ANALOGUE][SCARLETT2_PORT_OUT];
 
 	if (!info->line_out_remap_enable)
 		return index;
+
+	if (index >= line_out_count)
+		return index;
+
 	return info->line_out_remap[index];
 }
 
@@ -3264,14 +3271,7 @@ static int scarlett2_mux_src_enum_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
-	const struct scarlett2_device_info *info = private->info;
-	const int (*port_count)[SCARLETT2_PORT_DIRNS] = info->port_count;
-	int line_out_count =
-		port_count[SCARLETT2_PORT_TYPE_ANALOGUE][SCARLETT2_PORT_OUT];
-	int index = elem->control;
-
-	if (index < line_out_count)
-		index = line_out_remap(private, index);
+	int index = line_out_remap(private, elem->control);
 
 	mutex_lock(&private->data_mutex);
 	if (private->mux_updated)
@@ -3288,16 +3288,9 @@ static int scarlett2_mux_src_enum_ctl_put(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
-	const struct scarlett2_device_info *info = private->info;
-	const int (*port_count)[SCARLETT2_PORT_DIRNS] = info->port_count;
-	int line_out_count =
-		port_count[SCARLETT2_PORT_TYPE_ANALOGUE][SCARLETT2_PORT_OUT];
-	int index = elem->control;
+	int index = line_out_remap(private, elem->control);
 	int oval, val, err = 0;
 
-	if (index < line_out_count)
-		index = line_out_remap(private, index);
-
 	mutex_lock(&private->data_mutex);
 
 	oval = private->mux[index];
-- 
2.43.0




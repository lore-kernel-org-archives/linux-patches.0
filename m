Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781294E1AD;
	Tue, 23 Jan 2024 00:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971392; cv=none; b=Ls/HooEo8u5IArFYKIlDD2NrhBjcht1TCRiZ68Yigzzro3MxerghRBvJ0UsIMBN2eYe0r4GTihhi8X7fcNBM+Ho8lNxak1h0/BJc/kf5NhxNa/2ZlWJgVJqSrfLuxNlAmyQ3ofObifIydt2IRQxXR7RgHEFE137KoU5/KKM41E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971392; c=relaxed/simple;
	bh=SH4cigonEG/g2Pc4QUaUHkWoB+R5xQ/hzty1Q7GI9ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0v7Ri7XK5H8pOGlFP/IKMfDJFPhsiy4bIBkyoYwTtc2Ole+4tP3kk5LxwfaFqcy6efKFNbKciu5vT6TMJ85h0cg48qG75+c5F8f8T1GTxc70DFl73KVsQ64c6Ybwgq9kZ3uoGZ3Uo/15lDcW8/rD7Ds8jD05/3JsZ5anFxq1V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiUUQ5A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiUUQ5A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC48C43390;
	Tue, 23 Jan 2024 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971392;
	bh=SH4cigonEG/g2Pc4QUaUHkWoB+R5xQ/hzty1Q7GI9ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fiUUQ5A4JP5/Ci4IO7MxtSRMI2HGD83jIDAEar5NU6FCyqVjlywrWsCRh9B+mXahV
	 +/HQZf7hTR9zNxDzlICHgwnpIeW741odS/dsBWq3uW3NUAhOoZOJiUiHfRRw/m6coJ
	 6NEo9J+WL7K7VYc0NRemaHjwWDXjOueat9u9zolo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/417] ALSA: scarlett2: Allow passing any output to line_out_remap()
Date: Mon, 22 Jan 2024 15:56:42 -0800
Message-ID: <20240122235759.991324689@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 94704581865b..f8a2ba479b7c 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1901,9 +1901,16 @@ static int scarlett2_master_volume_ctl_get(struct snd_kcontrol *kctl,
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
 
@@ -3388,14 +3395,7 @@ static int scarlett2_mux_src_enum_ctl_get(struct snd_kcontrol *kctl,
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
@@ -3412,16 +3412,9 @@ static int scarlett2_mux_src_enum_ctl_put(struct snd_kcontrol *kctl,
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




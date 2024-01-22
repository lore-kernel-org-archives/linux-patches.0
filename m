Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BFB6BB3A;
	Tue, 23 Jan 2024 02:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975359; cv=none; b=cUDbYlAK4EFqnXdT3XDWccnneJEshu2ADse03yHAj+FyfOeK3SW+KQ/GlhZR7iYx5kK4egn11EHwj8An6xCah+d3FkI/WcfUVrKvnKg8azXSOHapqzVwmydlVKqo2XOpuBryZMDQHKQiu6AjG0UaowfToSrGCVTTyF6xeGeqgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975359; c=relaxed/simple;
	bh=EkGVycmBKI9n6wB3MotGnCwqRLjl75pmc3+UPvn6Q7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tk4nFRniAw11PqQYcXbHvNoJz2ETOFT9blP3bCK6q1BYr2SlOrUfmv+tbwxG/I+Ms4n41shT64SNoUaNg9Gmllu5eoHv9juOUJe5xo599UovT69exN9Jq465CQnAUk3xqJpCYhGfp/802E6au6rJN83c1xuK48E5hJtFqzfwIZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6I7VM1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6I7VM1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C457C43390;
	Tue, 23 Jan 2024 02:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975359;
	bh=EkGVycmBKI9n6wB3MotGnCwqRLjl75pmc3+UPvn6Q7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6I7VM1oe1EzQsie9mD+/uwZnFErWOlkn9vNZjfdBXS8RzxqLCvNMaPF4g6ca/2DX
	 gsorFD/LsJDXX+VlomdIhT/U02W2TUTe/jOdOnGpu84NtaTRAS9Q0QuJZ37UTdaU/m
	 0r4zktXzPYCawahoFgfAn6OVInTbXsfBqh/3R5ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/583] ALSA: scarlett2: Allow passing any output to line_out_remap()
Date: Mon, 22 Jan 2024 15:56:12 -0800
Message-ID: <20240122235821.872308397@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 834b936e7106..5e3118bd0dc1 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11AF2581;
	Tue, 23 Jan 2024 00:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969620; cv=none; b=sHzjqDrGAbkyxJ9OZxZimsbOnjVz3xWnCNjfffCMY9DtdhO5L4jF7FIQ4FLzowrhvpeBF2W7ekox8Hfu1yRS7irt0mYJp/siOf6NBcmDKIEMVBDmnaxxju5FurX7DWdodVfva7vbQrcIepd1jAhEvX/ckaKKWhRdZICSNCQlDeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969620; c=relaxed/simple;
	bh=/8FOvJ5QOzWsbx/4y2Kv/Val/bzLPg9/mswHS032Jj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWG6vLNhAaEht905RdgA6tiiv9tGN8MMG/g0MT9RdXhEgsSJ3rN+3XbX8qZu/kriOkcVUxXtuikC6Y0IxtfhAqgI0WTBMQJN8QIobtPEyzeWvJmT1G9gAqFh1j4IeP77tfk1c4ZW7AcvMEm1aFTHNoLLuXNC8tZkJgE7eXjHV34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrgG9Y2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrgG9Y2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6169DC433F1;
	Tue, 23 Jan 2024 00:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969620;
	bh=/8FOvJ5QOzWsbx/4y2Kv/Val/bzLPg9/mswHS032Jj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrgG9Y2NM3sK3vyrK3/ZBCK8aLQLuqzGacFWXbPLqChvB6A3OIgyxTbuRyuxbRljZ
	 SGVVZJDV9QFvVQsNFESb+Dg56jnsQJGLv3yPeqHhnpKuuIabGTR5yIrj3vAvpfe/Fh
	 rPnFoDRyt2RzRLMYV/f9DvdFQAoGWXay1QbYPDVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 362/641] ALSA: scarlett2: Add missing mutex lock around get meter levels
Date: Mon, 22 Jan 2024 15:54:26 -0800
Message-ID: <20240122235829.265685595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 993f7b42fa066b055e3a19b7f76ad8157c0927a0 ]

As scarlett2_meter_ctl_get() uses meter_level_map[], the data_mutex
should be locked while accessing it.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 3473185f31df ("ALSA: scarlett2: Remap Level Meter values")
Link: https://lore.kernel.org/r/77e093c27402c83d0730681448fa4f57583349dd.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index cdaf0470e62b..3b7fcd0907e6 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -3880,10 +3880,12 @@ static int scarlett2_meter_ctl_get(struct snd_kcontrol *kctl,
 	u16 meter_levels[SCARLETT2_MAX_METERS];
 	int i, err;
 
+	mutex_lock(&private->data_mutex);
+
 	err = scarlett2_usb_get_meter_levels(elem->head.mixer, elem->channels,
 					     meter_levels);
 	if (err < 0)
-		return err;
+		goto unlock;
 
 	/* copy & translate from meter_levels[] using meter_level_map[] */
 	for (i = 0; i < elem->channels; i++) {
@@ -3898,7 +3900,10 @@ static int scarlett2_meter_ctl_get(struct snd_kcontrol *kctl,
 		ucontrol->value.integer.value[i] = value;
 	}
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+
+	return err;
 }
 
 static const struct snd_kcontrol_new scarlett2_meter_ctl = {
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E944AB71;
	Tue, 21 Jul 2026 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668193; cv=none; b=T4XpsYfjVL+PW2Q9ZdSQuamfo/PAl6xeoPiTGVKAFvvkovpnCbpVB1/zerVCDmu+tcf0zxPMWxLI+SmkG2Ah/m/7vX7FjlRIchlva6BZWutCuKLC6ozURX+xngi8Cva6lAl361DAyg+GBT47vru5Nil8pX9FndRJFUNsn89akPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668193; c=relaxed/simple;
	bh=D2VwZ6RUKWBOC0mnaajJglmMyvq3UKmPlntvxYC24vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQYucw+6vylh2p30otDVa0375j/9bPZKU9uiQlH29lxIUrhATsBuI6SBxskuIcEQKiY+DV/yRUvsLlXMJQ5A+nWlFcNA0q2YbGD0YCmqw2TsGtdsQfzWWop4FRNQC3wUCorCnU0ia+fp8BBOs3yuDAI1r71gg+A1CW8bpDDqmpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weEoxvwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weEoxvwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D721F000E9;
	Tue, 21 Jul 2026 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668192;
	bh=I2cuF0FIVi5/4xDWNsz6J2PImPhshFgnmLi7hEwkDw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weEoxvwpppXDaV2B8Bm+0LElWp/W0Pz6Rg8wLvWukfQ8Y4fRzWGiO4BGM5QGgW6gX
	 pSaAzwnZnTugIqJg5LGGSYH56bHl00rmpB8I0swRn08WSCH5GmFT20x5ZrY3C6uWZ8
	 +9lf90VESizNQ85GmG47sY/bVen7oAYdYbXUikKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0082/1067] ALSA: usb-audio: Propagate US-16x08 write errors in route/mix EQ-switch put callbacks
Date: Tue, 21 Jul 2026 17:11:23 +0200
Message-ID: <20260721152426.409735380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 3c06aec8abda6ba068b58a8b7119cdb2a48456b1 upstream.

Several US-16x08 mixer put callbacks log failed control URBs but
still return success to userspace. That hides device write failures
even though the requested value was not applied.

Return the negative write error instead in the route, master, bus,
channel, and EQ switch put callbacks.

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260419-usb-write-error-propagation-v1-3-5a3bd4a673ae@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_us16x08.c |   49 ++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -225,14 +225,14 @@ static int snd_us16x08_route_put(struct
 
 	err = snd_us16x08_send_urb(chip, buf, sizeof(route_msg));
 
-	if (err > 0) {
-		elem->cached |= 1 << index;
-		elem->cache_val[index] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set routing, err:%d\n", err);
+		return err;
 	}
 
-	return err > 0 ? 1 : 0;
+	elem->cached |= 1 << index;
+	elem->cache_val[index] = val;
+	return 1;
 }
 
 static int snd_us16x08_master_info(struct snd_kcontrol *kcontrol,
@@ -284,14 +284,14 @@ static int snd_us16x08_master_put(struct
 	buf[5] = index + 1;
 	err = snd_us16x08_send_urb(chip, buf, sizeof(mix_msg_out));
 
-	if (err > 0) {
-		elem->cached |= 1 << index;
-		elem->cache_val[index] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set master, err:%d\n", err);
+		return err;
 	}
 
-	return err > 0 ? 1 : 0;
+	elem->cached |= 1 << index;
+	elem->cache_val[index] = val;
+	return 1;
 }
 
 static int snd_us16x08_bus_put(struct snd_kcontrol *kcontrol,
@@ -325,14 +325,14 @@ static int snd_us16x08_bus_put(struct sn
 		break;
 	}
 
-	if (err > 0) {
-		elem->cached |= 1;
-		elem->cache_val[0] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set bus parameter, err:%d\n", err);
+		return err;
 	}
 
-	return err > 0 ? 1 : 0;
+	elem->cached |= 1;
+	elem->cache_val[0] = val;
+	return 1;
 }
 
 static int snd_us16x08_bus_get(struct snd_kcontrol *kcontrol,
@@ -393,14 +393,14 @@ static int snd_us16x08_channel_put(struc
 
 	err = snd_us16x08_send_urb(chip, buf, sizeof(mix_msg_in));
 
-	if (err > 0) {
-		elem->cached |= 1 << index;
-		elem->cache_val[index] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set channel, err:%d\n", err);
+		return err;
 	}
 
-	return err > 0 ? 1 : 0;
+	elem->cached |= 1 << index;
+	elem->cache_val[index] = val;
+	return 1;
 }
 
 static int snd_us16x08_mix_info(struct snd_kcontrol *kcontrol,
@@ -530,13 +530,13 @@ static int snd_us16x08_eqswitch_put(stru
 		msleep(15);
 	}
 
-	if (err > 0) {
-		elem->cached |= 1 << index;
-		elem->cache_val[index] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set eq switch, err:%d\n", err);
+		return err;
 	}
 
+	elem->cached |= 1 << index;
+	elem->cache_val[index] = val;
 	return 1;
 }
 
@@ -1419,4 +1419,3 @@ int snd_us16x08_controls_create(struct u
 
 	return 0;
 }
-



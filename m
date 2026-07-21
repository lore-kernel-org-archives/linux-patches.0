Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC7F47252F;
	Tue, 21 Jul 2026 20:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664932; cv=none; b=ND4+CVqDYk93MJiGtSMSFNjrFLoWqxqKULIC9q3e5Ja/6VwDsY/rzxpA73skLlPDdUjSJ28lRdsLwznn4pyVLU0kod1juyJ939JIFHnTewwzj93Ix5iKa60miNq+L/YfA8tjiD8uJ5RUZOW4ToM7Jv52zKMkaQMcuVTB4ECwZ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664932; c=relaxed/simple;
	bh=0VflhKPPHOCW49sz1kuXi90CoM6MTliLVL7tnnVvw6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EURthVwJzPhq+ja7cmEqn6hXyWp6vdxhahXj0TEHMtrhpEL1Muvrh7XayeWBmqfFh9bX3jA4SvJwJtbMwfaaAYE+Rf4wBqV3vdosKgcpdObReLV54OhHXHipUo4tltsKfWkUhj6EOlho6jX6ak8z2RoMCmpfkUkN//i1wirq2U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkNATSZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkNATSZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5621F000E9;
	Tue, 21 Jul 2026 20:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664931;
	bh=he5hy8FcEqZXB/Zka/Uq7CKpayO+Z+v8hC9mMFUNGQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkNATSZ6IqCh33clEw+Mu6Qpcr+mMMmWDGuKRBJ8ZQRt18pbHw81F/wZEfAKJWiTk
	 fv+vc7evdTCRxrYy1WsiZwZnmwYG6jyHf9pnANU/o232GU3m5JUwYtusgKUIuSBQLc
	 CKG0WTLVJii0o12gwh2sy+ZWeocSXCYyXS4Pckvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0113/1266] ALSA: usb-audio: Propagate US-16x08 write errors in route/mix EQ-switch put callbacks
Date: Tue, 21 Jul 2026 17:09:10 +0200
Message-ID: <20260721152444.330808021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



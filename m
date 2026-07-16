Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4419036A35E;
	Thu, 16 Jul 2026 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209217; cv=none; b=lHMoLyPMj6r9FClCjzFmPdoCa951AEe3g/HKWmBUgFJkCKy4cqEFrfLaxBI7UK4UMf/nOQMrIsWeo+gDiqA4fcsm1YZKQxZ/ryAQD6AtBF+LeD3oMTwGAyjmDIk6HEj9e779XxIxlHn9n7N8G2wkCOvvq5987Ik1CAN7Rq7luJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209217; c=relaxed/simple;
	bh=ZYRz+4SpphAYGPpXXSF38U+7Ymdo/K4o8P7bamY9k+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nw/JkZSI2I/7q4CD60eAfuL8vx6uzVB5qzl7yF59F0y6hXwfp5llJtYI8B3d8bar/+kxupcxnw2hnQqKcln7zrBv0VRsBHMuZnHloOnwtsP4iYgyAgP65bf1/bZ55RfXaOcWD6CVwcJz0+vTRNspc/vA/vw6A28KST52dsjKDhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c3XSnTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c3XSnTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92191F000E9;
	Thu, 16 Jul 2026 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209216;
	bh=8pzfJwsZUoiuRzYkIr3nfA4u+hWCN/8LC6LCToZoJfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1c3XSnTXJzixmhvvCwBzB765GpPDdT8taK72xi6gy+9IRnpMdyYa0N6xIeCf52unO
	 ZhV4syh2yvo5AGC8ZWKxjA1YVKM4I/u+MnmQ4lL2hy7UIToyjUyQySmbhJRWr+1RM/
	 /IhJtBSZwMvmS43+mFs9XgFzZnnP+Ja5XbrcMVfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 101/518] ALSA: usb-audio: Propagate US-16x08 write errors in route/mix EQ-switch put callbacks
Date: Thu, 16 Jul 2026 15:26:09 +0200
Message-ID: <20260716133050.072906919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -224,14 +224,14 @@ static int snd_us16x08_route_put(struct
 
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
@@ -283,14 +283,14 @@ static int snd_us16x08_master_put(struct
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
@@ -324,14 +324,14 @@ static int snd_us16x08_bus_put(struct sn
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
@@ -392,14 +392,14 @@ static int snd_us16x08_channel_put(struc
 
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
@@ -529,13 +529,13 @@ static int snd_us16x08_eqswitch_put(stru
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
 
@@ -1418,4 +1418,3 @@ int snd_us16x08_controls_create(struct u
 
 	return 0;
 }
-



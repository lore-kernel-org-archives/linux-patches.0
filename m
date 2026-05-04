Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9113DDDD7;
	Mon,  4 May 2026 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903138; cv=none; b=N77Gqhx5A1EbEAX52CJxSOmxZS77jr2c/1w1jHFgaDL3XeYkr6mO1n5DLnIBj7/Af0k4EFc5kX4yQXkNING7si4OpuEOTxc58dtiTjM+nqxP/Fxegq5zHLUr8+KbEtvVSPY7ukdaeAgLGkb9Tqi72O+IHwAv7NDGe7rBLu6Vmjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903138; c=relaxed/simple;
	bh=N+sd9JBl3/E0YbBHMrhkX9SARqdjBOoswzMYwKrAZsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RrWqg88FvuvdqamNeIGMga9AtYRw4jB5E7zFLcokm+qIVX8JKmpa+pohiIoJaeohjTVhczEgi4QCqXp8KxEJwdeT7qrbqdyxdqul+DmUSIP8rVv9BnIyLQ9aDOvpB/bxy/ZsoYP9pNreHqLagXIDspgas3n/Y2B4R/mnpTViu54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kB/ixeul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kB/ixeul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54426C2BCB8;
	Mon,  4 May 2026 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903138;
	bh=N+sd9JBl3/E0YbBHMrhkX9SARqdjBOoswzMYwKrAZsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kB/ixeulgsWyFbqJ9aLAznbqJ73i/PbRDmXqMQKFd7AUoreAcs5/Wvw6ahAmEWaeg
	 vGhFIj49ahvEqkLW4/yXJDN/OZAfpK5Hid6o+Gb+W0EtMNoRYU7JYfESGvbvss2oQO
	 iy3ywtbPgdmnPbdMZrOLKQO3TW7I4133M/tV5k1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 118/307] ALSA: caiaq: Fix control_put() result and cache rollback
Date: Mon,  4 May 2026 15:50:03 +0200
Message-ID: <20260504135147.243633177@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit a3542d1b30f92307f545f2def14e8d988dffdff0 upstream.

control_put() always returns 1 and updates cdev->control_state[]
before sending the USB command. It also ignores transport errors
from usb_bulk_msg(), snd_usb_caiaq_send_command(), and
snd_usb_caiaq_send_command_bank().

That breaks the ALSA .put() contract and can leave control_get()
reporting a cached value the device never accepted.

Return 0 for unchanged values, propagate transport failures,
and restore the cached byte when the write fails.

Fixes: 8e3cd08ed8e59 ("[ALSA] caiaq - add control API and more input features")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260417-caiaq-control-put-v1-1-c37826e92447@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/control.c |   54 +++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 17 deletions(-)

--- a/sound/usb/caiaq/control.c
+++ b/sound/usb/caiaq/control.c
@@ -87,6 +87,7 @@ static int control_put(struct snd_kcontr
 	struct snd_usb_caiaqdev *cdev = caiaqdev(chip->card);
 	int pos = kcontrol->private_value;
 	int v = ucontrol->value.integer.value[0];
+	int ret;
 	unsigned char cmd;
 
 	switch (cdev->chip.usb_id) {
@@ -103,6 +104,10 @@ static int control_put(struct snd_kcontr
 
 	if (pos & CNT_INTVAL) {
 		int i = pos & ~CNT_INTVAL;
+		unsigned char old = cdev->control_state[i];
+
+		if (old == v)
+			return 0;
 
 		cdev->control_state[i] = v;
 
@@ -113,10 +118,11 @@ static int control_put(struct snd_kcontr
 			cdev->ep8_out_buf[0] = i;
 			cdev->ep8_out_buf[1] = v;
 
-			usb_bulk_msg(cdev->chip.dev,
-				     usb_sndbulkpipe(cdev->chip.dev, 8),
-				     cdev->ep8_out_buf, sizeof(cdev->ep8_out_buf),
-				     &actual_len, 200);
+			ret = usb_bulk_msg(cdev->chip.dev,
+					   usb_sndbulkpipe(cdev->chip.dev, 8),
+					   cdev->ep8_out_buf,
+					   sizeof(cdev->ep8_out_buf),
+					   &actual_len, 200);
 		} else if (cdev->chip.usb_id ==
 			USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_MASCHINECONTROLLER)) {
 
@@ -128,21 +134,36 @@ static int control_put(struct snd_kcontr
 				offset = MASCHINE_BANK_SIZE;
 			}
 
-			snd_usb_caiaq_send_command_bank(cdev, cmd, bank,
-					cdev->control_state + offset,
-					MASCHINE_BANK_SIZE);
+			ret = snd_usb_caiaq_send_command_bank(cdev, cmd, bank,
+							      cdev->control_state + offset,
+							      MASCHINE_BANK_SIZE);
 		} else {
-			snd_usb_caiaq_send_command(cdev, cmd,
-					cdev->control_state, sizeof(cdev->control_state));
+			ret = snd_usb_caiaq_send_command(cdev, cmd,
+							 cdev->control_state,
+							 sizeof(cdev->control_state));
 		}
-	} else {
-		if (v)
-			cdev->control_state[pos / 8] |= 1 << (pos % 8);
-		else
-			cdev->control_state[pos / 8] &= ~(1 << (pos % 8));
 
-		snd_usb_caiaq_send_command(cdev, cmd,
-				cdev->control_state, sizeof(cdev->control_state));
+		if (ret < 0) {
+			cdev->control_state[i] = old;
+			return ret;
+		}
+	} else {
+		int idx = pos / 8;
+		unsigned char mask = 1 << (pos % 8);
+		unsigned char old = cdev->control_state[idx];
+		unsigned char val = v ? (old | mask) : (old & ~mask);
+
+		if (old == val)
+			return 0;
+
+		cdev->control_state[idx] = val;
+		ret = snd_usb_caiaq_send_command(cdev, cmd,
+						 cdev->control_state,
+						 sizeof(cdev->control_state));
+		if (ret < 0) {
+			cdev->control_state[idx] = old;
+			return ret;
+		}
 	}
 
 	return 1;
@@ -640,4 +661,3 @@ int snd_usb_caiaq_control_init(struct sn
 
 	return ret;
 }
-



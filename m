Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DFA30567B;
	Fri, 15 May 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860738; cv=none; b=YN0i2ZHz+fXo5bNyTVJZl/X9Tx3Zytn0SWwN9C+vSB/LcW/aAumeVj/0UC8mNubJqqF0NT/hX+WetwJw8QUrmoF+kDw4gTyFdIe1IjOlmgNAkScVVWf2yYsVU/uY8mVDQR7BJZXnwRtjzYgH3+x2R/E033fZQEHJulFiR9SOZgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860738; c=relaxed/simple;
	bh=pcGtyoYKohQ38VNcS5H1kGgdXS4Z748TPcBsADM/oTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1+MWxcbHzsYLHH/DDYt8fiCi2TwOPsw0O3ow10SqrUQ70KXI7oC/kKUfgyaXDwNt3PxZsf87AVlB4vi/XzJR24Vm2l7m2lLufGmJ5NOr6edbnxRaDl6Chc+9FU7xV4j6PSq5oCDNKwek8ru5Z2cOVRJDJZbLvsumQQePznubzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnZQO4QC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnZQO4QC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0672C2BCB0;
	Fri, 15 May 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860738;
	bh=pcGtyoYKohQ38VNcS5H1kGgdXS4Z748TPcBsADM/oTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnZQO4QC5OqAMb/vWCxDOaF/SGTP4zNtGd7xqrY4o1UK8fylE0Cl3Pl3yCWfPlrPD
	 5TcF4kx6GyBQJ1b1laLZxI3wyb8giwfiIVY2ff1W9GW3leOm8czMj8hgjbpFfkT8ah
	 IsXdaxYfbfQ0R5tCq+1GNoc6WSq23KKQRtNW+NOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 059/474] ALSA: caiaq: Fix control_put() result and cache rollback
Date: Fri, 15 May 2026 17:42:48 +0200
Message-ID: <20260515154716.321440846@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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



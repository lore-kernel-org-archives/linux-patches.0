Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DEE4766AC;
	Fri,  7 Aug 2026 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117291; cv=none; b=N7J0QX8Cw+9Y8G9xJ4VDEy7UkKP2psiNsPhnZNiwHbe1943wyjeTx/oj5ZsPQPRD+Cty60s3nPJH81FkXAOmtj/jQCR4t8AVTCrl9p8Syhh6olaCWEUFp7WcembZZwke+FOCfNsd1Qy1qJf1UlXhyU8DCDpGCT/YtXkeUMbeMaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117291; c=relaxed/simple;
	bh=sOlhQFZUe5jmHlqY0ZsLExF6dUvO7bEbcVae11Ep3K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sExUS1wnzrbxIZe2HT4ZTFw99nQNj9ogE5U58WMhmPhAoM0fUUiCKbG+xOnIzgyWTeNG2+8TW4CkeS5leDNO/2+o/8n4c57H/Gc2csjq2rNotNYA9aB5eEA8UPBX0bCIzsNAQ95cad43EO8jsR3pnEIIRTTrPyfxQeyZisTnKqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niGf8TJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niGf8TJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5461F000E9;
	Fri,  7 Aug 2026 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117290;
	bh=bgdDakwpO4I1gaTszCT88cTUQ12ap4BEjCAnwuR+Q7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niGf8TJb75rPWor+Us64CfCARpIagaQQtL55g41T82FvS7DtGqDUwEIwvx0L0H5m2
	 fWyaBoMdlljpv7OMq2xHMosxDJVoRfOhJMD/XaRtXkLxAdI1WZyuw4QzsOWhpDHqZZ
	 ER3sn3oFLzb5QIo1n93TZ5pKJFqntrpJw5yFtdUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 268/438] ALSA: usb-audio: fix stack info leak in RME Digiface status
Date: Fri,  7 Aug 2026 16:37:44 +0200
Message-ID: <20260807143433.701865996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit 441aaad150c57edaf57ee482a79a3bf4c5b7e353 upstream.

snd_rme_digiface_read_status() reads a four-word status block from the
device into an uninitialised on-stack __le32 buf[4] and, whenever the
vendor control-IN transfer does not return a negative error, copies all
four words into the caller's status[].

snd_usb_ctl_msg() copies the full requested size back into the caller's
buffer regardless of how many bytes the data stage actually delivered:

	buf = kmemdup(data, size, GFP_KERNEL);
	err = usb_control_msg(dev, pipe, request, requesttype,
			      value, index, buf, size, timeout);
	memcpy(data, buf, size);

usb_control_msg() returns the transferred length on a short control-IN,
which is a non-negative value, and writes only that many bytes.  The
remainder of the copy back is the kmemdup()ed image of the caller's
buffer, so a device answering with a short data stage leaves the
trailing words of buf[] holding leftover kernel stack.  The only guard
in the caller is err < 0, so those words are stored into status[].

They then reach user space: snd_rme_digiface_get_status_val() selects a
16-bit halfword of status[] per the control's reg/mask, and the eight
Digiface status controls together expose the whole 16-byte frame to an
unprivileged reader of /dev/snd/controlC*.

Zero-initialise the buffer so a short read yields zeros instead of stack
residue.  This mirrors snd_rme_get_status1(), which already clears its
output word before the same kind of vendor read.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 611a96f6acf2 ("ALSA: usb-audio: Add mixer quirk for RME Digiface USB")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260726065020.46070-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3454,7 +3454,7 @@ static int snd_rme_digiface_read_status(
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
 	struct snd_usb_audio *chip = list->mixer->chip;
 	struct usb_device *dev = chip->dev;
-	__le32 buf[4];
+	__le32 buf[4] = {};
 	int err;
 
 	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637AE3AA195;
	Sat, 30 May 2026 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159899; cv=none; b=AdxYUgzzLyixS82DVnMtA7KVOeHI9/DcOYwqhN3wMpHOn5W3vnuRWPHLgpFoM69V7Vacy0RAZrtZ1dgMuPhoRMZpOss4s7X0lOagyelNhTJ5OxvvBMI4+5w5XukQYpFlSHcE9lyQF6ZwpD7yDKtqKYaFXYz9R3jStKHcYpaWmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159899; c=relaxed/simple;
	bh=8jO1huyxHK/4A2KBLGeOnuT0Jy6x4H9pbO3KoaysS54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMp2vjIWbxnUg3jhS9u2kmDl+k6fnEQZ+4+0GWnXe/LCNWLJhlYw9tHwPPBjoHIUj0xhtPLvfRKR7Rw6SnQYyCrKfCpY+5V7ChVEP3nuwMXyjjVFdArrmG1r7YiK3CUZ5xMyjKeusXurfFt84MYSNhDpjZ2Ch7v28pVqY6QUet4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfobC43V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfobC43V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADC01F00898;
	Sat, 30 May 2026 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159898;
	bh=vh4FiVHY0tXPIpa2Cpy31FRugAPXLc4J8PfxErOT7uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfobC43V7HUWiBMK59TuxELmgBfGSVZNZy/Zu+KedohXWIwFBisxULaN2usamTQTw
	 JTcNy1jQtrrBE/a4AQ/teYsK4xRDuslulyu/TmExdwB5Cv4VChMqAHMJjw2JGsW99J
	 UUE8YTxU++FkxKQntxauKBW7+W/FMGgqChXoUD6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Arun Raghavan <arunr@valvesoftware.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 189/969] Revert "ALSA: usb: Increase volume range that triggers a warning"
Date: Sat, 30 May 2026 17:55:13 +0200
Message-ID: <20260530160305.702680720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

commit 41d78cb724f4b40b7548af420ccfe524b14023bb upstream.

UAC uses 2 bytes to store volume values, so the maximum volume range is
0xFFFF (65535, val = -32768/32767/1).

The reverted commit bumpped the range of triggering the warning to >
65535, effectively making the range check a no-op. It didn't fix
anything but covered any potential problems and deviated from the
original intention of the range check.

This reverts commit 6b971191fcfc9e3c2c0143eea22534f1f48dbb62.

Fixes: 6b971191fcfc ("ALSA: usb: Increase volume range that triggers a warning")
Cc: stable@vger.kernel.org
Signed-off-by: Rong Zhang <i@rong.moe>
Acked-by: Arun Raghavan <arunr@valvesoftware.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260303194805.266158-2-i@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1814,10 +1814,11 @@ static void __build_feature_ctl(struct u
 
 	range = (cval->max - cval->min) / cval->res;
 	/*
-	 * There are definitely devices with a range of ~20,000, so let's be
-	 * conservative and allow for a bit more.
+	 * Are there devices with volume range more than 255? I use a bit more
+	 * to be sure. 384 is a resolution magic number found on Logitech
+	 * devices. It will definitively catch all buggy Logitech devices.
 	 */
-	if (range > 65535) {
+	if (range > 384) {
 		usb_audio_warn(mixer->chip,
 			       "Warning! Unlikely big volume range (=%u), cval->res is probably wrong.",
 			       range);



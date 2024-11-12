Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636D621C189;
	Tue, 12 Nov 2024 10:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407809; cv=none; b=b4dJQjpbJmt6Qfj9f6I68h3suh2BehEdeCPfxZWU89But7WOTxIBW7bHItRgKadAKWPFnm8hL6hhJulwBspiC0y63/zdDX4JI3mZhW2qgEi+XRfhYO2aYFy8UrfVgQ2pV2z0xdPBPFRYSFr/ZiroMvLgksx0AOnQx9SguqVwnpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407809; c=relaxed/simple;
	bh=yTPJMTT2GpSKHQO5+anLFClTVO0taON68QOjUwRTiaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoeeZ7A0LAZHkCedrB1VcJ1iXZpuJfwPjSVFHEd/N4m/K1utnbN7NfKtz0OOQuRuMiW0l8OAXG4uX7m/By/PsUrfTGRIOOt0eJh7Mxk33L43bSzkM7JeNN7dpL5Tz5tqKWCnTOJPY7Cuh3XX3tEKhqAHgo/2O0atDM+iMNiSHEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlzBVVJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlzBVVJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8BCC4CED4;
	Tue, 12 Nov 2024 10:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407809;
	bh=yTPJMTT2GpSKHQO5+anLFClTVO0taON68QOjUwRTiaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlzBVVJSIc4oBSvYRK+eAi8wAhX0iTRtOBKkMCJ+ToOdyAhoMbqC6xECXDd//V28O
	 XvB0108nWRNykZPVyaLlAqvxUdRLTMu+m2NKRAFwkcoIAnVGrWbcZBaHIoIijbSKl8
	 fO1D2cVoqgmHk4Zai+K+7j6Ac8cIVLLjSwLGuhMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 088/119] ALSA: usb-audio: Add quirk for HP 320 FHD Webcam
Date: Tue, 12 Nov 2024 11:21:36 +0100
Message-ID: <20241112101852.077438108@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit dabc44c28f118910dea96244d903f0c270225669 upstream.

HP 320 FHD Webcam (03f0:654a) seems to have flaky firmware like other
webcam devices that don't like the frequency inquiries.  Also, Mic
Capture Volume has an invalid resolution, hence fix it to be 16 (as a
blind shot).

Link: https://bugzilla.suse.com/show_bug.cgi?id=1232768
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241105120220.5740-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c  |    1 +
 sound/usb/quirks.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1205,6 +1205,7 @@ static void volume_control_quirks(struct
 		}
 		break;
 	case USB_ID(0x1bcf, 0x2283): /* NexiGo N930AF FHD Webcam */
+	case USB_ID(0x03f0, 0x654a): /* HP 320 FHD Webcam */
 		if (!strcmp(kctl->id.name, "Mic Capture Volume")) {
 			usb_audio_info(chip,
 				"set resolution quirk: cval->res = 16\n");
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2016,6 +2016,8 @@ struct usb_audio_quirk_flags_table {
 
 static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	/* Device matches */
+	DEVICE_FLG(0x03f0, 0x654a, /* HP 320 FHD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73662141C3;
	Tue, 12 Nov 2024 10:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407406; cv=none; b=mUPb7kCAw6fPkUVdyCOt902JiAOobSIsY9GmS8Knr/mKTVGe3DOjm4sVGmJgXOQHRu6oXO/8Go7Fgxnc6yjOt6xZ0Gncd3T+ZFk0zXWgOQIH0UMg+5wLoZf3/5Vfemm/zhQBApSxcObbxRiEjur6W7Tz7dRuaYbN1tVlKfpKYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407406; c=relaxed/simple;
	bh=Z9BGu8ZtiN/sJiRCPorCzL9sR2+7EQ5GW3n6nbJvmVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0p8JYhHkjIcFjnqHeR7zQNV/VT4YADWR6COVgM3SbdzIBYOU1xAoifkVV9TTr0eU03Us5mI3GGxLNamWEPfa0enEFeKEp0zUkDtoRLJqBcYH8gULwAqKSwaGEsxJmvi1i3DqAn9hzWf0/5WNe23Z/aE8n3GLYfn539Tuo4UDvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCf2ItI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCf2ItI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45032C4CED4;
	Tue, 12 Nov 2024 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407406;
	bh=Z9BGu8ZtiN/sJiRCPorCzL9sR2+7EQ5GW3n6nbJvmVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCf2ItI25vr+E2lj3vAQ4n2GmB8gSS7F8DvQiTuYolBAAeo0JpKr/j9OyhM70eY4e
	 cKAV7AaSUDs0esa8QwfNE2mHdw4ftoCFGWbmBAl1qdEBo17hTwGdwJ3xOjW9yoOr7d
	 YtNBZ6nOwgxlRfUL2Icii5YXPXwKz4hUhM8uOHmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 66/98] ALSA: usb-audio: Add quirk for HP 320 FHD Webcam
Date: Tue, 12 Nov 2024 11:21:21 +0100
Message-ID: <20241112101846.773979966@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2014,6 +2014,8 @@ struct usb_audio_quirk_flags_table {
 
 static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	/* Device matches */
+	DEVICE_FLG(0x03f0, 0x654a, /* HP 320 FHD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */



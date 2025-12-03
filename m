Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3C35E523;
	Wed,  3 Dec 2025 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779233; cv=none; b=VPAQqXbaxo3RnjvSzsGT6OUVsX6Mi0iZ0//Dcu2vCQOE0iZ8HxVvXKqUXCbL1ZhwsIWNrHn3eOy0jFYshKa95mkd504Go/BUWZyQ0U5HzYr7CW4zieFLGBZVU4ixaGi+/uzwj3oDmX7AjcZj8K58aQNdh5yZzeieAsNfyoQMPec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779233; c=relaxed/simple;
	bh=wneHHsXu1XVwgEbXkDcXBLBAEY9rZ0/HuVXjVStNW4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2q9tZDOsdAMvcdEKyCOmQ1h9dHqfDe+ZCWlYdWS2xw2esHig2KEQ1yHnN8sz9QoeZvNwERIQmvSSpqsFFORGxjauYRUsOTdqkrgRJQ8OfxkqdvfmnPI4ysKBCCR3pJtEjnicBNfWhq2kTrhzri4rpJt5aAUTmMEVvPbH5TS52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUyZtlbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUyZtlbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E85CC4CEF5;
	Wed,  3 Dec 2025 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779233;
	bh=wneHHsXu1XVwgEbXkDcXBLBAEY9rZ0/HuVXjVStNW4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUyZtlbTZZbGis/uoi2gv3evu2mZ0GCK+L4NFKJR9m5j9UiXRW6b2gQjuL/rudB8W
	 OcXNd7yXmalLeVUIzYV6Z0Bk5kP+AsPPj4ZB/c/pvVxRJd5wngJy/OKlCynPgEYNpE
	 CQof7OByWxOQOk0Re4g3uob0+NnlWZ4mGiOLAMtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/568] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Wed,  3 Dec 2025 16:23:17 +0100
Message-ID: <20251203152447.867809202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia@uniontech.com>

[ Upstream commit a73349c5dd27bc544b048e2e2c8ef6394f05b793 ]

It reports a MIN value -15360 for volume control, but will mute when
setting it less than -14208

Tested-by: Guoli An <anguoli@uniontech.com>
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250903-sound-v1-4-d4ca777b8512@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 4cded91d22a8d..d258c7324fcc7 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1191,6 +1191,13 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 			cval->res = 1;
 		}
 		break;
+	case USB_ID(0x3302, 0x12db): /* MOONDROP Quark2 */
+		if (!strcmp(kctl->id.name, "PCM Playback Volume")) {
+			usb_audio_info(chip,
+				"set volume quirk for MOONDROP Quark2\n");
+			cval->min = -14208; /* Mute under it */
+		}
+		break;
 	}
 }
 
-- 
2.51.0




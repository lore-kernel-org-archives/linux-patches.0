Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0445126A1B6;
	Tue, 11 Nov 2025 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823674; cv=none; b=m0YmQGnU8yzv6rp2j30RSfHrjZZ4YVJJNyYGHK8E6HRrCaM5wY3heg1LLdkKTeFv8ue0Zml8MeFjPMZZPesv/ZBlxG2il0nOIrdTQRGkjnqCqyrIq/y0yDpeSEs/ulmb2F/WHRBfardBDvi2DiJHQj/rLOm3W75jD0jh7dOPVc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823674; c=relaxed/simple;
	bh=/ZVTS3OvOaZ+Em14EWFpRo+tUPtmqIQDKbz6+3zvFWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unM59g7//XRcTwvfHMUzc+fYIaDmxmW9e/4vhhmsq5nFmDxpyOKyeqQAm9MVbqoLxFjRuEwmS8gvSeI9MTf+ZH4Ig+qUuH4OD0tNpYDLmYJfKo7YvYvr2CfUaFly88EsMTDa30WDUuYFoNT3nkO/d7IBkH27dEWE8rniU2wgzFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Rh/caqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Rh/caqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3647FC4CEF5;
	Tue, 11 Nov 2025 01:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823673;
	bh=/ZVTS3OvOaZ+Em14EWFpRo+tUPtmqIQDKbz6+3zvFWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Rh/caqAwPU/c/s0Byxwh/9TMjuHxxnj79hB8T+ZCMnwx76Kfaq757GcZ8IR36zGX
	 H77pAKwn3gzmmmM5aR+3JIq+LByOa6KthmB8AXyNNq+WGZdOoGVmq0yztDcbGtMesj
	 MmT1LNeLUcykyVAauqajCZYx5MiRUDCyHOUs0zx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/565] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Tue, 11 Nov 2025 09:42:34 +0900
Message-ID: <20251111004533.581830026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0591da2839269..ba9c6874915a2 100644
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




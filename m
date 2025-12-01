Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD2B2561AB;
	Mon,  1 Dec 2025 11:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588524; cv=none; b=uqVq3t2lWAv/DUyhs4/0TCBdlcyACXhcsEKwpau8myhFaFeqi3NqpvBTZIqeUEt5IASBIBxDiJGONrhtpsm9NgJKfSql5CgQEMnFy6v7e4oQMn/4UJM03mDppO8H8jYMMgVn1ngrfC6nGHxEZoOQwxIe3/CFr/HN6VrPyX2PhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588524; c=relaxed/simple;
	bh=EGY3X18Fed+4dnikwemj5Cwi5xmLg6cWwyKrhd71p8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cp2QpuO23A1zKxm6pkeHHLh2+ZATcXJIHKEUv6eUq7vcuFgrWiY9O4XPafboII2DC0wdUCp/DixanroumnQgCkLJQ60nBirmB9beA/2auGAHYDSK2QO1mChQ23MnLRavdklsLE587fgYzTnQbmZCJzhyOusWhIsv4n7FompAX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wc/ZJCb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wc/ZJCb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9DDC4CEF1;
	Mon,  1 Dec 2025 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588523;
	bh=EGY3X18Fed+4dnikwemj5Cwi5xmLg6cWwyKrhd71p8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wc/ZJCb2aJroiBXqZU8Vx0sUB+H8LKBsVoTUvhX3jUvSacxfGpeV3pRzQ41cO3Dbc
	 aBk+HRNaluiZc2ilPFembvuDynOT7q1/iNS2FlP3c33KtNIU3xdr75wtAToyaQfF4l
	 Wqnp6LmxJjiXzyi8sstA7cwwLtoNvgxNJDwj4+MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/187] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Mon,  1 Dec 2025 12:23:05 +0100
Message-ID: <20251201112244.014377733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1374a4e093b3f..f2c697ff50b57 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1181,6 +1181,13 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
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




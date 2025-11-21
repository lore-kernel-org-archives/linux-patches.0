Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74EC3F9D2;
	Fri, 21 Nov 2025 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732638; cv=none; b=j4GKMwBriHJaR7W88z21SixhKi81FK6r97MJHBwNH974U02rznsPKxhplR/JOswjTRtkPmWgCuCaw3fjrkeQreFARlYXb2m809V3JC/prNlcNzLdaDPkQobYCImFwKFzokDUgiw4cS4hXnfWk84l/x0cQ/63M9WNrQD1DFmOAIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732638; c=relaxed/simple;
	bh=x4O5BR24Jbqou50T9+VmNq2rosrx4zwj6k0bli3h7JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1bIy5S+0+K6yUuL/P9LltNSPXBWYC5nMZ94kS3WDkM3/v7Fzyp6lMl9OKy+cd6sO0SYY309skNN2bwOfuhJ8LlIjyYEHGUe6dI5sPlxVgcimRduuz/eAHYEKZ64Wun6OJfGN9kNw89SLOcQwbre0JSQzJzEXr+W4UclaPO0MEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7i08G0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7i08G0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F14BC4CEFB;
	Fri, 21 Nov 2025 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732638;
	bh=x4O5BR24Jbqou50T9+VmNq2rosrx4zwj6k0bli3h7JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7i08G0ayYO+umnqJELeD50ts//n9X0f0Skx1gWkkyts3MQAuQ2PWcZJEBBMXCznW
	 tOeJ9VGI6Jhw3kxRm4BiryWguJ8y6B0k/pXYzMbPu48ej91NKii3P1KVxf4Oh9RmUw
	 eYSzWmp+M2MvWTbCdIIfyn6qbDoNyQlXml2MXqcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/529] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Fri, 21 Nov 2025 14:08:10 +0100
Message-ID: <20251121130237.814001663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b8fa0a866153b..cc051756a4220 100644
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




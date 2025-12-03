Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C7E314A9B;
	Wed,  3 Dec 2025 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776289; cv=none; b=A6JUG2sZq7xIIW5iWE5VKtCeEXQ9XTeo7rwjHV5EArq4gCCqEISCoA9+kMf9f+DZ9Qy6k4hMVi4QXUQ5J7+z6s8q33fb+zCnL/ycjXTi+6i04Vp11qQn2dJbyzuuW/SPkB79GEIhW8FkX7+C+7lQCxhMjIv3XANMYRI8v5yW8Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776289; c=relaxed/simple;
	bh=7bEMhweOpmcBRSl/4s9hfHeP6smQMy7spEc80B81474=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujFXZAH1eP9ctlwOkWeqotNt8MT+FYQspm3cjzjZe4c0JaR2qj0mAw8izCbSVltbrF2jm5yinnE3ZCVqlJpM/RPO5y47rzAHChZ3ZhrwqifUdFqf/72S8e/dXwMrfqg3L+ipSNNS1QHqSP6ZfXW4hou/UwfSG9KuNVpZhAJtQO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+8rqiPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+8rqiPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096C1C4CEF5;
	Wed,  3 Dec 2025 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776289;
	bh=7bEMhweOpmcBRSl/4s9hfHeP6smQMy7spEc80B81474=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+8rqiPu7MP2SvaGQqlISkyWAGwSlqVsEexbXvmzAed+0iOQBeiFwSDWJyy+7jJrH
	 EWPTbrrhieNrbVMC6tl3EhMYf2u5/9HRVmF72w5Q9h4r8UZM/HLSUZBzmrYlOks7cO
	 UF7PAZCIGHrVFVyFyDljS34bygKkLqZ/SQTCor+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/300] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Wed,  3 Dec 2025 16:25:09 +0100
Message-ID: <20251203152404.513991761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8826a588f5ab8..c84e25b2b1fb9 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1192,6 +1192,13 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
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




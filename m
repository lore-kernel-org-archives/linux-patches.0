Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55772263F52;
	Tue, 11 Nov 2025 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824118; cv=none; b=fxWFr7FqUf5LFQz9+YA8U/qlN0IdYQGCNVFM+9fuke8fR2M9UOV+ZJjFxPQ3SPdJCSTO8SgZAWEFkQ5sLwU8G0AcB6DAtgoC6amxj9VAyY38YiBCSO0fpvRiUlfg/QDcwVYigOhweD/HMcnrg0DsR/wF/RAffh7unQWmKextKp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824118; c=relaxed/simple;
	bh=f1iQezGCEkwfUE1msxHjfwvQw0ZW9YsWSKjfIZrHL5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5UjhW+jVtNi2QQSUfEmxlARTnf+SqUg4U0EIXq11gDPFmqraUxKSLXxPvKDio5YKyUBq3XiyfDX+4TmrprWyC/UUMt934mzsh180Mv4743BvQlIjoTghAzjVKZ0kAUd+N5THcUFWMuokZikn0QUmsrJUNVIS9UWRrm1DNFMbhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHBj9pZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHBj9pZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81EDC19422;
	Tue, 11 Nov 2025 01:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824118;
	bh=f1iQezGCEkwfUE1msxHjfwvQw0ZW9YsWSKjfIZrHL5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHBj9pZoH9p4V3LFiIetEYSqqcjzqyqptzYRzZMqUsBfHvV5xGp0u5WgTG88WCdFL
	 hZbNV1pGGHqCdeKFEuYh5gbjE4ELv0mVTG4cBdMHIay9gEuzYFLUa8UZ3+wwuay8FR
	 VjWcGVrzUw5exoHI3suhegREhTvUt9JmlUoFj+ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 440/849] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Tue, 11 Nov 2025 09:40:10 +0900
Message-ID: <20251111004547.071456245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 63b300bc67ba9..cf296decefefc 100644
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




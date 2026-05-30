Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568F34F48F;
	Sat, 30 May 2026 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159758; cv=none; b=Nz0R5t5dVAVVtwKMa5stj/TQNkfrb8fILOWxgUSX9IJBJ1YAACSM0HW9RCT+APOJ+z5obIPe/VhCLm5oGwjXZE3A6/y4lm3SMURaKVVRrVKCdop4C+Ocbcsy36Ez32qnTVbgkNRZ3/ua8OvshyunPvSohE9fsRzyRe1es8Z0mAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159758; c=relaxed/simple;
	bh=gHl6dG4dtE2GWOxegQo/Px5EadO/XhWhwPmvQP7D/L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB1rNj8Z53Tc2+wpLmpYl+wNA4cYsXA/fkhamwvH/+1nRoCfxeTbBV83kj7J//nuhJpi4/ibCxr/alH3SLKk5m+ZCkk9pE+qRVuacDQ1s5ViitSTwerasrHpSA0XGGytp9LA8ye7l5fmO0cXyAS41oJMm9tG1mAa4jbBxnDCvPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bw5KfGm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bw5KfGm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9751F00893;
	Sat, 30 May 2026 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159756;
	bh=S30Zd+RRcobA7XKrhFGkEeDCeqeJf/+WIUubTrTVaJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bw5KfGm9Ihxhmq/P+L3107kB2TWWR83y+jX+h+UmMmhJ8TUaH036CrW8s5bF/83Lr
	 pubo2mBe4fNVQUAALr20Io0oBBOFYd1rEMg4H7TmpYdv1s3YAjk73fejeDxlRym7d0
	 BGN/O/cSbK4kFDu73jl9P8x0bDc/O4ROvgiGi3IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 153/969] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Sat, 30 May 2026 17:54:37 +0200
Message-ID: <20260530160304.768556737@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

commit 4513d3e0bbc0585b86ccf2631902593ff97e88f5 upstream.

It(ID 31b2:0111 JU Jiu) reports a MIN value -12800 for volume control, but
will mute when setting it less than -10880.

Thanks to my girlfriend Kagura for reporting this issue.

Cc: Kagura <me@mail.kagurach.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Link: https://patch.msgid.link/20260402-syy-v1-1-068d3bc30ddc@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1198,6 +1198,13 @@ static void volume_control_quirks(struct
 			cval->min = -14208; /* Mute under it */
 		}
 		break;
+	case USB_ID(0x31b2, 0x0111): /* MOONDROP JU Jiu */
+		if (!strcmp(kctl->id.name, "PCM Playback Volume")) {
+			usb_audio_info(chip,
+				       "set volume quirk for MOONDROP JU Jiu\n");
+			cval->min = -10880; /* Mute under it */
+		}
+		break;
 	}
 }
 



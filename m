Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4DE2E6CA8;
	Sat, 30 May 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165621; cv=none; b=KZ/JovH1QZDndzj/TGwL2VzXX2aIsjgHcuBDHeVRivL07h4ol1ZzShXqSM5LgtLAnmFgMnL7suWotU6e0pMgP+OFB9cAVKYuDIthjVaqKEZ56tfftuLYUX9GObachrk8RW6Syvhqn05ODU3KU9AYHBNvGYDOczFaogmfWsC1to4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165621; c=relaxed/simple;
	bh=74EUPtC4wlHtwW6+1Ehs+HQNhTpbNEJjU4lD98CQc2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkI0oBKRpsCBgKFzhATFnRgubfeO0q6kSvXshbHzmdUdKIGuvLvTnRrWiGfPHk7hJJ+xnUYXHfXkKVKCl0SXJOly8LB4tGvyM0QUngUqQtBr7DCyUb5KO3L6TfDwzZ56lh/te4cdDoyc8iDeBXz68sKwns3Ugfg/9TYeQVZKMVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHLM7SiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHLM7SiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA221F00893;
	Sat, 30 May 2026 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165620;
	bh=3ucycT9TfQOuYdfJligwHORJ/7RZRmUx39fBxB4wILg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHLM7SiTefd78lokPEFrNEge+fGxYf+Zc33AH7FljVaaMzuZ2BIM8a46Ox5Av16O2
	 JycJeJ9AQxBD46A7z6pm4cF8vxpuk49Zn+P/UrltVnlggHlfVuNBuJnMbkDpB2DLaD
	 FgU/CbCV97h299W6l4aSpvXeuADc22PsfYKtpIOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 131/589] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Sat, 30 May 2026 18:00:12 +0200
Message-ID: <20260530160228.220957372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -1199,6 +1199,13 @@ static void volume_control_quirks(struct
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
 



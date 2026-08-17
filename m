Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B44D43D4F7;
	Mon, 17 Aug 2026 13:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974253; cv=none; b=J1QFpX2pijTT6HgspDY/0y8Qr95YHQmz3j1+mKIbDl/FbJSqhsHW8tTcLa1HMhD4TnmFICIxVrdWeRP+miSg8UOdSNKqiL07YMYll49CSiJXQuSN5QD/qs5ZTpkpjfen3Pp2p8ddyw1L5FFr8kvaO///qJ/H9gYb/2es15qXoOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974253; c=relaxed/simple;
	bh=0A6yMandknU1fXDrDlM8hLiCuZiwqMITcHwXe9ZSMPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK5XJ1P3Pw5az6FbfENV83OHhYw8dJbt5GTRnECPk3rb/iH/4Ls7bu5+msgJnjyWFJc3h7NaoAEAHm7Cvle3MX2mZe7MhnSiXRjk9ljCoiDnMB01NAkTlAxQTPjTbri+mf3T7dtxR9Jz6zmCq6rT0WFNAclO7pnKK/bx84JaWQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fInAtjVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fInAtjVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFD81F000E9;
	Mon, 17 Aug 2026 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974247;
	bh=OnUbsZ8HX+imIh4hNT2uy968nnwelnkV25cD7iU94zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fInAtjVgNb/unFIsXAEVr9mBfEqsQgGKnqX+8myXf7wpJb7mwAFGJco8NioVPVpCe
	 21pbGqpzwd3qFehVEjFG8GRsfE0H9DdP6oS0Gk8UD+I51s/GUXAWQxguWVNTte+tXL
	 W4IYg2RdhumjHjykeiTuMSvo8apywXvEqnjbU+4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 123/271] ALSA: usb-audio: Fix sticky mixer regressions on M-Audio Fast Track Ultra
Date: Mon, 17 Aug 2026 15:30:48 +0200
Message-ID: <20260817132541.920509306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a8934c2c6dfd72901cf3cc0de28e85eb902a61a4 ]

The recent fix for sticky mixer volumes caused regressions of M-audio
Fast Track Ultra device, where the mixer state is kept to the default
value.

Add the quirk entries to tolerate the broken mixer behavior.  As the
device is known to work in the implicit feedback mode, explicitly
enable the implicit feedback mode, too.

Since there are two FTU models that are almost identical, both entries
are added in this patch (0763:2080 and 0763:2081).

Fixes: 86aa1ea1f15c ("ALSA: usb-audio: Do not expose sticky mixers")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1273166
Link: https://patch.msgid.link/20260807083418.1712585-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index e97038cf5271e..354866a806056 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2320,6 +2320,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0763, 0x2031, /* M-Audio Fast Track C600 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0763, 0x2080, /* M-Audio Fast Track Ultra */
+		   QUIRK_FLAG_MIXER_GET_CUR_BROKEN | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0763, 0x2081, /* M-Audio Fast Track Ultra */
+		   QUIRK_FLAG_MIXER_GET_CUR_BROKEN | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x07fd, 0x000b, /* MOTU M Series 2nd hardware revision */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
-- 
2.53.0




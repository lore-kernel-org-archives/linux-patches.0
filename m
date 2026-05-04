Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA3D3D5645;
	Mon,  4 May 2026 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903889; cv=none; b=lajgjFDp5myBFp3JZWVYXpEZj07+lVVx3TXEqPmibpMaylQZaZAmQUFAZlkiCTg0uiSDQ2fPvQkPJkghET5CyIXHl55A5ZIfFGOa/MgJ7ndZ9weyewasU0N+vSHdz9752N06lspmkpb/vP7246dtgK/WxNPvr3m7TDkzZ6qv0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903889; c=relaxed/simple;
	bh=fNjPB1mN7YXDL7yl93fV5bZ4wT1cNbApK2z93+Dpjng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbQbDqLoLMxkQD4iifSegVGfYZQ/UnxqKTL5tHQX7y9+DjFCV5r0YdcuiCp8KRLkj8+bIBkjWTQFe4xE3qcG8hqXcoy7pKd2EwIV+aSytW276ozt1Yy3sGcPsAKdQOleN1lGLDv6wZcxhfciHfBLDY+3d/w1iNuJLUozzNLYv3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVfo1l6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVfo1l6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23341C2BCB8;
	Mon,  4 May 2026 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903889;
	bh=fNjPB1mN7YXDL7yl93fV5bZ4wT1cNbApK2z93+Dpjng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVfo1l6SBLuW0rC/IQTMVEgluxHNqDqzAk8c140yiBcZck1eo7lZG1MaOOR+Bodua
	 e5IW6lPiD2w4+is3bikxbSj3ZpNp5DQ23uX/Xey7bTosRUqkdE/lx5RxvNLTlPZhjA
	 A627jFqF6btr+VbCxBLYROceIJS6O66d8pNh+UQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 102/275] ALSA: 6fire: Fix input volume change detection
Date: Mon,  4 May 2026 15:50:42 +0200
Message-ID: <20260504135146.704891336@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit dc88eef8f55e85e92d016cdf7e291f5560efd79b upstream.

usb6fire_control_input_vol_put() stores the analog capture volume
as a signed offset in rt->input_vol[] (-15..+15), but it compares
the cached value against the user-visible mixer value (0..30)
before subtracting 15.

This mixes two domains in the change detection path. Since the
runtime is zero-initialized, the visible default is 15; writing 0
right after probe is ignored, while writing 15 is reported as a
change even though the cached value remains 0.

Normalize the user value before comparing it with the cached offset.

Fixes: 06bb4e743501 ("ALSA: snd-usb-6fire: add analog input volume control")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260416-alsa-6fire-input-volume-change-detection-v1-1-ec78299168df@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/control.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/usb/6fire/control.c
+++ b/sound/usb/6fire/control.c
@@ -290,15 +290,17 @@ static int usb6fire_control_input_vol_pu
 		struct snd_ctl_elem_value *ucontrol)
 {
 	struct control_runtime *rt = snd_kcontrol_chip(kcontrol);
+	int vol0 = ucontrol->value.integer.value[0] - 15;
+	int vol1 = ucontrol->value.integer.value[1] - 15;
 	int changed = 0;
 
-	if (rt->input_vol[0] != ucontrol->value.integer.value[0]) {
-		rt->input_vol[0] = ucontrol->value.integer.value[0] - 15;
+	if (rt->input_vol[0] != vol0) {
+		rt->input_vol[0] = vol0;
 		rt->ivol_updated &= ~(1 << 0);
 		changed = 1;
 	}
-	if (rt->input_vol[1] != ucontrol->value.integer.value[1]) {
-		rt->input_vol[1] = ucontrol->value.integer.value[1] - 15;
+	if (rt->input_vol[1] != vol1) {
+		rt->input_vol[1] = vol1;
 		rt->ivol_updated &= ~(1 << 1);
 		changed = 1;
 	}



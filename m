Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEED17C220;
	Fri, 15 May 2026 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860746; cv=none; b=TjrZVvz5GVyCK1C6JHSke0W2csehuUNQ+qUPykYxf3jcQd2uaXaGnIHuIOBnKJqjHmkvxA2DwZDIjWG0mDFPbefZVCAW8AYQE6yXxMUOBgWTKEZSyadnp3C3No2ruHCB/WsZiO69Llc7fLvJR28CdkWux8mt8RO0iakTPX5LWzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860746; c=relaxed/simple;
	bh=0V97S2SmNu9bBzNPhAMix1UCDp8PbyCipe/fyYAU7RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmK2hd9QXiVzsRgbI80rfvynxR69Rk+l/JDpblsLbxFr8ClHY4S7HxJHWnJZtrZvv83x5NGu+bB8qv/ZelSJYH+vxJxuBb7pIQ1b1j4FhDZjLdUCqH7Cohx4eI8ddLvCmYLzGdAP6aNdG41MJ9UvsxgCzwT5yXV0lqS+qvuOBmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBJuxFFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBJuxFFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A63C2BCB0;
	Fri, 15 May 2026 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860746;
	bh=0V97S2SmNu9bBzNPhAMix1UCDp8PbyCipe/fyYAU7RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBJuxFFnFn7lFKMpkoWPBZw06UgQe4/fdknSEnaAoVolBFAZ7x/HtowRtxBgJ6sx7
	 /D7tJ2Dd5W5mTJiOGlPiiP2B3QuM0fBeDXon2RL/vGFNCVLNJT/GROAaeHqvI7xUZ6
	 Rk9/pTgiMsVCst4mk2ba4cvxt3I9ftNxRY9LpBVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 061/474] ALSA: 6fire: Fix input volume change detection
Date: Fri, 15 May 2026 17:42:50 +0200
Message-ID: <20260515154716.363861136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



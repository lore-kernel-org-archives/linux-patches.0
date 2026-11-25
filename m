Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625216;
	b=jTYCjHJdKxr9EBx64i6P9YWpFIVmJjpCAHR4CD26aKJcNY99WMRgMd3JtwQ7jfLS7pAB
	 RQf1/h0nYEl2/nx4QjkMjWrHbgDWvoYl3TnR6O3Bx7aBNc7/tGxQwKNGOAJ+XljKSugHh
	 cRJLv6W+rHvS9RXo9T+kDe7Dc7deeosMYg3g8/yIwPC9lKBKi9l2oiGXUv4FkX9B6+KIw
	 jH/9+Ezv0/MxQbqQC8xJQZl8lXz3EXyYGOj4+YflOeBD6D0TqT/CPIPjIGXdK/LSMECfh
	 tSK4qfyPlmN01dSH3wT6AIFyqJfPe7Z1QcgmFsmdF4xXfraSZmdNEYKI9SosbzStxEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PybEl2b8Vfhp50SqWs71TNWX3blLe9F2ntJFc3GARlc=;
	b=0ytVvIeIQxNHb1y1kWZbma2BPXUOYHYaJSuUx1JOJUvZBcT2sGRZRCbzuBuWcuglPJEd
	 ivRFdkJHfCX+w9Mqty2Mq83BWicRL30Kdnz8WyoGZvL1bff+KEfGNnYPRrf/YSpxbPRlk
	 J6VdPhwwi/96proeDsM9M7iP/lb+aWoCLFyi6pmV6yZHbqgNNICsidd7/IIp2i1Y6TEFq
	 1oR3MN2Dt+RSC0giLqClTUQX+wo3ic+cl+V0W6mOZ4ndhF0444uo57/NpQ1ykB7RWca8y
	 pcFDpl9eIBBScplcNfoIGoD/eF8z5qCVblWyYwS7nh7LiBENYpoT3HF2nj1I4wez0Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3P8B5LW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D2A606A323;
	Wed, 25 Nov 2026 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3P8B5LW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790181F000C4;
	Wed, 25 Nov 2026 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625216;
	bh=PybEl2b8Vfhp50SqWs71TNWX3blLe9F2ntJFc3GARlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3P8B5LWfW/AjmP4keKXqwHtZxdPPZPNdIKocZlgxXGMVEp08kHj17R4UQcXrn6AG
	 jBvOnOFp+CQxdadYD7ZxD4aI0J6K9bTjM6GngquP5imlUviZSw8jkVHFUWa684/CoN
	 +XZ8KdFLJVQRyZhsYvSvT3fGlB3uk0Pmyqt/QkSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zipdox <zipdox@zipdox.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/816] ALSA: usb-audio: Fix UAC2 mixer unit request handling
Date: Wed, 25 Nov 2026 15:33:12 +0100
Message-ID: <20261125143859.469678161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0458d97859840506c3688a963dcd4f72b4a23083 ]

For a request for a Mixer Unit on UAC2 (also UAC3), the wValue is
different from UAC1 and an incompatible value must be passed.
Namely, UAC1 takes a word consisting of 1-based input channel in the
high byte and 1-based output channel in the low byte.
Meanwhile, UAC2/3 takes UAC2_MU_MIXER in the high byte and a MCN
(0-based bit position of input/output channels) in the low byte.
The current driver implementation blindly assumes the UAC1 way, hence
it would cause a firmware error.

This patch attempts to implement the conversion to UAC2 MCN at
get_ctl_value_v2() and snd_usb_mixer_set_ctl_value() for mixer units.
At the points above, the old wValue containing ICN and OCN is
converted to the corresponding MCN, and it's used as the proper
wValue.

Reported-by: Zipdox <zipdox@zipdox.net>
Closes: https://lore.kernel.org/d46fcac6-bd7e-4fc4-95e1-4e8d39f92ad3@zipdox.net
Fixes: 23caaf19b11e ("ALSA: usb-mixer: Add support for Audio Class v2.0")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930155356.348608-3-tiwai@suse.de
[ sashal: Context differs: the tail of get_ctl_value_v1() and the neighboring struct field (no get_cur_broken) are older here, but the patch hunks themselves are identical to upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 23 +++++++++++++++++++++++
 sound/usb/mixer.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index ae311c95ac023..394d3f1193838 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -340,6 +340,17 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request,
 	return err;
 }
 
+/* convert the given UAC1 wValue (ICN|OCN) to UAC2 MCN */
+static unsigned char to_mcn(const struct usb_mixer_elem_info *cval,
+			    unsigned int validx)
+{
+	unsigned char m = (validx >> 8) & 0xff; /* 1-based input channel */
+	unsigned char v = validx & 0xff; /* 1-based output channel */
+
+	/* num_inputs * num_outputs is guaranteed to be < 256 */
+	return (m - 1) * cval->num_outputs + (v - 1);
+}
+
 static int get_ctl_value_v2(struct usb_mixer_elem_info *cval, int request,
 			    int validx, int *value_ret)
 {
@@ -352,6 +363,10 @@ static int get_ctl_value_v2(struct usb_mixer_elem_info *cval, int request,
 
 	val_size = uac2_ctl_value_size(cval->val_type);
 
+	/* correct wValue for UAC2 mixer control with MCN */
+	if (cval->v2_mixer)
+		validx = (UAC2_MU_MIXER << 8) | to_mcn(cval, validx);
+
 	if (request == UAC_GET_CUR) {
 		bRequest = UAC2_CS_CUR;
 		size = val_size;
@@ -476,6 +491,10 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 		}
 
 		request = UAC2_CS_CUR;
+
+		/* correct wValue for UAC2 mixer control with MCN */
+		if (cval->v2_mixer)
+			validx = (UAC2_MU_MIXER << 8) | to_mcn(cval, validx);
 	}
 
 	value_set = convert_bytes_value(cval, value_set);
@@ -2208,6 +2227,10 @@ static void build_mixer_unit_ctl(struct mixer_build *state,
 
 	snd_usb_mixer_elem_init_std(&cval->head, state->mixer, unitid);
 	cval->control = in_ch + 1; /* based on 1 */
+	if (state->mixer->protocol == UAC_VERSION_2 ||
+	    state->mixer->protocol == UAC_VERSION_3)
+		cval->v2_mixer = true;
+	cval->num_outputs = num_outs;
 	cval->val_type = USB_MIXER_S16;
 	for (i = 0; i < num_outs; i++) {
 		__u8 *c = uac_mixer_unit_bmControls(desc, state->mixer->protocol);
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 8e5e8da6d480f..00ffefb751d2a 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -97,6 +97,8 @@ struct usb_mixer_elem_info {
 	int cache_val[MAX_CHANNELS];
 	u8 initialized;
 	u8 min_mute;
+	u8 num_outputs;
+	bool v2_mixer;
 	void *private_data;
 };
 
-- 
2.53.0




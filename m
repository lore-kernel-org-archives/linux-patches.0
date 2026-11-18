Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017948;
	b=xCCMSYzeo8P+XiPafHpYP8vildNT5CEN8VkRBka1rOB5ufkWgABrHuEFD5elFUo7jLaH
	 1nQxIkhiseljl8IaGLPo5d/qBvlNIqIUyNLKQSxtM8r0JyQ5sv2W6xyfSWBZppeHUd75+
	 qEN+pPtLRs1Lw2dMJ8MhtbiE/DbvmGTQPV/16uIDJssARHQdamd4xbkUmj5/plOMw/BW1
	 VRykhBMgBIGUjBPUBjIXWKQjMwyF+BQto43ksOklr+E6pEw38Lwxp13AqrECl2GRPbIpZ
	 d+kq5RQFXWsoszvSdyelNlM7LHX+Cm0/Y2o/GM3sU9UgXPV5Pw2DbfeNPpMgkMnHdDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rDVt/WPhCfveUXWXQiiFGboReNBvaSxgjUAw2EhYhc4=;
	b=4y76OuwNbyZaqrqnM/ZI0hMDNJT+4J/8EwbzIrcqawm2lHTKlUA99168gGfphQMcYhKH
	 3HEBY0CcaY2gnwJxKOdWGZE98ueMub298r5LNfZLB+yZrBfOxJ7xnabBA3FCV4SDIIqHO
	 9XAdV9no7AeNNefmK6//eByPFg8CPTmTqP34zwcg6JLyo4kxwUZD4y06i3f/yi0UarfON
	 6ZAoUyO/P/CupB1wdtShuq+Xcv9XpjH3B+haEArNzZ38qY21a0EfvxdYveseBN2ykVyYo
	 a4Zrrt1T2QebHFrB8mYk/iQhpcUfoDD2hgAQHIyenH3tEAt1qlgMKjTm5dLD/iYCPzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJTkYEtO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAE9606A31C;
	Wed, 18 Nov 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJTkYEtO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D571F000C4;
	Wed, 18 Nov 2026 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017948;
	bh=rDVt/WPhCfveUXWXQiiFGboReNBvaSxgjUAw2EhYhc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJTkYEtOq6KEsHM4k6b5UOr9od+la7Mzgls4fW9IBWCO+wyQ+P7JQTJNGg8iWbS/L
	 /5QErt26WwweG6P/vJlEPm7VhCplD1sSi8+IU8srYjHyG2SG4sAnOXaG1lNyQdrgcY
	 gFI1PoKx1hc75kPHrFatZ3lQClxsEMcuYbytrJCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zipdox <zipdox@zipdox.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1066/2651] ALSA: usb-audio: Fix UAC2 mixer unit request handling
Date: Wed, 18 Nov 2026 15:38:26 +0100
Message-ID: <20261118150326.356675011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 23 +++++++++++++++++++++++
 sound/usb/mixer.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index ecaa8bc08d7ca..d78314939be13 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -335,6 +335,17 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request,
 	return -EINVAL;
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
@@ -347,6 +358,10 @@ static int get_ctl_value_v2(struct usb_mixer_elem_info *cval, int request,
 
 	val_size = uac2_ctl_value_size(cval->val_type);
 
+	/* correct wValue for UAC2 mixer control with MCN */
+	if (cval->v2_mixer)
+		validx = (UAC2_MU_MIXER << 8) | to_mcn(cval, validx);
+
 	if (request == UAC_GET_CUR) {
 		bRequest = UAC2_CS_CUR;
 		size = val_size;
@@ -478,6 +493,10 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 		}
 
 		request = UAC2_CS_CUR;
+
+		/* correct wValue for UAC2 mixer control with MCN */
+		if (cval->v2_mixer)
+			validx = (UAC2_MU_MIXER << 8) | to_mcn(cval, validx);
 	}
 
 	value_set = convert_bytes_value(cval, value_set);
@@ -2345,6 +2364,10 @@ static void build_mixer_unit_ctl(struct mixer_build *state,
 
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
index 037b446d8b6f5..cf45c39cbccc5 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -97,6 +97,8 @@ struct usb_mixer_elem_info {
 	u8 initialized;
 	u8 min_mute;
 	u8 get_cur_broken;
+	u8 num_outputs;
+	bool v2_mixer;
 	void *private_data;
 };
 
-- 
2.53.0




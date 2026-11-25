Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622508;
	b=Na+os0wzrzgiWYKBFJubb8jznN9pp222lleqOq4aykzpdCE0ioP9e5TcDwfLqH+FzPYy
	 mxu0X25i0fEZSa+5wQ0OTdSIzalR48melB6+ri6zdo9To5POE4/PiEyV0RL6C5HMNExuC
	 D1nt9yZ86Nqi1LJGW4t7kTUHznYYbxJtisYBbWEaZH5eRD8PZxpj6PzyOs6BGNEFQA2eJ
	 9INenRJXIwnHab8VP7ap4ZTPkWwPy9Hzw/1TtSn/T13oLShKM4G08uSY6T8A7qRuj4m0I
	 4Hm5K6v+M3fPxUzY2qpvElB1AJ2IHzm3EeHcQyy75OskkJ8bk+NVRWuZMSXW4Qm49Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jbx6jZ7wbpdesYZDfQlEal8J3xWB974SDlSuuYknrPI=;
	b=p3iCmvL0RVa+ScPkJSxSXnbL/MKGS7uKSboqqpjOeaz0aH/a49yTlhhVQLfNa1KapwWO
	 IZmsFa7lN3yU2rsl6feb1QMigAYVC7bLe6EABD1ZxdFJFUQ5tqO/TjVMP2Ctb5VChG7Xv
	 6SRi/QBMQD3e92/kas1h3rHyxWOGe0k9lbO3BGiMntLJEZZ2BRkW9r/+O4Oztj0MKMNzR
	 VVEHvs/P4pkqwuR7SnlIUvQdhcTEok7h6F44kX6IbV2t0mt4f55eIHXt1GGQworAPQ0jT
	 ab0DdDAPX/Y2MFXLbbYngf+ooGkRv7Y0tm69CXDWXMhGuOIFe6VZtVVQ8IO3her1hVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeCh+z0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F6C606A32C;
	Wed, 25 Nov 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeCh+z0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855041F000D3;
	Wed, 25 Nov 2026 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622508;
	bh=Jbx6jZ7wbpdesYZDfQlEal8J3xWB974SDlSuuYknrPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeCh+z0eQGpmV39f6yjwXq4K15V/L1QWgEdj/B9/076WMUpllJ3ZSTh+K+tAu5QPE
	 zh5Stx5UWpQUeamL+cnidpimQS5E3ybokBJt53ZFsgxJcS78Ohu+LYNr2Ja7m8rMbg
	 CwWp4QUhoSml9hSmLQn1rjhztkbiDOXbQFK+dcyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zipdox <zipdox@zipdox.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 561/990] ALSA: usb-audio: Fix UAC2 mixer unit request handling
Date: Wed, 25 Nov 2026 15:32:08 +0100
Message-ID: <20261125143835.238364259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f4e44c31111cd..e578a29a675f0 100644
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
@@ -473,6 +488,10 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 		}
 
 		request = UAC2_CS_CUR;
+
+		/* correct wValue for UAC2 mixer control with MCN */
+		if (cval->v2_mixer)
+			validx = (UAC2_MU_MIXER << 8) | to_mcn(cval, validx);
 	}
 
 	value_set = convert_bytes_value(cval, value_set);
@@ -2206,6 +2225,10 @@ static void build_mixer_unit_ctl(struct mixer_build *state,
 
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3946F33BBA0;
	Fri, 21 Nov 2025 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732918; cv=none; b=NdY40OnKfKUFKa2vD/wgKVHOe0lrsFeBsz+Zl4LYSX7sf8SyRWp9/v4JXLLB7fIQiqeqiwfmqVunh4OpaNM53vLhljtQYW/8eJFvGzYYWx7gBmGB+9/q+T/PhWXN//qjuD3m9AKiBR/TA4umZWfNIlQtVtKMDc42tR5NMu0/V4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732918; c=relaxed/simple;
	bh=0RdBLBRIyeBHfXhNeFAPyJFSat1EMR6qWUeNo2p9780=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZJeYhZJuVKzf+t3EIuOYbYc0AYLqH5vQNFzsTKkAsbAdzDO0yd0ZHJSWV5nE2OJAi5eeTXlipyhadJu+HRhoEBb6gXg13GS1RRx5lF4jcGeuGPWPHLW6uX3cs8PLWW9CegCArXtgCVruQmcyKcdLFIzztzjoGwqnet2anvpQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsvaSSTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsvaSSTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B648DC4CEF1;
	Fri, 21 Nov 2025 13:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732918;
	bh=0RdBLBRIyeBHfXhNeFAPyJFSat1EMR6qWUeNo2p9780=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsvaSSThGmCRhb9s6rqGbGUiwzpDm1hjrRd+eH5kfetPQzPcITase/dRKAZJ83jbx
	 JXIOLTkz2vgj35YctryLss3Q3cJQf1A07ByYIuAYMFXIXZYQBd0BTwHkIajPlpx2RL
	 ZyJupevFmt3ei4KLJouj8sfNnw1AH1ZZV7eavppQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/529] ALSA: usb-audio: add mono main switch to Presonus S1824c
Date: Fri, 21 Nov 2025 14:09:48 +0100
Message-ID: <20251121130241.311711125@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit 659169c4eb21f8d9646044a4f4e1bc314f6f9d0c ]

The 1824c does not have the A/B switch that the 1810c has,
but instead it has a mono main switch that sums the two
main output channels to mono.

Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_s1810c.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index 65bdda0841048..2413a6d96971c 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -93,6 +93,7 @@ struct s1810c_ctl_packet {
 
 #define SC1810C_CTL_LINE_SW	0
 #define SC1810C_CTL_MUTE_SW	1
+#define SC1824C_CTL_MONO_SW	2
 #define SC1810C_CTL_AB_SW	3
 #define SC1810C_CTL_48V_SW	4
 
@@ -123,6 +124,7 @@ struct s1810c_state_packet {
 #define SC1810C_STATE_48V_SW	58
 #define SC1810C_STATE_LINE_SW	59
 #define SC1810C_STATE_MUTE_SW	60
+#define SC1824C_STATE_MONO_SW	61
 #define SC1810C_STATE_AB_SW	62
 
 struct s1810_mixer_state {
@@ -502,6 +504,15 @@ static const struct snd_kcontrol_new snd_s1810c_mute_sw = {
 	.private_value = (SC1810C_STATE_MUTE_SW | SC1810C_CTL_MUTE_SW << 8)
 };
 
+static const struct snd_kcontrol_new snd_s1824c_mono_sw = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "Mono Main Out Switch",
+	.info = snd_ctl_boolean_mono_info,
+	.get = snd_s1810c_switch_get,
+	.put = snd_s1810c_switch_set,
+	.private_value = (SC1824C_STATE_MONO_SW | SC1824C_CTL_MONO_SW << 8)
+};
+
 static const struct snd_kcontrol_new snd_s1810c_48v_sw = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "48V Phantom Power On Mic Inputs Switch",
@@ -588,8 +599,17 @@ int snd_sc1810_init_mixer(struct usb_mixer_interface *mixer)
 	if (ret < 0)
 		return ret;
 
-	ret = snd_s1810c_switch_init(mixer, &snd_s1810c_ab_sw);
-	if (ret < 0)
-		return ret;
+	// The 1824c has a Mono Main switch instead of a
+	// A/B select switch.
+	if (mixer->chip->usb_id == USB_ID(0x194f, 0x010d)) {
+		ret = snd_s1810c_switch_init(mixer, &snd_s1824c_mono_sw);
+		if (ret < 0)
+			return ret;
+	} else if (mixer->chip->usb_id == USB_ID(0x194f, 0x010c)) {
+		ret = snd_s1810c_switch_init(mixer, &snd_s1810c_ab_sw);
+		if (ret < 0)
+			return ret;
+	}
+
 	return ret;
 }
-- 
2.51.0




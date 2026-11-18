Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055931;
	b=MpJzb9+H3hv1lTPi3S44455EIeUMk4NSzYCFbeZ1dqP8skqXTK68X7nXkzCMy8VSx1e+
	 RuL60RNN2LBchDc3HINxn5N1UBh0RRj3msRaX12lMVfK8W8+kCuSZwZty9iLA2QEbAIGQ
	 K6Q1tuURmrp3lBTdYmuYyzAc3ML2r4cmH9g7fzXP+ag/XJvetDl0X0T6xTt9zIngf60vE
	 aADfnWYgiW3OdF48kRUjbJokX2lE+BpZw8bKHspf87+0Mj/Ot7TEyUsRizQRQI4X3a4YJ
	 gX6pWnwAtiZFfMxoWRjrLhCgDLUUl7ARP8j6c/FjBAB1BznmnP0CJC4HfCzZ5v8XyLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33omYE5NAlwWg5rs6IEpBpWfdb+49qEFZaTqxcad3N8=;
	b=FsjV3hZzcwotF/mq3i0el4rcNYAyKCUKGoeVAx0CS2gea0xNsym1goIFgAVUIwAELPUl
	 qqHuHzI3r6ClCdE0R2FDslWymLPjk7Vg9nR3sOSMZubECOuZol4G7W8aGI6u4o4hGTJLq
	 RHxBoZjl75RhgdXH9x82JH1NlkJ789LnKzXV+/2QFU33FWtHfqV6qcccMydTChvAE6aw0
	 EmHLVrBgr+5CXRT+NF7kdvbMgsYcOLpy3/ZLbek/MPgLEWUrXcmgoGbLA0c5DfkE/5oS/
	 cRiq3e+DyFbW7vPR0iO/MKZYaQB5u57F0nH44Hf04/atRWJNse9/BQySqXY4HEKafHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOQYdDuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876BA606A320;
	Thu, 19 Nov 2026 02:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOQYdDuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA451F000C4;
	Thu, 19 Nov 2026 02:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055931;
	bh=33omYE5NAlwWg5rs6IEpBpWfdb+49qEFZaTqxcad3N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOQYdDuH7WycpEpzgIsd+OvE2SlO+SHnpoRpGj6Bc26hv8fUOCEiLI0i7oAfC6R9Q
	 8QYG1qwS9JxfmExUK2ysAbAvnySSoFM953om8qgfb8SYyQc29xlvPGExRgl6o+dwtN
	 tgd5E8ZsxHtFLkRlmGhwlYLjZU3385eikaWjquO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1806/2214] ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150123.738612071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 22185ffd7b31885d03fdeb20055a8707779a70f9 ]

The matrix of input/output channels specified in a UAC2/3 mixer unit
must fit to the upper limit 256.  Add a sanity check and returns an
error if an invalid size is detected.

Link: https://lore.kernel.org/d46fcac6-bd7e-4fc4-95e1-4e8d39f92ad3@zipdox.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930155356.348608-2-tiwai@suse.de
Stable-dep-of: c01fb2ed90c0 ("ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index fdd3efd297c2b..f8074bed378d8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2269,6 +2269,16 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 	num_outs = err;
 	input_pins = desc->bNrInPins;
 
+	if (state->mixer->protocol == UAC_VERSION_2 ||
+	    state->mixer->protocol == UAC_VERSION_3) {
+		if (input_pins * num_outs > 256) {
+			usb_audio_err(state->chip,
+				      "invalid channels for MIXER UNIT %d: input=%d, output=%d\n",
+				      unitid, input_pins, num_outs);
+			return -EINVAL;
+		}
+	}
+
 	num_ins = 0;
 	ich = 0;
 	for (pin = 0; pin < input_pins; pin++) {
-- 
2.53.0




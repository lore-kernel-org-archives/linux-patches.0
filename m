Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041084;
	b=SOapiu0BdO+yUctFvr0HZrxMs7ntnusQAynQ1H2futa8ftOZukJyhVbhtzb/t4Je1u6e
	 eyUze1sOPAhGrv5JEf4w0nOnEj17NnpzXJDN068zX+l8rkxT2jDndy8zLnOA31gULTEd5
	 K/EaDdXfN4+sNybIg8ELvcze3UXpHNgvTGdwiRmXG7/BbpwxqsuDYN63Z4Iv0TyjnTO8v
	 B4mz4Pw9A6jIn6uHBKKJ8WH0UauU4TnqkHOOfQfqaTsXyHeGJiE8BSLhPOdcsg+dHQxbH
	 ucAiMpdA1ymnXHZbud9cuEpQnP168HuFPRdhPfex4uGvsnaYN66zRlqTK49+WlEHdjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dXCLUDPDA6d/gGoMU++0buiPiKq+AZSVKmmg0WkUuGY=;
	b=NINr0xUnRvUCt7VtFJHko2aWQobZN8iOy/0c9je130y6y/uFGpklOftZc+0II12JZLLP
	 PtEmGHXePvfsPCTWPE1Rfg/ZfuOfBygfuS85q2KpTzp25tyuPu6ZUPiAMcn/yLoLIRZAU
	 dqPfyIYMIYhT8r+v82wzR+r6JpDD9bpDYSv6FiY3KURzbhUMaY6WLCf08DEcNnpFgOIXN
	 yS61zcLT/0WhayjmNuJUlDrOEJ6DX9R2qCmDAJHse61RWRWoAxhrpyFEuEhWJ748iH053
	 e0kkFg06bhv4rDQCpFqdmfcGHhSVJi2sMjIWTFW3dETeSSsCkdNzBvsBZP95YH8FbXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWIQoJBH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B90A606A31C;
	Wed, 18 Nov 2026 22:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWIQoJBH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FC21F000C4;
	Wed, 18 Nov 2026 22:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041084;
	bh=dXCLUDPDA6d/gGoMU++0buiPiKq+AZSVKmmg0WkUuGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWIQoJBHmcAMgtoL6zzc0un35T9InujQY8pPSsD8DrKYYaxIUhZtLSbgIq7aplATL
	 RyPojbg/yNdXPqLsacBGp6XCaf+pi2crrFC0iBC+6zXZUsIyBzjiEEZ6WickwCfZSb
	 7LnU8qTybM1x952Eyk2QTflM6iC3Q0l5eU/ckq4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2688/3318] ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing
Date: Wed, 18 Nov 2026 15:55:10 +0100
Message-ID: <20261118150441.603484318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e70853cfec65a..5f0a122fde8c9 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2284,6 +2284,16 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
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




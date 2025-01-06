Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7221547D8;
	Mon,  6 Jan 2025 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178608; cv=none; b=A+/9S2mUUhT3tdci7JXpJKkLGCZlc4UfbfiY1MLURSqbM1zBOycpieBrB5NtsGCpyX9aQqO2BcdiJJ2l0lMQw8Mhw3TRNkdNvP/pVHkwZ1xc8KbberNqa6VoVvm4u1KKZro59h+gnl6zeaDiifq5gBufGpNvZHW2U3Fyo0aNLok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178608; c=relaxed/simple;
	bh=dupQLWxS8wMuvLr+2vmlaA/k/zd0POGCGxMMkxO7SUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpXv6R6S/mS1Nkuf0pYUqv8JLY/IM8ZNcycQI313+xA09j11P8GZjzESk2dw9GmcvNNq8eTS7P5fmNak9Yl2quTlvGLm1IeF40aKhX9fthz6N8vBOrI4yjFIfZen8auDajdIqQSsM8Va/0k/w6spgj/QOn3lNOH8MuLW1S4fAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q10I470+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q10I470+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A11C4CED6;
	Mon,  6 Jan 2025 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178607;
	bh=dupQLWxS8wMuvLr+2vmlaA/k/zd0POGCGxMMkxO7SUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q10I470+efmdmjMVeSNoUcfZ7k979/9APmhI4A6S0d6c3UirI7rwIgIo/r06Vu+Qk
	 IA+mAQ6GA8miiILLW3ZKAHDsdfnda4u9z+DwWs1XHBHUyr43CW7vRxcJtT9etkCnKX
	 EFg8WLbAWHfcScpbglSz+Oub4eke9DEQOJjQkzkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/168] ALSA: usb: Fix UBSAN warning in parse_audio_unit()
Date: Mon,  6 Jan 2025 16:15:12 +0100
Message-ID: <20250106151138.624514988@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2f38cf730caedaeacdefb7ff35b0a3c1168117f9 ]

A malformed USB descriptor may pass the lengthy mixer description with
a lot of channels, and this may overflow the 32bit integer shift
size, as caught by syzbot UBSAN test.  Although this won't cause any
real trouble, it's better to address.

This patch introduces a sanity check of the number of channels to bail
out the parsing when too many channels are found.

Reported-by: syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/0000000000000adac5061d3c7355@google.com
Link: https://patch.msgid.link/20240715123619.26612-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 4b979218d3b0..5163d5e7682e 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2008,6 +2008,13 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid,
 		bmaControls = ftr->bmaControls;
 	}
 
+	if (channels > 32) {
+		usb_audio_info(state->chip,
+			       "usbmixer: too many channels (%d) in unit %d\n",
+			       channels, unitid);
+		return -EINVAL;
+	}
+
 	/* parse the source unit */
 	err = parse_audio_unit(state, hdr->bSourceID);
 	if (err < 0)
-- 
2.39.5




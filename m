Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37755DF71;
	Mon,  6 Jan 2025 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178147; cv=none; b=e0WmQFE3q3VWK+PgDXtn4P+585qUoMEK1aaIk32EnSTE/6FW3JzwoF0PnM737F0C7ZpisKjejHt36WVAsvIwRi35BOUXDaRbkNdSxf6sLPA3vXrPsOPSHrsvemlKnp5vRb7qDO61o0EARnuCpmfc17DAs8/UwAZe80fUPIRKfSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178147; c=relaxed/simple;
	bh=K4TGMIsv+cWqiJ41RI/UU/3cmictd4LwG/gCFJxfAU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZILmf+Vf8ZnBQshmwBRexmcy/gwL5pilUGhXmf2hbD9rpv37401spmkr0x/C+DnrlTEGVsAIv7ia5urdZc33o9Gq38DkkjiGtNxp7EInc//sCd61IOOYfZBgc0JlrvT/nZZKcTC9PNxTJTTlnc35GKnbq2DUiJxTn4eb5IDzU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unJzpuP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unJzpuP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA418C4CED2;
	Mon,  6 Jan 2025 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178147;
	bh=K4TGMIsv+cWqiJ41RI/UU/3cmictd4LwG/gCFJxfAU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unJzpuP2UX66KbNIeRtv6PtGy2K3g0vBObE62NN9HlSvC+s2RmbzeZe/nkDcMkrDk
	 yNcmo9MBTX/skS2zWOLiNqucc/aJW1dUgKA+Odpe1wLf+oqS1jzLGza54egp5HuyX0
	 zdKpbY+xHraYv4pnFM8sTZY5RsJcmNsC+VxvdFTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/138] ALSA: usb: Fix UBSAN warning in parse_audio_unit()
Date: Mon,  6 Jan 2025 16:15:29 +0100
Message-ID: <20250106151133.420207184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b598f8f0d06e..8826a588f5ab 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1932,6 +1932,13 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid,
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




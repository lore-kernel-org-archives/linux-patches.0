Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA871C6F57;
	Tue, 27 Aug 2024 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771993; cv=none; b=EGK4W694N8VgfQLWzqV0w8enl3l2htKdpyPyzuxD2m0f4Bzn8xBK1Ymf1hxSOrgNf1bEAkzUU4+0I3UWAo5TzdA4MFk8XUwT0U7P4OFo5lbYDR8eviIpAgNpwHS4B91QhYwQSjgR004EEzfAYDZXn1PvtsSwU7Ssw7bswaCKln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771993; c=relaxed/simple;
	bh=8ZzSPe2TO7gef9dilcwWUdG8VYyhP7jpKQozaR3+ba8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8NQ6gT00+kFBKflfc46hYzLlK1DjG4fNr6sf2xkAfPdPnwwJa9jZlfxfmPHz1i+ri06EFkZWm1I6jUYn+nDZHL5RCbP6xAvfQTILcQH5aF1/Mi9NCb1QTyc3SFxS0dr7WsQWjkhzMOouzEo/ZZatot0W14CCFSml+K3IMNMV08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkECqmHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkECqmHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C3CC4DDE8;
	Tue, 27 Aug 2024 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771993;
	bh=8ZzSPe2TO7gef9dilcwWUdG8VYyhP7jpKQozaR3+ba8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkECqmHSthLhkm0Iqe/flPnzTI/GHPPv5G+g9SIqqAp+PA6TqQX34PPCTzN4FwyAm
	 YoYk5d9oCfrx2EAju9Tqg6Dq8PpHNKpGdxtDR6elqIK9Mc3S+3RSMda6UF7olWNoYt
	 eBJF2e7pIt3ZgWasRUSkgxMGoCQjbke2znIDB3iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/321] ALSA: usb: Fix UBSAN warning in parse_audio_unit()
Date: Tue, 27 Aug 2024 16:36:30 +0200
Message-ID: <20240827143841.362564845@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5699a62d17679..34ded71cb8077 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2023,6 +2023,13 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid,
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
2.43.0




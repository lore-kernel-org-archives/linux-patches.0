Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7BD1A01DA;
	Thu, 15 Aug 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731048; cv=none; b=qqPCYASMhcoswjZ0njbS5Gt5MIZ5br9OF0ejAFXth4tILR5tIJ3RlkGUnqyTdqbome1g/1jiOtvbb17P12Y3WoAdXtiD9SqAORewcSzK8Mmfk2qMcz1rHGETaDQ1PopoLy+k0FNX5gjPYummWv/O2HxA3SkNGS9B4h3hd2N8yms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731048; c=relaxed/simple;
	bh=4x0JCUKFtqgfLa2PVd7H5vRc/ZMW4gZ7s4tHo9F4hqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7hGQtYqY4VjorSlLB5J1wpYRrKo0+swn4xR02JNoiAfmL+zUvYJ2Jyu/w+3KSqXu/mYlRoHfP52kJimfl25L5DeWhP3LlaJ/6FsRs9Vq+qVjgas+KH5/uSK9tJUc1+kk1iDPkCuqmJT6QNkBEdIzm/3Z/3jW/emEN7yaEFAkK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNEmRCIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNEmRCIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601A5C32786;
	Thu, 15 Aug 2024 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731047;
	bh=4x0JCUKFtqgfLa2PVd7H5vRc/ZMW4gZ7s4tHo9F4hqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNEmRCIf/3mf619veDDK4DCJZ3Ghw7b0SqM+BMJEanJQIXkek+kiwQb4Bw+Y+cbjh
	 e7Sbh9v6jO5W7Zsj6+LWPk9hyqzhmDlPyRas497jwMCg8pG4FvU2myCDPOTR9vZ1W4
	 ylZLZmqzSm2fN2aUiOHENN91d42siV7JGuhIUA20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/67] ALSA: usb: Fix UBSAN warning in parse_audio_unit()
Date: Thu, 15 Aug 2024 15:26:14 +0200
Message-ID: <20240815131840.604840529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d1bdb0b93bda0..8cc2d4937f340 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2021,6 +2021,13 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid,
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




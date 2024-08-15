Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C001714AE;
	Thu, 15 Aug 2024 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729102; cv=none; b=INbbua1P3sSnWXScdCVa3f7qTzx8M1pgPaKb7FHIuUdZjyWC+KGfXKcI/K697WXNga4s4nj5nR2DaUbUeEhKMzT6d9FeMoq+gYiyYExxs5pcoJktvD9VBDivgfjviZA0bUp7BzOyYUUxtnGPsgn15UehBmAIgErWDbH03fIsT0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729102; c=relaxed/simple;
	bh=JFPfok3B3GbIxeAV2CQYXSg85p0Na7/wXv4FnjAT/Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAzWBshdd0T8oP1GZTiVfJLEylT41ODCXIdPJCHMgTBXzFLtshyWWiwtpOT4L2/tDxSY5r3l6igdkXZPdMFTC6/h/KfqNUNwY0rT6wjyDt0IJiAms6e7lTxrRj5BxskDcwgMUEJe5+Z5O7TnT8WRl9MEa/PbP25ywA49b9wxhfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocRMz2vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocRMz2vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4586EC32786;
	Thu, 15 Aug 2024 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729102;
	bh=JFPfok3B3GbIxeAV2CQYXSg85p0Na7/wXv4FnjAT/Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocRMz2vxle0e+pM96CZ6lWye2Fxbd7grA8lE/gagwVJcoAmxN3v11zZb7WslZIPLM
	 O5xTywQhVQEXog2O9h3oncETYmRqD1xWiZ/6EYJE6CC75VPv1ULpCMZ37WEHuszbhB
	 B2RTNZUt3Ma5tt4uTbZ9kecLUfz3zKhpA0Q27b2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 15/22] ALSA: usb: Fix UBSAN warning in parse_audio_unit()
Date: Thu, 15 Aug 2024 15:25:23 +0200
Message-ID: <20240815131831.848225473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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




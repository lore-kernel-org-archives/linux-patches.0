Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D06B39FCE;
	Mon,  6 Jan 2025 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179063; cv=none; b=VXRXZeuS4jVozdBxV2s9dCPVEoPRFPQEYObHi7JoxpDqdybsX76HXCk75RI9N6s2LiWneZHO8Uj04EOx5tW848UaGb6uuEZLbE2ughzfI6koBmIEDM0lFTp4OSOF2G6pjf4oqfLB9A6TDp4XUHakKPyFQoqDkDkHmuE6bHqNMMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179063; c=relaxed/simple;
	bh=IEyQ/Nlarfn0CsPD0M/hS2svVSyTQyz7CXBiVsg0CLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXfomCwVjstvFflC0mbjiNbBGY8Pp5PfLpmbXPm/EelvD+VUOLuLU7enpwyPLmeqMa9Z8VmtO9I2d3XuQHUtrdvT4MmaT5WKcVPdS4ML5ZG41dUbwdCYEOeBCi0Nk8EcUg06DUR9q/OUJdMfwHFmd/oQBDuhf5Ns9bK79XRg5KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSn8CmAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSn8CmAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DA0C4CED2;
	Mon,  6 Jan 2025 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179063;
	bh=IEyQ/Nlarfn0CsPD0M/hS2svVSyTQyz7CXBiVsg0CLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSn8CmAOtPMoOfZhGMmeAbcup+9Zq810LwxUeRxXupeMg72MwUhzLHaKjNfCepQoA
	 Cmz+y/cVRyj8CzjKJsCL51J3nXyB/V6PbDV2JojMGNbyA/SRliJ4u/5gP24rDasZrJ
	 9/CrJNgDpNLHJNdG74eiEab+oE0+nR/LLL4v3/AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78d5b129a762182225aa@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/93] ALSA: usb: Fix UBSAN warning in parse_audio_unit()
Date: Mon,  6 Jan 2025 16:16:40 +0100
Message-ID: <20250106151128.859381672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 67eb1293fa15..1374a4e093b3 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1906,6 +1906,13 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid,
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




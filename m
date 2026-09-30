Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6323CB8F1;
	Wed, 30 Sep 2026 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785297; cv=none; b=Wix+aJOci6oMLwUcTdsNXpn6MkT9lDqc2BWDX9DstplBcluSmMuJNJABm3RLNGnJf7vG7oAK9wAoc1I+ru43Xs3Qew7d0hl4/232CUK6F/xiiLIh/tLOh99/EhKmHSfWPR9gLma74Sronbz5btp0EGXVvGbcQntR1fZ4rM0pA0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785297; c=relaxed/simple;
	bh=BCFjiuF8mO8Ws1cAE4IvFk4+Las+R7lsKP4qifVY2co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx1QbksFDC919PGUUdjKkQPVuq53CPxGNolZnnkZqOnYnRBS/IjUBLJPSSNCdQvxOvlAgaLxObBjDrQVvDiI7dR8qhTVo2jN5dMncZfuztK4KW5ftpKlxjOVvmpClrDu2FVuA2mVSfjQVBxNZie1zD262gvJdFiInMxY9swe3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13JSQejN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13JSQejN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959ED1F000FF;
	Wed, 30 Sep 2026 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785288;
	bh=T/gMCZjXoARVuyB7wd5mpqVpucRG/MbpYpfqJBGEx9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13JSQejNmRXrtFL1AU7w09BWgTng851SXW+/jX1Bm9VEzoENhbMwc4wT1H58BZ5Y6
	 jdqS1vBI+yNTcu1lzXxBZaWo5I6YMbhhR6RfXWncejnCR9r+KFrhp4i85nkBQNJaw8
	 PZtLy4AJNcyndDDn21MnXKTFsvlDHNkoHZ6JxWsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 457/982] ALSA: hda: Report a change when only the channel status bytes move
Date: Wed, 30 Sep 2026 17:19:53 +0200
Message-ID: <20260930152426.605159658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 7284788743121ec8bed556b00f830dc52ad9955d ]

The put() callback of "IEC958 Playback Default" returns whether the
converted register value moved. The convert_from_spdif_status() helper
reads part of the first two channel status bytes and none of the last
two, while the get() callback returns all four. So a write that lands
only in the bits it does not read changes what userspace reads back and
reports no change. Of the 31 bits above the mode bit, 20 are such bits
in consumer mode and 29 in professional mode. The core notifies only on
a positive return.

Toggling status[2] bit 0 on an HDA HDMI codec moves the read-back from
04 00 00 00 to 04 00 01 00 with no event. Toggling the non-audio bit
in status[0] gives one.

Compare the stored status as well, the way the ac97 code does. The
write to the codec stays gated on the converted value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Link: https://patch.msgid.link/20260908134153.1614273-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 600714881335b..b715a6c366a8c 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2315,6 +2315,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	int idx = kcontrol->private_value;
 	struct hda_spdif_out *spdif;
 	hda_nid_t nid;
+	unsigned int old_status;
 	unsigned short val;
 	int change;
 
@@ -2323,6 +2324,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	guard(mutex)(&codec->spdif_mutex);
 	spdif = snd_array_elem(&codec->spdif_out, idx);
 	nid = spdif->nid;
+	old_status = spdif->status;
 	spdif->status = ucontrol->value.iec958.status[0] |
 		((unsigned int)ucontrol->value.iec958.status[1] << 8) |
 		((unsigned int)ucontrol->value.iec958.status[2] << 16) |
@@ -2333,7 +2335,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	spdif->ctls = val;
 	if (change && nid != (u16)-1)
 		set_dig_out_convert(codec, nid, val & 0xff, (val >> 8) & 0xff);
-	return change;
+	return change || spdif->status != old_status;
 }
 
 #define snd_hda_spdif_out_switch_info	snd_ctl_boolean_mono_info
-- 
2.53.0




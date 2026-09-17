Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4652528451;
	Thu, 17 Sep 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665954; cv=none; b=Yp4Z3ng/mnDakR7ZUKcAhHR1WhqeSMpVFWXM9Hjqx0ZJJNIlBdAa3kERE0EGH5HowJHe4wiCo5J7J5fgaIN5wysP32/qUHFnW9H8d0wynqlBPkB2mdMybZtBbAyMmoVGaqsd8Zc7vqyLNvLKwtZStPBqDH4N5JfZsH3+xGw+pDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665954; c=relaxed/simple;
	bh=B5CAy8VXn1iaKv2YBjZM25if+1scwI25V3HvdIJ9UyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk/EdPY5vduakiL+LENTXhwsmYyLmSrVdK5EoGZL7Xt5g+CD52byBP52YACHsl4zi4WZqdyAUqlhQLMhL71NoBxMMTArbxU0FW1PeX6kKoF8WytBlPABchQ7QB4TjHG4G9nqX1Gxzz638tA/Kz7fGyf0IP9rL+CiycKTfPEkLUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN9qO9X2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN9qO9X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B6C1F000FF;
	Thu, 17 Sep 2026 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665952;
	bh=G+Kdn6cozrEoxxYW7RFfUyQREmTlB4egCydMTqlKD7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jN9qO9X2som1uYzvqYPNnXBQHPyA9umGpUx4oHCdI6OHWETJk9DmSVfFsVoNCwGJy
	 Tam3cpq2vdlceHvX48Nxdvnh3A3fen3qBBwJA4g9lMyh8bzdzU/D4GcZkGu4XxO7cS
	 RIm1QAYMYzvAqo+CnbVIibjTVWLv/qiWg4MCQSOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0875/1250] ALSA: hda: Report a change when only the channel status bytes move
Date: Thu, 17 Sep 2026 16:11:10 +0100
Message-ID: <20260917151615.695993228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/common/codec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index c6d44168c7f9d..164906e2f00f4 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -2277,6 +2277,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	int idx = kcontrol->private_value;
 	struct hda_spdif_out *spdif;
 	hda_nid_t nid;
+	unsigned int old_status;
 	unsigned short val;
 	int change;
 
@@ -2285,6 +2286,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	guard(mutex)(&codec->spdif_mutex);
 	spdif = snd_array_elem(&codec->spdif_out, idx);
 	nid = spdif->nid;
+	old_status = spdif->status;
 	spdif->status = ucontrol->value.iec958.status[0] |
 		((unsigned int)ucontrol->value.iec958.status[1] << 8) |
 		((unsigned int)ucontrol->value.iec958.status[2] << 16) |
@@ -2295,7 +2297,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	spdif->ctls = val;
 	if (change && nid != (u16)-1)
 		set_dig_out_convert(codec, nid, val & 0xff, (val >> 8) & 0xff);
-	return change;
+	return change || spdif->status != old_status;
 }
 
 #define snd_hda_spdif_out_switch_info	snd_ctl_boolean_mono_info
-- 
2.53.0




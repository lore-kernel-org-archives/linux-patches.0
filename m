Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760613CB57B;
	Thu, 17 Sep 2026 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670670; cv=none; b=q5oRhomfmL/K9kkrD4yTC9OUZjJvTGrEk7oBqo1bSNU0Gi3n8yVYGrwRzr/+QvrqQTVcfFrmStDfd0sF9Ywnfjuek/1BV/1kWEj1AGLLF/lJ053rmfZ4s8VQn4TrMCx2YezzDcjJdnO/8mOw5HZ4YI3eT+71dOQT5jKSGZTLQ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670670; c=relaxed/simple;
	bh=Fj03FnADOEy++wQwgGVpbpCJPoU1alEEOjamrhkGe+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keM0cCNYmdBJtYkTImKC7O4pvSPCtITjLO/Xc9jaKVLMKQi/ybyEZ0A+GHNrvfpP7cVurxqr4M/vTHiPMTuOGT4No5PJTJPY9dT+0U+paJUKEohJyv3/wH1LAmCa179yaJbcOH9jAJoRGlkLiFL5+8nT9Fq//utMUplSsM+REfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFU3Py6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFU3Py6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B291F000FF;
	Thu, 17 Sep 2026 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670669;
	bh=rgwhGCDBB6f4feIwTnb8O7eNrZ+lPB9v2O/dcSmLA+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFU3Py6zR9t8pOBaRB7J0oaQqHPxwbLTsqpmDYM+tqYOUh3njCt4MM5xnWI+KUEEK
	 uEq1SdbJzF3HPJYVPZrJAMlHv69oT18sGaH7MsXOKqrrNhLL4P6IsRx3OHyPoIOmbk
	 uikwmVfy55oodcunyIEGu46s0QfEZJUTRxUgrFGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0735/1102] ALSA: hda: Report a change when only the channel status bytes move
Date: Thu, 17 Sep 2026 16:11:18 +0100
Message-ID: <20260917151558.839032908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c99abab12c841..b4006b31251f9 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2320,6 +2320,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	int idx = kcontrol->private_value;
 	struct hda_spdif_out *spdif;
 	hda_nid_t nid;
+	unsigned int old_status;
 	unsigned short val;
 	int change;
 
@@ -2328,6 +2329,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	guard(mutex)(&codec->spdif_mutex);
 	spdif = snd_array_elem(&codec->spdif_out, idx);
 	nid = spdif->nid;
+	old_status = spdif->status;
 	spdif->status = ucontrol->value.iec958.status[0] |
 		((unsigned int)ucontrol->value.iec958.status[1] << 8) |
 		((unsigned int)ucontrol->value.iec958.status[2] << 16) |
@@ -2338,7 +2340,7 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 	spdif->ctls = val;
 	if (change && nid != (u16)-1)
 		set_dig_out_convert(codec, nid, val & 0xff, (val >> 8) & 0xff);
-	return change;
+	return change || spdif->status != old_status;
 }
 
 #define snd_hda_spdif_out_switch_info	snd_ctl_boolean_mono_info
-- 
2.53.0




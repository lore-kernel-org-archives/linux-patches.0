Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709C327584E;
	Tue, 15 Jul 2025 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585709; cv=none; b=nZuWb7eZwfjdf6XHQ2K6hqCKud7Y3ZOOOLjt8J+IdP8/if43zmRyB7aI4bfECpAorqIzUtAv2/6sG/SmpxYXf83Ga9rH9EKoac7Y3s+kX5CNa9VoV/6AiNEPeWI2IbJafdgzKYar9r2hOvm3DRnAoRgiKFzjK1R4gZeu4FSmNjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585709; c=relaxed/simple;
	bh=0C5d9i0U79G+W3nh0vbwg04ayUXIMIx1c6vIpVXeUJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHSKs+MKV+7vq6GuJkO3VHpHAKU/e+mPsys23E/u/UBEtmyLPF0tN6HOrlagDBwuSRhJMz373ikUJakxfxob0If0ZnDPrNeg61WDAevpWgjFl+q+krE2Ou3e1HQI5UTruUf98HrJGvAk0JNkgQjBNhV9wQyAVGTDoLioEsOcTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8IVakdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8IVakdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00036C4CEE3;
	Tue, 15 Jul 2025 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585709;
	bh=0C5d9i0U79G+W3nh0vbwg04ayUXIMIx1c6vIpVXeUJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8IVakddjajISTnTksb/oNf+7VrxMB6xEiLjpB0ooVIs/sQdWpx0A08ZEugfwvGec
	 qYOEdrbilTGnwXfxoSJzRx6WKkuGGTGxAslkyOU/wiGk8TfVLHpEZf7fhc8wM2y7Jh
	 Ykw1cSGyxqMO85fp98/30BLc/x4K0uKn07BMk3yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/163] ALSA: hda/realtek: Add mic-mute LED setup for ASUS UM5606
Date: Tue, 15 Jul 2025 15:13:30 +0200
Message-ID: <20250715130814.531167164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 41c66461cb2e8d3934a5395f27e572ebe63696b4 ]

ASUS UM5606* models use the quirk to set up the bass speakers, but it
missed the mic-mute LED configuration.  Other similar models have the
AMD ACP dmic, and the mic-mute is set up for that, but those models
don't have AMD ACP but rather built-in mics of Realtek codec, hence
the Realtek driver should set it up, instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220125
Link: https://patch.msgid.link/20250623151841.28810-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 30e9e26c5b2a7..57f17ddaf7860 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6611,6 +6611,7 @@ static void alc294_fixup_bass_speaker_15(struct hda_codec *codec,
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		static const hda_nid_t conn[] = { 0x02, 0x03 };
 		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn), conn);
+		snd_hda_gen_add_micmute_led_cdev(codec, NULL);
 	}
 }
 
-- 
2.39.5




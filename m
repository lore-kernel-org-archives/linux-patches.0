Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063201;
	b=5Iy36/ES1I9ySmYTEhfVN6gsSXtS2+OYPMYOiHAFQpKVEA986JxL9i1meykTlxad2v+p
	 l5JNvUOWF2to/RsKko1GJ+OF9iSMJGNBKtYBZIV41yCWUIAKrsPCHkRt11Ddnbg6sQJUf
	 vhSxFaYYuhtFjz50TSRk6EMLNEBornlPVlHorCOun4S8XJ9oNJGf9+fue72oU5B13OnUH
	 CylDtwIlEuJ5VrPBK7gm7lAjV3h5ib7fYaa7PsQjfDFOgzkNfE2kruAGlK6NSkYtwKW2g
	 m/WR23LEWO8aNE2bXM9Oq/P9+lQ2W2cClx4i7bC1MMfjSVIp0If03GRlArNky9q701Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yukU0N3qFxNrSWV99Yl05bN28DRvIU3IOZvwuo59hLA=;
	b=UzJLCkifIKV3mNexb17CpCRLOU429KJXTVkmMGAUBrgazzxpv0VSYfMIQTL59McX+/SX
	 3Dz+ct5ID+67/EK3Sb3zbtOvIh3EJMh5ds7tL442ZLcqBR9K+GiisCVXCmtGwnfIsxu/U
	 +TYqtpx9uF9bIi9yrD0QULXrrTni8BDDDDKySlwO68Jwr5obt/1FeEjAw41mCTadn0fRs
	 +70iB4izGh6XLoxjoFDFuvPhcQMIsXPAtsVxxS+c+swn7lfm0lLzg1dh1nA4Xyge2WAoI
	 7+tk8IrOhz3RJ+Ekd+lmbnqTkv4ShzJ8VTBu/yh9aNwYzf7r00r6Xd5YgQIvtdsGD3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuiEC8LM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4799C606A33B;
	Sat,  7 Nov 2026 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuiEC8LM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA27E1F008A1;
	Sat,  7 Nov 2026 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063201;
	bh=yukU0N3qFxNrSWV99Yl05bN28DRvIU3IOZvwuo59hLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuiEC8LMLNbeOTdT5OuBRZRd30UulJZb5KijJEFO3kOAPcb0heBgFjsusu/BOGVhA
	 icr6AEzjdSDJQSyAXzdGbLYiooix7orXOI5zj83B57DfkvS3SanQJPUhlWVwBTzxQN
	 WrusRUrEteOGslOFGg8o3nspSEezOerQCWC5RWYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 414/869] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Sat,  7 Nov 2026 08:51:36 -0500
Message-ID: <20261107134907.433169649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b3e7ddd694f8429217ba509b55b910a0e4361dfb ]

snd_hdmi_write_eld_info() parses a "sad_count N" line from the
root-writable ELD proc interface and assigns N directly to
e->sad_count with no upper bound, unlike the per-index "sadN_*" lines
a few lines below which are already bounded to ELD_MAX_SAD.

snd_hdmi_eld_update_pcm_info() later iterates
"for (i = 0; i < e->sad_count; i++)" over the fixed
e->sad[ELD_MAX_SAD] array, so an oversized sad_count read from the
proc file causes it to walk past the array.

Reject sad_count values above ELD_MAX_SAD, matching the existing
per-index guard.

Fixes: acb059938810 ("ALSA: hda - ELD proc interface write updates")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261008085133.9528-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/hdmi/eld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/hdmi/eld.c b/sound/hda/codecs/hdmi/eld.c
index 1464fd1c675bc..fc6fe1b0873c3 100644
--- a/sound/hda/codecs/hdmi/eld.c
+++ b/sound/hda/codecs/hdmi/eld.c
@@ -155,9 +155,11 @@ void snd_hdmi_write_eld_info(struct hdmi_eld *eld,
 			e->aud_synch_delay = val;
 		else if (!strcmp(name, "speakers"))
 			e->spk_alloc = val;
-		else if (!strcmp(name, "sad_count"))
+		else if (!strcmp(name, "sad_count")) {
+			if (val > ELD_MAX_SAD)
+				continue;
 			e->sad_count = val;
-		else if (!strncmp(name, "sad", 3)) {
+		} else if (!strncmp(name, "sad", 3)) {
 			sname = name + 4;
 			n = name[3] - '0';
 			if (name[4] >= '0' && name[4] <= '9') {
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BC630B520;
	Wed,  3 Dec 2025 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776353; cv=none; b=dFTULJYWQl4+Patks+8OKTFVbziLZhKhRjSn/KdJnMbENlTSnU1CGRBKzl7ex9TFTqb0yG+5Mf+s7VsXUaz/KYyOI2dZSxR18GoR5m1XkjiErj/o0kdyFcYGRuJv1TNVlIbVV1DExHW4jKlVYhRr6MDk/cV16vLMU19asAwWtQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776353; c=relaxed/simple;
	bh=DywWd+Nc4yoVd2fLiVoo83IzEfN0SF87j3nlI6KvpOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDf2EFSuq6WUhXqY71C6iS6ggbG1XHAUr5fi/Zp18iZlUgogAvLpEyG37s8vNXQO0bX1kPfTpihy3stJYtbRatXGt8GifuX3q7d4UVM7Y1bEwRTIxRjmzheX3KWLoiOtWyI2oUXCi4JWrtEmbXblF/QWzAGQeu6U2DfhC5uadQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhHQru6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhHQru6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A6FC4CEF5;
	Wed,  3 Dec 2025 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776353;
	bh=DywWd+Nc4yoVd2fLiVoo83IzEfN0SF87j3nlI6KvpOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhHQru6jCiY4gacZUJ/87d/+nB3PJEBcbOtpyaVKyTPQmZXcyqDqwiDP+ziB0L5NW
	 s3oD3PoykX+BDCJIoNd90wGitOx+im+tUUdk856J4CzZZErWSR+Sulw6ggCvrlJmET
	 lk+Zmc1Lyvkbs91DT4L4pdUltbriP61O0FI6D1Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/300] ALSA: hda/realtek: Audio disappears on HP 15-fc000 after warm boot again
Date: Wed,  3 Dec 2025 16:26:01 +0100
Message-ID: <20251203152406.433752455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit f4b3cef55f5f96fdb4e7f9ca90b7d6213689faeb ]

There was a similar bug in the past (Bug 217440), which was fixed for
this laptop.
The same issue is occurring again as of kernel v.6.12.2. The symptoms
are very similar - initially audio works but after a warm reboot, the
audio completely disappears until the computer is powered off (there
is no audio output at all).

The issue is also related by caused by a different change now. By
bisecting different kernel versions, I found that reverting
cc3d0b5dd989 in patch_realtek.c[*] restores the sound and it works
fine after the reboot.

[*] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/sound/pci/hda/patch_realtek.c?h=v6.12.2&id=4ed7f16070a8475c088ff423b2eb11ba15eb89b6

[ patch description reformatted by tiwai ]

Fixes: cc3d0b5dd989 ("ALSA: hda/realtek: Update ALC256 depop procedure")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220109
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/5317ca723c82447a938414fcca85cbf5@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 84dde97424080..a9c71f38710ed 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3637,6 +3637,15 @@ static void alc256_shutup(struct hda_codec *codec)
 		hp_pin = 0x21;
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
+
+	/* 3k pull low control for Headset jack. */
+	/* NOTE: call this before clearing the pin, otherwise codec stalls */
+	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
+	 * when booting with headset plugged. So skip setting it for the codec alc257
+	 */
+	if (spec->en_3kpull_low)
+		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
+
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 
 	if (hp_pin_sense) {
@@ -3647,14 +3656,6 @@ static void alc256_shutup(struct hda_codec *codec)
 
 		msleep(75);
 
-	/* 3k pull low control for Headset jack. */
-	/* NOTE: call this before clearing the pin, otherwise codec stalls */
-	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
-	 * when booting with headset plugged. So skip setting it for the codec alc257
-	 */
-		if (spec->en_3kpull_low)
-			alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
-
 		if (!spec->no_shutup_pins)
 			snd_hda_codec_write(codec, hp_pin, 0,
 				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FF829BDB4;
	Tue, 17 Feb 2026 20:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361510; cv=none; b=ao1BRhf025r7GE6VtNWLy3YxASPBriLbcu73Z+CQ4X12BNWjrWzhIa+jsQDh0XCwMwC3MrDQd+aAwOB0WalwVrSTCvjOV2aUJ7VlT0rrjrkrb7nYpNtDxtlFKVA9XJgsmVbBMoEgrQ/jPtv8dIzlSb/Ae+7vVBuj5kQCXKJj7N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361510; c=relaxed/simple;
	bh=vb73SZitYE8F++/ZmlcBi5J4YG1Z6HRWtlhO6xOeE30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBX3zJyycFw/pyhvNgSdP7UCkmr+dhKznS3a1Q9BSgQASj+4rN3YvXIm25O6/fkSRcaoe4T2Jnuev2jmK5ta5IPUjDF9clbrwqicjz8g8FsIaO0HDGDIJa+vWoto928GwIhL//tjHQZq55m2MClhReX3gYvUoQ4Qe+iDlYuLVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vB8KvdwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vB8KvdwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2C5C4CEF7;
	Tue, 17 Feb 2026 20:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361510;
	bh=vb73SZitYE8F++/ZmlcBi5J4YG1Z6HRWtlhO6xOeE30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vB8KvdwCYFl8HYQWJ07MbHzWCSQGcOaq+sHHW6arPrfKLJKGr9VSE+mJI0vuXUPxS
	 /A1wAFqJi2HYQIopOpdy7BcCnFiPcfwOV8Y8I+7mZ6RJvWMsrlIjw0N/cd8jHsV/hl
	 i6kFRF6oILP5S3xbRfDVQLp8gbqJzy6wFEDiLih0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 09/43] ALSA: hda/realtek - fixed speaker no sound
Date: Tue, 17 Feb 2026 21:31:49 +0100
Message-ID: <20260217200006.827358407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 630fbc6e870eb06c5126cc97a3abecbe012272c8 ]

If it play a 5s above silence media stream, it will cause silence
detection trigger.
Speaker will make no sound when you use another app to play a stream.
Add this patch will solve this issue.

GPIO2: Mute Hotkey GPIO3: Mic Mute LED
Enable this will turn on hotkey and LED support.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/f4929e137a7949238cc043d861a4d9f8@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a77f16abc6df0..55ef52fefaef4 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3371,11 +3371,22 @@ static void alc287_alc1318_playback_pcm_hook(struct hda_pcm_stream *hinfo,
 				   struct snd_pcm_substream *substream,
 				   int action)
 {
+	static const struct coef_fw dis_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0004), WRITE_COEF(0x29, 0xb023),
+	}; /* Disable AMP silence detection */
+	static const struct coef_fw en_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0084), WRITE_COEF(0x29, 0xb023),
+	}; /* Enable AMP silence detection */
+
 	switch (action) {
 	case HDA_GEN_PCM_ACT_OPEN:
+		alc_process_coef_fw(codec, dis_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x954f); /* write gpio3 to high */
 		break;
 	case HDA_GEN_PCM_ACT_CLOSE:
+		alc_process_coef_fw(codec, en_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x554f); /* write gpio3 as default value */
 		break;
 	}
-- 
2.51.0




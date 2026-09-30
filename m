Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A3D65192;
	Wed, 30 Sep 2026 18:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791969; cv=none; b=YFDkHfM+B894VGtpVShCIoU3/Z5/Y6/Jjai0nX869sCTWDj5lNraK2bRKUlhbr3309tWvbTxltXIJ3IiS+QCC5f7LmI9426Vtrm0c2JukdxyVA0M1WL2WRhnX0RYqNm5GazgjCrEPv3p4o2bCr+VefrntwlKpnJInHBbM3UH3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791969; c=relaxed/simple;
	bh=5kNzuZ+HhRyqjeWNr/6DoY7Q9sHT3Vk3yZaKnp98xhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug3NaIEUgcrf3gznodgHcNY3HeuyjkYB6iHMiepoPsoYF0exRobwyX0c3qUZ2TsgnvlAlWRJjFKBGXadkxEBcYkDBjPsSAtD5PSgxXeIk2Sl1cSQL18E/g7jdk2C1QPcytDZR2pBpmuNZNAn1TNzXY42eiKXhXsY82tpUTDR5Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSJrE4f2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSJrE4f2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2391F000FF;
	Wed, 30 Sep 2026 18:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791967;
	bh=239FCtFZV2hqdxPJAQy6IDZu6gMGmOUj9KyjIAHEcSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSJrE4f2r+UDUvmu2AeLe60RyiK4r1Gxqj71mhthXaJs+urw5GepkRc/9/rcRYuDt
	 qgLph1Xx//em0NSmpzbJ1Q0J0ger4/J0CKIc0Z6eukrN6rQQFC3K8yX+JJf7sy7o4n
	 87XgVB6VJRsJuwH15xKaIGHGBspsStjddYnB0YU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 489/752] ALSA: hda: trace PCM open only after assigning a stream
Date: Wed, 30 Sep 2026 17:25:59 +0200
Message-ID: <20260930152408.849832291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit c9e6e5f38bf75276605f1952b22285f5f3abcaff ]

Stream assignment can fail when hardware streams are exhausted.
Move the tracepoint after the NULL check because its payload accesses
the assigned stream tag.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 184865085b88 ("ALSA: hda - rename hda_intel_trace.h to hda_controller_trace.h")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260913125154.109944-1-bolin.liu@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 0ff286b7b66be..69f0ba397ea0e 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -587,11 +587,11 @@ static int azx_pcm_open(struct snd_pcm_substream *substream)
 	snd_hda_codec_pcm_get(apcm->info);
 	mutex_lock(&chip->open_mutex);
 	azx_dev = azx_assign_device(chip, substream);
-	trace_azx_pcm_open(chip, azx_dev);
 	if (azx_dev == NULL) {
 		err = -EBUSY;
 		goto unlock;
 	}
+	trace_azx_pcm_open(chip, azx_dev);
 	runtime->private_data = azx_dev;
 
 	runtime->hw = azx_pcm_hw;
-- 
2.53.0




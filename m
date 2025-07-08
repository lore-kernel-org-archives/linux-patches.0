Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E331E2E1C74;
	Tue,  8 Jul 2025 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994107; cv=none; b=eEwOFuvJxgLxCTH3btp4Vabupp4SFtiEJUlDkVVTWqqPSiTE1+D4G11ntFmAQoel9tOh8PnvVKd/U5bLWcvoL4FcwF2iW1r7VIebk3rop0KWyjKE2LgvyIjsuiRpBjrwLEM/LriaTSYJU1Ukbg+hzcftmyLqLk5K4F3ts1QcJec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994107; c=relaxed/simple;
	bh=S39Szx6ynpHAiaIZnIxTIwfM1xANFT5ShqNCw8sBwIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzTVT2fWdCoP6cIubSMWuTyoxfSiqy18b7vyhHhXGTUfUVUP0mvwTgjrg/4lUCbseJB6PgIhNtatElCsZN3et8mHxtxuQg5kOvyOZlGr6Rwu0uwUAuhFCnKd9shUFKS3G9bc2pA3sNL9MqnWeJsW02IX56I78LUbDk521gTDtok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5lRj09O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5lRj09O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7266EC4CEF6;
	Tue,  8 Jul 2025 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994106;
	bh=S39Szx6ynpHAiaIZnIxTIwfM1xANFT5ShqNCw8sBwIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5lRj09OovttdBOLgfAWpdAwxDGks0QLbHbvqYv76L/4HTchZLCdf8ksXdTlZK4fe
	 iJ8/PmoG4/73BxGfUKNKb5PHg2jqiRfh59GSlgg9A09D8oIrUuCcTuCUiXXyDiNUlG
	 o2sB4QIboLz5a37eVhYhnMGNy/FEcssS9lcX+DcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/160] ALSA: sb: Dont allow changing the DMA mode during operations
Date: Tue,  8 Jul 2025 18:22:44 +0200
Message-ID: <20250708162234.936337337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ed29e073ba93f2d52832804cabdd831d5d357d33 ]

When a PCM stream is already running, one shouldn't change the DMA
mode via kcontrol, which may screw up the hardware.  Return -EBUSY
instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb16_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index a9b87e159b2d1..5efbd0a41312b 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -703,6 +703,9 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	unsigned char nval, oval;
 	int change;
 	
+	if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
+		return -EBUSY;
+
 	nval = ucontrol->value.enumerated.item[0];
 	if (nval > 2)
 		return -EINVAL;
-- 
2.39.5




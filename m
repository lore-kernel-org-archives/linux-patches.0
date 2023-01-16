Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB46633EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73683C433D2;
	Mon, 16 Jan 2023 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885036;
	bh=Js6RZH2ecQ+hKtymEZUwQNTYxCqG5fcjjoHM54slJ1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KX5vb3Zh+HOpAD/VR3mfAn02FFRjx91TqkKqsqXHo43F77Tvm64VsOkY9/MhxHQ/s
	 DwS9IZiLK3bQ9xGBUmNt20iyG2imhkeEyqbxwxSAvb6MFQxPonH2ETDni10RhqsqFN
	 D2RZrfKd1mNT7/OqRl12OyqkKqL7heMrMwuEG7qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/86] ALSA: usb-audio: Make sure to stop endpoints before closing EPs
Date: Mon, 16 Jan 2023 16:51:24 +0100
Message-Id: <20230116154749.151492211@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0599313e26666e79f6e7fe1450588431b8cb25d5 ]

At the PCM hw params, we may re-configure the endpoints and it's done
by a temporary EP close followed by re-open.  A potential problem
there is that the EP might be already running internally at the PCM
prepare stage; it's seen typically in the playback stream with the
implicit feedback sync.  As this stream start isn't tracked by the
core PCM layer, we'd need to stop it explicitly, and that's the
missing piece.

This patch adds the stop_endpoints() call at snd_usb_hw_params() to
assure the stream stop before closing the EPs.

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Link: https://lore.kernel.org/r/4e509aea-e563-e592-e652-ba44af6733fe@veniogames.com
Link: https://lore.kernel.org/r/20230102170759.29610-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b6cd43c5ea3e..ef0c1baaefde 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -525,6 +525,8 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		if (snd_usb_endpoint_compatible(chip, subs->data_endpoint,
 						fmt, hw_params))
 			goto unlock;
+		if (stop_endpoints(subs, false))
+			sync_pending_stops(subs);
 		close_endpoints(chip, subs);
 	}
 
-- 
2.35.1




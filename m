Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7BB1E0493;
	Tue, 17 Dec 2024 17:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455967; cv=none; b=TJ+lwVHbjIQyTx7m7WIvZVNs923eNb7/hlPKF4Pcp2VnmPaPca8TuJk/Jh+7HFvMp0Dpq0Qn8BEL2Z/a60J1zbIbNLDUzt5RcGsBn+czQTKfvpYfacFSMB9djJWRiz1ugN1TdL+L6M2WW0eiEa3104UEzQ6AfDwCFrsT3YM1qbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455967; c=relaxed/simple;
	bh=FlllF0p7PZ7hPjskBP826RrMVA6qwiv/jhxB35i6eSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCrDADFsWjDj0/jE1IFsI6pFAUFqSeFyxUXJuvPkvGpM1nxZHen14426jBCFQDXJzD9K/UN/+UzJjdo0XBQPoDlTaCHH+eYtcrzYB0u6O2RPvlvK3ZCQPX5GxlQ484Kn0CJ9d76ae2lnDiHehISTfKj6zxEQqIJi/jf4hRPL8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gn2q3tB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gn2q3tB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8120C4CED3;
	Tue, 17 Dec 2024 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455967;
	bh=FlllF0p7PZ7hPjskBP826RrMVA6qwiv/jhxB35i6eSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gn2q3tB7G0rwbN9jdJv5LkREOZZgmf+MXbWRPrEJuo0rxFdERxVdrjypbGLyt0/1O
	 6dsGK4Q9hojz61WCOi/PMTliScxExGiJ4BCFnY++zY6o9+hgFMSunBCH4ASqEhXLcJ
	 1lPJy4g9yKaNFPlDy51vQnsROI1xOhaUornxYpoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 016/109] usb: gadget: midi2: Fix interpretation of is_midi1 bits
Date: Tue, 17 Dec 2024 18:07:00 +0100
Message-ID: <20241217170534.039626313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 82937056967da052cbc04b4435c13db84192dc52 upstream.

The UMP Function Block info m1.0 field (represented by is_midi1 sysfs
entry) is an enumeration from 0 to 2, while the midi2 gadget driver
incorrectly copies it to the corresponding snd_ump_block_info.flags
bits as-is.  This made the wrong bit flags set when m1.0 = 2.

This patch corrects the wrong interpretation of is_midi1 bits.

Fixes: 29ee7a4dddd5 ("usb: gadget: midi2: Add configfs support")
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20241127070213.8232-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1593,7 +1593,11 @@ static int f_midi2_create_card(struct f_
 			fb->info.midi_ci_version = b->midi_ci_version;
 			fb->info.ui_hint = reverse_dir(b->ui_hint);
 			fb->info.sysex8_streams = b->sysex8_streams;
-			fb->info.flags |= b->is_midi1;
+			if (b->is_midi1 < 2)
+				fb->info.flags |= b->is_midi1;
+			else
+				fb->info.flags |= SNDRV_UMP_BLOCK_IS_MIDI1 |
+					SNDRV_UMP_BLOCK_IS_LOWSPEED;
 			strscpy(fb->info.name, ump_fb_name(b),
 				sizeof(fb->info.name));
 		}



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DE75FDC1;
	Tue, 23 Jan 2024 01:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974654; cv=none; b=qO/xoxU7b6Dn5k9gc3rshFwaweeiDKMw6n1vSjbcYiwOuUNokNNdL7CuIr6YDpfxlb65IlWa2X99/P208j9OFD0EgiBH8tlcnH9CO7TB5KpYge3SiCKeK0WlKkSMN4usGcPenOeFSG8HNcZ7jSFjw7MyeDDCbObih5jccuvZGro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974654; c=relaxed/simple;
	bh=I2wv45kbphLxqqD+RIeO/5VT2QX9NUQWaaCPTCDyjAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6U1k7sUVDX93ap9jMcgecjUk638hjTy9iLUb3EP6bcMO0ANWhXJWPWZS9QsViz2eTuFKaXD9L4TsHDBv0V5fA7cFQPMSc2T7OSPeqeHuf83UL1tVtS7x3bsaGMdjY/EqQtok0z1vqMNnrlr8p3HjKMxcnnc4KD8YXb8Ev0Y9eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNRNRIR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNRNRIR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39387C433C7;
	Tue, 23 Jan 2024 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974654;
	bh=I2wv45kbphLxqqD+RIeO/5VT2QX9NUQWaaCPTCDyjAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNRNRIR6Uf7B26i0eZlXXIWMlMpRC8ycFHhMyXVY2D5AMiRl6GddV+QUfgASkEOLS
	 BiiqwYnPUNLq2+jQF8Eovwg84CHH5poJwrln3SkNUml4RK/399Oz1U8u0x5SzpVQIe
	 2TCtv17PH626xigaVt57pDHs/okQFY/bi8Tr7Gs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/374] ALSA: scarlett2: Add clamp() in scarlett2_mixer_ctl_put()
Date: Mon, 22 Jan 2024 15:58:11 -0800
Message-ID: <20240122235752.909222596@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 04f8f053252b86c7583895c962d66747ecdc61b7 ]

Ensure the value passed to scarlett2_mixer_ctl_put() is between 0 and
SCARLETT2_MIXER_MAX_VALUE so we don't attempt to access outside
scarlett2_mixer_values[].

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Link: https://lore.kernel.org/r/3b19fb3da641b587749b85fe1daa1b4e696c0c1b.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 9302f45b62ac..0a9025e3c867 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -3237,7 +3237,8 @@ static int scarlett2_mixer_ctl_put(struct snd_kcontrol *kctl,
 	mutex_lock(&private->data_mutex);
 
 	oval = private->mix[index];
-	val = ucontrol->value.integer.value[0];
+	val = clamp(ucontrol->value.integer.value[0],
+		    0L, (long)SCARLETT2_MIXER_MAX_VALUE);
 	num_mixer_in = port_count[SCARLETT2_PORT_TYPE_MIX][SCARLETT2_PORT_OUT];
 	mix_num = index / num_mixer_in;
 
-- 
2.43.0




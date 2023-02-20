Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE4963B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8798C433EF;
	Mon, 20 Feb 2023 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900304;
	bh=z/96+ovYQqvzl3gQWrPZ70bGG7adaQMdM7McEvC9CCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hli2LqlxqpJ2j2CPWwYE3Nr37VlTeCxJWOxZP85SwXySyQlUxac51EC2IuCgqdcMU
	 MgGdPS+EcSspqYFerV3ALCCnPl6E2YgVDfSLfvMKKo0ea0p3qDC+jEErIFkJdZ6qpe
	 QeBhJycR2/c02oiGRNruspD9fRnoRxngwqE83vMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artemii Karasev <karasev@ispras.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 27/53] ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()
Date: Mon, 20 Feb 2023 14:35:53 +0100
Message-Id: <20230220133549.146199970@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artemii Karasev <karasev@ispras.ru>

commit 6a32425f953b955b4ff82f339d01df0b713caa5d upstream.

snd_emux_xg_control() can be called with an argument 'param' greater
than size of 'control' array. It may lead to accessing 'control'
array at a wrong index.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Artemii Karasev <karasev@ispras.ru>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230207132026.2870-1-karasev@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/synth/emux/emux_nrpn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/synth/emux/emux_nrpn.c
+++ b/sound/synth/emux/emux_nrpn.c
@@ -363,6 +363,9 @@ int
 snd_emux_xg_control(struct snd_emux_port *port, struct snd_midi_channel *chan,
 		    int param)
 {
+	if (param >= ARRAY_SIZE(chan->control))
+		return -EINVAL;
+
 	return send_converted_effect(xg_effects, ARRAY_SIZE(xg_effects),
 				     port, chan, param,
 				     chan->control[param],



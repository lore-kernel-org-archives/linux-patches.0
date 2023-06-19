Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5BA5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0955BC433C8;
	Mon, 19 Jun 2023 10:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170955;
	bh=mdbmSESeonHWN1aK4IwDHNYlhsoIxMfPZ0/Z6vaPIGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4bASEKqTHda8PA8FxWRkY/g/W7VMUMGvr+u3JWa+NMVlTlnL8RBEkP+IeHwFi9Op
	 ztAN+ARtgYh1ceQjQLM4MMHDLAYZVCB9FuzJniG7bPkyhxByJ8+1JLyfTPgiSpqJhS
	 /2T/NDrnOUZIee9Tu8BThC6Ui5ELuR6URYnnHUAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 070/187] ALSA: usb-audio: Fix broken resume due to UAC3 power state
Date: Mon, 19 Jun 2023 12:28:08 +0200
Message-ID: <20230619102201.040498478@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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

commit 8ba61c9f6c9bdfbf9d197b0282641d24ae909778 upstream.

As reported in the bugzilla below, the PM resume of a UAC3 device may
fail due to the incomplete power state change, stuck at D1.  The
reason is that the driver expects the full D0 power state change only
at hw_params, while the normal PCM resume procedure doesn't call
hw_params.

For fixing the bug, we add the same power state update to D0 at the
prepare callback, which is certainly called by the resume procedure.

Note that, with this change, the power state change in the hw_params
becomes almost redundant, since snd_usb_hw_params() doesn't touch the
parameters (at least it tires so).  But dropping it is still a bit
risky (e.g. we have the media-driver binding), so I leave the D0 power
state change in snd_usb_hw_params() as is for now.

Fixes: a0a4959eb4e9 ("ALSA: usb-audio: Operate UAC3 Power Domains in PCM callbacks")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217539
Link: https://lore.kernel.org/r/20230612132818.29486-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -650,6 +650,10 @@ static int snd_usb_pcm_prepare(struct sn
 		goto unlock;
 	}
 
+	ret = snd_usb_pcm_change_state(subs, UAC3_PD_STATE_D0);
+	if (ret < 0)
+		goto unlock;
+
  again:
 	if (subs->sync_endpoint) {
 		ret = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);



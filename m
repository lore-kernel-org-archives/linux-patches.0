Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3CC24DCF6;
	Mon, 13 Apr 2026 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097138; cv=none; b=hv5LIRo5adu/o+Dapb1kUWlwI76pj84IBk8UNMMQvv0Ng/k1XZbrdgVDZii+rBZdif7m4rsh2v/ozGwkB42pvKX+Si5+/0ktb9gi45uqT9DM6avBxOzQjVi8vo1UT4PB/tdTs/usSOGR/IEKN0QJM/5tP9xfX1ERaYAi9kUySo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097138; c=relaxed/simple;
	bh=8iD/OlwPYLL6ZnVpykkHjAaOrPJwY58I4QJElsyQd8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtXK29Bt2k2z2VhN1Qi+IYYosXl8SYcVnGUH1yd8k67p5LvIkP5oinhu7gGasxhAS9nxQVHAu13xnLgh7zBlq3oUDgO/SwGoFHNXN9ljccrEZegUox1ZwUiIaaNl78SvjFmfMf6/sAvoTnI45VK3lWBCp0UwwawcF1tZDCFTB4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emwsYaK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emwsYaK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5D2C2BCAF;
	Mon, 13 Apr 2026 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097138;
	bh=8iD/OlwPYLL6ZnVpykkHjAaOrPJwY58I4QJElsyQd8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emwsYaK7JDbIHKMzS28hV1Fw39pW6fWLvLGtGbq3r0XGOHB7n1HusCwyosHSjKsMY
	 J1w8WSy6u+fTEpJxAVlyz58ZiIODe9Ny/kZ3iHNec8OMjrq0sqOmc+R9ISVY1Y7S7k
	 13A14n8N/1MNF1BCnF1OdObspR9QSZDb5cZ7N3nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/570] ALSA: usb-audio: Cap the packet size pre-calculations
Date: Mon, 13 Apr 2026 17:52:19 +0200
Message-ID: <20260413155830.710075659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7fe8dec3f628e9779f1631576f8e693370050348 ]

We calculate the possible packet sizes beforehand for adaptive and
synchronous endpoints, but we didn't take care of the max frame size
for those pre-calculated values.  When a device or a bus limits the
packet size, a high sample rate or a high number of channels may lead
to the packet sizes that are larger than the given limit, which
results in an error from the USB core at submitting URBs.

As a simple workaround, just add the sanity checks of pre-calculated
packet sizes to have the upper boundary of ep->maxframesize.

Fixes: f0bd62b64016 ("ALSA: usb-audio: Improve frames size computation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index e442a4fcead9b..a861915e07f3b 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1387,6 +1387,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 		goto unlock;
 	}
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
-- 
2.51.0




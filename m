Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43431408617;
	Mon, 17 Aug 2026 14:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976349; cv=none; b=D1+PFnx5VIV/Hh7dTevYY5l0OfUa/i3IqJB7zE/rNYGkM03r77owsNNMJtBJZi/R+AHWJU6JGbo2+I063s0mBH8NNFWBl53pF+eK57R+fb7QE1j304IcJMX/owuJXu22rnX7m8IppklzGJbFEaV3Tmzq24CLA9tbw89moj68fe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976349; c=relaxed/simple;
	bh=Rojw/S9QvyAW+5oAWtZ8Z0ec4OS/wT5tnchaFzY8K8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meT6kZf0gkVhzqSN45kLEm7IHoTf/LXCm+FM9cEp9AGAk1QrgdX1qwLaE64vaMx08XM56qUUhN6PTXJECG6K8EmtfKhG/dq//kEgOumgqTuE/H3sCqkb0oCnPdXTfE3lHx51DLjoX88cH6x6KpoHB9ApGagHx+NSjzCr9KAV5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNj44Juj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNj44Juj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8351F000E9;
	Mon, 17 Aug 2026 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976348;
	bh=yGFPbvRsB2FFezqGpQTxecB8P/ziM8MeXlOfchyqqS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNj44JujsMa5hw64c03wimNTaFn/ZqQnMUdRgWez6qPxygetdwj82zcdzOlxyWbOQ
	 N7RsPIeYK314wbWpNqoHwkvJiWsgFLbwoWk+rtJrhnpibejfn/t7LatueZcyepaxAK
	 HOhK/57yYP3qWTj7yxRDknd8uVVGC95TizQb+Odo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?=E7=8E=8BYP?= <pzqqt88198@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/389] ALSA: usb-audio: Evaluate packsize caps at the right place
Date: Mon, 17 Aug 2026 15:33:01 +0200
Message-ID: <20260817132552.172730799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 52521e8398839105ef8eb22b3f0993f9b0d11a57 ]

We introduced the upper bound checks of the packet sizes by the
ep->maxframesize for avoiding the URB submission errors.  However, the
check was applied at an incorrect place in the function
snd_usb_endpoint_set_params() where ep->maxframesize isn't defined
yet; the value is defined at a bit later position.  So this ended up
with a failure at the first run while the second run works.

For fixing it, move the check at the correct place, right after the
calculation of ep->maxframesize in the same function.

Fixes: 7fe8dec3f628 ("ALSA: usb-audio: Cap the packet size pre-calculations")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221292
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260410143220.1676344-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[王YP: Move the check to `snd_usb_pcm_prepare()`. For linux-5.10.y,
       ep->maxframesize is calculated in `snd_usb_pcm_prepare()`.]
Signed-off-by: 王YP <pzqqt88198@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 ---
 sound/usb/pcm.c      | 7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 3ac4251f9cde6..730744104df61 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1101,9 +1101,6 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
 		return -EINVAL;
 	}
 
-	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
-	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
-
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index f4494d0549172..802ed1dbd23b0 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -953,6 +953,13 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
 	subs->data_endpoint->curframesize =
 		bytes_to_frames(runtime, subs->data_endpoint->curpacksize);
 
+	subs->data_endpoint->packsize[0] = min(
+		subs->data_endpoint->packsize[0],
+		subs->data_endpoint->maxframesize);
+	subs->data_endpoint->packsize[1] = min(
+		subs->data_endpoint->packsize[1],
+		subs->data_endpoint->maxframesize);
+
 	/* reset the pointer */
 	subs->hwptr_done = 0;
 	subs->transfer_done = 0;
-- 
2.53.0




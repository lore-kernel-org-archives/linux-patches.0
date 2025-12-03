Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A94D357A52;
	Wed,  3 Dec 2025 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778826; cv=none; b=KNBruDDt+FH3uzrRnbUkDpWizhHlBZfUSbOYDfZfrbSlEGiyEYZez2FPXof/IsyyI2QEKMhWsP+RMHX/q3J5zhpo8B0TOLg9xcMF8UwqYJVK8a42+gF3/U1FQpxBtODVbtsJNkID16Rs92unn+XA6fFhWlQEJ1itvpnsT7qZwTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778826; c=relaxed/simple;
	bh=MGkOgVzbsvQbYVypDhu7Fc2pAdOeM7OZxLwAkOsBL+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbVbP/ejVun5b39wQwP5pYyuWdyjZmRYA6pvPdDt1otZC3+p34T6wUlRr4ueZQqbhJrXErmBTRAUQ2cfNJiNi5Ul7zZqisBsCTAhsjYODcMC4AGz3fmZ70a1KG3jsyXDq4kwikvZAXN9FuExX2lTU3rqOgxS5ddPENak15JQwwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMqdYfGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMqdYfGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6057C116B1;
	Wed,  3 Dec 2025 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778826;
	bh=MGkOgVzbsvQbYVypDhu7Fc2pAdOeM7OZxLwAkOsBL+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMqdYfGah3AlwkHbzjBWovZTY5cR8SWUS2hM2EdiPEyiUz+0tTwKPj3oXYZVk1m0P
	 RH6g8fjDupCzVwtuI41Sn6dChQzEV0A0zJFMLJdhUODNxqdncZuSG6aUyXwVrSs77U
	 ZnBLtz4oInPfQ3g/hzZUc4AVGcEVXelC7gPiN0o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/568] ALSA: usb-audio: fix control pipe direction
Date: Wed,  3 Dec 2025 16:20:40 +0100
Message-ID: <20251203152442.086370417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit 7963891f7c9c6f759cc9ab7da71406b4234f3dd6 ]

Since the requesttype has USB_DIR_OUT the pipe should be
constructed with usb_sndctrlpipe().

Fixes: 8dc5efe3d17c ("ALSA: usb-audio: Add support for Presonus Studio 1810c")
Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Link: https://patch.msgid.link/aPPL3tBFE_oU-JHv@ark
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_s1810c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index fac4bbc6b2757..65bdda0841048 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -181,7 +181,7 @@ snd_sc1810c_get_status_field(struct usb_device *dev,
 
 	pkt_out.fields[SC1810C_STATE_F1_IDX] = SC1810C_SET_STATE_F1;
 	pkt_out.fields[SC1810C_STATE_F2_IDX] = SC1810C_SET_STATE_F2;
-	ret = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),
+	ret = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
 			      SC1810C_SET_STATE_REQ,
 			      SC1810C_SET_STATE_REQTYPE,
 			      (*seqnum), 0, &pkt_out, sizeof(pkt_out));
-- 
2.51.0




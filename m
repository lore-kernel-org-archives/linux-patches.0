Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29230BB94;
	Wed,  3 Dec 2025 15:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775884; cv=none; b=IGO110cL6RLrSqr0IyBd3kJhLtib0QTgz6N89ARAjFd7huTn8jM1pP65Kqpqf52OMkQa8/ecOwL2PRpCiYOJ0ZjvtHqABhEQ0++FjNY31u5GFOFU1bbeSloCFsHYMGqHtpv+GhT67/eFz0syXv4iLxQdrHLcHFaDjJ+rj3bzzCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775884; c=relaxed/simple;
	bh=MKgMOgvKlDVKIfi/vQ8EKdzlMOJNTjWO43cDZQspjmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/Iuj5tj+Ix3Tia5XgmL2azhvQuNeV+9KyUdH7mpucaL2x9snd9ZGT/EshN5pBMhI/uET+/khsHEhmpQvSRSspAgG2RpmVovcRcKYFR1Ve8WIpl8T63Uyl2oa91VC/WP9ONkMQ4p8AdBDND3SA+c4a13Yb9+NI1FkHhk3MKdgmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA5G/t5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA5G/t5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF875C4CEF5;
	Wed,  3 Dec 2025 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775882;
	bh=MKgMOgvKlDVKIfi/vQ8EKdzlMOJNTjWO43cDZQspjmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA5G/t5iENZPCES8+52InaDAL23xnM9DJJNIl0qLVxjuyfFTzyL6Eh5MxJQ/gz8Z8
	 KRiUoiStWCJleJzM94x2CoUglziyO2YNfUEPRHOAxVGpq3nt67j+foD2cFwlgVYpgS
	 AI99UBR8jCt46ObV41ap3Hgem9htK64Y55ACoi78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/300] ALSA: usb-audio: fix control pipe direction
Date: Wed,  3 Dec 2025 16:23:40 +0100
Message-ID: <20251203152401.059296802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c53a9773f310b..457e07f6fc7c8 100644
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




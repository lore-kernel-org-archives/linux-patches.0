Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA6624EA90;
	Tue, 11 Nov 2025 00:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822309; cv=none; b=NB2Mv+gfkndlhQ9FZeirVq9MNx68efy4aJHplZTGvuRrMX3yat2TLFK97A+/KzkNxizIhMddDPZ6b5fDB7oSaKARDjEVOXsBF4K1MphuQuQ9OkSmWf69DXjBFpWgpW5jbNr6ARzbfbIZqnagZ/PVFlrv6iTRnT9oO5mEk/xKMjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822309; c=relaxed/simple;
	bh=/259lyIVxoAeAXaMZx0KmSsOtBoUuLxrYAhllbA1oJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZUkruBL6TV6Q5H6EvIrfiiQF2M/Mn0l/IuSN8iiWl47yV1/XQrVjZWceAGzwfebgU2hqmx9AYZAFZ5PQ9Qm74nkbarWJK51vkiyR3Wodv43q6pBxLa31leCTzH8BmX/bPcNLJWJiTr1+jhTW0FNT5ILIzkWyn45Z8GyoV75YDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWIIY3S9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWIIY3S9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C626C19424;
	Tue, 11 Nov 2025 00:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822308;
	bh=/259lyIVxoAeAXaMZx0KmSsOtBoUuLxrYAhllbA1oJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWIIY3S9/mUvfOiSd1ZWopjai4pkmFl5T7S47hXGfLyuF0dG13wBGom4cXztwDYKx
	 tV6gx3Cpm8qPWaWypy++EHY5ge3cD1sXXIAbJEUGl0WZ9+0+QaZTwxBN5fSm1QT28v
	 SKdQB0aBH1IB6hLHIW3XWrj0pShKA9/HUewvqtEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 036/849] ALSA: usb-audio: fix control pipe direction
Date: Tue, 11 Nov 2025 09:33:26 +0900
Message-ID: <20251111004537.316545538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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




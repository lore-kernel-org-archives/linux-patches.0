Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5EB4086A;
	Tue, 11 Nov 2025 00:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822503; cv=none; b=FJuwsQVXQajgLxfjR4BdGu0OPiIvjxc3qjbhC5LFMYhy6m1SoRviF4jPFyuLPiburfEFIR0ghRne4l40zFMjHpX5Vhfs6CPws72DuYKkcPI5BdUwkkVpsHsKfH0kOtHwhLiYZwwg4G4m74FXBexKTN691ayJptXZHsmPstZLYTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822503; c=relaxed/simple;
	bh=azq9VAxkyupea6r8E10LgCR7RvnjvpOiG9XKq5GMT10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlHjob7M/q3/O6qXHwOeLKfpa+SQjScglKh9KiVNwhduwRTzEsU/kalKgzQCYLm0IY9lfvj8dMg7KBWQQaDKSdnatOj9oi3tXIEBa+v73E5ja8VGzEd9vVIOf7CpLyE5aUZ5Iu18K83O4n1BwQIisT8vYaowQ7VVZGTwb7PUMy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6EMp8FZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6EMp8FZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A15C4CEFB;
	Tue, 11 Nov 2025 00:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822502;
	bh=azq9VAxkyupea6r8E10LgCR7RvnjvpOiG9XKq5GMT10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6EMp8FZJFVJtGtSVm+t7KwDb4o8fjIztoEl2J/gWJhwnywYAD2BDovDJVCh5ky3R
	 tlsHfzBd3EB+UDgG6boddaJ+e/Twz6s9QiOr+y1wvqv8/HQd3ci/9AvzIboleFSXjp
	 YNBaEfNlB8lMUoUpxZr+iwDvsp1VfMhWPZV4gAZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/565] ALSA: usb-audio: fix control pipe direction
Date: Tue, 11 Nov 2025 09:38:01 +0900
Message-ID: <20251111004527.442832552@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




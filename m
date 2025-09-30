Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F4372617;
	Tue, 30 Sep 2025 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243932; cv=none; b=XlhO+C6+Jb7KQMfovdOSPcc+TgVdYqyWRIo9A3t6zPQRFDahgReb/KLFduJ9xFKIbVUzd4yNY7zBGCqlTN4byNk3T1f8RiSuQRUTnq4D8kFCoK5FXlIIeQi0GhEFn8VpGcg8cBRwHhxioytzd6IIeVWCX3wjDqWiyeiFOkUIl7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243932; c=relaxed/simple;
	bh=PB/HDRzaatK5VQDBI/W20iP1WNGjeaX/6cYTxExFOnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlVUOtGr4mCRbdMwCKN6fnpXMJcTSG6OGIcxL1kSDsyOgpyeKI3hru3ax2JWdVwVtmtOBBjjwktmBo0zl4JueKSPUEHZDuV/jjxYUP7P8L5fDY3KEQRTQOnlZXoD5bHCdeRi+fvYcp+qLwvNS8EKzidvxMSTVZXh6lvEWkKASL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF/G7cKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF/G7cKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514FAC4CEF0;
	Tue, 30 Sep 2025 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243930;
	bh=PB/HDRzaatK5VQDBI/W20iP1WNGjeaX/6cYTxExFOnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF/G7cKkH9xazv1KdVz0CZYdAkVNBFfPxK9aqDGOCLqftx2E+GwpeM+pfLNkp0QXw
	 xJyZ/6t3QTcTB7FKqtPGWbQ6pHvtMjrR8DrUVux3lh/rmOcN0ZFxuELyQrqF9kLgWO
	 ajNRKrJFkvxYx8mYB6VlSPVfP4B3y0u2ehBSgbe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 58/81] ALSA: usb-audio: Remove unneeded wmb() in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:00 +0200
Message-ID: <20250930143822.104103451@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9cea7425595697802e8d55a322a251999554b8b1 ]

Adding a memory barrier before wake_up() in
snd_usb_soundblaster_remote_complete() is supposed to ensure the write
to mixer->rc_code is visible in wait_event_interruptible() from
snd_usb_sbrc_hwdep_read().

However, this is not really necessary, since wake_up() is just a wrapper
over __wake_up() which already executes a full memory barrier before
accessing the state of the task to be waken up.

Drop the redundant call to wmb() and implicitly fix the checkpatch
complaint:

  WARNING: memory barrier without comment

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-8-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index f318b80d646d5..03d49d4c5141d 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -207,7 +207,6 @@ static void snd_usb_soundblaster_remote_complete(struct urb *urb)
 	if (code == rc->mute_code)
 		snd_usb_mixer_notify_id(mixer, rc->mute_mixer_id);
 	mixer->rc_code = code;
-	wmb();
 	wake_up(&mixer->rc_waitq);
 }
 
-- 
2.51.0




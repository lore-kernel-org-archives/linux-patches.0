Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF64A31E107;
	Fri,  9 Jan 2026 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962006; cv=none; b=mNvORqgG+yva/mFYv39RTL+fPxfDlgZvI8Ssn16l/DC4D269HQoxOzqibtSk6HkRfQMmFqx8g/bQJXg5irwczKmG0mRxYQuVMA/2jdbFEjNn6YmMzzdCdiizTEYQAIShy/bV7BW3yjxd91WodUYLaUjZ4NvsmFtwjUQgP5BC3jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962006; c=relaxed/simple;
	bh=t8sqWEXoiKdAJZPGWLic5QzMVVLfnLT+0DrYIJtyqp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD9XtPa6pAmpzUXLmqfnQS0qUE3mqtTYB9+XfdwFQf+BikaBLyHsd3aQaiVC07hhBaBAT35OXZ0bJ0V45ZoLHWQ/rKzNTMKg5YFTxudvG8OQNNWRTmJRnQghKCFpPvlovqewCl5AJie0sSnIxf+oxHjf5x3iaeGCCaQAX6ashZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZ2RMn+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZ2RMn+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE8EC4CEF1;
	Fri,  9 Jan 2026 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962006;
	bh=t8sqWEXoiKdAJZPGWLic5QzMVVLfnLT+0DrYIJtyqp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ2RMn+3hAGCtVYvKdbpiwOvN0qFAc4KSFcFczMLKBkF9Vm/pMqYs/dJ76gJI6/Ue
	 xGxIWXshmazqpeUItvpAFm4exrNvXMxTQOggT/z/dB/j1TtwyHs0f4nhVYUPht6OFc
	 WkQlTwFCylmWUC6/m6mN2RbU3SriWYaVzEzPMWZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/634] ALSA: firewire-motu: fix buffer overflow in hwdep read for DSP events
Date: Fri,  9 Jan 2026 12:38:04 +0100
Message-ID: <20260109112125.190409568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 210d77cca3d0494ed30a5c628b20c1d95fa04fb1 ]

The DSP event handling code in hwdep_read() could write more bytes to
the user buffer than requested, when a user provides a buffer smaller
than the event header size (8 bytes).

Fix by using min_t() to clamp the copy size, This ensures we never copy
more than the user requested.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 634ec0b2906e ("ALSA: firewire-motu: notify event for parameter change in register DSP model")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78810656377E79E58350D951AFD9A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu-hwdep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index a220ac0c8eb83..28885c8004aea 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -83,10 +83,11 @@ static long hwdep_read(struct snd_hwdep *hwdep, char __user *buf, long count,
 		event.motu_register_dsp_change.type = SNDRV_FIREWIRE_EVENT_MOTU_REGISTER_DSP_CHANGE;
 		event.motu_register_dsp_change.count =
 			(consumed - sizeof(event.motu_register_dsp_change)) / 4;
-		if (copy_to_user(buf, &event, sizeof(event.motu_register_dsp_change)))
+		if (copy_to_user(buf, &event,
+				 min_t(long, count, sizeof(event.motu_register_dsp_change))))
 			return -EFAULT;
 
-		count = consumed;
+		count = min_t(long, count, consumed);
 	} else {
 		spin_unlock_irq(&motu->lock);
 
-- 
2.51.0




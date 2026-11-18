Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046259;
	b=Yd575KrVVlVXL2/YivnySoOvJP2oLudkI49xgwGUa8eeXg3I6q85ml3MPF/bj4Gv2Arl
	 0y+ZCGOEdz7lRkEywLYkGZXOy/QI3CIkPFcxE1Tf37r3W2/RbcgBxh6iWweEqhdwVEPsr
	 rSXIU6tvKpu4drkNjBhoyj9s17ridY51LPge0CaXpixxHtCSN6mcJFOLgsw/jtBhCo9g5
	 lUnCgPG7ynNNmvMTowWIduw9kbEBCsahbtpEb8Q4wvdTcULz0jIopqAbx1bIuqQH3j04N
	 tenKbmle77IhANq4liQ/fx7HGHX28KAeJjWuz/tNssuRSTfrGnsjfg261oTIHc/XGMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sFiz0bklcKk5zFN3dWY/nxRQEp8zqfbPj7lW+El0jF4=;
	b=SWlg6c+3RUkWM23Xtz52HMWwe4TkJ2VfGW35IlMpCtS/5C5eJalAI/9KbKpXv03nEGSu
	 RWy7iVygJt7Pp2mnN+aCD+boeJHHUGBwQxZxQ+2keMgrdSdUo9ZtwV5VxIl0mnk0DkROg
	 AuG2Z82/UeIR43TVbXWVoMhWtJuTG0TXB4A3ZQYn6w+512u4IqVyKyX+ceJsMLnRgInxa
	 rlEznB5xzHUrNc0dVUCS/ijXpNaT8JOi0j2dsedGq5g7lS+eUPNwfZ7nVpD5KtAsKQkBU
	 R2dkb8WufjrDQ0ah+Ft+AiORTGhZfiOPPWL8cEVqWFMJazAyfIN11Nx+w6l2mllok7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9DVQVhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE26606A31C;
	Wed, 18 Nov 2026 23:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9DVQVhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18401F000C4;
	Wed, 18 Nov 2026 23:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046259;
	bh=sFiz0bklcKk5zFN3dWY/nxRQEp8zqfbPj7lW+El0jF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9DVQVhDIaIFbXo76mSW3q4R0bE2BNWbV1yMBikq32Pnu6dac8Ol8VfriQZYV1Vbw
	 TebrpQSt0RV7sqRbiOSlSYUaganbkNsNS+UlkICEPjFZKRJ0+alM4vh/5CCn9YBG85
	 kSJnqCh44KtspFchVsWrBSmx0SkyzdIpQa+PinAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1218/2857] ALSA: hwdep: Serialize DSP load requests
Date: Wed, 18 Nov 2026 15:37:32 +0100
Message-ID: <20261118150245.431630397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit aee83c204f80d56b4d55f53acdb8594308ddcd4a ]

The check of the loaded DSP indices and the call of the driver's
dsp_load callback in snd_hwdep_dsp_load() are not serialized.  A hwdep
file descriptor can be shared among threads, or inherited across fork,
so two SNDRV_HWDEP_IOCTL_DSP_LOAD requests for the same index can both
observe the index as unloaded and enter the driver's callback
concurrently, even though the device itself is opened exclusively.

This breaks the assumption behind hw->dsp_loaded that a firmware index
is loaded only once.  For example, snd-usb-usx2y hits
WARN_ON(usx2y->as04.buffer) in usx2y_async_seq04_init() and may
allocate the US-428 sequence URBs twice.

Serialize the check, the callback invocation and the bookkeeping with a
per-hwdep mutex, so that the second request returns -EBUSY.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261029084810.21910-2-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hwdep.h | 1 +
 sound/core/hwdep.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/sound/hwdep.h b/include/sound/hwdep.h
index 8d6cdb254039d..137be4b4074b2 100644
--- a/include/sound/hwdep.h
+++ b/include/sound/hwdep.h
@@ -57,6 +57,7 @@ struct snd_hwdep {
 
 	struct mutex open_mutex;
 	int used;			/* reference counter */
+	struct mutex dsp_mutex;		/* serializes DSP load requests */
 	unsigned int dsp_loaded;	/* bit fields of loaded dsp indices */
 	unsigned int exclusive:1;	/* exclusive access mode */
 };
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index e95fa275c2893..c4215f780389a 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -212,6 +212,7 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 		return -ENXIO;
 	if (info->index >= 32)
 		return -EINVAL;
+	guard(mutex)(&hw->dsp_mutex);
 	/* check whether the dsp was already loaded */
 	if (hw->dsp_loaded & (1u << info->index))
 		return -EBUSY;
@@ -377,6 +378,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 
 	init_waitqueue_head(&hwdep->open_wait);
 	mutex_init(&hwdep->open_mutex);
+	mutex_init(&hwdep->dsp_mutex);
 	hwdep->card = card;
 	hwdep->device = device;
 	if (id)
-- 
2.53.0




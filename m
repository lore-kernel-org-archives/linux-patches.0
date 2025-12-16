Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC49138259B;
	Tue, 16 Dec 2025 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888604; cv=none; b=Kp0TLsummdG0qpzDGaprKdxdToaXfSm5Fn8kuR8ePSOu3HFtHSsSqztj1b5xFMzz6J2ZP12zhpfHiwpsm+9qGpjjglGyZexBZQpZOvlGXoQ/a19cK1qSCBDVPbW9sZHdph/T9V417CYHrrzkRZyoSobW/neplan0Edi3+MIQhkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888604; c=relaxed/simple;
	bh=WbaS0FrP4/kI43Mm2lkPA4fHKBR5sD6Y3JudCDyXtSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSe+JOcx3V7wZX4XbHNFhhrqGRPv0ymkeWXMjRsKg+HN8fQaChcELAsRx0inDQYIZannV4UeKYOK3aVLMyz/Va8Txf9DXc1HcUEx2SHeEHUG2db3pC2YxggkKfOHZdagQ8fImID7lbhh9Nddi4s+B/NgqlkzMosvyVpNclpj6Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15HP4+wX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15HP4+wX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5730BC19423;
	Tue, 16 Dec 2025 12:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888603;
	bh=WbaS0FrP4/kI43Mm2lkPA4fHKBR5sD6Y3JudCDyXtSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15HP4+wXsJcG6lRazxCb9XmWnSWsgplrymv/a5rMmeK7ttG82GYMRZ7oo15F8QDnd
	 9KFdrjha4ljt7NEc9SQBSPKaIKa+NQiqTKszqDBt62aoQhA5SzVI2PFxI5L6Cpu1eW
	 u0K+8s9z2XQEn3A3IyOn9vyh4LfftjIXUCwp2H5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Junrui Luo <moonafterrain@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 583/614] ALSA: firewire-motu: add bounds check in put_user loop for DSP events
Date: Tue, 16 Dec 2025 12:15:50 +0100
Message-ID: <20251216111422.511970571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 298e753880b6ea99ac30df34959a7a03b0878eed ]

In the DSP event handling code, a put_user() loop copies event data.
When the user buffer size is not aligned to 4 bytes, it could overwrite
beyond the buffer boundary.

Fix by adding a bounds check before put_user().

Suggested-by: Takashi Iwai <tiwai@suse.de>
Fixes: 634ec0b2906e ("ALSA: firewire-motu: notify event for parameter change in register DSP model")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB788112C72AF8A1C8C448B4B8AFA3A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu-hwdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index 6675b23aad69e..89dc436a06529 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -75,7 +75,7 @@ static long hwdep_read(struct snd_hwdep *hwdep, char __user *buf, long count,
 		while (consumed < count &&
 		       snd_motu_register_dsp_message_parser_copy_event(motu, &ev)) {
 			ptr = (u32 __user *)(buf + consumed);
-			if (put_user(ev, ptr))
+			if (consumed + sizeof(ev) > count || put_user(ev, ptr))
 				return -EFAULT;
 			consumed += sizeof(ev);
 		}
-- 
2.51.0




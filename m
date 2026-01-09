Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A159335BCD;
	Fri,  9 Jan 2026 12:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962089; cv=none; b=Y/slZFZH5BSnPi56MNq76mhuCwh1OkxPq4ed6W5g+qGZXT2hz7Fsv8q2BCav3yZ186Rz0L1J0n2Y7iVb5hcY6L4S376psAV80Wme9UWkgSe71RU8HstqPC4xf9rkQmNP0NGjMIZrffnNfQ36JUhdLF0f/82h7oaigDIoKTcffis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962089; c=relaxed/simple;
	bh=jevsbeaZ6sTiyIg3FPfyGkLTvScWMhmwzR6AfTNYvFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXJPa2ItwN6ZesmIRUn6HYlagdVjzRGOlfN2cnRQ32x7l/6RMKbX1uMvZydnM5EfaJG30rXXIZhh37MnsZa5TGMHBoDEdlqWnyfbYN8IZQZswSIgIWdevcj56GMJXK2psxsmBdphaQXBF2hTiVgyjaqijsHQxLQWqgTeufeX5Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceXFF88O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceXFF88O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF338C16AAE;
	Fri,  9 Jan 2026 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962089;
	bh=jevsbeaZ6sTiyIg3FPfyGkLTvScWMhmwzR6AfTNYvFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceXFF88OARiz2PYS5ixy1H5/hFPFlYhdARdudAS/k+woAi1mBkdjIOJdkECLeHAqp
	 7mNf21jcHutEjU8Sg8EZ7p3h9t3CnhHacivCCMkH8N4+eVb2x3dRfiy0yTqV6Y8kIh
	 UXA6hoRP1GCxU+JQfeqQsLjoQuhi9Ti/79OrCrXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Junrui Luo <moonafterrain@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/634] ALSA: firewire-motu: add bounds check in put_user loop for DSP events
Date: Fri,  9 Jan 2026 12:38:08 +0100
Message-ID: <20260109112125.339272452@linuxfoundation.org>
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
index 28885c8004aea..8519a9f9ce2c0 100644
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




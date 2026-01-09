Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0A3359F98;
	Fri,  9 Jan 2026 12:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960212; cv=none; b=IlNBV2/opP7/jSfc/C987TvXrfWT4G4mlj/s5PWt+bojAVahbDc4YQ5WThsn8hMadfhWweIAgSmH7KOZJ2tE48KetFuXWlBQOS6DMK9zWkv8KG2is6aE0uFHLz5pkfvTVjrGv6Yl8ivRaw9U0/UOiSckHvAnzkFvKLFYuQqXxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960212; c=relaxed/simple;
	bh=JjaBHS02mnB8Zbzr6JpM8VVvTsTwrQ8PGtBgrA9jkDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd0AdOh6V9fVPoeRqnPUkOJ5XnTAMVNoKIU/dfE31qnTQ6a4hoe/3XlPEt9xCI7KVr/TgJMgpk9nIgqfWWz1iV6qMTNYuSyrcGpLPFAZpGls0UkJA/7atU3KPN8Uuoy+ntwT6AwUWSbsD8POshQOj2oLbXaX81rIkJggu06i25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i22bAeBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i22bAeBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D9BC4CEF1;
	Fri,  9 Jan 2026 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960211;
	bh=JjaBHS02mnB8Zbzr6JpM8VVvTsTwrQ8PGtBgrA9jkDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i22bAeBNJQ/FUeedGeclFc/ha/SvNAQLavUdT0+mDNfnpPLpdX8xH6PVsr2Bj7cD4
	 PgPb+5QKvMC3ljhlP2XDAqfi0lG6Mkf3JZiFs4TfLTm0hF8IFErMVdKe+/kU6jqlcd
	 MgFnIxKU1eMrUU0qyw/BtUnzowkLhY21pI3OJlc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Junrui Luo <moonafterrain@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/737] ALSA: firewire-motu: add bounds check in put_user loop for DSP events
Date: Fri,  9 Jan 2026 12:37:01 +0100
Message-ID: <20260109112144.621483135@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




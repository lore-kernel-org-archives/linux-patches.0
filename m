Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE0A3B3BEF;
	Sat, 17 Oct 2026 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256429; cv=none; b=HB1WIVTepKc0EqnqQg65wOPC+qjCa2D3NVmA1tEOMz0zaMklTZG5WIxgaLlP8yIWHkmNblEYr5LPo7vslPCCu0t/h9WQhRJhv/F/Fq4D+02b/xEm2cyjNsE/hAjz8+3FVmifn90lPqREbQk/9SqJ/9Jvv9v0vQuqmEURO9fsneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256429; c=relaxed/simple;
	bh=qTPniev/nbGo+CM2rsbM800QRBKqO+y/NtT19V4UwY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw7i9S9AyIbZ4rssfHQsuRvn6p4PY6UDmy7jYPtTes6i2KkftdB3h7GDdtstjGaLeIkbiK4H5iiAqYorrB8kaNq/LB2Pm6uvVWQ2Q5wMXLB5YJ3XbtoEcqtQnXJtubMhHbEiVgYvsFXbwq743sr7VgTAofyTakY2BqJra991v00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlAmR0r7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlAmR0r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47D31F000C4;
	Sat, 17 Oct 2026 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256428;
	bh=Xd1ArsdhMBYEKD00TtfbhI43kmUa15SXVNBbQC7lbSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlAmR0r7jBpTxVVf7AqD1v2x3DUSxvZAQ0gPXRscFlCXs9PPPq5hIsmCICfYI/UMP
	 KqH3JH/ULfYk4RXZ1Qwi0oVBdnf9QSoIiva3yLaDzBgUO9veo5gX3Ca7HBY44Ct7r6
	 5Hb/BNmqO7coG+rb4hYkwqZ0KKyM6zQdoHbRHpjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0233/1674] ALSA: core: Define auto-cleanup for snd_card_free()
Date: Sat, 17 Oct 2026 17:41:45 +0200
Message-ID: <20261017160437.116127522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f1d565dc92955f05383794e0fa27e61ee0555027 ]

For the errors at the probe time, we'd need to call rather
snd_card_free() instead of the snd_card_unref() -- the former calls
explicitly snd_card_disconnect() that cleans up the registered
devices, etc, while the latter may leak in corner cases.

For convenience, define a new auto-clean with snd_card_free.

Link: https://patch.msgid.link/20261001151039.592033-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e6229c0402ea ("ALSA: ice1712: Fix the error handling via auto-cleanup at probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/sound/core.h b/include/sound/core.h
index fe955fb238e59..f9d85dd653066 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -316,6 +316,15 @@ static inline void snd_card_unref(struct snd_card *card)
 
 DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
 
+/*
+ * For automatic error handling at probe time, assign the card like:
+ *	struct snd_card *card __free(snd_card_free) = NULL;
+ * then create and process as usual.
+ * But, don't forget to clear to NULL at successful return for avoiding
+ * the unexpected cleanup!
+ */
+DEFINE_FREE(snd_card_free, struct snd_card *, if (_T) snd_card_free(_T))
+
 #define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
 
 /* device.c */
-- 
2.53.0




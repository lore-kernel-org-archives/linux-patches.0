Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A94B3F6C42;
	Tue, 13 Oct 2026 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894948; cv=none; b=YQ+GdFzFtx0TtZzeH6J8ZBFx0SL6LIW8pL0+qawr/uwOCGpeZGz8LyCYlQ+fuuwqhTXQZkCGSRMgOLf3s43KKkepHhGgWR/C32cbjUcN+AKOQPrqW9vJy9/H9jfes3zTnFzariev5Q8s5jhmp6Mh+/uHVOtYIuXYqUAm7v/mw6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894948; c=relaxed/simple;
	bh=b/+8MAque2HDsSULQHNQlem7kRKMgaWd2CgBvTbfyrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/nVa4chygzGmaGCgNh+QUVqPaJGKsUg51UnTbIiWOLiZWNw5BUZAruSgSfWIJ48CwtqAWIJWkWRjwh97gRc1Z0kU2u1MbVnwNdvN8ljLYMcevu7D1QDI+ow/TcPSdh1i2m3X+Li25VuwJbr8iomW6rtJHTtvg0nqQNWXvAL1Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+xzF5Kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+xzF5Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D681F000FF;
	Tue, 13 Oct 2026 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894947;
	bh=KJCaF+q+0xxZMYLtN7eZLgSXo8Px8iJP0KfdhtveeNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+xzF5KkfLQsrDom86k8moQaUBMbYU8A+zouI7zftlOkD5/QfX8eQIDCc136STA0A
	 jybOD1ly2YC5hXknPInikXBrtkqsJfo0h1xKwO9MTF2kRnElairXsYVQIwIbB0gxqz
	 WzCsJCVibELC2OOl6kfcxah4DITqHSphnoOqt6X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/497] ALSA: core: Define auto-cleanup for snd_card_free()
Date: Tue, 13 Oct 2026 13:34:37 +0200
Message-ID: <20261013112910.502359546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 0fcaa1cda1663..0b7aa6755e2be 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C263AAF69;
	Sat, 17 Oct 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256435; cv=none; b=l2P54sxIo/GHJTlUcJY/hNXnBpsGrI2wdaPHN4rIe7Z73G/xV44UP0QhHtxrFUBdHxwUjZGPajNhX/0FjXDcmN5KOfXlCGV1d2STjGIANjOWn06qvCTh+xANyevmN4obzxhobV96rWgrsClrufR4kX3+klx4N3iZ2L6bWsXRdT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256435; c=relaxed/simple;
	bh=M+MJBxo7URXDXj9qVNBBEKaAQlDcMNYrHkvIQMmCaic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMLm7OrhFVh6rYuJHJwHQdZ3lxJ/41ankmkysWNIiKlMIpjR/oRrtT1bJTFc4tQjrDIYtTBkEgUZ2uwmzcvVCS8Syhl6P5hbu5ZQO2c/vk/4lX7G6FIy3ae+kwqC7pq9l4LtkWa7gSXXbjIgHlmMuSQ6ufDWFp2Im3QG4+E9N1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyGm/ufe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyGm/ufe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B941F000C5;
	Sat, 17 Oct 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256434;
	bh=zLmYqbmrPCMkfkcnH5T7mxpO4VYgFEbPa+jE4NNuV9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyGm/ufe8oe81+oV5tbAX7Olnq4St3cad+QfbztSKkPhzrcrkvrQKUlvxu1PmIUfx
	 wLA2ZMgkZyJmx1oAYKFAeubysmU+GLdlcL/xW7s2FfAHOcMYzejRfyXof4SB3RTcXI
	 g3ROZ8j8sLdd53rWfKJ/FETBTL3zFC2RsT6IhsQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0234/1674] ALSA: ice1712: Fix the error handling via auto-cleanup at probe
Date: Sat, 17 Oct 2026 17:41:46 +0200
Message-ID: <20261017160437.141220605@linuxfoundation.org>
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

[ Upstream commit e6229c0402ea4863ec74802d79d5b52b9398d66c ]

We used the auto-cleanup via snd_card_unref() for errors at probe of
ice1712 driver, but this may be problematic in a subtle way when an
error happens at snd_card_register(); since snd_card_unref() skips the
snd_card_disconnect() call, it may miss some resource clearance.

For fixing the issue, use the new __free(snd_card_free) instead, which
does call snd_card_free() explicitly at errors for avoiding such a
pitfall.

Fixes: d736eba9c453 ("ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup")
Link: https://patch.msgid.link/20261001151039.592033-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ice1712/ice1712.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 45cb3e7b8d214..ce1758ad7200c 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2549,7 +2549,7 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 			     const struct pci_device_id *pci_id)
 {
 	static int dev;
-	struct snd_card *card __free(snd_card_unref) = NULL;
+	struct snd_card *card __free(snd_card_free) = NULL;
 	struct snd_ice1712 *ice;
 	int pcm_dev = 0, err;
 	const struct snd_ice1712_card_info * const *tbl, *c;
-- 
2.53.0




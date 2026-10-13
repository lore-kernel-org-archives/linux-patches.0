Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776D442B06;
	Tue, 13 Oct 2026 12:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894951; cv=none; b=sZuDdM7W7PCUx/lvCLXOwShUVfF4gvgEGPm9rLCaDAXIIdXulQfP0+UFvzN0PohjCMohhc9m6aSjsRpR4RsXaLwCq1mIHNGcVekO/CdfGHgEOXjYIUF8ve/P9qjKlO7WIxr9cQuIUhw7jR06kc/wCKPT475wLOd8Bxzj+6YuLo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894951; c=relaxed/simple;
	bh=SO9m0sqGr1v3DXDV+HAfsQQPGR3R9jNjQ6Ec00gVJ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEOM0yeQGdFxEEvOHoI378kOCjK9QyHPCSlL0hJMYGDcSTBHTwtYq003z41ULeSCWoRxhSpYx2/DrM95DgCYxxBRpCjGD0a3szOEhMSbtI4LjKpqGDI8bEOwm1RiaOuziIerJahcOOFZIZ+kp4Ec//ncjullfufVuthFlvRroEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9DHK66T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9DHK66T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1571F000FF;
	Tue, 13 Oct 2026 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894950;
	bh=MIp9Nc/fab68jIbArG1orIj5FA0znrXYXJ+2cdfS2xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9DHK66Tt5yDJpupX80jXNhoJwGQ2iolJ7PqyIYtHfA+UQj2HMs73ibYH4iY9FJmb
	 6zbLLP6NfRTPdvjYy2sd4gcBJuy2pkPFVXXynOia4vSlBmwK1W0uvVKGSabYeIFJsV
	 pTqoH0xQ7V6qaXcJ9f5W4IeYIxKKq9YHekpEbe5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/497] ALSA: ice1712: Fix the error handling via auto-cleanup at probe
Date: Tue, 13 Oct 2026 13:34:38 +0200
Message-ID: <20261013112910.525625686@linuxfoundation.org>
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




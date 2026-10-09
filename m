Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55773231C91;
	Fri,  9 Oct 2026 14:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556338; cv=none; b=WdUYb86jIjbaP+0HN29j5gu4yWoS1Qnci+vGP2yRNYYNbZ3AG6urAYLiGgToFQHVg3YzGusOl9bHRfbj6YK1VVDMsv42NxmzhcMrm18Eer427/50sl/vIdRboy1dI51In2GkHv0rsoBOf3aMb0wDsgaxs3W1QMPJGeFW82ZAzik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556338; c=relaxed/simple;
	bh=rDBKMNUagHydkt0AZ2Lv2T9RSmhcxSXEbAu9ZBskauU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSq52D75FvyGhG8uaGY2y1/VDsE0jgssNpeOgM+z+VgL/jALDbsJ86JIEsyvB17JK7NqTyQjQxlGIvSXdc4b/fEN1uk/pXeCLolJ6lbE0Kad3U8CRR+W2jNyxac0P7OviLWYr3Dc05TcvoGkEbzx4VoVp5QvA8WpfKYuHOsfc0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuMVZXLQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuMVZXLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61621F000FF;
	Fri,  9 Oct 2026 14:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556337;
	bh=7zXHNQ+IPt9iTjRGp9VsA5+DY+VPCVzh+Gyc6YFbXtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuMVZXLQEkEfvoUgseDNJzMK2gc2ipiaSILo9B0TVO2cJ/nLlo66UK68I+wQ5MyI9
	 C7Q+8OIggh98NG49oX2ozBUTAthzBPdkso5vu1nD15j/0qIBVMtssnyrqsVe16+M/a
	 F1dhipuwnTfsK344eZUF5F2AGR5DuHHzNlXqdo6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 160/428] ALSA: ice1712: Fix the error handling via auto-cleanup at probe
Date: Fri,  9 Oct 2026 16:08:17 +0200
Message-ID: <20261009140949.676270278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d6bfd8fb20e65..1fad8c418132c 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2523,7 +2523,7 @@ static int snd_ice1712_probe(struct pci_dev *pci,
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




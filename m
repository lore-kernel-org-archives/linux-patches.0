Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D3E58B6DC;
	Wed,  9 Sep 2026 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963512; cv=none; b=lgzSdJQd0v8OSiLmdhXi2SCjH3iMPoa37rqceCbolDEuxUyVDUGa9lUwE/Z3aPjCOjV0hrqCNySyNl4q1LSFdJerW1sSTevmTCw/PLOEHdpcy3E7KIjtrA3oPdj0bMGYH068hE65L5qEP6uTUFsEcXPvBQYD2rPNn4wsJwiff94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963512; c=relaxed/simple;
	bh=3psEtLFAdUCojFRiSPcKm1wgfMXsRkEsucalyKndPgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvqPl3MiaBHHb6PV9lWFZrzWiUSA7M90Dn+Qh80MfOIThICaionAuKkiQaM41rQzAF+5y51WFC2drTmiuFC638HBl/4i3K9bR+pKcSFpjEloH2IzRFEiRk5AzwBRhdAeSWNZK/wN8T1adms9+Kd6Rmfp6yb7XctVfCee22mauk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxqByJ5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxqByJ5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8551F00A3A;
	Wed,  9 Sep 2026 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963511;
	bh=jxp8IWo3Zytbslgk0BGiNRyGL8C35/ikDT/kVbR25hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxqByJ5rgk0dz005KcPYVj4NCd/H/47T5o2Lt98v3rtazN8Wdg+98TonlgWtuzhB1
	 8C6j9faqyUkJzMzt47sJ11PYNJPp7Y9uOC38VX30/qQXFEzg3omHo/1nRtBnhJ3nPa
	 EZvXFi9ynJ8lkxASO0XGUMsLZTJoKZTZJ3skaR0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 104/583] ALSA: harmony: initialize locks before requesting IRQ
Date: Wed,  9 Sep 2026 15:36:29 +0200
Message-ID: <20260909134241.731775389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 33abb7491e89285a41565670945293dda841afc4 upstream.

snd_harmony_create() registers the IRQ before initializing h->lock and
h->mixer_lock. A pending interrupt can invoke the handler while these
locks are uninitialized.

Initialize both locks before requesting the IRQ so the handler always
sees valid lock state.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260830063411.2215691-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/parisc/harmony.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -868,6 +868,9 @@ snd_harmony_create(struct snd_card *card
 		goto free_and_ret;
 	}
 		
+	spin_lock_init(&h->mixer_lock);
+	spin_lock_init(&h->lock);
+
 	err = request_irq(padev->irq, snd_harmony_interrupt, 0,
 			  "harmony", h);
 	if (err) {
@@ -877,9 +880,6 @@ snd_harmony_create(struct snd_card *card
 	}
 	h->irq = padev->irq;
 
-	spin_lock_init(&h->mixer_lock);
-	spin_lock_init(&h->lock);
-
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, h, &ops);
 	if (err < 0)
 		goto free_and_ret;



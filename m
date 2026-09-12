Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED618425CF5;
	Sat, 12 Sep 2026 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213257; cv=none; b=jLq3uFRV3A/S0O8NHGOkBs28oJ7a21HhAfn7EvBALFvhSnLUEYWgdqSP98qZadpCmZlXX9r3TzzRFZNJa1eiFqO9b5GwU+N/jRLO2I5EKkMFkCV0Y07x3AH52H3lphM/2Mbe5gUm7F6zLd/subHX2kd6XZudPw5l/tq8CnR9Kis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213257; c=relaxed/simple;
	bh=ti2D0dEl/n2ai/W9UQZSymRYOvZyMWUyBSqP3MiMnl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Soyzz/RckfFfVAmFaSnKJSOtRvmZ5in3XhhPToid/zaFtj4DwFy4Te2MT6Isrd/tv+hNYeceUAAhXRmSssmjiMUSFTDLojKvGC89Vls7LiFS9o+n68wKGzsw6u0S/MC1ilEIJddq2JKjWDcKg1UHPgUWTXD1WR5Bu37RoQLPX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8Dy+Ftc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8Dy+Ftc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEC31F000FF;
	Sat, 12 Sep 2026 11:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213255;
	bh=ALmN/uL/mRAxXqL48hWuOwTQqG+8VyYLWDGMVUqOjIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8Dy+FtcIUVQoF5hYLQ+rhxKspuGp79hgR81r9d0WLb+iBxqkmAB2ZS64qXvx66hz
	 v5n1S1pXudALLdQPQIZq8Bs18cWPAK9YcLCCd26dfpaJk2OuBAMP8FVRDWQiq3ZO1t
	 FtlzjeVMN8Hk7MsOYuKIuilZMBrdtZp/eC/WB3SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0083/1376] ALSA: harmony: initialize locks before requesting IRQ
Date: Sat, 12 Sep 2026 08:41:49 +0200
Message-ID: <20260912065609.409038273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -889,6 +889,9 @@ snd_harmony_create(struct snd_card *card
 		goto free_and_ret;
 	}
 		
+	spin_lock_init(&h->mixer_lock);
+	spin_lock_init(&h->lock);
+
 	err = request_irq(padev->irq, snd_harmony_interrupt, 0,
 			  "harmony", h);
 	if (err) {
@@ -898,9 +901,6 @@ snd_harmony_create(struct snd_card *card
 	}
 	h->irq = padev->irq;
 
-	spin_lock_init(&h->mixer_lock);
-	spin_lock_init(&h->lock);
-
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, h, &ops);
 	if (err < 0)
 		goto free_and_ret;



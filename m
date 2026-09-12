Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BDC30FF08;
	Sat, 12 Sep 2026 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221378; cv=none; b=Nr2yfVM7O8Nn8IEF1IHAsSK1ZlsA2/t9lPbrAD5ohyxNNXlVaH9XQeO6bsAtKnneKNJX/tYzaVorRikqH8zL8PzWiutNKM0eNTNc194m32SAB0gdw34NkLaJcl3F81pCcMMT8kkshRcIriPmu/29OyjxcaX8MVWteBARfqpOgxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221378; c=relaxed/simple;
	bh=i5wk7lMI1BIljVUqiqEkr+gEgifdmvY2QyXQr9ka8TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F99GEtXIfQR8JB5IpBW2S9L8UamJVkFdqFVk3txYSaTDPy+sjSEKwaIC1/l0XRs9Y2htEPjaXdxc9OZ1JyyNuccBLF7ts8vLylsCggvq6Sur875OHRcIyhOAILRPiP2o/Y1MexYO2O65NUU0+rcE1rhQavVoF3RD6Z8YJtG5w/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRir+/U8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRir+/U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CA81F000FF;
	Sat, 12 Sep 2026 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221376;
	bh=15XQXmwaZVp4AMRgKMnhNGEts3rRQAFq0rEJvLjcq4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRir+/U8a7S+8lo7Feik3h3Hj/OguVdjZkRHN4N8i7fei5l06smsIC/uE1Snjx1MB
	 J/BcA4pHdy3zEFV+zaO5+c8COLh5aV4U5EhmGyyMMO+tPfACZU5nI4fYUHs8O0dmcY
	 jKcfLvNxwdLclI3OSIRhOmonZ2R+ztTsqFIqL4Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0370/1424] ALSA: harmony: initialize locks before requesting IRQ
Date: Sat, 12 Sep 2026 08:46:42 +0200
Message-ID: <20260912065615.579188410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



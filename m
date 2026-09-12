Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9C2471249;
	Sat, 12 Sep 2026 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228044; cv=none; b=MjdbC47M41wKgD1GYtn9qeKrWoVSyw3vPuqAgumthp83FEBZyRUoCfFfuj8iwmW5AXQmXUArrBCGcbTR7TSLBZ+aT111QGjGep8GO1hEXLBw/DywmlTFIXbIESk/PYALhrGv1WxzO/sx544DXXbeFEL5kxjbEKgLfeSO58KAEFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228044; c=relaxed/simple;
	bh=d8rhm3rSDvibE8F+AC+C99NGfjpl8/IsvtCtk1tK0UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjfybBVHGEBB9NoDK44cq5ocA1Ss5jGrBFo8VJuKvWfInoR1vhfW9uV8cZsr1/oEQpHW1Lxk+VTdEFM95uw7xpCvoONJycHz5ypfoMLbmPAGOzUIXz2Kz1ZYY1zPZGFmdLl67NGH7NCQY3se0pSOe2LPXWZyr2eGu+44AX28r88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnWYj1Fg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnWYj1Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7521F000FF;
	Sat, 12 Sep 2026 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228042;
	bh=mRguxVS3OwUxBKmq6Hu7zeh/5bHd7bk3XfB8QAWfS5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnWYj1FgyH1rUlmQ3Q6zDYpIScCaZyEGYTgxk6zBFEg5ctUoIH2RVDFA5DS3qD8rD
	 bbZwFhW/7BLSePeATIXxPWgAHYvPt9kM+z3cCalWjOplcoAseonnse4ceYIpOtuWdQ
	 qeshl+Nx0R7eCIIKWUTx9CmDPpVNcNIlAo+yDvRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0305/1191] ALSA: harmony: initialize locks before requesting IRQ
Date: Sat, 12 Sep 2026 08:50:33 +0200
Message-ID: <20260912065555.085739559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F337274B46;
	Sat, 12 Sep 2026 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237639; cv=none; b=StZ4mGMSeGsxh8o+LgLA1OqYALUdiHKR5taI3pzqPH5VHaba96Q0SFcO2Jg3FaaeOs92DFeA18kfNyrPDs5uowU/Q3UyNizWeU/V/heVxGJAgSAHyFcalygAGQ1pqYjNjpN35Ly1KYcs5hLLK5z//W/sqb35JMBHjP9RF20KhTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237639; c=relaxed/simple;
	bh=u3NpCq/QwpozPgIjW7mCBgTotHNqiPUtafOCGF0O/io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4Ok6OmFvd8VZXFUsRynLmy65UwJNKQNCjFA6K7JmTVkptgF7BxhKDhTBALelq4wWzjEPMtbQOu5a5sT/BBJfyquPaHvXgMw7IP28cn2rV69ZkNS01pUBuklPEcY8nnsl5MF02GIeyQphk0siUfmDDYe0fp8iH+8XGWRYX4tjrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2VLeRT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2VLeRT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A951F000FF;
	Sat, 12 Sep 2026 18:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237638;
	bh=xtp0oTAj/WYWO91Bo68rIo7wbD+shLY7G9mT2SW+BK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2VLeRT2QHzO/bnorZwe5eJjDsj3pDtbHHXEYkMadjAK+6+V803gWHCucEdo/TLvy
	 vvlgKrxn4SnyLU3hCaAqBNHjC46+oiUFj3d8nLsGeIvvpUn22KqzaU7CfLAyU2G0Oi
	 dKw88Is6zb4q9ollhARTifNJNLTmCwgRAv17E+oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 262/935] ALSA: harmony: initialize locks before requesting IRQ
Date: Sat, 12 Sep 2026 08:54:52 +0200
Message-ID: <20260912065532.834428666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



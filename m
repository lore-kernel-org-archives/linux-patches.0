Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD1563FB7;
	Wed,  9 Sep 2026 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962034; cv=none; b=O0+djucSTkaCSrKu1/oAa3eei5EvjGxUPe2IQYnebzZG6tprQ4t9dWdnSuythngXno4RqN8OQWRlWysXS138TMhgJIJEUAo8H+AktEffQ9cKIAgDtBRMrHhh8wjWwElQLvib56DxeqJXk+ot1IHfvmRt3fycsazDSxXKVmdXGSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962034; c=relaxed/simple;
	bh=1MRB9vs/IH4oJaOcf4EysXSGAwzqm3henCpR1HNU3rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEXaR6xlvBT9CWLzJDPCokzWv7d2k0hGoMQz7Kya3uhLB5YG1bGFwAjMJO/smHZ/z0tvP1Kz5VhWNwbQPoHm535ef/0z/amf4dEFbjeV1Gj8/1bNNagBK62SxZjlQdTSafrCioPpCH+EhOzffu2FR4VGm+Ag/ykddn7fcyeu1OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuR9v6Pi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuR9v6Pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628E11F00A3A;
	Wed,  9 Sep 2026 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962032;
	bh=w3E0S3x6Nov0qrr5vTrVJhcJUzpgr+Jb4x/VnQRsKAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuR9v6PigqQNJaFG0+IdcuBDGm30/ibUBS4FEntyBpaWIg7lSIf0BXrE/DOWQYJiG
	 A5s8cGDo76V9jRnAda/eSUl1bZ15QEsJsE9m11AUbjC/oQgeTx3YOt+K56k/Jag3gR
	 JARds1Vtw0DyA/qGbP415N49Ftyj1ioSsLlpkVXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 150/556] ALSA: harmony: initialize locks before requesting IRQ
Date: Wed,  9 Sep 2026 15:37:10 +0200
Message-ID: <20260909134235.713120253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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



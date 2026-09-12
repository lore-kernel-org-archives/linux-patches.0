Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CFF331203;
	Sat, 12 Sep 2026 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227659; cv=none; b=T3efL1rMCiYgPhbAYyy5At+CEocgmEwd+BGZLiyeB/nbbLydGZYcDTvvLwJdO14uYjdQHRRwo6dv6HxOZ7ccoZZs43wNVeJE+iF766YrTPjcpYzQk334dKduVeiGG1ZRwC69e7c7mJl9I76ec5GB3s/AUtiuhB1KF/MuSb9P8Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227659; c=relaxed/simple;
	bh=/qBJA+qhwp5QLCy1FQrZZCE1FrJMp7+P+iE8zHR+ltI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiz/rpeCLo96Vso7j1wOofJrxT8UH+00ejXt9MMklXfSnHvVu8Jy6GrVMgb/csczpD0yCQOaNHELk7aIH4bNsFn5y+4RG1jfxZkIbUdi1aY36Kjp3hRPr0aYMDGrJvY51R76N5hoAkkNqxjMQpc4n0X4OX8faprfG8uwlsQfJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuE6DN74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuE6DN74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399151F000FF;
	Sat, 12 Sep 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227657;
	bh=CRf1ove962rlshkf2fYgPOS3kUV/cRIcx3o+Ivz7Ihc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuE6DN74WAhJV6GNzxC4SdJXSQcZbGyfLk7Uob6YLF6tWgKRUimVf18bZFNAuHKkz
	 4kuYiT7ItFLUjr8EcuuEsqIEHo6u0WeYdlGwsROZuYsQuKtuI+STE35ZIFdYsUCgvO
	 we8xPP3976KM8buOfKr/K3Cu5eaahQDVH4bDzQKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0225/1191] ALSA: pcxhr: initialize mutexes before requesting threaded IRQ
Date: Sat, 12 Sep 2026 08:49:13 +0200
Message-ID: <20260912065553.265561820@linuxfoundation.org>
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

commit 6c97817e20598e5473094e0e38d1f51f1cf4dfff upstream.

pcxhr_probe() requests pcxhr_threaded_irq() before initializing
mgr->lock, even though the threaded handler takes that mutex.

Initialize the manager locks before request_threaded_irq() so an
early interrupt cannot run against uninitialized mutex state during
probe.

Fixes: 9bef72bdb26e ("ALSA: pcxhr: Use nonatomic PCM ops")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260818144717.2269918-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/pcxhr/pcxhr.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1551,6 +1551,13 @@ static int pcxhr_probe(struct pci_dev *p
 	mgr->pci = pci;
 	mgr->irq = -1;
 
+	/* ISR lock  */
+	mutex_init(&mgr->lock);
+	mutex_init(&mgr->msg_lock);
+
+	/* init setup mutex*/
+	mutex_init(&mgr->setup_mutex);
+
 	if (request_threaded_irq(pci->irq, pcxhr_interrupt,
 				 pcxhr_threaded_irq, IRQF_SHARED,
 				 KBUILD_MODNAME, mgr)) {
@@ -1564,13 +1571,6 @@ static int pcxhr_probe(struct pci_dev *p
 		 "Digigram at 0x%lx & 0x%lx, 0x%lx irq %i",
 		 mgr->port[0], mgr->port[1], mgr->port[2], mgr->irq);
 
-	/* ISR lock  */
-	mutex_init(&mgr->lock);
-	mutex_init(&mgr->msg_lock);
-
-	/* init setup mutex*/
-	mutex_init(&mgr->setup_mutex);
-
 	mgr->prmh = kmalloc(sizeof(*mgr->prmh) +
 			    sizeof(u32) * (PCXHR_SIZE_MAX_LONG_STATUS -
 					   PCXHR_SIZE_MAX_STATUS),



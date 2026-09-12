Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0EF3161A1;
	Sat, 12 Sep 2026 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220942; cv=none; b=A6yaRfz+3Ag9lPEgGSScXGBLB7SqDQFUGQNIxBuzt0YiyTHjt+mPaaVgtlVAjfWBO+VZ9piqFiKv4Xo/18NvbQBghJWfNzwMsKJ1gwGnRLduDTe3d2yPAIHt0L2IbUJMAlyGIOyaKFbei6nOqYnXsKH+Vo9tBUi+W4LIljy07Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220942; c=relaxed/simple;
	bh=3wM9NvpTABwa5LFoQwYjF3f/IYcCl0XHDtVnZFG968g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8HrZ2XF2hO3XdCZgwghGbrtWlkhjYbUJnwDwFnlICLBVWO3uhUmPNt6e3NzIwmCZTuH+ZVF+t3ajyzi4nNGlrlEPU6ixGZt4c7VqYJezGu+k4PzC5G0YUKFOK6Anh9EQbvz1DgG5y9q8fXAdxhpapZxlihmJF6HwNUoGbRvUnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWq3XBdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWq3XBdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A3F1F000FF;
	Sat, 12 Sep 2026 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220940;
	bh=TEpQn6HK4X0Gp8P0dCaKlOKg9cqSATw7eWlpXPWVgLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWq3XBdbNhBLkypVeA4HAedLJSVv5QkGdOrBTG9n8d3hYIPsN29PdZxBIZGnF3mGL
	 cx5Xr8S06n7EBpj5G46zALK9T1gPh8wFiCh2OdyNzfkYfy6/j41vbcdmB7QES5koVk
	 haNrzywJWq81UVzlsXSLPJjE3jLugaO5tKWCf4rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0281/1424] ALSA: pcxhr: initialize mutexes before requesting threaded IRQ
Date: Sat, 12 Sep 2026 08:45:13 +0200
Message-ID: <20260912065613.574068328@linuxfoundation.org>
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



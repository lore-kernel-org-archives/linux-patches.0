Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A553415F22;
	Fri,  4 Sep 2026 06:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501796; cv=none; b=q81p5EzplnnxHFCmI0C9Vwlm8EHPf1V3XeaouwCjeCO60qcfCZC+yLFCP15gAOkiPHi3pkN/46wQ/NDHl/xKRBlL8GMC/Nkr8PcGnF0VxnPgiPCVy8zdcHkhvnUzkttERCd3JTpLSf3qf0WFNVnH9t+yDY8JEjaBcTiZaTcPTcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501796; c=relaxed/simple;
	bh=Ff5S6GKOF2f5JIqo1mma/r5Z82Mt0Vk9PxR4b146nCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmlGLiFwE5KpEP4ki3UJVfHt+dE8TRO6lWqTxcQeUIkyMoG3QVRpRp5gsWjbYJvBmOimQHV7qS4HC3ncUCxN4Jfk0eV2CQ+lzIxMnIvPOuX+/Y8BMuNpe7MSKY/bFmW3jJXAaTQSsislfmeGtA4r2RMfA5nD9tPXi+E3os8oJwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdZLpXnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdZLpXnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647A51F00A3E;
	Fri,  4 Sep 2026 06:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501794;
	bh=Jp+CPd33NIeWi4FY0xeQBdqRfm6oBrvectsFR4IpWAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdZLpXnuOlbm3FoUof8CNfCQN6psMwWVNmgho92mJLgzYXRg3MeQAnUv5l8dBr38L
	 VMy/XM7c60kV8bW2U+uyESeiiidOlNBUR5Lza1e1vXyZcgIasCTWkXy18w3IxfPktW
	 spy4IX558LbQZISFtNDNL1uaqN7jBCeD9HFOt+CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 492/552] ALSA: pcxhr: initialize mutexes before requesting threaded IRQ
Date: Fri,  4 Sep 2026 07:00:49 +0200
Message-ID: <20260904045801.815725700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -1532,6 +1532,13 @@ static int pcxhr_probe(struct pci_dev *p
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
@@ -1545,13 +1552,6 @@ static int pcxhr_probe(struct pci_dev *p
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



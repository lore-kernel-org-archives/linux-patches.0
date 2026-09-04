Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9613815E1;
	Fri,  4 Sep 2026 05:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500073; cv=none; b=PHq0Aba5ReYhJOYokqBS5fwjQtxdIHWwd80/DPxonMZiqCg4Q3POjwsGqEYKTFr5PhEVvuLFFuVlmWARZzUcC2QRcGehwdoSs3ycHv8TMrX2z43h5OFSqmN6lRdD+LiUe1BWLkNi+R+dhFnLy5aD5OS+2qWJO6J3UCNWZPEpTkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500073; c=relaxed/simple;
	bh=4QUlXvpQGN56gOetXrn/na/jNrroffE3ptgk9lRcK0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNLB+89YzZzDF83zo7uKWzIflve8otTPanHs3OQ2g1Egpg2y12l7+f9JMDw7mUEPIkfEX04xot3KBjx30VQeyKY5G5scLRmPZ1VLT96VKB2ESoMk59v+WGR3z57T7e22hNbXlkUNuiJ5t9aJAOsvrtF35fnZX5qxSUzWInRgpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZCOCyIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZCOCyIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126181F00A3D;
	Fri,  4 Sep 2026 05:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500072;
	bh=t/EQVacGfxRK1draP22KSQ2Gr+yEkx+zPFY6iuy5/Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZCOCyIXFTHgf53HCJjdDCWYTQf2IBS/wpz0Enanq190t442IWjgHpmwmMLeb6JTm
	 vq3Zyru1XzcXuMRaFj6jCPn7kQxL7gTlKwP3/L2YjqNrWX+Y5Jqk3EVLMv7IO0+TDc
	 XaPQz+uf5k96mhsxiWRdvFhp0GZMctRply2Zzhm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 642/713] ALSA: pcxhr: initialize mutexes before requesting threaded IRQ
Date: Fri,  4 Sep 2026 07:00:10 +0200
Message-ID: <20260904045818.221981835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1535,6 +1535,13 @@ static int pcxhr_probe(struct pci_dev *p
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
@@ -1548,13 +1555,6 @@ static int pcxhr_probe(struct pci_dev *p
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



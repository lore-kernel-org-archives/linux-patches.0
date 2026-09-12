Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF9047D451;
	Sat, 12 Sep 2026 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237115; cv=none; b=QkHlMnTPH+RUuKZxstkYtolMIEYgprMOaVfYK4VhlaAQT4tFkc62DPbsJK1PYjrogbuwcgG/0L6+vhhTDX0khL42bEHqWg/7aLc0s7vfxxrpy/lmetQGe2XMcF02C/iRi+mg9kttGYmYVkNOyDXS0gCqcyavmti+Q8ei5A9Srt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237115; c=relaxed/simple;
	bh=r6fMdTzkTT97Wc7cUTXW+aQksJWrmIYPodiSmWv0vQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSLKTjp4wk7uzL2+tChNeh5m4igmyaYCftCD2RMSJD4vFqqoV1FVq7SG4y0nIA4tMnR3MJ6qvF7+aiR/BYQxHPMIh3aQeA1UfGdkut0x+m/J4CSsQw4Hmhcl2IG1FsQWQzbnbKnWdr+j6Ha0FC+4fyGgFeHGOz6vtgWgoNQeazQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLcOMuiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLcOMuiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9739A1F000FF;
	Sat, 12 Sep 2026 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237113;
	bh=GOjKDCyg7fkT01PePmTEVPpok7eq+nQME+or4cgG6DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLcOMuiNwjUJaqZoR1nZVSBgaKFFG7BhbwMeBUh+oFI9eM9y10DeQCnBNlwWSFa0I
	 MOyH8L10kN//toao4RPTkTk2tN6geuhVJwCHPGBZiTcfr5ogytmVX41TakNhc9+fKA
	 DIS6GttLODf61ZL/PWvhpILm/687Qxjt7fzsJVZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 193/935] ALSA: pcxhr: initialize mutexes before requesting threaded IRQ
Date: Sat, 12 Sep 2026 08:53:43 +0200
Message-ID: <20260912065531.243550612@linuxfoundation.org>
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



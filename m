Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208309;
	b=RjYC2bDE6JxJ5PfuoN38GvoxDVP0cLeQ3H0JMDCXKDoMD3z5XDtPi/fMHpzuvThurBTm
	 P2mELkhIZRZlknO+WgWNKj9gc/DI/5LozqrxDD5Sre25uzeMh9cFoennP/jmBqZYml0er
	 UG95zo8zcJgQr86ck8u0cvCEJoTLzqNc/DRdUA+ns8LXpR3TDUAEZ+MAnJSxRPq/D/gqw
	 YnFKbdp7erfhCZabnVEDI+x5EG+Bn7Hrr4EswDULQssknagoC7aS2nGfG3x6HYlNnqGoR
	 jxif5z8ButCfsazQnQmw66Hv6VU8IHtovUhwscN2YB0npMTkbjTUMsMR5yAFVcpeFPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEKMHEAVd3+t+W2LUCq07IpywgOVsOsWjPIC5Kr8zg0=;
	b=QMQXqrSVeDDOSY45QFMAcHxJrNpe+44au1T2/Zh8hi86vxN0kidRfhXQc2/044jwyKVL
	 KpCRrDTcYhwWzqeIu0GLYb94FVLMSBPgQAEwmLpve5EY1GY0dShCoZTFfIVEBvX8sX86I
	 fTIzoeL9tYq5GlsJlSz2W2sCf6gCc8qCSpcgHra0KR4eskq4TDd0CX/CcMmcAyRpQVApD
	 zNAQeSsf9/mwT589jeISLcfBWBU9B97vZuyYljURWhPsGWhVLoIBS8rUPKTt4owTMvgrM
	 1K3qRcg1PVGcysbnpFVIuR3glsu7D088fD89lGa0mlCfMCMZolPpwUzv7mwDhBztHgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSN2RUo6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CE6606A31D;
	Wed, 28 Oct 2026 17:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSN2RUo6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEF51F01828;
	Wed, 28 Oct 2026 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208308;
	bh=YEKMHEAVd3+t+W2LUCq07IpywgOVsOsWjPIC5Kr8zg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSN2RUo6/pHpDTSJptocRH3KKMALy/hnJegkY5yPKnXQJIbF9yPOY43NQy3cDdhnA
	 tdTSBDWt42Y1LhfK8wu5O7aLM5ZBqB34dQryoYDvEM0F9sktFLIzYn1601ZnX434TC
	 Q6k70mfvHMLDkzpQFfzq9cDZzoVKMSpBiSJ1XEHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/516] ALSA: pcxhr: initialize mutexes before requesting threaded IRQ
Date: Wed, 28 Oct 2026 17:53:46 +0100
Message-ID: <20261028170005.275376581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 6c97817e20598e5473094e0e38d1f51f1cf4dfff ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/pcxhr/pcxhr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 1fe7e876c7fb4..318289a94ee21 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1548,6 +1548,13 @@ static int pcxhr_probe(struct pci_dev *pci,
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
@@ -1561,13 +1568,6 @@ static int pcxhr_probe(struct pci_dev *pci,
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
-- 
2.53.0




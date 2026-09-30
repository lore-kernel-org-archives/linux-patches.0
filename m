Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908104C9E11;
	Wed, 30 Sep 2026 18:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793334; cv=none; b=uvrUy13z4PCa7mXr1t0pJh+JfbBntMjuaA13AoepFZTFXDD5SqCRSe093HCWaW8v2ZBx58Nlp6vRV/dVQmZQR130aotNOtivEAK5A9edRhBdUWSblWD9fSGYVucaBC8eRVSfVTnjhJv6HLjyRI0Mw7wibniLeHXw7W3UUi6/+rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793334; c=relaxed/simple;
	bh=Jsjl5vkW6Qc4okh599RfglBpEGcMRb1us976BQFBIVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC6Tf70+kdy5eH+92dfa+UeUiUEPcV9vb/AFRx6De6f6V+aTBSXEPk1hdFJ9KEl9kGumOwNFCDqouy5wsX2FoQr/UZm/ukgeoBWiFp0IN1lIO4vpkxksPzAKOBzRFHe+QmyQQWWuUoJKMI34i8LBxOv8WJ1jM0m+762iw27Wza0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppgKnFR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppgKnFR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C721F000FF;
	Wed, 30 Sep 2026 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793333;
	bh=+74oCAaTgu9++8xjZwPozsbTgRQoWdPbSS7v6uaBtuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppgKnFR1ihVFhNPoiHjMtgFxV17TsS0FC5IiC+sPRSSUiz1s5TyvdEDrcOEXq3Vbp
	 3mZJ/cBEYil+qVAXE6zBPK7d4aiCaP4vXfX73N3yMWjq4pGpB7t9QMTyOsqB33gYO2
	 X2+RoW1UFO4mAkeSIHZIjLRYls3xJdc70eF2lsag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 216/395] bna: prevent IOC timer rearm during teardown
Date: Wed, 30 Sep 2026 17:27:58 +0200
Message-ID: <20260930152345.346908006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 77b1718e39e5c9f6956fb60807326af20baf889d upstream.

bna: prevent IOC timer rearm during teardown

bnad_pci_remove() and the probe disable_ioceth path call
timer_delete_sync() for ioc_timer, sem_timer and hb_timer, but not for
iocpf_timer.  bnad_iocpf_timeout() then takes bnad->bna_lock after
free_netdev() has freed the struct bnad.

Deleting iocpf_timer last does not fix this.  sem_timer and
iocpf_timer rearm each other: bnad_iocpf_sem_timeout() can arm
iocpf_timer, and bnad_iocpf_timeout() arms sem_timer from
bfa_ioc_hw_sem_get() when the semaphore is busy.
timer_delete_sync() only waits out its own callback.
bnad_ioceth_disable() can time out and leave that callback live.

Shut all four IOC timers down with timer_shutdown_sync() on both
paths, so a later mod_timer() is ignored.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1d32f7696286 ("bna: IOC failure auto recovery fix")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260922014605.588040-1-mhun512@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/brocade/bna/bnad.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2574,6 +2574,22 @@ bnad_ioceth_disable(struct bnad *bnad)
 	return err;
 }
 
+/*
+ * The IOC timers rearm one another, so deleting one cannot stop a
+ * sibling callback from arming it again.  Shut them down so a later
+ * mod_timer() is ignored.
+ */
+static void
+bnad_ioc_timers_shutdown(struct bnad *bnad)
+{
+	struct bfa_ioc *ioc = &bnad->bna.ioceth.ioc;
+
+	timer_shutdown_sync(&ioc->ioc_timer);
+	timer_shutdown_sync(&ioc->sem_timer);
+	timer_shutdown_sync(&ioc->hb_timer);
+	timer_shutdown_sync(&ioc->iocpf_timer);
+}
+
 static int
 bnad_ioceth_enable(struct bnad *bnad)
 {
@@ -3730,9 +3746,7 @@ probe_uninit:
 	bnad_res_free(bnad, &bnad->mod_res_info[0], BNA_MOD_RES_T_MAX);
 disable_ioceth:
 	bnad_ioceth_disable(bnad);
-	timer_delete_sync(&bnad->bna.ioceth.ioc.ioc_timer);
-	timer_delete_sync(&bnad->bna.ioceth.ioc.sem_timer);
-	timer_delete_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	bnad_ioc_timers_shutdown(bnad);
 	spin_lock_irqsave(&bnad->bna_lock, flags);
 	bna_uninit(bna);
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
@@ -3773,9 +3787,7 @@ bnad_pci_remove(struct pci_dev *pdev)
 
 	mutex_lock(&bnad->conf_mutex);
 	bnad_ioceth_disable(bnad);
-	timer_delete_sync(&bnad->bna.ioceth.ioc.ioc_timer);
-	timer_delete_sync(&bnad->bna.ioceth.ioc.sem_timer);
-	timer_delete_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	bnad_ioc_timers_shutdown(bnad);
 	spin_lock_irqsave(&bnad->bna_lock, flags);
 	bna_uninit(bna);
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DA13ABD99;
	Sat, 17 Oct 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256217; cv=none; b=JpIEVDmxnuf7mcXaflR3O4w6PxiLgU8uQ9I8aiOVFxf/0x5wJIDtzVEyBeeiitwpxPTkQU2XPo0Xm/p7ELrWAFQJRjFArgC5W/uLr4aMeWp0lVvsoXTjcTpoiQShg05QHJLzwK4dBtYrNC0cfuGiVGemzyPUzRIp4kHKNeDG4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256217; c=relaxed/simple;
	bh=tJLVkQH4CeVWGWoKNJXPvpYy81V9QLR26VK1ZATxxr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSCMj8N/bg0o/4oIsBxDTHyuFk5Z3SlUKA3/yUfXvw2AbY/4b3CEgbRzOcHm3N8I4cByHCty+2MFOyJWV1N7qCojlSdIl38grBwrqfT41a/8lYpV0VeHV3IWjjAKh5SfJNHM91Dbi8bkfgQ7FSrnxACRXs0A/S6VJGTJU3UDF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHAfmTx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHAfmTx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272901F000C4;
	Sat, 17 Oct 2026 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256216;
	bh=7BMiPL8p1oBTt3z4nnYnkImUSAwCJfkdS1BdnqkCtdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHAfmTx+q8ps8ED2xepfD1igkGSs7Lw+y++Qs15lZjBDMEMsDzfzG4lT8euXoqvub
	 JuoWY8iLFCo7buxc3VyVyLzSmM9GvXqfLNc4mQiSkcjTzAp19y74UG0YSc+VtMeMPC
	 9pQFrlIAqmijkCknectc/m+3s4G5TMfdoWlzG4Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0121/1674] bna: prevent IOC timer rearm during teardown
Date: Sat, 17 Oct 2026 17:39:53 +0200
Message-ID: <20261017160434.258901898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 77b1718e39e5c9f6956fb60807326af20baf889d ]

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
[ inlined bnad_ioc_timers_shutdown() into the existing teardown functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 6cf06a93bedfb..c01c849a8d1aa 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3727,9 +3727,11 @@ bnad_pci_probe(struct pci_dev *pdev,
 	bnad_res_free(bnad, &bnad->mod_res_info[0], BNA_MOD_RES_T_MAX);
 disable_ioceth:
 	bnad_ioceth_disable(bnad);
-	del_timer_sync(&bnad->bna.ioceth.ioc.ioc_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.sem_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	/* The IOC timers rearm one another.  Shut down all of them. */
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.ioc_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.sem_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.iocpf_timer);
 	spin_lock_irqsave(&bnad->bna_lock, flags);
 	bna_uninit(bna);
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
@@ -3770,9 +3772,11 @@ bnad_pci_remove(struct pci_dev *pdev)
 
 	mutex_lock(&bnad->conf_mutex);
 	bnad_ioceth_disable(bnad);
-	del_timer_sync(&bnad->bna.ioceth.ioc.ioc_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.sem_timer);
-	del_timer_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	/* The IOC timers rearm one another.  Shut down all of them. */
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.ioc_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.sem_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.hb_timer);
+	timer_shutdown_sync(&bnad->bna.ioceth.ioc.iocpf_timer);
 	spin_lock_irqsave(&bnad->bna_lock, flags);
 	bna_uninit(bna);
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
-- 
2.53.0




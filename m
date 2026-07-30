Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0577B432E6E;
	Thu, 30 Jul 2026 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422052; cv=none; b=tE7IQRnjEjlF/31bKy0gf2eXIZ9Iy9+py34urD/wQ6jjYEFSZbvMw+vNsCFlqHXuLEasHSsEONWX400a1jWRLqmpKlxFB6BLUlJsn1zEJKppEfXjzxsMWvA7V7EKO/E9u6EwqeOEufYHlM9b8DqoKXK+D8rBdqJBTqckg2OjuAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422052; c=relaxed/simple;
	bh=eC8oKN0wkNG07mYP+N/Bh7Z3wqClzlIHUj7O4kFV45s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh3a42X8o2iymZi8bogePOp1TIhpSlDMt9QNAAtx5ZtyubhnAl7JLoW+OGD+uvs8u0eXBHh3bST0Vk9HUNV1GZ2baydGCHBUyDY0XOBtYqjWekSzYFcFb8SPRPQhVJOnpHZ5mYttEzRNqmlQ0aMgvUhOAK9LUBS1ke5n1gYCWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryBCxETZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryBCxETZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B981F000E9;
	Thu, 30 Jul 2026 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422050;
	bh=SdDMdsRJxbAyJlFRWmjJmWbAf07s5CzB8gnmBpSM2X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryBCxETZSHIdeb1dieSyf018wByzOV0dBZZGCCBVFdrMMWKk2lfDgthrn3VYSkIqA
	 BrmW2YwsRzBm2OcnECiwZAFdeVeIRq8681ajbQwt1chnmVRMqPMMmtTqbno7taJHPv
	 T49bOYPOY+LcwaY5Nq3V11zK3sx16y7NNDy+uTw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 271/744] pds_core: check for workqueue allocation failure
Date: Thu, 30 Jul 2026 16:09:04 +0200
Message-ID: <20260730141450.052949015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 3a660ca49e2c3807bffe0519db3cff677a5906e0 ]

pdsc_init_pf() does not check whether create_singlethread_workqueue()
succeeded.

Fail probe on failure. The workqueue is set up before the timer and
mutexes, so its failure path must unwind only the earlier setup.

Fixes: c2dbb0904310 ("pds_core: health timer and workqueue")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260629200358.2626129-1-nikhil.rao%40amd.com?part=2
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260714212713.1788438-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 638b9c7a509d9d..8d94a4d70395ed 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -238,6 +238,10 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	/* General workqueue and timer, but don't start timer yet */
 	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->uid);
 	pdsc->wq = create_singlethread_workqueue(wq_name);
+	if (!pdsc->wq) {
+		err = -ENOMEM;
+		goto err_out_unmap_bars;
+	}
 	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
 	INIT_WORK(&pdsc->pci_reset_work, pdsc_pci_reset_thread);
 	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
@@ -253,7 +257,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err) {
 		mutex_unlock(&pdsc->config_lock);
-		goto err_out_unmap_bars;
+		goto err_out_shutdown_timer;
 	}
 
 	err = pdsc_start(pdsc);
@@ -305,13 +309,14 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	pdsc_stop(pdsc);
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
-err_out_unmap_bars:
+err_out_shutdown_timer:
 	timer_shutdown_sync(&pdsc->wdtimer);
 	if (pdsc->wq)
 		destroy_workqueue(pdsc->wq);
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
 	pci_free_irq_vectors(pdsc->pdev);
+err_out_unmap_bars:
 	pdsc_unmap_bars(pdsc);
 err_out_release_regions:
 	pci_release_regions(pdsc->pdev);
-- 
2.53.0




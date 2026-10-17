Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D62C35C68B;
	Sat, 17 Oct 2026 16:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256079; cv=none; b=N/HBN5fbhi/ym8T3A/uVBmSVuSk3DggAYg8erYUIP9Tn5txVVVjjjAQ+4//jYhTbwygNYCyqhLnRMjT2YYs7m/DPQR4CFB/rnojawAOlPBAIJwHPL9/xzWCrPsJdSDYqxXdNWScGeEGWo9Ob+IDnGXMNeHIn3nwldlKu2gAej6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256079; c=relaxed/simple;
	bh=A3TYcj4cj0jOj8MegbnBumtqvemSTVlQwfcAkfSFCuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv5rgfJ1Zus/xjV3yhE54h5yBcrjnRFwC1L11mxzXs3vDHO5hDKzyZ6Q1eULhHBQprGr/ltcBM2yDFcDIPpVeT/fCwhG61yHy6IH8B/eQDnDpFhaCAazVSAlxiCnpwQPuIWL7kCe5GHLhNxyvru9IQFWUT6CwnlW+001J6J32o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDpM0dhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDpM0dhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0A51F000C4;
	Sat, 17 Oct 2026 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256077;
	bh=7nlFMSVvjmBqs0x52VLlJ9qAwZgXB+UUVZF57CkoNIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDpM0dhcDg+L10txCySiMG+yLbAzlCTSPlgqvSMDNwcjn/qakmIoYAbZgjARyocRg
	 a5RvJ7vfIwdG4jjGUJCHFzAVFn8DQiRPzU2MBCPx7xFOMSzbgcm+ecb5MduezQb9rW
	 zcKp+JwFsu1rgXrGPUiCIrMEL9Bf0cQ40CijzgME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0074/1674] mmc: via-sdmmc: cancel card-detect work on remove
Date: Sat, 17 Oct 2026 17:39:06 +0200
Message-ID: <20261017160433.033310045@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 57e5d877f898d5e5c9d672a77bb6bdd24f0d9bf5 ]

Disabling the device interrupt and freeing the IRQ prevents new card-detect
work from being queued, but carddet_work already queued by the handler can
still run after via_sd_remove() returns. via_sdc_card_detect() recovers the
host through container_of() and dereferences its MMIO base; once remove()
returns the host can be freed, so that work would touch freed memory.

Cancel carddet_work after freeing the IRQ and before cancelling
finish_bh_work, which the card-detect handler can also queue. carddet_work
can re-enable the interrupt through via_reset_pcictrl(); mask it again
afterwards.

This issue was found by an in-house static analysis tool and confirmed by
manual code review.

Fixes: f0bf7f61b840 ("mmc: Add new via-sdmmc host controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
[ adjusted context to retain del_timer_sync() instead of timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/via-sdmmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index cac4b894f5f87..6634b04a7545c 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1207,6 +1207,10 @@ static void via_sd_remove(struct pci_dev *pcidev)
 
 	free_irq(pcidev->irq, sdhost);
 
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+
 	del_timer_sync(&sdhost->timer);
 
 	tasklet_kill(&sdhost->finish_tasklet);
-- 
2.53.0




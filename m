Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E504F414A0E;
	Fri,  4 Sep 2026 05:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499821; cv=none; b=aTXRkJCJ5EHfGXS2YQERvKCFucdE7qzxtecKa3/61C9IeWz7VvgBdEY5WPCy1g6M7QrQsgsHXNfeoVmW5nVOZTlJls2akguc6xaLrfyz9Q4l7ytw/c7e+OzpGForvUPmJ6fCcoJhsJ51P6VmEwwWqQeuScHzmTj0LVwnW0p0gm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499821; c=relaxed/simple;
	bh=NKGA0z+CEokoxEUkZApYk67znNPo1Vt/0QThQ4UyVhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2CebJTzC2MWqkaKUnSyI/7EwQzRw2ped5pevx19juLgwCccH02pU/zczkCkl5pBqFElQh7v5IQMoBJfMdRCzQhC8f/bTGYuZDd0W7eLa4n0D0s9msqSdJJ/lNkiCzaw5vtbjWdYBNYlBaHsJjf5P1VGVwKjm6GH+CF/zq/MCIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB+1fw4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB+1fw4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43B71F00A3E;
	Fri,  4 Sep 2026 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499819;
	bh=u7NPEN9I9fbiZ0l8Uiobstu0ln1Hku5xlnxAN8rMru0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bB+1fw4tOnRGI3lAqhbcTFL/TTzFTLwuEtCih/fj1qCnawrJypgIpTunwmeeGn3wI
	 XilcvIipYpJ+DxT1B8xIj3KnSC2sjO/kIn+3cC9fmDpPvhR2sun37OrawUv0MUdE3N
	 vtef66XdnrsgmhwSE8LRU4dBfWPm4YXm5V/TfSC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 553/713] mmc: via-sdmmc: cancel card-detect work on remove
Date: Fri,  4 Sep 2026 06:58:41 +0200
Message-ID: <20260904045816.213982401@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 57e5d877f898d5e5c9d672a77bb6bdd24f0d9bf5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/via-sdmmc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1199,6 +1199,10 @@ static void via_sd_remove(struct pci_dev
 
 	free_irq(pcidev->irq, sdhost);
 
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+
 	timer_delete_sync(&sdhost->timer);
 
 	cancel_work_sync(&sdhost->finish_bh_work);



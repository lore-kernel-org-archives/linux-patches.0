Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD903356744;
	Sat, 12 Sep 2026 15:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227688; cv=none; b=d8t3l86yp/g0s2MCodHikQwhtapRtedKpX3OebGm1RjfzR1Kx7ExJ8Sk8pDDTb1s+Pp0CB4l9C2PfkDpOh6dQGPJF7C/0ot8oUMmeb692Ul0gJzKsN2u1tTggz+aiL8OxWupG7UOBIGek2DMpTr+Iq4S9P4F3tBLomhsDbCDf7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227688; c=relaxed/simple;
	bh=NXM/XwuvhqpdW83pGeNhoPT/H6FhJfV5emAaAtVtNeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGHHo9h/qaPBzRuUlxXcqK42E2mYijlfPG64xqT76VFBF6iTabEQW2V4ww7LSowQtvySZy2ICoqXTGcH83MIN47aovdYwSyxmGAOkN08ApL504JQZHA5/slEGHE44vk7vEsi4DyfWv1n2PZhYbqjmCKlUm/2VFZ292SjlkT4jug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On6QE2uI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On6QE2uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6D61F000FF;
	Sat, 12 Sep 2026 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227686;
	bh=G5Vj6r+fSs7QOLFuTNhO4ih6xPlh8wl2zl8j91TgE4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=On6QE2uIEIjNC5dzPBi4LS0Ks6xgzC+86yDKaaxf0hpaG0+DMiGORi/aMt8bBT1h0
	 pVV9KK+pTxl1i4e3hRdhYQKMpmgxv5XdVHiv/mmNhMkcrQfbST+QFnRW28MgJ8ory2
	 U0VTVCg/Ucl6fPP+AF30QhQLZ0xhPDmXJzvZVsog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0195/1191] mmc: via-sdmmc: stop card-detect handling on probe failure
Date: Sat, 12 Sep 2026 08:48:43 +0200
Message-ID: <20260912065552.594381514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 088eaa92fcebaa6b957ccf9635afdf39643a577d upstream.

request_irq() registers the SD card-detect interrupt and the probe enables
it before mmc_add_host() runs. If mmc_add_host() fails, the error path only
unmaps the registers and returns: the interrupt stays registered, so the
handler keeps running against the host once it is freed. via_sdc_isr()
dereferences sdhost and its MMIO base and schedules carddet_work, which
via_sdc_card_detect() also runs against freed memory through its
container_of() dereference.

Add a probe-error path that disables and frees the interrupt and cancels
carddet_work before unmapping. carddet_work can re-enable the device
interrupt via via_reset_pcictrl(), which restores PCIINTCTRL, so mask it
again after cancelling the work.

This issue was found by an in-house static analysis tool and confirmed by
manual code review.

Fixes: e4e46fb61e3b ("mmc: via-sdmmc: fix return value check of mmc_add_host()")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/via-sdmmc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1153,10 +1153,16 @@ static int via_sd_probe(struct pci_dev *
 
 	ret = mmc_add_host(mmc);
 	if (ret)
-		goto unmap;
+		goto free_irq;
 
 	return 0;
 
+free_irq:
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+	free_irq(pcidev->irq, sdhost);
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
 unmap:
 	iounmap(sdhost->mmiobase);
 free_mmc_host:



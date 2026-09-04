Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D6C35AC03;
	Fri,  4 Sep 2026 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501459; cv=none; b=HfA3oaOVZ7u9qt8h3oDWYa6OADySVrrm2XLHVIoI7DIwAVv2cq6PsgMCeXlITRSjbf2fhJZWfboS+f0lMZZJu6gJzFrPMgahkXwyNlA8Rv0/YVNqM0FWyBCVPJp0x46GBEe+7RF7mgnT6/+cA+ivb0cV/3K8pG+XoAv1zuPIe0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501459; c=relaxed/simple;
	bh=cXtCaKKTZb15KpEwPXc4ajRbHzoA5pZouurVz4a1xnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxtSZFkuTPRHFn3wp+aRzl7F2PWPbW6De0KbVpSKcg2LuAMDDQO7TBCm9IrT9vx/4p4jiPZbQ1xeJCenDSbLRPHK+fv/F1/O2YvCWrPw/JDBC8OBppM5213X2g2r3ZqySPE1syM8kJU9/x2ms3g87qBIjVAn9P5oGhnUD1WtL8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REDEmw77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REDEmw77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F2E1F00A3D;
	Fri,  4 Sep 2026 05:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501458;
	bh=Y4RciGAwvUBBPPJPm5UbVng4NviRb7wlnuvLjZFbY0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REDEmw77Wzl9Cn4mci1SkH2wqAkSDKGWq4RAZx6xaKINbFf89aoLiLfE3TQ63w32s
	 TwtkdmYD0bH4pQSJVYY7Ik1Y056kVRAwCHExopbzh7Aej7BW0OIOXEGRzg2AuAqFWo
	 4K/bYOlz6w9hrR2a8EYUNFXDd+TL/3oyXvg7vzzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 417/552] mmc: via-sdmmc: stop card-detect handling on probe failure
Date: Fri,  4 Sep 2026 06:59:34 +0200
Message-ID: <20260904045800.068263274@linuxfoundation.org>
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
@@ -1154,10 +1154,16 @@ static int via_sd_probe(struct pci_dev *
 
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
 release:



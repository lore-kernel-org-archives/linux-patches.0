Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE183019D8;
	Sat, 12 Sep 2026 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220721; cv=none; b=CQTrgUy6Mmryt7nmpB1c9hokfO7zxHfFItsCVIE/STXxEOMLLtvOQ8mrAV6U+3czJCfneipGBaHnckqqneie7PZNOyYuTwbiNVEedf0jOFouPT/fM9v25xsqq+gftXRnjLvW35M5BMXaBjoma7GhRyjAmX3Bh+Yn0vaGCtbrzB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220721; c=relaxed/simple;
	bh=pepEgq+y0O0nWhMO4XddodMzeFnKoMARkQ2vICiVAqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc1yYmTnDO/XGLbK8JV7EnAUu+6wSbkK/5dn2R4KCUYlBC/SGxQl2bQla2/s6kv+865muFUChWzbeBO+BHs703+guywP9dNgRkFoJdbk4IlkIZONqN/gzdDjqf6lbSUoNHWRZ9EQq3poGvRN+t3KkdBPMfS7T2hSX43JLZvOxXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfJhbnt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfJhbnt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6021F000FF;
	Sat, 12 Sep 2026 13:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220719;
	bh=+DsgK6pAZL70Wbmry8ysv8EpVF2tie50CXEQIgTPyxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfJhbnt7CsCTPROOBPdM2v4SM71HNW+lHZrNDInWm2kBES48nsLfrGomifyyFX9Gg
	 KRX5OgVY+2TX2iHWU1MKgCOd3lH/tL99uwBFcQIKY8OGWkNg81w6scthrMfmizAT6O
	 eNLCxh2PS4NrM4gkjWbV2sh02oVK0Z7/GTNcdaTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0235/1424] mmc: via-sdmmc: stop card-detect handling on probe failure
Date: Sat, 12 Sep 2026 08:44:27 +0200
Message-ID: <20260912065612.543637109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



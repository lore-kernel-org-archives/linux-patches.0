Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569B4358378;
	Fri,  4 Sep 2026 05:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501456; cv=none; b=gz3MZ60CHNDP24DBRNOZRgkPVZNCm7X4kqNbq48Yu+oTgdJw4OntmTdTO3MT+apeNtipX/PnHu9ZBXM101+yTpfXWi1NA+kMkHShBg4z8yLgA8fXiMmRn1aZMpqin/lI6szM2kRdbdobxxHMAWVBneyfHalK8NPK92imp7SkZkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501456; c=relaxed/simple;
	bh=3ZBMu8MgtqCNMJFJMyYEBLK/BrIjVyzgML4pwwY3hqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4nS/SYtlpqmxQayzMoHOumJEY3y+JujzzwjS2XHk7g+xNTiaigip9cRV+5L+rFv7BNuBS/1OI3rdtQ8jPyEhHsUu49wS3q4gcwF+E8OdF7BwjxFqLeDODhmglregB2AleGVLCbUtwK5ONTr4ZCI9t8vdPPvPCclo8C7+dZLgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1olryD8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1olryD8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08F81F00A3D;
	Fri,  4 Sep 2026 05:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501455;
	bh=ndKYXOiGVHpeiEGqhOehaMcxs3p0+OgXsdO8YyqkWFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1olryD8DnAD8FTeoBp+L4MAT+J5kMfAktdT7Ep6Ghod/KV452Ws6wB/sY9cvYU8WX
	 AQB3BcAxUEy7aPEb6Q1uKjhoEbeGdF0UlXVjbWO/TxQ+D2Ni+MyDr4jI16Tihyr6AJ
	 H4EFsIz8x0GbzATfbrF9o5ey4hwg3sq0mD2S/u2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 416/552] mmc: via-sdmmc: cancel card-detect work on remove
Date: Fri,  4 Sep 2026 06:59:33 +0200
Message-ID: <20260904045800.047145566@linuxfoundation.org>
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
@@ -1200,6 +1200,10 @@ static void via_sd_remove(struct pci_dev
 
 	free_irq(pcidev->irq, sdhost);
 
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+
 	timer_delete_sync(&sdhost->timer);
 
 	cancel_work_sync(&sdhost->finish_bh_work);



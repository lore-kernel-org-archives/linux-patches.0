Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E755C1AC;
	Wed, 30 Sep 2026 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789737; cv=none; b=tWOTPgx4lo4CTROb8U5CJV+2saBNk9vJZ/LNagYvVdzF4IgRG7JZ6Ekgxx96aDeMF4zfpAEDYbc/ouSw/cbcmBxAMCbRqgBjz/eY8Ve/jgrbxpaX/NTKVkMZz3qt8Q/7RKNc6+QUTSP1RrM2sd2MwZBtbIUXiQ4x6oWirwIodmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789737; c=relaxed/simple;
	bh=1rvQ9R4CuRwxmVrRGjSIf1ZDNxzfIdIVxGMG8HHNcKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9XDkKHmBmSP9eqHUr+T6BWidfg6Fem/7uV4q3sD/yAwJzt+PWjHFRXnAhyFdaVyPCwJrmgaqDPBqpWd9mrJENKcIU5gx5zMEc/Z+L0ZLhRrT+0gkr8NVrw9V0YWkiNmVxQISFk8yhNk8R4IA9MWaA6paJV1gKYWrmNxyhANoho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXaSCp7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXaSCp7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C10F1F008AB;
	Wed, 30 Sep 2026 17:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789735;
	bh=G9T0tjP3KHOTnQlqe+L/GOMd3u5uuTWYSd+SWwSCQJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXaSCp7IzZIL1ZidTi9oDE+tm/P7LXBvtxUX8Y+E/wqksINNmGq9WY3IjJhdRMAEy
	 ma4EJxaklqtfLU+v5DSI9q8OLxZURqHRl9rGgMAwGEah0oW6JesPGYBy3NIWw4KJS6
	 t0ad7uRrp6wvB+uHCpgq9gIL9Ntyh0Cr80S7xBUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 581/877] mmc: via-sdmmc: cancel card-detect work on remove
Date: Wed, 30 Sep 2026 17:24:52 +0200
Message-ID: <20260930152427.181568706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/via-sdmmc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1208,6 +1208,10 @@ static void via_sd_remove(struct pci_dev
 
 	free_irq(pcidev->irq, sdhost);
 
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+
 	del_timer_sync(&sdhost->timer);
 
 	cancel_work_sync(&sdhost->finish_bh_work);



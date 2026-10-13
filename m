Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6444FD287;
	Tue, 13 Oct 2026 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893419; cv=none; b=R7K3RdDuSBLGX/wp/36abGO/5i1C8jQ7QK+oOjbX18DeAPd1AvXDdNsu1vzS2by4zTZz2UdYY8jVuIz3gsY7PKxMV8aGTqpoYUwRuMGDXRJHIK3OSFNnB3IIiyT8veW8oFO/E/3RGc7f8afDjuHnhQohyEhybex8tqkLFR/Xf/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893419; c=relaxed/simple;
	bh=7DNYN8wCdk/fAD35bewZy8ZOlG4WL7PoelpUDaCNzV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN0QBdq9bxIRb4NLgIiV5fOuTEvi4D26OkbHy7bnIUhKc5J9Nl+xlLhospvlfuqPQd6iyVCu0OnRZPzqiYOuYnPccqkVWMSAwU986ZFolUQUOpLE2qADmMbTkO7rtOWkr20qn/dtECPbF4BLEpGsXL7zF4YiI6dS4gZABJi1txA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCu5Zhme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCu5Zhme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB591F000FF;
	Tue, 13 Oct 2026 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893417;
	bh=hm4lAvHOHXcGzEctL3QmaDmu1W5MhclrJdYDwWpBJOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCu5ZhmenTZCHEsVQ/QVoVW4OH0wzHvNkPsgAiCR8iA+2+raDVkoC4V2jHdJPaf6F
	 sbSKqic/RLf8/Pmg+pv/ZfYnsWAK6TTg25S967cO0413GrlzV8TPNRRe3GCtRsdoU0
	 0mURPrG3Ets1Dlgeh03sS7WoqU1w+0I5iVuLhoLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/621] ptp: ocp: fix resource freeing order
Date: Tue, 13 Oct 2026 13:33:35 +0200
Message-ID: <20261013112926.082528366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit 627366c51145a07f675b1800fb5ea2ec960bd900 ]

Commit a60fc3294a37 ("ptp: rework ptp_clock_unregister() to disable
events") added a call to ptp_disable_all_events() which changes the
configuration of pins if they support EXTTS events. In ptp_ocp_detach()
pins resources are freed before ptp_clock_unregister() and it leads to
use-after-free during driver removal. Fix it by changing the order of
free/unregister calls. To avoid irq handler running on the other core
while ptp device unregistering, call synchronize_irq() after HW is
configured to stop producing irqs and no irqs are in-flight.

Fixes: a60fc3294a37 ("ptp: rework ptp_clock_unregister() to disable events")
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260608155952.240304-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 46cb06c2160f8..5260cbf56d115 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2217,8 +2217,13 @@ ptp_ocp_ts_enable(void *priv, u32 req, bool enable)
 		iowrite32(1, &reg->intr_mask);
 		iowrite32(1, &reg->intr);
 	} else {
+		int irq_vec = pci_irq_vector(bp->pdev, ext->irq_vec);
+
 		iowrite32(0, &reg->intr_mask);
 		iowrite32(0, &reg->enable);
+		ioread32(&reg->intr_mask);
+		if (irq_vec > 0)
+			synchronize_irq(irq_vec);
 	}
 
 	return 0;
@@ -4561,6 +4566,22 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	ptp_ocp_detach_sysfs(bp);
 	ptp_ocp_attr_group_del(bp);
 	timer_delete_sync(&bp->watchdog);
+	/* Disable interrupts on all timestampers */
+	if (bp->ts0)
+		ptp_ocp_ts_enable(bp->ts0, 0, false);
+	if (bp->ts1)
+		ptp_ocp_ts_enable(bp->ts1, 0, false);
+	if (bp->ts2)
+		ptp_ocp_ts_enable(bp->ts2, 0, false);
+	if (bp->ts3)
+		ptp_ocp_ts_enable(bp->ts3, 0, false);
+	if (bp->ts4)
+		ptp_ocp_ts_enable(bp->ts4, 0, false);
+	if (bp->pps)
+		ptp_ocp_ts_enable(bp->pps, ~0, false);
+	if (bp->ptp)
+		ptp_clock_unregister(bp->ptp);
+	kfree(bp->ptp_info.pin_config);
 	ptp_ocp_unregister_ext(bp->ts0);
 	ptp_ocp_unregister_ext(bp->ts1);
 	ptp_ocp_unregister_ext(bp->ts2);
@@ -4578,9 +4599,6 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		clk_hw_unregister_fixed_rate(bp->i2c_clk);
 	if (bp->n_irqs)
 		pci_free_irq_vectors(bp->pdev);
-	if (bp->ptp)
-		ptp_clock_unregister(bp->ptp);
-	kfree(bp->ptp_info.pin_config);
 	device_unregister(&bp->dev);
 }
 
-- 
2.53.0




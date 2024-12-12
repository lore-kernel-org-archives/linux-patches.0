Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D78213E6F;
	Thu, 12 Dec 2024 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025108; cv=none; b=hz58vzZb+glBYMlcR9mEOjJiolkiMO3Jw2U5CUbyhiAy85ouk6MClEDCHcaP+hIXIrCQMRptTV7Oe9CXJHKVUAtQAaPP4vtBBfI1oHa+JyRhWoPNqQkOSqCb0mz4Jho0bBFS4Tpqf6CE8EZCAx81JhREw0SV4/x0EQ/CHT2nqrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025108; c=relaxed/simple;
	bh=PDqLkYuDwSeHF+QiJvZCKirq5h46b/Avuii7ZnHEPpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK1bGPXMnIyu88MVYly7wYotK2it2yoN54DRmh47rKzhoRv5Duofj2TawAZ7yH5H1WTWYAPQ4Ta0pnCCZLf3hL+iL7JGfZXBgcws7Xc5tqzmuoLwCP1hSkBbgawlpMkqCA0JIBz79aXvdNQrESkDkjb/ENmbWR/aZy1swOHLYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8KzqiTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8KzqiTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4849BC4CECE;
	Thu, 12 Dec 2024 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025107;
	bh=PDqLkYuDwSeHF+QiJvZCKirq5h46b/Avuii7ZnHEPpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8KzqiTIcc86JYQ5h3/LNSEvSyEYBM7JlW22yoYSdzb+fxD+AlnkYavCF1Ui+XYnz
	 sHbuUPIH2zRRRWYcSe76vpNECOSOVbtAxUxIZdab3gravwe9axiGUAP6kXM97HA7co
	 TTDIoV7jkB5mTGj8GGHk0gAP0ROgDvnap4ilm4Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/321] wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:59:37 +0100
Message-ID: <20241212144232.323179744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 9a98dd48b6d834d7a3fe5e8e7b8c3a1d006f9685 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 853402a00823 ("mwifiex: Enable WoWLAN for both sdio and pcie")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240910124314.698896-3-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 5894566ec4805..d788e2e6397ce 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1600,7 +1600,8 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	}
 
 	ret = devm_request_irq(dev, adapter->irq_wakeup,
-			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
+			       mwifiex_irq_wakeup_handler,
+			       IRQF_TRIGGER_LOW | IRQF_NO_AUTOEN,
 			       "wifi_wake", adapter);
 	if (ret) {
 		dev_err(dev, "Failed to request irq_wakeup %d (%d)\n",
@@ -1608,7 +1609,6 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 		goto err_exit;
 	}
 
-	disable_irq(adapter->irq_wakeup);
 	if (device_init_wakeup(dev, true)) {
 		dev_err(dev, "fail to init wakeup for mwifiex\n");
 		goto err_exit;
-- 
2.43.0




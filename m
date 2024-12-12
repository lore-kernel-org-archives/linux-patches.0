Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBB94F218;
	Thu, 12 Dec 2024 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023845; cv=none; b=f3TRpGwkCpHaqaYQmxd4g6aDrLr7CqHlojnhTzVJojX0mNIAcxN0tPbWGmB6UYHctImU5qs2YzQZt8TvOy3DmYiZZFfa8pb0c8IMirMWO4sE0PoaEzJRMuKJz9qx/ThzbqoFY28u/Bb+fr+22ax6gPofp0hSfV9AeD1GHrS84Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023845; c=relaxed/simple;
	bh=S3KMWYp/oXNDgoDl4wTRpyrF+XaAxcwOgTI+h4yHtFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+0ERLpw7C56ug+GD0JefWrtHFNIh1uF4wIOHbxQESSPei/v2pqxFbbwT2uaTt+0M7ZrbLsphfrf307zonc7irKroqamUNo10vdee5DsLM95uuMJR55Cx3y5xXsJhoTXM9PQUP3OwFcYYW3FSE6/8YCmgmQPyh/FjwbHJOSqqN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpIBQDgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpIBQDgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E7C4CECE;
	Thu, 12 Dec 2024 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023845;
	bh=S3KMWYp/oXNDgoDl4wTRpyrF+XaAxcwOgTI+h4yHtFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpIBQDgz7i6HJj8ayAiWoGlP5llgv9dLDSzM7GKg3NPvJ/SYTDc36VkGhk+otBMdI
	 zJW4EyKsg25zyIsS94jwWIz8Vl9EWIrLY9aULjk2iSZirbpocLICAWXvM1gy1rTokk
	 ar1Q8mdYMMalhDHdgDxY8Td+nvQwDiYwh1n28jEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/459] wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:57:20 +0100
Message-ID: <20241212144257.542264473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b8b79fe50dbc2..6991bb0e8e9b6 100644
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




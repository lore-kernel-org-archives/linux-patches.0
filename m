Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9711A2054EF;
	Thu, 12 Dec 2024 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022117; cv=none; b=mJSiGKzmIwtr2xBgSni8nO7yA7IfGo0rQW27+MkyRwgiFO4tUcZClFXuOjKHE+Bdt481eSq95MWC42hB3Mt7CN1YLBDtqeQNQC/z1M5we4uHcmslCZgneVECJA97LlA5wR6s23iXZpKYN93QqskIoPmO7yiQM8LH9E0Kyor3mng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022117; c=relaxed/simple;
	bh=DdIMJm5RvjCupqqEh0+H0diQHknWxle0I6rwdDoQUD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV+4pNp0KtLOxJfDv9DJUDeuE1733bJbiEhuI/uNpqP8K+RuqXmYUpJxl5TxGF2N+mTU/fyujmrGUFVy9z5PDLbtG4fg79l4O0j/+8j4xhnaHJPRViVyRdJfT3AW+Hya8fGGcIm1gyqmNmzhW6yO24adenmjem0UOgSCl/PQX48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS/3RhCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS/3RhCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C669FC4CECE;
	Thu, 12 Dec 2024 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022117;
	bh=DdIMJm5RvjCupqqEh0+H0diQHknWxle0I6rwdDoQUD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS/3RhCuU9tQYYxIeUd40j40fiVa8AOv6bq4/+0dBSD5ystIXok2UNHnQ+PXDyuXc
	 zfegH1UTtrJBnVhACRSwVXwBw8RBfKuqCTgYMMD4MjwmwYut8WX7vsOFfz2idVY9vO
	 +/GlhpOuH4pcbhd4KTNpl7qc6hg7ePQAhfsyX8f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/565] wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:55:46 +0100
Message-ID: <20241212144317.452946248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7943fd3b3058d..18ab3222b1406 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1614,7 +1614,8 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	}
 
 	ret = devm_request_irq(dev, adapter->irq_wakeup,
-			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
+			       mwifiex_irq_wakeup_handler,
+			       IRQF_TRIGGER_LOW | IRQF_NO_AUTOEN,
 			       "wifi_wake", adapter);
 	if (ret) {
 		dev_err(dev, "Failed to request irq_wakeup %d (%d)\n",
@@ -1622,7 +1623,6 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 		goto err_exit;
 	}
 
-	disable_irq(adapter->irq_wakeup);
 	if (device_init_wakeup(dev, true)) {
 		dev_err(dev, "fail to init wakeup for mwifiex\n");
 		goto err_exit;
-- 
2.43.0




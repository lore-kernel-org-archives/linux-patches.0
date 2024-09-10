Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4819418CBE8;
	Tue, 10 Sep 2024 09:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961670; cv=none; b=uEnS9NPfI23z7b/H5OC/UAGN2kBGw54d6qsWZPjQ5TReytUg9jzSYQRHPzpfMriGbQoHZ3Jk060c/eC4RRzfdbmjUAp3167P/Sw4Ke+J9H4SHUGe6Su0cxp5TYGOxv03eaQGMevpLK3WXZu8lVcoKZ+IcFNXrWDArrvkAr7eykg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961670; c=relaxed/simple;
	bh=y+QfykvCgNOXAepB2/90dOf4nRYc5tYe1IJIpiV4+wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/iWHNX1t7hfkTPUAubvngqzyzGkS5G3fR2zpZK1C9aT3M9KkItagOZ6bzocmHpUq3+78ohDcw92+mmvyUh+qBn264/g7LWd0euySlWlxj4Ym4ImtDOFREhC7MGmwK1SzE8xzTINIVgTOulDxFBEDx5/k63k4rxq8+O5ftbq7Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPkTjBGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPkTjBGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4374C4CEC6;
	Tue, 10 Sep 2024 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961670;
	bh=y+QfykvCgNOXAepB2/90dOf4nRYc5tYe1IJIpiV4+wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPkTjBGDjgVLcOCd7Oe7lpPHQUVkiPTKlBCO/HH9w/OHbOr1IStEFCD9Xqgev7qgN
	 ja3+ouXKI78AnKpUVjW5Fd57RWztI/oCUZ9LIcfIOy3CTXff5qEH4hADD1tL/0+2Xa
	 YjQoxffNtYaYU7+Xu2AkdWYGMsqYOJgVD/zVtK6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 149/375] can: m_can: Remove coalesing disable in isr during suspend
Date: Tue, 10 Sep 2024 11:29:06 +0200
Message-ID: <20240910092627.470685372@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 6eff1cead75ff330bb33264424c1da6cc7179ab8 ]

We don't need to disable coalescing when the interrupt handler executes
while the chip is suspended. The coalescing is already reset during
suspend.

Fixes: 07f25091ca02 ("can: m_can: Implement receive coalescing")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-3-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 257d5bc0ae9e..dba1788f7fbb 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1189,10 +1189,8 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 ir;
 
-	if (pm_runtime_suspended(cdev->dev)) {
-		m_can_coalescing_disable(cdev);
+	if (pm_runtime_suspended(cdev->dev))
 		return IRQ_NONE;
-	}
 
 	ir = m_can_read(cdev, M_CAN_IR);
 	m_can_coalescing_update(cdev, ir);
-- 
2.43.0




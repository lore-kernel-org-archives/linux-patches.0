Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93F182D7;
	Tue, 27 May 2025 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366587; cv=none; b=rK4w5/gyxc9TXGgCD8BR7AUfYrXYQyXYbqfkpqAmYH89radAKNd/c2TMtWfUvNCjPQR0i1igz8dTZyD0U9zJ4qHve7Coo8rfp2O5NPoiC7eVaaaqIknU27YW46XdbzdOpJOCLh5EQ5wzQuEbMRWkWnW9JGrn+tFd8gKu1VUnmBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366587; c=relaxed/simple;
	bh=nLNHX2wLNDEkQ6y96UaQQymRs4D/72lqKXjBVE5nqEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cebfDjEu/cKs3XJ/+v9E7ba4uqB6HChSVxKoOFjt/PTX3ah8YIfIKQPH1/yx0jmCqaDZS5L8HcDd257aNfZJSy/IzGbtls1gwx7O2EZtXvcTjC5AgULGBnk8LtWsoxn3ocZ/0nkmwWn65oEtIb5B0vXBezMn+w45Q2+o1XTQgNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+nXiTts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+nXiTts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DD4C4CEE9;
	Tue, 27 May 2025 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366586;
	bh=nLNHX2wLNDEkQ6y96UaQQymRs4D/72lqKXjBVE5nqEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+nXiTtsjZkUITW55+KgQrDqC5XNo+SDRzUGTfBWbkpdehM+G8W7Q0jLQ6q/fyRmG
	 sn8DEVsF0EcQuwAwmtipFMewlE2e5LYGhbgUiOP4dGAoKCkHFS/TAm3Op/KR7kcPCb
	 DL3pETardPkPIJaTXDk9xCldc0wxcLqiZqiaLZag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tsai <pedro.tsai@mediatek.com>,
	Felix Freimann <felix.freimann@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 086/783] Bluetooth: btmtksdio: Prevent enabling interrupts after IRQ handler removal
Date: Tue, 27 May 2025 18:18:03 +0200
Message-ID: <20250527162516.641735528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 6ac4233afb9a389a7629b7f812395d1d1eca5a83 ]

Ensure interrupts are not re-enabled when the IRQ handler has already been
removed. This prevents unexpected IRQ handler execution due to stale or
unhandled interrupts.

Modify btmtksdio_txrx_work to check if bdev->func->irq_handler exists
before calling sdio_writel to enable interrupts.

Co-developed-by: Pedro Tsai <pedro.tsai@mediatek.com>
Signed-off-by: Pedro Tsai <pedro.tsai@mediatek.com>
Co-developed-by: Felix Freimann <felix.freimann@mediatek.com>
Signed-off-by: Felix Freimann <felix.freimann@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index bd5464bde174f..edd5eead1e93b 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -610,7 +610,8 @@ static void btmtksdio_txrx_work(struct work_struct *work)
 	} while (int_status || time_is_before_jiffies(txrx_timeout));
 
 	/* Enable interrupt */
-	sdio_writel(bdev->func, C_INT_EN_SET, MTK_REG_CHLPCR, NULL);
+	if (bdev->func->irq_handler)
+		sdio_writel(bdev->func, C_INT_EN_SET, MTK_REG_CHLPCR, NULL);
 
 	sdio_release_host(bdev->func);
 
-- 
2.39.5




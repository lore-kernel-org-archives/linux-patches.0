Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CDF46AA9E;
	Tue, 21 Jul 2026 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648194; cv=none; b=Wem9B/KdlrLoCZXF5JC5YKWyka00wfGoMojxxb+iJzFvwb8sPB3zC45uW1yWGNLlnr9XxQANJbmSLdz4oXYWnL3wR64oh0G/4MMudfJTR1KV4ZR50nbidtir06CDlQDJQk0p3EKFfPl6yYSlD77qTIFpQ/zFIFyUYIfrJLJZErs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648194; c=relaxed/simple;
	bh=3D8N7UbPO/ujy8KL5awtUsHRaO/YRaUoCp97xq16SOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSZ8E06EGGtA6vUzdC9XfVUXSyYRce1nurdCIWuFCO03RK36kSkEyZglihYRiogXJG09ZldgTPhejPcaH2gm8tA3fKvZZWabNa278RYiqElORgKmpRRr2loH7j3/Pd7lIABNpZ/gBgnt9M9VixnLmdTad4XS6LVM7hQkboTkRM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwIW2BHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwIW2BHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AB11F000E9;
	Tue, 21 Jul 2026 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648193;
	bh=ddB3vhF8WlxtUDOdKOBz2jS9SEas2yzpEOUdGKroWJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwIW2BHFlTtkgMycBV7Spnlrbl97Qo5r6btbDS05qVwWuUpS70lE3oydx5mq0ekaU
	 tKNEY5ab1ZfNQrUxeAqcJxcDFc+17AjL9GSwWRnFOrRSFDIhpRXj5RdVX3Z5bKln0J
	 prGqv/T6pZB20Q5BtjT8YcyMM/HaD9SmL12wkIf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0107/2077] soc: xilinx: Shutdown and free rx mailbox channel
Date: Tue, 21 Jul 2026 16:56:20 +0200
Message-ID: <20260721152555.217598748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

[ Upstream commit fdee7c66c0d7b6869c36b9f9a915abf29ab5b550 ]

A mbox rx channel is requested using mbox_request_channel_byname() in
probe. In remove callback, the rx mailbox channel is cleaned up when the
rx_chan is NULL due to incorrect condition check. The mailbox channel is
not shutdown and it can receive messages even after the device removal.
This leads to use after free. Also the channel resources are not freed.
Fix this by checking the rx_chan correctly.

Fixes: ffdbae28d9d1a ("drivers: soc: xilinx: Use mailbox IPI callback")
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20260320060445.1541017-1-ptsm@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_power.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index 9dd938bd01d840..370e61ac47d88f 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -389,8 +389,10 @@ static void zynqmp_pm_remove(struct platform_device *pdev)
 {
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_suspend_mode.attr);
 
-	if (!rx_chan)
+	if (rx_chan) {
 		mbox_free_channel(rx_chan);
+		rx_chan = NULL;
+	}
 }
 
 static const struct of_device_id pm_of_match[] = {
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8353326D44;
	Tue, 21 Jul 2026 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655663; cv=none; b=C84SMc9/1dejVU9AeeAIy2JUTQcO7JLbxH05mBXfjh431IpWECTVIkIVMfqBtE9pBmZK4KW/tAbZewIgmoAgp2DzolpE/6dAaNL4hELkDogUj4P+z8NdrWQEcFH+ZzQgkQDlgBz+vL/F2UELVT1s0txxdBhKV7Qq1t7BQ3IgpHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655663; c=relaxed/simple;
	bh=l6Yipy7Pw/d1fgtLpydMjdeVU5O7U8zCKxt71ZNXGu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpsdC8WKmF/DbOXJ6bPgG7tl45ri6dqmWY9+RdOx6vUTriHfgL3lajjYVehkyKb5XfchZbDo6AjNSoqX0SLV4IiWDmAv3NKWM3jftDWlUE+XHQnAD90562jSS2cljfVwcfpXvbLvmGRfKnTOPf5j2UM1FXf5nZZUJZQj5bkWyCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWlDqfvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWlDqfvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F8E1F000E9;
	Tue, 21 Jul 2026 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655662;
	bh=CnOVzhERGvwQQJz0whH1ME5Dzo3iOGzEBWyRNYEm8BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWlDqfvN7+rPOVtf5PYDSfoASZA55rVUPtgIZJsyJtOqqMq5PArt82449rTYfemLM
	 Zafiibsg/eQ92HinZsfeHM7Xk7wxzrfN7LkbHcQ04ubzBmrCElngAtSxCZPZSKgoUX
	 i8bDTo22cWl096xWrDaRe6oK4LYetDik/Z0BJ6Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0092/1611] soc: xilinx: Shutdown and free rx mailbox channel
Date: Tue, 21 Jul 2026 17:03:28 +0200
Message-ID: <20260721152516.914492867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index ae59bf16659a68..84ef7c87dfaa38 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -396,8 +396,10 @@ static void zynqmp_pm_remove(struct platform_device *pdev)
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




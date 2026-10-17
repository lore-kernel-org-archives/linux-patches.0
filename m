Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7B538424C;
	Sat, 17 Oct 2026 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259489; cv=none; b=p7p/PP11XwnPXxZN2mSVEjC2rn0keuCi6P+OVFozTIuUOxApfRyD+Xz0ED7PODksE68ohUZnXa3q9VLcXzTWK18W9A828+HQOvIXXTfaDqxKUpJ8hsOciN1fyqEilS0jOxHWGPMVsuIG63NqOUtTVGjky/IYwjxhzHduDIr13f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259489; c=relaxed/simple;
	bh=we3iu/dV14EiWq4J9Yj1SsX/AvFPjzuDV0cykYhJL5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wyv92Kju9LZt62CMz4VAeHKf91mN9iTanIe82PbYNoEGch+5KzBUoyoTRQfgJIVWaGEjheDwD5EYCAlAggIqFkVTOb/KNPARchVLuebpGgdBPh7BK4vw6v0g1eWQFIbMn1Aiv8QPpAyf76L9FN2aJrGd5zrqrm0jOS/71I5F3OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7MqgbjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7MqgbjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4068B1F000C4;
	Sat, 17 Oct 2026 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259488;
	bh=RHRBQB41trrxuZHW1sqsmM7FvYpPyXmtmiSgnCYUNXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7MqgbjZ/PfnFG3C7N0y21erY6q0H6AeFKmhqRAitTHRyFvqca/9+I8RvPx6NVdKO
	 OUYI5dLAZCsXiBEXIpcsfIoJlproJvTxyVhzZjI1EhFZZcD6sXFhHFngRbCnsRTJkp
	 Y2p/qltQ/g6mx6UXDH8hV20cASUb7hIDyUBLj6+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1229/1674] soc: xilinx: Shutdown and free rx mailbox channel
Date: Sat, 17 Oct 2026 17:58:21 +0200
Message-ID: <20261017160502.685767613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6f6484eafeb45..92c6efb209efd 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -283,8 +283,10 @@ static void zynqmp_pm_remove(struct platform_device *pdev)
 	if (event_registered)
 		xlnx_unregister_event(PM_INIT_SUSPEND_CB, 0, 0, suspend_event_callback, NULL);
 
-	if (!rx_chan)
+	if (rx_chan) {
 		mbox_free_channel(rx_chan);
+		rx_chan = NULL;
+	}
 }
 
 static const struct of_device_id pm_of_match[] = {
-- 
2.53.0




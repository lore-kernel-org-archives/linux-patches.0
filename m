Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C244F431A5C;
	Tue, 21 Jul 2026 19:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661479; cv=none; b=gkB1cGkrmUEoyyLCDe7NJHzT3jNO28n3rGEkMhlN5U1sf7k0FsGfM3ITRHMa0cIC6rKI969RI2SV1IXdmlF0YJ+HbkumXcEGdFeuOoSBNMsSWZZHFPhG1tU7XahSWmjgGWarN83EZd1b7Dg++A8PNtRbq8qD8vJA3w2KFSYOx0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661479; c=relaxed/simple;
	bh=tatQHnCMD4zyvFFmNwitGU8uVWS09UvTwKYQPvVXjMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEyKCMJB6WPSG5IfzKK7mihPAVCmLdqrB/NzWbZgzBwY4HBW3Vbk+5JofIuev4/gOm9s8MVTPrsRijqX5x6EuuttmRS/UJVN17O/BDWdOqrXFcZEiIHodFwdBfnoRQZD7dHkAhdMfpvtgwHuSz28A5f/J6cg1Yz+xrefoEXojfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhbW85qD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhbW85qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344971F00A3A;
	Tue, 21 Jul 2026 19:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661478;
	bh=M+VBFJEoO/g7QOfoaUfNRReMSJCAj6k8/Yu1TY1bnFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhbW85qDkY++hRoGpz1kw3BFoRwaGhChGKFIg/IePIAxIduoeW7zQGc0xtC0/pNde
	 F/FxRtX4KGx8xT93Ne/av+yviMj1QRAWdo5KNl9zZVbMFhOf3KvC8n48LFm3qjBQw8
	 vrR26UkWiyr7GPSCdWbrWKmlvJGQQEeOWmUzBSK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0081/1276] soc: xilinx: Shutdown and free rx mailbox channel
Date: Tue, 21 Jul 2026 17:08:44 +0200
Message-ID: <20260721152447.907010774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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




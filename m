Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404D1263C83;
	Tue,  8 Apr 2025 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113511; cv=none; b=fZJOEQg3AIUKx0R6PZJTnpoViwcOT4GAAFFVQtOl3nJ0Gn0ESp/G1mpOiGk/kjf05o8OEXn0nU0kzAmcsHQQSOBSbhq45WHClJkmqR/qLsRyR4afUk5Tci1IRLPhsZ/31Tup84Se6AjG2TFA7yRic7fAd2cywX2Z6yt5JVqdbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113511; c=relaxed/simple;
	bh=YjKeJR248Z5MNCpgzFDUVhP7sKpEgjFbU1MgUDtkNCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV1QorwdXP0g3+87dFW+mO5PW2fL4ablRaUrCloB3lTw59Fmd2hohgZ/ysjUzdNPAy58SspVI0FMQeXEEt9mVdgl6RVU446Rfblr8/+LtRlC5q4ZdUCF8drwNRs7pAF4Ff1vJbA1FxSzv0KSuhyl7IadclKBFdBZ8PZ/ZNna9wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDMVinbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDMVinbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACE4C4CEE5;
	Tue,  8 Apr 2025 11:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113510;
	bh=YjKeJR248Z5MNCpgzFDUVhP7sKpEgjFbU1MgUDtkNCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDMVinbmt3Z61/Oub1Oz+FDaq+vtTGThyHOSvPqrcyrXs9ZQBByfBaIunjz4OWWq6
	 WAZ1+8rgutizGZMSVrPHsGi9poD3BWiCbtRvyg0Iv3BVLFkzDa3cS7xct9bTSCQ0bS
	 89nB9BOpUz4UtwJpAVnLOj95qbd2YbXQgHrwPAeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/268] nvme-pci: fix stuck reset on concurrent DPC and HP
Date: Tue,  8 Apr 2025 12:49:56 +0200
Message-ID: <20250408104833.541049259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 3f674e7b670b7b7d9261935820e4eba3c059f835 ]

The PCIe error handling has the nvme driver quiesce the device, attempt
to restart it, then wait for that restart to complete.

A PCIe DPC event also toggles the PCIe link. If the slot doesn't have
out-of-band presence detection, this will trigger a pciehp
re-enumeration.

The error handling that calls nvme_error_resume is holding the device
lock while this happens. This lock blocks pciehp's request to disconnect
the driver from proceeding.

Meanwhile the nvme's reset can't make forward progress because its
device isn't there anymore with outstanding IO, and the timeout handler
won't do anything to fix it because the device is undergoing error
handling.

End result: deadlocked.

Fix this by having the timeout handler short cut the disabling for a
disconnected PCIe device. The downside is that we're relying on an IO
timeout to clean up this mess, which could be a minute by default.

Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5265be835a4ce..a763df0200ab4 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1282,8 +1282,19 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 	struct nvme_dev *dev = nvmeq->dev;
 	struct request *abort_req;
 	struct nvme_command cmd = { };
+	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	u32 csts = readl(dev->bar + NVME_REG_CSTS);
 
+	/*
+	 * Shutdown the device immediately if we see it is disconnected. This
+	 * unblocks PCIe error handling if the nvme driver is waiting in
+	 * error_resume for a device that has been removed. We can't unbind the
+	 * driver while the driver's error callback is waiting to complete, so
+	 * we're relying on a timeout to break that deadlock if a removal
+	 * occurs while reset work is running.
+	 */
+	if (pci_dev_is_disconnected(pdev))
+		nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_DELETING);
 	if (nvme_state_terminal(&dev->ctrl))
 		goto disable;
 
@@ -1291,7 +1302,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 	 * the recovery mechanism will surely fail.
 	 */
 	mb();
-	if (pci_channel_offline(to_pci_dev(dev->dev)))
+	if (pci_channel_offline(pdev))
 		return BLK_EH_RESET_TIMER;
 
 	/*
-- 
2.39.5




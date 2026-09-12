Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8A02BDC0E;
	Sat, 12 Sep 2026 08:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200240; cv=none; b=laY4LhC66I1EZjF9kINeYBgB4Cots8ck7hS+i59kPivf4Iy5wzP8lLbLkliSkMUqdwg1kplXQSw+p0+pXt8/GejszCfZt/+z3DtySFvCypbR0fvAEWPr2SotTIe0I3LvXf6jv0Yvm4UMf1A3yGq6Fr+riIQGFFTO+hczfFLHLqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200240; c=relaxed/simple;
	bh=1MIYLOkCgSui3t5bRFXZWkXHfFTSadgILFETYhbdNRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n22shRhslm95Rq/uH1fxY3cPjx+mvPFsnbjFTCxT6Hr6/OD43Tt9BpIW4YfgPJjGBEG6JnorgNnc9k77X+6p5Ig4LkcWZKVZluztHdmKp09lUx63FAgVlxASsH0YlogIe8pH3kBZ9c0H/+wUmjFv7I3tEzV24akCjeOsbNfaFAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTydWJZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTydWJZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA6D1F000FF;
	Sat, 12 Sep 2026 08:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200238;
	bh=hSw4cI8bRVWWPeXprjF7NfFGAlEp4t/1H3pFUJvHZKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTydWJZS5yPVJmXM10cINPSTEmWxjWHFIYEoNfJIhK2sY3hwq9H1ifGMoF8UZDpUT
	 pOcN6apAO5mbai1PdBOf3LK6s+zyQy09mW4xNNbJYyy5LJLJ8Obr6l2PBzcII3Epfn
	 VSualKyxA/XhnE9Xjyp7tRmt8dBqX9fT7Vyj+PgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0749/1815] PCI: starfive: Fix unchecked pm_runtime_get_sync() in probe
Date: Sat, 12 Sep 2026 08:41:39 +0200
Message-ID: <20260912065706.489265110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Tariq <alitariq45892@gmail.com>

[ Upstream commit aaae917990623a6ca6b638557056606a1ae4a8d6 ]

pm_runtime_get_sync() is called in starfive_pcie_probe() without
checking its return value. If runtime resume fails, the driver
proceeds to configure PCIe hardware through regmap_update_bits(),
enable clocks and resets, and power on the PHY, even though the
device may not actually be powered.

pm_runtime_get_sync() also increments the usage counter even when
resume fails, which would leave the counter unbalanced if this
error path were later handled without additional cleanup.

Switch to pm_runtime_resume_and_get(), which balances the usage
counter internally on failure, and bail out of probe before any
hardware is touched if resume does not succeed.

Tested on StarFive VisionFive 2 v1.2A board.

Fixes: 6168efbebace ("PCI: starfive: Enable controller runtime PM before probing host bridge")
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260718153352.661930-1-alitariq45892@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-starfive.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/plda/pcie-starfive.c b/drivers/pci/controller/plda/pcie-starfive.c
index 0ca39f3fa1d4f..fab44054a5de2 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -419,7 +419,11 @@ static int starfive_pcie_probe(struct platform_device *pdev)
 		return ret;
 
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0) {
+		pm_runtime_disable(&pdev->dev);
+		return dev_err_probe(dev, ret, "failed to resume device\n");
+	}
 
 	plda->host_ops = &sf_host_ops;
 	plda->num_events = PLDA_MAX_EVENT_NUM;
-- 
2.53.0




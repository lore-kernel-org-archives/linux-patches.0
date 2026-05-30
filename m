Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4752F6184;
	Sat, 30 May 2026 18:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166638; cv=none; b=eKUeO9pghEsj0W3A4EDL8NiUVa6hw9w1VFnl/xWoNkmKhlNJDvYkM89CLeenrlzpgn8UlokGOQScDWfoPvcrPfLSE+t6qlH3fWlXRB9EAdeumE7yNiF3Jz2eaBDhEcQEIUtT8TgvhL7YTfteNPMDZvH0rc2seez5rWkmXNnMdPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166638; c=relaxed/simple;
	bh=o/y9YV2fWscdt5cXFT+C9uoFTmXQdVvyMVCzbTYQq6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSu8mz8Ji/xOjDtmAALhQod3q1ARXpxB6vBTotbQrxVZ0+L6jKHDWSq2bfLbtJfpgarQP17A+bEbYojrTm6JPq/+kCb4Z7BLzGOM7CO9ylmgS+gRU/ujkJyZ8mYJayVLwc7G/YDeR8mvOqVZ/8OHci3LPG7VRl3RfAG1vWVMomM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9E7MC+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9E7MC+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7661F00893;
	Sat, 30 May 2026 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166636;
	bh=x7xDhp13WdsUAr18ECb1RAvkjofdp73Fbu/5YDRu8U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9E7MC+Jszt6ug5DlJz4JOHvz8/gsvjVPj6OyIV2QgZ4vhgIGLrryowjIxnd5weV6
	 il3KEn8UXHPd43g1EApsFBQ5FwYhJdJkDw2hE58WyyD/K7EmTdh3SvgFRv2vN0WTxa
	 SK+Leuj3X+Tr1rLAtG5igICT/7RnVTrKfExX+nCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/589] e1000e: Unroll PTP in probe error handling
Date: Sat, 30 May 2026 18:05:06 +0200
Message-ID: <20260530160235.897494333@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Vollrath <tactii@gmail.com>

[ Upstream commit aa3f7fe409350857c25d050482a2eef2cfd69b58 ]

If probe fails after registering the PTP clock and its delayed work,
these resources must be released.

This was not an issue until a 2016 fix moved the e1000e_ptp_init() call
before the jump to err_register.

Fixes: aa524b66c5ef ("e1000e: don't modify SYSTIM registers during SIOCSHWTSTAMP ioctl")
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-12-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 902ada6a3b06c..8f1c6f08be00e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7642,6 +7642,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_register:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
+	e1000e_ptp_remove(adapter);
 err_eeprom:
 	if (hw->phy.ops.check_reset_block && !hw->phy.ops.check_reset_block(hw))
 		e1000_phy_hw_reset(&adapter->hw);
-- 
2.53.0




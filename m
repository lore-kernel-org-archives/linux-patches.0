Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E638B309EF2;
	Sat, 12 Sep 2026 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229720; cv=none; b=GT+a1qLPm+L3nXNgFSiUT0WxwcpqC74A8S+hRRzFZ4uFb3kDiMBagANj4hWf5iJNGbYPSoI8PILQi0wZkvjUL2TQB1J3C0mSS76hr75oqUKifnMDBDhuljyj13pDzjmVqtrtBf3VXG31jQoQ/rNx2xyTPuP0uZcJlLUZjOPg2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229720; c=relaxed/simple;
	bh=T/ChrBiQuX1bEYFryBsrRIG0jmRVSfIJZkoWhgKr0Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6oyTewlGuTrk4MtHnQ0hT/L2pfODQBxnLh/ehLqwty1+TatW2MfXH3eT9c+o6YrsDrWLnAcx9hznPzMyog1N1YdKkjGSMMZBMsw5YNavOX3CWivjHi+0c47GI6XJvf412eOjU3LLSJ4at6nEvw885zIpwF5eeoRXI0ztC4n3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLfGnUSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLfGnUSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AA41F000FF;
	Sat, 12 Sep 2026 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229718;
	bh=UcNB3kln+bdVZS8wPHQHLChQ2ttas/1Wn7JGaKofXXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLfGnUSpU3DPk6QrC8NFDxmt6NNmzlGmedtU/jVqJBKwXItbRn33viqTCZXUkOBnl
	 gXePIJXbhCR0gwBzaIb9iPee5CvLmRKFoDykKNdaH8d2w0VpoeKd07KzsAuv1xmpXx
	 AqFD38UAW5hGC1K5hZL6P6IcLwiQ3nCs6zYZXIaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0604/1191] RDMA/hfi1: Free RX data on late probe failure
Date: Sat, 12 Sep 2026 08:55:32 +0200
Message-ID: <20260912065601.814990272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 8e17e101e04a3dc062e2719da57ff78c1c060632 ]

hfi1_init_dd() allocates the shared AIP/VNIC RX support before returning.
If hfi1_init() or hfi1_register_ib_device() later fails, init_one() tears
down the device data without calling hfi1_free_rx(). This leaks netdev_rx
and its dummy netdev.

Free the RX support after IB unregistration and before postinit_cleanup(),
as done on normal device removal.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-7-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 9c2a0b126e9f6..e3573e833a0de 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1679,6 +1679,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
-- 
2.53.0




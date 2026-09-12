Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C893B2F617C;
	Sat, 12 Sep 2026 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238659; cv=none; b=C1/OTim4BbeUU6siEcv3cDoU2gmgZwBIICG4s2jnXh+8LOcmWqQUo03GH06HUTy5w/ge5qa5GokIidSx0oSZzXURodBAc+liIbB09hWtwzLpjMOhpMYNLF8B4sndnHhPGpuU3FV8krbUzrJ/J0ENIfZFErI2ErynFqiV4G4eujY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238659; c=relaxed/simple;
	bh=QUgL3yI4xPGZJ8wdqDohGIySZzULZyXCXhqMFo3ffpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFyWPZqhkC8IQ6uqZNNvEQHenV4pOCfCB/hFAhdwUlCaR0sjah33QHoH5dCuQ2vLuyoMf2eaU6iRBQX8QmRmNq56dI+ux73hns9ilfDIyHwvhCWOjoZnuDGqW+suPVmNBCLgOf0vFNDAuOISJsLpIf1OCvG2Kj7ON2aji/73KWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfnzQVuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfnzQVuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDA41F000FF;
	Sat, 12 Sep 2026 18:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238658;
	bh=31s1oGi4fLpgbo2Lahj3woJsjalUajkVhK3sxOPu3yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfnzQVuYT9pWKoMfHMVsK2VZQCunJuAjqqyvcOKBzO2wg+TR+/GVG60CvQWfqlYkC
	 gwLbvBzu/YAK2KpkamNCBpHekte2A4U8lmkov/HGZEhDhNjtNNeYEC10h1Q2rz21cS
	 6UhRFfEKl7DMHOQgXGO1jlr7XlOVpIT1nwL1DrAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 508/935] RDMA/hfi1: Free RX data on late probe failure
Date: Sat, 12 Sep 2026 08:58:58 +0200
Message-ID: <20260912065538.469749469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 02e2efd180a10..1a3930c2db7e5 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1678,6 +1678,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
-- 
2.53.0




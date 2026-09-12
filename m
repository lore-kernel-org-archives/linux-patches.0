Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5084F4D5A1;
	Sat, 12 Sep 2026 07:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198605; cv=none; b=WTJIsHHJCKtIHDXoVaAaKiDb2AXWFV65ib+Ct1ISgNc0d+MSLS0KarEa3f8GRKoc/5vpLFl1X9JPw0Om5qtd3cNn9gqW9QH5I5VIL+zx3R1iVWRbjxlWDp6LjsTK49OFCfQP+5B7HHNuIKXxsCL1NJ0d+o3TenX9r/VTT7hvjZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198605; c=relaxed/simple;
	bh=JC2TNxapcmXUwsPzMgMeboC8E1JyRMNSAgRi7e0W1xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9+eIiJQFtn/dyGHSLHUTXLRSSS7PSUMn/qtXBScn3aCbCABQwlD1Pp7ENGazbAJNsYxQA81ARE7B4ZQH57vxhmGrVRp5re4QN2PGKgIxT0Wpthd/ogst2hofo2S5EAUwRCx6D22o/OF5pcV0QuVvGELPL2cvEt9gytZrjujuIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPDnkAyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPDnkAyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1B01F000FF;
	Sat, 12 Sep 2026 07:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198604;
	bh=Pp1n5JiAT2s6MwLz8jPJfs14EnDLFaa3hMJ289osfWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPDnkAyJOoJlH/RT99a429n300JYVrd5yKa/WA3fOrLP6JJrbr34GowJl4P47mTHp
	 bnxri6tFK3NrFMX5aIMvZH7mym48F3cOo1l/uG/KLPaqtke0Ovy1SE/tpefRh3JAAf
	 0X9kKGNpL5yzhfdBtczpHnNF8YY8+9vGr9FiOmYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0362/1815] RDMA/hfi1: Free RX data on late probe failure
Date: Sat, 12 Sep 2026 08:35:12 +0200
Message-ID: <20260912065657.404038809@linuxfoundation.org>
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
index 3a408399f9ab8..11141a1b950fd 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1686,6 +1686,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
-- 
2.53.0




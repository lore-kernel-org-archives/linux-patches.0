Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D783037F8BC;
	Sat, 12 Sep 2026 09:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207157; cv=none; b=BfRfXYodsO2QPh3Dxlhc/nj4DpYEykrvdC5eFfUkEi6eKk3kw9p36H0gSJNPjttJ08Aaf7TE9gzWxy+OoprvwLx8xWMpw5Q3zUupeb6kgqy6hdjB1PsUXM5skntrwfuk5FiAjU/CWMNdCJdW6DHew6/LiyuFQ57RrBXBiaSlNEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207157; c=relaxed/simple;
	bh=uKEEOKQdqt37Bkjl1SUN56Le/POoENMBG21nLYu7Qyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf8USieg3mc9elgrKKHGHiiRc4srD4mhYqDuwwvWSD9AdyTo6Nk+5efqvD33z/BVtn1ivcSbziCKFijiVhssdnGrxVVwtSxGBOy6/5CjGpViMLUUUEWT4UCGZqNFoZXaiOhG6NbFD3Ai01o3FY2Ajzy2pIeGCxvmMODeWWvknVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOKvAM+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOKvAM+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFF71F000FF;
	Sat, 12 Sep 2026 09:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207156;
	bh=VRKyX2p+SUadooXEc2dpEuvCE3CTsLXlZ/6U28Tanf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOKvAM+4RoP+kCmAT94UaYlA3LfCshZYS0WqbR46ggJcXosj3t6ZJjJOiohogah9U
	 TyL4d7m8b1GXR+68aUGg3coO4+1y8Cb8O+TDbarq9mQMeRoLwg7HuH9RTn/gLIvQH5
	 kuB3Ccls1+F0VCY9xrp9QINPFCwF8ContLZpYIVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0354/1518] RDMA/hfi1: Free RX data on late probe failure
Date: Sat, 12 Sep 2026 08:42:03 +0200
Message-ID: <20260912065631.482137020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 8b5b4f58aa62e..cb6851a5df60e 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1688,6 +1688,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
-- 
2.53.0




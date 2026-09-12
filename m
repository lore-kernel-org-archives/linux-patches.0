Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2FA2F6931;
	Sat, 12 Sep 2026 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229716; cv=none; b=PJ3WCSZjPhbXGcb+Zh5BpFD9jRmB4jyCjuyBrFuc5zax21lC1d4bRlW7RZiJfI164wwAr1nT5nHyR39U1kT8sSvwTzgoM0L8zNdfM3c04qJ/s1Fcv2CGGABXRjzo8Hvn39ib5gxxZ8xQ6oPC+uL9n3Krm9gz0hNxDhoktNT/l1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229716; c=relaxed/simple;
	bh=nzXj/UyqnSZK6lWdQGVuYVskpTLK96cuRyYhTeo1lyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDUifKWySAYW8pj00GKVR7rqKHjVMPR/J0a02oC4GLyJG5botAzJC6mPCxnMnPa5liExMLtzXAuAd2qqdWgh/CGZHwv14FmGVHKjs5RJrvUTUKeUR3JtmyXN2kvhjeb2KQ+iMxpwouwLL11xU/Uw6mIPMprSutmaY09HPo/Ac6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hkmdq+2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hkmdq+2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040461F000FF;
	Sat, 12 Sep 2026 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229713;
	bh=bQ0G3e0Vus/C5l0XocVZB+x9irjkKswGMEW4H3qod40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hkmdq+2StV8dvDrgeqA9OtJ9NzCrGbhLyZ3tOiIUZc3Fu5FjpoeHN2uaQ0o5Q5QAu
	 7TWfuXL+N2tfHW/vLSHzpDO1j66pz3nzb/ofOS5Mc3uvM+ZCFctcbweav9myHdXlMv
	 nM78711PQfhbZDN26KMfAI/d1T5tzpq8XJvkC1yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0603/1191] RDMA/hfi1: Preserve unit 0 on allocation failure
Date: Sat, 12 Sep 2026 08:55:31 +0200
Message-ID: <20260912065601.793316990@linuxfoundation.org>
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

[ Upstream commit 2e3809ad8911f5d5581b3f046bd628417bface76 ]

hfi1_free_devdata() assumes that the device was inserted into the unit
table and unconditionally erases dd->unit. If xa_alloc_irq() fails, the
zero-initialized unit remains zero, so full cleanup can remove an
unrelated device from index 0.

Release only the rdmavt allocation and return immediately while the unit
table has not acquired the device.

Fixes: 03b92789e5cf ("hfi1: Convert hfi1_unit_table to XArray")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-2-b9e9641268a5@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 436372b314312..9c2a0b126e9f6 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1228,8 +1228,9 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 			GFP_KERNEL);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
-			"Could not allocate unit ID: error %d\n", -ret);
-		goto bail;
+			"Could not allocate unit ID: error %pe\n", ERR_PTR(ret));
+		rvt_dealloc_device(&dd->verbs_dev.rdi);
+		return ERR_PTR(ret);
 	}
 	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
 	/*
-- 
2.53.0




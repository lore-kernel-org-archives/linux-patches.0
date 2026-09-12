Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C97386C21;
	Sat, 12 Sep 2026 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215347; cv=none; b=CTa3o2m5bZUAtpE1n3Cn2spFZMiXWT99830bYQoHBiaSXgDwSRcN1ToN0480aYIaSJO3poNwTTRtMUg9xFKElD5c5wgxoVntZ3Y81Z9CEBxfYgOWa9tK/i48Xom9H3ljFrL2R/YkEd0t9NSwecVTv5QIOGRPiCNjsW+nUKbja/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215347; c=relaxed/simple;
	bh=h6MQzWJfgu0qsh362hBU4TfkLh32fwpesgBXaYyRDbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkU36ztXPAZnZd+Qp5ulGIYEX3UzfnoFqmKJPm3FER7kNvwugg8+jSxU1biNiqRxfqGoyRQjIUcalUcl8nw/Tgso6aXtcysZbkAMuShAP3axHIRXbs3fpotP9oiyb4E1bJfGmC5ASC+23Rtpz2qR7AtUcjQAsFqiLQltcrYEjxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2i9LVVEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2i9LVVEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F4A1F000FF;
	Sat, 12 Sep 2026 12:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215346;
	bh=dWLRigQPs1uMlxi89fyk0s4wFCxieWqvkCLr7q/kgSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2i9LVVEd8sjBbmzb9FF50FgEt/SsGIy9hTJW9pw05Im86PRbAkGaJgP4STKYHeG+e
	 EuuglUNZ+aKeuZ0u4Hx6sjTku1P5wAiv768yYJJXyapo0mhe9opIa8IVBkzOKoF9M4
	 ZJl20R0BMTNuzDpWjFmS79O5Euk8euNMAW6PMDd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0511/1376] RDMA/hfi1: Preserve unit 0 on allocation failure
Date: Sat, 12 Sep 2026 08:48:57 +0200
Message-ID: <20260912065618.926421104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index cbac4a442d9ec..e84616bc4fa99 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1227,8 +1227,9 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
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




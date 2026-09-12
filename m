Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF1C37F8BC;
	Sat, 12 Sep 2026 09:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207152; cv=none; b=oltSBuhLcnpVZUh58ZUlnvBxGgo9eZnVhvPAralWXp4pzV3D20dDfSkdIwUceb0PePaFx47pGHMNTciKnXtcE/6RNganF3sn4VlaWCf2zk8RbxmQOg4bgZU9qC/LOWERKHbZgThgwJGQLxpLgc0dwiEMsTQWEd/EvIAlcAldFvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207152; c=relaxed/simple;
	bh=aHnwudJVtHoK7JQtsIksr5wWr16uqyXy+3T/LHaM7IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPLOwDVPZ5EbsoqK0D/c0JGf8bvNCfWI7e0OKIszElomAShlH0Cl+pV6xNUKRwBo85AHFXPvP6/3pCFBhi0UeFcqgH5zDZ3htnVc8uqlmOMfuTIH3sRe71n60xsiBJXEeXPUb5XF8DChent1K/JEjMdBCe3A+LdfTntfrRCG0Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/j/OunP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/j/OunP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEB11F000FF;
	Sat, 12 Sep 2026 09:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207151;
	bh=uvIW+vBTI/ieIakNlQ6ZTU71twlr+M8e33rH0xc2VUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/j/OunPD3WRSnTCw9pZlBUSeAVcJNYv3tmElB0oqNoBtMquc6sXRaGrXi3W7xdJR
	 yUF0uaVwW40JNDeyRS10tSa2NkT9+5cgqqytrDV4sXUIY0r52J+7lJT9SxzlxF6KYz
	 GRnuCX13XkV/fG9wlDisadEzlij05gFiOZ3wP+dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0353/1518] RDMA/hfi1: Preserve unit 0 on allocation failure
Date: Sat, 12 Sep 2026 08:42:02 +0200
Message-ID: <20260912065631.459750178@linuxfoundation.org>
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
index 7e0298c62882e..8b5b4f58aa62e 100644
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
 
 	/*
-- 
2.53.0




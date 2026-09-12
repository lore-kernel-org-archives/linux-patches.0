Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A8D1FBEA6;
	Sat, 12 Sep 2026 19:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242637; cv=none; b=VDvwGsnF9Q5CT4Rs3JXCCcT+j7hAlQbJKQALPUt5GwQWQSY3OHPZotGc4acxBiQGmXzBPU2w69uOZIvgFwaPdHzh+h4GYwldbY2kMday0SQNX+q8QaRWKgFjGaMUtd09jTEOEAyuQhrsSyI3eP5hrJVIJMy51YPcHp8h2geH+j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242637; c=relaxed/simple;
	bh=CFbdjfDCQwhUgOQCOJsNEt/xWRyU+HYEKGbxMLdsRqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUI35TWacTTlrq7HXHZZejDsEplsweEGwZfIZUUeOFlM8US3Qtt2sBkK3LrV/rhK9Er/VsgOFRBabG0of7LohpYEyPjMEmlcyczfSqG107R3wGQcbFu2UExsFxBY7su5kdijmF2MAAk9+lOeY9AKuG76I15J23dyRlk/zBeToTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3SQoNDv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3SQoNDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A791F000FF;
	Sat, 12 Sep 2026 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242634;
	bh=sEMzhfkxaMi1Kw8+WzR+3bs+BI2VBVHz51zdNCUN7oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3SQoNDvaN4Dw0d5+Pa+Z5xEz5DgYAN+/pOmzFLANP1kd/yg9EYsM5y9ofph1igrk
	 pczD5dh60TeLUL+NiARXCPwtca7tb/E9A5PEHsMem0+oJpfoNnwdFyeJiCIbcN5LhL
	 NwQ4ikU1v7hSb1eS6K2Yz51lSztfqrCcKUWlouuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/798] RDMA/hfi1: Preserve unit 0 on allocation failure
Date: Sat, 12 Sep 2026 09:00:58 +0200
Message-ID: <20260912065527.003039114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 837293aac68fe..c4d098344d8e2 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1269,8 +1269,9 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
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




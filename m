Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4A2D7DEF;
	Tue, 31 Mar 2026 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976942; cv=none; b=p3Guj9CCQO5AayPllt4BDfsZDnarmmpq8xU4O/PwLIst4vjWVKxrBInUODjFWBdgozfu9hfSY1ERQuDl7sCw1ebL+2aiidLFI0BPtp7iccNxKuEZvGzgCtROkVrodP/qw7Qwvk5+2lJK0hx4OqGk2FCcRMdO49VvCnVbzm2x6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976942; c=relaxed/simple;
	bh=LLYMil9R1aHLtGMB8rsUJ5b5/oqyBZty3w83di6SKWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZk3j+tdN82eK7ataT2NegKnpAoXKlbHVZjyS1UKLWBbQAWmA/rhqywFsAIbYB3nEhKUt1VHk/MOrk7DVQ9oHxQNB7635+tUg7OmsOPvn+Dmw7DG+RwmzKTWjtj1Khp85441tRnbMnfcTDsF33dxsSfYCWo4Wj/Zyqh1AmpakJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQJEbG3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQJEbG3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A6CC19423;
	Tue, 31 Mar 2026 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976941;
	bh=LLYMil9R1aHLtGMB8rsUJ5b5/oqyBZty3w83di6SKWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQJEbG3vRE3qQ5YWaDS1KveGG04s60uMRIEmY8VV3yqGNIHK8vzHmuPPu3nrUh38X
	 d4fSSTJKahdy7lk3ONVz8ymAk7/QNZZaJ2eJXgN4JHdAEQt8Teoz6D0/buHngExccs
	 9+uSpDUS/+i+rBtFRZCTUtAATALiMsMEDpe7lqHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/309] dmaengine: idxd: Fix leaking event log memory
Date: Tue, 31 Mar 2026 18:23:11 +0200
Message-ID: <20260331161804.169000288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit ee66bc29578391c9b48523dc9119af67bd5c7c0f ]

During the device remove process, the device is reset, causing the
configuration registers to go back to their default state, which is
zero. As the driver is checking if the event log support was enabled
before deallocating, it will fail if a reset happened before.

Do not check if the support was enabled, the check for 'idxd->evl'
being valid (only allocated if the HW capability is available) is
enough.

Fixes: 244da66cda35 ("dmaengine: idxd: setup event log configuration")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-10-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c43547c40ee34..646d7f767afa3 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -818,10 +818,6 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	if (!evl)
 		return;
 
-	gencfg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
-	if (!gencfg.evl_en)
-		return;
-
 	mutex_lock(&evl->lock);
 	gencfg.evl_en = 0;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
-- 
2.53.0




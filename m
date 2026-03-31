Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50383A1E8C;
	Tue, 31 Mar 2026 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976192; cv=none; b=FigeSwTVDa6na56wgRtmFuPwilccyjLbh375GZFil+5CXlCHnkGH1c7i9AZFDUl49rRCDafbNGrSJXXaZGkjNPK4ACz9VJAPMsHjvH/Lj2rPMjb/bR3fX9pA+e1vkqceMDMw5mcynEUtq1QtxqVdTIWZrBk07dAH6cxxNZZkxs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976192; c=relaxed/simple;
	bh=+6AJMr/I2idPSK1D6DaxdDtmeX9ppr4BMelvzuPAJIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISBfOQI6mVgijkOwwQ/7XzVTH/hwkys9m8ZBf5eX98Qprw8ntLrfQ06YFm9QFQc0wGaFkhqYidPGGK128Zj8ZwiU3zCD+sqsv9rAxnKN6x/BrIUf4jcp64CxoPJQDToTJcFhdz870WBoPBrAHHOJzf+/dLoSjNuuBZk3TIl9qQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBxObRHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBxObRHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79817C19423;
	Tue, 31 Mar 2026 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976191;
	bh=+6AJMr/I2idPSK1D6DaxdDtmeX9ppr4BMelvzuPAJIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBxObRHZ7tj6R/SRhw0rTAtbPIBRS7ZUuulp0lIxWNNXBf4NjIh38hwoYC1MSY8fr
	 bIaZ9p88/mmn1hVZ6v2yYtlowFpeOKnW6wLyjeUU860ToVykR6TQQZCBXJvMrskyhO
	 LlIEcuMsWTGu9qlCLU4YLLOK/lUS8AUMXeoO1D2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/244] dmaengine: idxd: Fix leaking event log memory
Date: Tue, 31 Mar 2026 18:23:11 +0200
Message-ID: <20260331161750.658270441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
 drivers/dma/idxd/device.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -815,10 +815,6 @@ static void idxd_device_evl_free(struct
 	struct device *dev = &idxd->pdev->dev;
 	struct idxd_evl *evl = idxd->evl;
 
-	gencfg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
-	if (!gencfg.evl_en)
-		return;
-
 	mutex_lock(&evl->lock);
 	gencfg.evl_en = 0;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F7D2D948D;
	Thu, 15 Jan 2026 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499061; cv=none; b=h067kONz0oCAylL1J3PipLy6G+HM2LIs4YiHQpPxTBM02qIBf5oP2a9Bltq3Dm9k3ib4YT63MGQa5IzqwRfVH1NeqqM/OMtOl7t5IJaGIrAUL/xlhpJ2wRBEMzhr7mS9qMxhkTTRTsCRC4l/Aky3cmPRMA6ePxy6IA7PvZy1K1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499061; c=relaxed/simple;
	bh=2ouPIy4CQ36D7KRxcA/xblWT+K9blWNfm/enUT+U+ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4zngMlqX+1ggLaoFQ9xOX+U1hHEx9/Sp/i6v2tZ363fn6v6qEN7J9UsItU79UXlr/vAKfhwZub3JdsKHLt5/EQkT5L7pLSOyfrcycAVOQ5Sq3Nc4HdxXmZ3MP02mIpTYxMBUyx1I+SNOcOSy0Dii5lnj56h95oY01VpYZqur9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNql++n+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNql++n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08896C116D0;
	Thu, 15 Jan 2026 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499061;
	bh=2ouPIy4CQ36D7KRxcA/xblWT+K9blWNfm/enUT+U+ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNql++n+GzS/mRk2CjffoqIfhoNdnEAigPuszn34mSH9Rq+acXkfhoiX/3dNsKqYt
	 Lzw8Ozb0j/lCJ0+CIfTO7cBRK8ktVVX6QnCmd/NA0nVaVHivR9zJyS+OYkzFEAtcOH
	 P1IJgqUlbZBeTxpGmeRsUqM7FcXnTNvFvv39GjD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/451] i3c: master: Inherit DMA masks and parameters from parent device
Date: Thu, 15 Jan 2026 17:44:12 +0100
Message-ID: <20260115164232.744766415@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 0c35691551387e060e6ae7a6652b4101270c73cf ]

Copy the DMA masks and parameters for an I3C master device from parent
device so that the master device has them set for the DMA buffer and
mapping API.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230921055704.1087277-2-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 332b1f02e6ea5..507fb6d26d330 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2668,6 +2668,10 @@ int i3c_master_register(struct i3c_master_controller *master,
 	device_initialize(&master->dev);
 	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
+	master->dev.dma_mask = parent->dma_mask;
+	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
+	master->dev.dma_parms = parent->dma_parms;
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0




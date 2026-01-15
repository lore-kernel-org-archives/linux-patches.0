Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2838B2874E6;
	Thu, 15 Jan 2026 17:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497484; cv=none; b=WWCJjurCo1jfliTZQjyrbY/6Yf2enRm6yEknSGX1weqZbcLgyrEG1wcoR0iOwFm5Xc+UWZFiBya+xAOHpekYlU3Z6u5IaR18xLqhESirfdNTE2fDvbG+79hDk3YgEbwpnc3xY9QHrsPYR055POgwu9N5IcQKr5b9JHDemaC67qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497484; c=relaxed/simple;
	bh=rBLmdlSoQajk3wndYp2CleymXjhUPhUUsgqJsQatrf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUkC4ayLcH2dXmHqhOkxol7Vs9srxPpzDh27xlp3stUQ4cUr/VCKPXSVBjPyeqIri2f29jK2PwohqjiePsF2Gv6fX2R6nDQcTK/GqGr3ENZQpt2NxmL0UhRVLVGifFVA5wNwaXBr/9EJCxixx2hCs7ZpqQX+BDgF2eqfJnoLH50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqxEQrmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqxEQrmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF9FC116D0;
	Thu, 15 Jan 2026 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497484;
	bh=rBLmdlSoQajk3wndYp2CleymXjhUPhUUsgqJsQatrf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqxEQrmTuXiN3+q+nfB8IWJaGV7WzF3p60RUBmlooMjzYsILaVBEEA++PoBUk4NiX
	 ZWatfk4vHVByuzOMka19fsKaI+j0FbP5qDqkOvJG0F4Fi6e0Si5aL3vPR5EYtPFibc
	 cqr3B9gLQI22rDvm5mGXEa8RbGoLSD4j3W4gG9eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/554] i3c: master: Inherit DMA masks and parameters from parent device
Date: Thu, 15 Jan 2026 17:42:11 +0100
Message-ID: <20260115164248.597296769@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 209aa1e889044..459399cd70da7 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2626,6 +2626,10 @@ int i3c_master_register(struct i3c_master_controller *master,
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




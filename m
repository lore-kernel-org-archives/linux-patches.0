Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2602C11CA;
	Thu, 15 Jan 2026 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497422; cv=none; b=Veijka9dIIO7bq0y9rPTr2D4wU/HZh5iAQbbZHLZG3dNDOZG3tLSLOCVps3zXYVyllVj5oCPpUTtEgrKDcfhIoFh9SJJdMvglW2PxgjeZJZdBJDFy46Uk4EhSla3GXhJo8PnJeB/S675+bf0BspJO0fxUnqkKwBY2O+8v66+dHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497422; c=relaxed/simple;
	bh=4bTKiW68aM3Nbphnl/gsuHPlz1nBs3HXv4LUl0gWr/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihbBWzEARbYs/NzshzITaGYZixD3bNVpdC5QcsPQAtqtncx5Twi/yvAI2iZUqyJ+0GS2hFXV5atq7/xD5vjl4jgBiSQuEdI8Yu96FDG1Z1i81KllIwd9YIN5olpVyPqTrmrcnBVV/cSV1wK6Ivj9FF9wMmUOHsdr9fAdNy13jKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDPO5uFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDPO5uFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD78C116D0;
	Thu, 15 Jan 2026 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497421;
	bh=4bTKiW68aM3Nbphnl/gsuHPlz1nBs3HXv4LUl0gWr/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDPO5uFX1Yd0eY8nivrBYpq3H32Fq/JPBvYcQ6LD6UDmVd5SCImxKLo+CpL292EkN
	 6PvaVMakhdiGW9BJ0SIvgtuQynIVOozf4RP4Fas2KA3ICY+SzSdIsG6i0gjh56lAaJ
	 6g4Sv+8/GwJXOb2Q5ZQzn6cFLvPnuUOsZ6+HqX30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/554] mfd: da9055: Fix missing regmap_del_irq_chip() in error path
Date: Thu, 15 Jan 2026 17:42:22 +0100
Message-ID: <20260115164248.992356822@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1b58acfd067ca16116b9234cd6b2d30cc8ab7502 ]

When da9055_device_init() fails after regmap_add_irq_chip()
succeeds but mfd_add_devices() fails, the error handling path
only calls mfd_remove_devices() but forgets to call
regmap_del_irq_chip(). This results in a resource leak.

Fix this by adding regmap_del_irq_chip() to the error path so
that resources are released properly.

Fixes: 2896434cf272 ("mfd: DA9055 core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251010011737.1078-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9055-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index c3bcbd8905c6c..a520890090ba4 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -388,6 +388,7 @@ int da9055_device_init(struct da9055 *da9055)
 
 err:
 	mfd_remove_devices(da9055->dev);
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
 	return ret;
 }
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9802236E0;
	Mon,  2 Jun 2025 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873538; cv=none; b=AsAdx5e9JiRskiQttHzRgbrkVmIIU1IrUAO8fsSFuUgkmxzZVDUhbIrBOALEkFPKg/TLcEqFC5fF4rdJs1twY/v/Hwr7bNNC5vKwUn+uskHgj5WtIpIRKn3IVtCvKCY1p4hCKSdrf6/3xuSPhgZCWqEd/NhMeOZ+00HQojtauAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873538; c=relaxed/simple;
	bh=2Qi+C3wRoamAH5+FPBNDdyaa0ZN9bt34kmOkDcJKKC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5E9kY6pux8/Vp0rPgO1GBzOoAkhqZkJzzC0EvDwiJS5O8qXl8um4Dpew+Te0pTbaN3EiQTyCgcAwgAFvYNfMQDb65Ao8W2Mdt0mzj+nXN8I2CTEgMs+XxI2fzoSCTLKVuxorNanFWjX5HTOA/zNQuHA5IZNO1HoFlm2JGn9MLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+HSu27i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+HSu27i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2ADC4CEEB;
	Mon,  2 Jun 2025 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873537;
	bh=2Qi+C3wRoamAH5+FPBNDdyaa0ZN9bt34kmOkDcJKKC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+HSu27iR93TzpUgLI9rkXtjr5hD6ZHBtsGrOA3+nbwyEWtvx80AyDADBVbu7wsAU
	 DHoHSfd9V0datQJdn75RnkmsW1I4AFwkp1ih2zfmOsQFkNGFoRon4Bhg7LGdhArvCb
	 tMHIUJLwVg4KJL+6cYA2TZEUbQJwCh+MAdRTistU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/444] firmware: arm_ffa: Set dma_mask for ffa devices
Date: Mon,  2 Jun 2025 15:43:55 +0200
Message-ID: <20250602134347.841428245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit cc0aac7ca17e0ea3ca84b552fc79f3e86fd07f53 ]

Set dma_mask for FFA devices, otherwise DMA allocation using the device pointer
lead to following warning:

WARNING: CPU: 1 PID: 1 at kernel/dma/mapping.c:597 dma_alloc_attrs+0xe0/0x124

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <e3dd8042ac680bd74b6580c25df855d092079c18.1737107520.git.viresh.kumar@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index 7865438b36960..d885e1381072a 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -191,6 +191,7 @@ struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id,
 	dev = &ffa_dev->dev;
 	dev->bus = &ffa_bus_type;
 	dev->release = ffa_release_device;
+	dev->dma_mask = &dev->coherent_dma_mask;
 	dev_set_name(&ffa_dev->dev, "arm-ffa-%d", id);
 
 	ffa_dev->id = id;
-- 
2.39.5




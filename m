Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BDC139CFD;
	Tue, 14 May 2024 11:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687053; cv=none; b=ksE1LdFsL/94dnCxsg1KjPkjc/3BpOTG8Zq6CQhFJ6GVpc+oxPlNaeZpX5Lx3fSEZ5zcQSW1q6DOEANGivza3GMs1sWbWBwWOa7rkiIZGx0Y1dx9pNyPyAwV52gEwRytR8eYSX76/og0tlU3pHsWVN3ihWLh2Qv0j0hSDHoUXJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687053; c=relaxed/simple;
	bh=zM7npf2jD1jrE4AphYloLzlrUTqrnqcv/T1+NBt1XqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kur1UAHeSTuYORZJcUkTxjhuiaWrLmH6R+845Cn9rOXLR7AH9d/J1fgN8ZL0+H8oa1awon89lqELTSY8xRzCZMZ8v1qsSDaueip8RATrANdsU/4x5xuXm9fHpqEDfAZ+xkcFp4LZwCRROzLbu0fUqL5s7bhse3VKNb08eB4216E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3N913CJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3N913CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F761C2BD10;
	Tue, 14 May 2024 11:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687053;
	bh=zM7npf2jD1jrE4AphYloLzlrUTqrnqcv/T1+NBt1XqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3N913CJhTT/ro7aBAc+DGW8mtQ/c2vhx33q5iRQeSnTOkw555j80jhrofU+yIYgt
	 y2cPDjUXP9H8l5qTf5wZ6JXTQLBbFzqi4D6NzyN4bvR2O7K3+BeH01mUlkcZ9UW4R6
	 eatwkJzx9Gl6cz0l6dDcFODDSGONiruPNIdXAAzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/84] gpu: host1x: Do not setup DMA for virtual devices
Date: Tue, 14 May 2024 12:19:59 +0200
Message-ID: <20240514100953.495250240@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 8ab58f6841b19423231c5db3378691ec80c778f8 ]

The host1x devices are virtual compound devices and do not perform DMA
accesses themselves, so they do not need to be set up for DMA.

Ideally we would also not need to set up DMA masks for the virtual
devices, but we currently still need those for legacy support on old
hardware.

Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240314154943.2487549-1-thierry.reding@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index fcda8621ae6f9..5a1bf59be7341 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -335,11 +335,6 @@ static int host1x_device_uevent(struct device *dev,
 	return 0;
 }
 
-static int host1x_dma_configure(struct device *dev)
-{
-	return of_dma_configure(dev, dev->of_node, true);
-}
-
 static const struct dev_pm_ops host1x_device_pm_ops = {
 	.suspend = pm_generic_suspend,
 	.resume = pm_generic_resume,
@@ -353,7 +348,6 @@ struct bus_type host1x_bus_type = {
 	.name = "host1x",
 	.match = host1x_device_match,
 	.uevent = host1x_device_uevent,
-	.dma_configure = host1x_dma_configure,
 	.pm = &host1x_device_pm_ops,
 };
 
@@ -442,8 +436,6 @@ static int host1x_device_add(struct host1x *host1x,
 	device->dev.bus = &host1x_bus_type;
 	device->dev.parent = host1x->dev;
 
-	of_dma_configure(&device->dev, host1x->dev->of_node, true);
-
 	device->dev.dma_parms = &device->dma_parms;
 	dma_set_max_seg_size(&device->dev, SZ_4M);
 
-- 
2.43.0




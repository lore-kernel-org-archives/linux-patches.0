Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7D139CE4;
	Tue, 14 May 2024 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683031; cv=none; b=I0l9/mfxdsLzWfggF/Bn8ZtQmYi1fs6qQ+oCUjKfyHqUPSiNg5gZyRMziQ04XKLxzCWkvKjaQ3uMfhrrSnsQOGjvyRC8D8WARkvp4fPNLuyfftovcWIqqm7Npwq3pHpacFnV38+LKB5ztbpt0MeZdBT9IgovqxXLNW+rIco5P84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683031; c=relaxed/simple;
	bh=v38gdOgSVoqt0/duySzFw2Atxg4L3A2wwgo0leq4CII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjPlPgpYmPqd1nZslqDvanVcblIYBcDNDfjf0c+Mu1rju+R9cMkDGEurLXTDcpK6eJjtUP59mGzHht2y6gK4pD5d2iwaBAWgHmEMnE7ns4Yyv7lsKtbB+J6wr3u0pdJDx3bbSJ1TpY7mj50re8W6IG2i4IXyBXOz7VvOEHtqYM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqrJhuHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqrJhuHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06B0C2BD10;
	Tue, 14 May 2024 10:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683030;
	bh=v38gdOgSVoqt0/duySzFw2Atxg4L3A2wwgo0leq4CII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqrJhuHa9JaNciF4RrovCoBUKhvyVFE8bCbzogUHysoYWkzSrgiU6FZmTxkIsv5RX
	 yFayEHFK7r3xagrlwehjK0WX7AINi2YIVZxIRs7hnD9h3BKn0uAZLxRbEM1d/g6rhC
	 RCXOCX/cbMJ1iqstH2I4khUNDDkycxFK4zbLacdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 154/336] gpu: host1x: Do not setup DMA for virtual devices
Date: Tue, 14 May 2024 12:15:58 +0200
Message-ID: <20240514101044.418212873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 84d042796d2e6..3937889fa912d 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -351,11 +351,6 @@ static int host1x_device_uevent(const struct device *dev,
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
@@ -369,7 +364,6 @@ struct bus_type host1x_bus_type = {
 	.name = "host1x",
 	.match = host1x_device_match,
 	.uevent = host1x_device_uevent,
-	.dma_configure = host1x_dma_configure,
 	.pm = &host1x_device_pm_ops,
 };
 
@@ -458,8 +452,6 @@ static int host1x_device_add(struct host1x *host1x,
 	device->dev.bus = &host1x_bus_type;
 	device->dev.parent = host1x->dev;
 
-	of_dma_configure(&device->dev, host1x->dev->of_node, true);
-
 	device->dev.dma_parms = &device->dma_parms;
 	dma_set_max_seg_size(&device->dev, UINT_MAX);
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A681BE864;
	Thu,  6 Jun 2024 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683547; cv=none; b=lTsX8dmAHGuQgCc1eXjz1OoR31hxmEgJU2OZdWuKTQclTNL1WTPIljbQcJ74MxGUI/L99krcc30IdgtbMYRreXRuhIAZgRcpnCBVbiQYYHvwWNZ5tRqGt0h0rkZJF2C5Wy5fn32uq5HqN5Dg6I3KXt1k23eBsN745sDjdSOfRqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683547; c=relaxed/simple;
	bh=ekvw884hrP+zOd6aUpG3CbAmWGhyt4ON4I1s1sCLOwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtzFtMRmEsrXN693DCipkd9FBMA+7k98MQrDzPdAlGoDSPD2clAzKOI3XRAyiL+dyvCgQhBTzu5kCKKK+3/GverHZjmktP9ygv0+1iibezGpQOPlRCxk+qhiSG85fGNUxg3y/3HiwkaHDZ5nYMr8CaRjdVkPcRp8c8tSgeXtRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyswytO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyswytO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9638CC32782;
	Thu,  6 Jun 2024 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683547;
	bh=ekvw884hrP+zOd6aUpG3CbAmWGhyt4ON4I1s1sCLOwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyswytO6ewUEpLHWWK40AEkp2uSQLUVh3SX6nF32JaoaZj008IyyB9g2m+3VtoxMM
	 F/sO/tCnFqLSmhgKH4esclXOxkKDej097hjLT+5Zd8awqcIs3MdCeCklAmfm3AkY4b
	 Wx0zChFj5zrFrFcOfaNvCmH0IPRcY3mJ4eqF4O6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijun Pan <lijun.pan@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 486/744] dmaengine: idxd: Avoid unnecessary destruction of file_ida
Date: Thu,  6 Jun 2024 16:02:38 +0200
Message-ID: <20240606131748.044717995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 76e43fa6a456787bad31b8d0daeabda27351a480 ]

file_ida is allocated during cdev open and is freed accordingly
during cdev release. This sequence is guaranteed by driver file
operations. Therefore, there is no need to destroy an already empty
file_ida when the WQ cdev is removed.

Worse, ida_free() in cdev release may happen after destruction of
file_ida per WQ cdev. This can lead to accessing an id in file_ida
after it has been destroyed, resulting in a kernel panic.

Remove ida_destroy(&file_ida) to address these issues.

Fixes: e6fd6d7e5f0f ("dmaengine: idxd: add a device to represent the file opened")
Signed-off-by: Lijun Pan <lijun.pan@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240130013954.2024231-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 26f1dedc92d38..c18633ad8455f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -577,7 +577,6 @@ void idxd_wq_del_cdev(struct idxd_wq *wq)
 	struct idxd_cdev *idxd_cdev;
 
 	idxd_cdev = wq->idxd_cdev;
-	ida_destroy(&file_ida);
 	wq->idxd_cdev = NULL;
 	cdev_device_del(&idxd_cdev->cdev, cdev_dev(idxd_cdev));
 	put_device(cdev_dev(idxd_cdev));
-- 
2.43.0




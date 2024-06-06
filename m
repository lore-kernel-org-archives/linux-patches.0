Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01AF196DB7;
	Thu,  6 Jun 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682935; cv=none; b=cacJ3Ji9hjPNYr6ht48fym4z6UHfZJDdNI6/9a3acOVMc9DpD8XRxAQ4Yl+0EOSXgbUX4UbTuoSUhLtgfJBlfInSP3gPIG7SrFAvzMy3wSH7KGF/9HMeiwwynhNcnNc27rNX2M24qGlswHP+/mE6yOi8pMqpzpTbY9nNhrMDltM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682935; c=relaxed/simple;
	bh=n4nR08YYpIEgQwuZB9lSqk2RvudulGaa84/tgsm1Uj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3ogqTopxzDDNPbxMRxXkxneRG0aiWlVz3PVx7dvF9wLbjBgwlWHTtVOH8TqCE30BX1U9Fg293/FzKgeY3ZDEpAot3FKSc00SUyZzzEy7cZPo3ae3i6ZcQVRejahrtr1UgsGUB4MAy+7/qCxlatEWIpK/UYhthoOXvudIBQEIQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ybki7QaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ybki7QaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA81C2BD10;
	Thu,  6 Jun 2024 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682934;
	bh=n4nR08YYpIEgQwuZB9lSqk2RvudulGaa84/tgsm1Uj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ybki7QaIWQO4kAi2AtUcIsSCRogxxT8I6FIh24a7iwOn77CWbvWBvyq4/AqgRTg9r
	 LjMHMl8nI4iBCNFKeM21dqMZ6m7OUHxWHsVwFmtAQ1n/QzEE4+Y6nuGc7cKvafFwuW
	 k1PQxLLeGSVgddH5AJ91LPB9wJtqsBuRuz0cJScA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijun Pan <lijun.pan@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 084/374] dmaengine: idxd: Avoid unnecessary destruction of file_ida
Date: Thu,  6 Jun 2024 16:01:03 +0200
Message-ID: <20240606131654.686007171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 39935071174a3..fd9bbee4cc42f 100644
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




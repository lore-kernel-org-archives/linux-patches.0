Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B869306D2A;
	Wed, 23 Sep 2026 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172794; cv=none; b=I9V3anHtl7zpKT3uexFYYPO7a8oXi7JyAD9NEHQpuKMu5hYsHwsdBBqZnNasI8ATV5yY8oIWHKs24MgiccQ269gT+uLSzyd+PatnWXo7M/Dz0xYsFtrd22LEitZ0yn5XHhLTDdMtYXW1xdZtYDCfJufQEUuQ4w0Rhgmu0t6PxTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172794; c=relaxed/simple;
	bh=kbNVw0/jm78262kY7Rf8DXdRZUwekoUk3DEhIkAfH+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwE7+BxCHh0GhYrvNy3CnA+Axid2+FgEC2INbrQ++jmpZQR3FtUwa/ne1Sr3mCziL2ngNbmL6vt/6DAf88qYJxri06xUH9rb3duw9bRiHgDvyRLGvmai2tARmdvlBBCX0MR1JBRb4iEtm6kUTp9pLfeLKu2f43S3985Y0CW3n5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK6uBkVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK6uBkVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8FC1F000FF;
	Wed, 23 Sep 2026 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172793;
	bh=+T62TN1Xzx1GQrb7zIcOJ5koMUmGrf+Idzf3Svskt0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vK6uBkVOre83/zyak0vgdmW/3X1c0+je8Y2za11fO9FW9vmBeO3I+xs/CQ9zxLH9/
	 NPrLqrUVS69v6qf8h2Jcq1grxQEnymGwyjKoJYyABm1c3xmf5esLu0peeo0CSzt5to
	 CVE7vz43VwdZrMxNm5i2pAWDserhUo2qF6KWSrW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Shivank Garg <shivankg@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 063/438] dmaengine: wait for RCU readers before releasing dma_device
Date: Wed, 23 Sep 2026 16:01:24 +0200
Message-ID: <20260923140646.424869646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivank Garg <shivankg@amd.com>

[ Upstream commit dc750422170a563c7a81f6e49d36bb02c62ae37f ]

dma_issue_pending_all() walks the dma_device_list with
list_for_each_entry_rcu() under rcu_read_lock(). dma_device_release()
unlinks the device with list_del_rcu() and then calls
device->device_release() (which in many drivers, such as plx_dma.c,
directly calls kfree()).

Because there is no grace period between unlinking the device and
freeing it, concurrent RCU readers in dma_issue_pending_all() can
access the device after it has been freed.

The lockless walk originally relied on clients holding a dmaengine
reference to pin the provider module, and therefore the device, for as
long as they might traverse the list. Commit 8ad342a86359 ("dmaengine:
Add reference counting to dma_device struct") decoupled the dma_device
lifetime from the module reference, so the device can now be released
while a reader is still walking the list.

Add synchronize_rcu() before the device is freed, so RCU readers are
guaranteed to have finished. Keep it unconditional: providers that do
not implement device_release() free the device themselves once
dma_async_device_unregister() returns. This call will delay for a grace
period with dma_list_mutex held, which is safe and only teardown path is
delayed.

Fixes: 2ba05622b8b1 ("dmaengine: provide a common 'issue_pending_all' implementation")
Suggested-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260526-dmaengine-kref-fix-v2-0-3df60afac01d@amd.com
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Link: https://patch.msgid.link/20260822-dmaengine-kref-fix-v5-4-d4a4ee47d927@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 7de33df0529a7..5b5673fc7344f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -428,6 +428,7 @@ static void dma_device_release(struct kref *ref)
 
 	list_del_rcu(&device->global_node);
 	dma_channel_rebalance();
+	synchronize_rcu();
 
 	if (device->device_release)
 		device->device_release(device);
-- 
2.53.0




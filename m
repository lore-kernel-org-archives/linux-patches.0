Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B8B4BFE95;
	Wed, 30 Sep 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788245; cv=none; b=jZkiivaz6TibRilqbg3X+fHw/dgENskh2Gs+mblo4zsUZBv5seIO3MeuTuvXdgA1+Y2C2/1UuOGWKLC2pmODI+n+J+IBYob4wGxagFzQ0iw24LiGvbz8hrjtqLCjIHipvX5CLlMyKet2NACDLwYA6XzhTw77oQK13PM7QRbLcMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788245; c=relaxed/simple;
	bh=IP2cxIbOr4zPuzIUUJ+WR8fMAYnI5z82d7UXvoIAfrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEOp+mF1EUPyf58z9q0CxMRd8tSJ7x+IBRGe6EJJ/KsodcLR35yhL8pjowQ5+ktJUDIdeAquQ3kydnquRUk8XaaESoZ44rnBprTy6fO5ipBX7y5Jbb2/O/66c3VYcZUEmHJxxcyPpnBRtZljAW3rJini24RIO09QDHEnxc2UK9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoH/6Pgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoH/6Pgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067131F000FF;
	Wed, 30 Sep 2026 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788243;
	bh=uPYpWLYoTBGrd43hGPTUK0a3hleHHshCOlNfwlc9Jps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoH/6Pgz02/1f7qLlAEhFKg4lHgmUDcUcG58m6JFyog3GWfBx1jmrbOfCLhTy8TUK
	 o4MWpgx2YLqq4ayFyCEV20H+4m1DIj+kiEW2Uh8DKM6Ha++FVYPZ8aKvj8GwaWihUS
	 FJAnSyLTTy/SF3JmrnyP5vjUCzchZ1yOUhEO+1AE=
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
Subject: [PATCH 6.12 054/877] dmaengine: wait for RCU readers before releasing dma_device
Date: Wed, 30 Sep 2026 17:16:05 +0200
Message-ID: <20260930152415.912840462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index d6a4e914018da..9a591bc15a36b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -426,6 +426,7 @@ static void dma_device_release(struct kref *ref)
 
 	list_del_rcu(&device->global_node);
 	dma_channel_rebalance();
+	synchronize_rcu();
 
 	if (device->device_release)
 		device->device_release(device);
-- 
2.53.0




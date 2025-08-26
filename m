Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF3730146D;
	Tue, 26 Aug 2025 13:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214032; cv=none; b=e7vCDXsRXqD1/czv/+QMVfx4NNs+N2ZGP2Mdb8Il/11XmWpqnq+vjAhHnDtV1m7O36EBskE5yrAU9o66Fd2eIZrIjh/TG1v0EMSv3NGDJ2AvF7mUIl9YHRckFArP6pY9KY/Qj2AKavNRzlnZ+YaUhLww1Tvw6vyA7ku2Fki9Cao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214032; c=relaxed/simple;
	bh=7NK0pFe9PK9mHVYGtQg9YrnpL7UBbcSEQcMsX31LVPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNH5H7i9OZXATQ5wnMLT8C3b51dLOa+XxouLuadlHWJ0rmvW4M9yqQvLzVsCQQ5ynEw8FwSbPFN8hqLABD0pb+nU0pOr3Js8amISYiCUiNDrkPehIzoO98Cvv9OD76g0dRA/lzFElV5AD7U6XTs6OS6J8QJb7lhX1Gmij9eGgeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rEPlHgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rEPlHgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E21DC4CEF1;
	Tue, 26 Aug 2025 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214031;
	bh=7NK0pFe9PK9mHVYGtQg9YrnpL7UBbcSEQcMsX31LVPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rEPlHgo06sSWqhBjcVMUIlX9c7qBPhUls2QSUgFPTARmfz8/4OnUJgb9lMVDXVB5
	 mCE+zf5/+7Jnzke1oeSAoYifQFtrNl4cvpIclD1Rc7c7iAt3B2jfHtBjz4s4LINVXN
	 TR2Zebmofv16HuxxSybmHvRkT2VlPOVQnQ4HV2LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 571/587] gve: prevent ethtool ops after shutdown
Date: Tue, 26 Aug 2025 13:12:00 +0200
Message-ID: <20250826111007.561681984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Jordan Rhee <jordanrhee@google.com>

[ Upstream commit 75a9a46d67f46d608205888f9b34e315c1786345 ]

A crash can occur if an ethtool operation is invoked
after shutdown() is called.

shutdown() is invoked during system shutdown to stop DMA operations
without performing expensive deallocations. It is discouraged to
unregister the netdev in this path, so the device may still be visible
to userspace and kernel helpers.

In gve, shutdown() tears down most internal data structures. If an
ethtool operation is dispatched after shutdown(), it will dereference
freed or NULL pointers, leading to a kernel panic. While graceful
shutdown normally quiesces userspace before invoking the reboot
syscall, forced shutdowns (as observed on GCP VMs) can still trigger
this path.

Fix by calling netif_device_detach() in shutdown().
This marks the device as detached so the ethtool ioctl handler
will skip dispatching operations to the driver.

Fixes: 974365e51861 ("gve: Implement suspend/resume/shutdown")
Signed-off-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Link: https://patch.msgid.link/20250818211245.1156919-1-jeroendb@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index ec189f0703f9..241a541b8edd 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2373,6 +2373,8 @@ static void gve_shutdown(struct pci_dev *pdev)
 	struct gve_priv *priv = netdev_priv(netdev);
 	bool was_up = netif_carrier_ok(priv->dev);
 
+	netif_device_detach(netdev);
+
 	rtnl_lock();
 	if (was_up && gve_close(priv->dev)) {
 		/* If the dev was up, attempt to close, if close fails, reset */
-- 
2.50.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14FA3093BA;
	Tue, 26 Aug 2025 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208040; cv=none; b=gsymKodtSiBsPBhgytp4MKxzU66LNs8nyAgSYQ8KOi5fJN+pPs2AkR4EFcujWHbH5kV4+yCMVPXh37oJfziHWPCcfbK63P7kp5jdqva/HYpjfNmTts1VXf5F6OWh1yOaXjCFXS6ktUbyyrqZSQkvMtRmUrnDPDDy5QTpKxJAxsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208040; c=relaxed/simple;
	bh=HpFta0HVhpPpnUPrPrkpSZQHAwFaKUT8eDqZ6iO/EiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX/QcOp0ZetuSf87FefgNidv9Z6daxylwtvJ9npOFeDwdKTjp/J7vEcFMES6Sf5WL4N4z3Miyf5vZXsd81nXbKPfP79xrVmt+mKENd2JGodfiP14xNa3UVAl2khGI+XuQuti8cbwDDNZ2yz7EtxBGzVhvsd6b0pGV/2dXIOaiSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3U/Tsk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3U/Tsk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ABAC4CEF1;
	Tue, 26 Aug 2025 11:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208040;
	bh=HpFta0HVhpPpnUPrPrkpSZQHAwFaKUT8eDqZ6iO/EiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3U/Tsk63hTof6CNuXUt1jgLuXBvkdoRz/goPu555ck3mctc5iIpUpnfAsCnhwx1R
	 4xwGEUrxV1LuDXBINU1COg7qhbT00HE8Yl104aFoHiG2r5Zwt2aS2ylO0+3M6sllXM
	 w3keEato7uU3brOMBvaLGPfHHWiy1RcYfMH7h3h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 413/457] gve: prevent ethtool ops after shutdown
Date: Tue, 26 Aug 2025 13:11:37 +0200
Message-ID: <20250826110947.501326271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d1aeb722d48f..36a6d766b638 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2726,6 +2726,8 @@ static void gve_shutdown(struct pci_dev *pdev)
 	struct gve_priv *priv = netdev_priv(netdev);
 	bool was_up = netif_running(priv->dev);
 
+	netif_device_detach(netdev);
+
 	rtnl_lock();
 	netdev_lock(netdev);
 	if (was_up && gve_close(priv->dev)) {
-- 
2.50.1




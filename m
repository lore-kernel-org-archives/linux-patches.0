Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9380D23D28F;
	Tue, 26 Aug 2025 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215325; cv=none; b=V0E2AIEusbYfrBJlis07oUo2C3TiXLcwUtk0AOZaPFjaN8OHT0GojHX33yp/Q4lnl6sObX14sPnmHQDVjVeoXZkmzU2gIEOBKmuesd/vC5l2SdDJ0uEm1lYT+JUz4lPqLmmi3niLKv9RqZq4BzHWlRdorVme6/12I/ySuvUgx6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215325; c=relaxed/simple;
	bh=jXz/ggTn4LhXCetzTSFAnNnDmWFSx8XPEJWKpvtZT1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBWVUUxHwblTQiprRrRBM3EyTJjlccWU30tpU8BrbftXHByv5pwMSYaK/t0x7kmvE2w7E4XLtEXjqXkDLzTaLaKktEQopX2VUCQL6xbN3Kg3hm2Vwi1vv606y0hceHMLIj3l8PvvXaVF87keVkyYD6vpn6jXDG/2plgfYsGhQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w37IqHkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w37IqHkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AA2C4CEF1;
	Tue, 26 Aug 2025 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215325;
	bh=jXz/ggTn4LhXCetzTSFAnNnDmWFSx8XPEJWKpvtZT1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w37IqHkb+p67DudEqTBSwXtWyjwiAQ0kXw5rC7CYxeOtgbDjpoYhuZnl+B1GOyccA
	 nuMRHXs1pm/+sdPqWmTszADacF9Zc60Z2W7XfZd7xUTbPFX8XlbCama96zt6B/Fqnu
	 G33lpTn4BKPa5Q96waH5Lu0cm8ShZVEjDNPx5Kn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/482] gve: prevent ethtool ops after shutdown
Date: Tue, 26 Aug 2025 13:12:04 +0200
Message-ID: <20250826110942.456951812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4fee466a8e90..2e8b01b3ee44 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1683,6 +1683,8 @@ static void gve_shutdown(struct pci_dev *pdev)
 	struct gve_priv *priv = netdev_priv(netdev);
 	bool was_up = netif_carrier_ok(priv->dev);
 
+	netif_device_detach(netdev);
+
 	rtnl_lock();
 	if (was_up && gve_close(priv->dev)) {
 		/* If the dev was up, attempt to close, if close fails, reset */
-- 
2.50.1




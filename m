Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53644214813;
	Wed,  7 May 2025 19:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645174; cv=none; b=c4mVfV/D5O2/hmZptgaAKMeAzcc3wnReQySYNNb9Zs+w8+7Jlih7oKMXZLIbyUOmq5M1sL7rmkrucZkQNkQnt6kIZDNkPxdcul5TN8y+QdR0RKbhHZd++eFlNjR1fGvatQN//Z/aksUSoaHgqWbiHGouGsTy4Vf2lVSNH4kIqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645174; c=relaxed/simple;
	bh=/qnk9/0ebfiBm8urj90Q9hu4pV3UPWy/hSFGFgDbSYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlYV4rdTEFZj4mlfVg2gtsKcS+XhFxOxeXI9Y15zIznI2ZKZg9RRePfw5AWYZniPS9hG3bLgZ2YMN6YAW+y9bbJXMyYQxMuXwnbNdIGnuiUio7c1dk8tFPtSN0PnWtG1cs4Fe8BVGv5BT6lnFu4sGD9c1XNsda0VqSxnZjesRm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JUdcJP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JUdcJP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81FEC4CEE2;
	Wed,  7 May 2025 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645174;
	bh=/qnk9/0ebfiBm8urj90Q9hu4pV3UPWy/hSFGFgDbSYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JUdcJP3ExFYT6LBvmrQqGfTGaTlysyPTV+92Ds+onMt1VHZNppjYVWlnka+Gdk3a
	 evkYPdjAdGZKxfRGwh77pBFOQtKk/fb6tZvaCeAK0N4pOwn3hV8Q+weacrRR0o2XYr
	 yH0FnKvOj1WFbk3M3IPA/b3HXuwBP0ooDC2jqwv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh B Edara <sedara@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/129] octeon_ep: Fix host hang issue during device reboot
Date: Wed,  7 May 2025 20:40:23 +0200
Message-ID: <20250507183817.030217500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Sathesh B Edara <sedara@marvell.com>

[ Upstream commit 34f42736b325287a7b2ce37e415838f539767bda ]

When the host loses heartbeat messages from the device,
the driver calls the device-specific ndo_stop function,
which frees the resources. If the driver is unloaded in
this scenario, it calls ndo_stop again, attempting to free
resources that have already been freed, leading to a host
hang issue. To resolve this, dev_close should be called
instead of the device-specific stop function.dev_close
internally calls ndo_stop to stop the network interface
and performs additional cleanup tasks. During the driver
unload process, if the device is already down, ndo_stop
is not called.

Fixes: 5cb96c29aa0e ("octeon_ep: add heartbeat monitor")
Signed-off-by: Sathesh B Edara <sedara@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250429114624.19104-1-sedara@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 6f1fe7e283d4e..7a30095b3486f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -917,7 +917,7 @@ static void octep_hb_timeout_task(struct work_struct *work)
 		miss_cnt);
 	rtnl_lock();
 	if (netif_running(oct->netdev))
-		octep_stop(oct->netdev);
+		dev_close(oct->netdev);
 	rtnl_unlock();
 }
 
-- 
2.39.5




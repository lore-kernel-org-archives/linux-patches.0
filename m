Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24E83D47A5;
	Wed,  8 Apr 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671717; cv=none; b=oW61vfKPdnmOsnS6R0SDM5aaNqobHZOrD/lwvnsDIosVFDOd9p9f8pH9Jt41ZZ/VvhR+tKAG5SfzWpdWQJpL5RpwdbtWqcN5dKHADoPi8QkbL4M44xRxqxwP6KxMKG5eUECM+HG2aF217HA1QR0bKwNG6SP6QGXArF3MCg5d1z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671717; c=relaxed/simple;
	bh=ONyyAPaMe64O2OiX9vaSrpAiIzw7j23djlDM+WgRFpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CceoGGctCg/DxoFGjgSmPYyQ0tzFMv7wS1lduwodBRAzguhaRGBeuA8czJx4uc9pX/4MegJedd8CT5DkxxDbO5B9RhGPJ4sHrs5fP35d3gRevOGmoFSrhQdOPlMbamH2PE1m2pIDPsVkY/dvmSqmTDMc1X9DRFKs0+LjOL6S8SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBSvWPIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBSvWPIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8792DC19421;
	Wed,  8 Apr 2026 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671716;
	bh=ONyyAPaMe64O2OiX9vaSrpAiIzw7j23djlDM+WgRFpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBSvWPImX7XwJy8IL35EpWQQXO++v7TG8p1gIKiZgqNL0MvE/00WAJ1yGofL7RHUA
	 CwMRjLedqyEZco/kgVr+Npko69fv+x/3MRjzJPLJU0zB9/SxbMORvrPJgiqnSqMfvV
	 kD2aMxiNAD3KsT+exPaYzf959QT7Rhwfy2uL6xZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/312] openvswitch: defer tunnel netdev_put to RCU release
Date: Wed,  8 Apr 2026 19:59:17 +0200
Message-ID: <20260408175935.229971450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <n05ec@lzu.edu.cn>

[ Upstream commit 6931d21f87bc6d657f145798fad0bf077b82486c ]

ovs_netdev_tunnel_destroy() may run after NETDEV_UNREGISTER already
detached the device. Dropping the netdev reference in destroy can race
with concurrent readers that still observe vport->dev.

Do not release vport->dev in ovs_netdev_tunnel_destroy(). Instead, let
vport_netdev_free() drop the reference from the RCU callback, matching
the non-tunnel destroy path and avoiding additional synchronization
under RTNL.

Fixes: a9020fde67a6 ("openvswitch: Move tunnel destroy function to oppenvswitch module.")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260319074241.3405262-1-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 18376e10aeedc..68d38c12427c1 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -189,8 +189,6 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev, 0, NULL);
-	netdev_put(vport->dev, &vport->dev_tracker);
-	vport->dev = NULL;
 	rtnl_unlock();
 
 	call_rcu(&vport->rcu, vport_netdev_free);
-- 
2.51.0




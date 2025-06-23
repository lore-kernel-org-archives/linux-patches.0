Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6551C253949;
	Mon, 23 Jun 2025 13:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684894; cv=none; b=fL4iW2r6+958D2PUkvCnPxt48drbCATDpEnagrL2Mb8jQYIyGjTs7IdbD6KZlYIQx+3a1Zl/Zc3/bUmhwtOsLrnJRuVNYJc2+4VKH9a53F43RFFxlcaNJpFxEfwEy9ic9JMWvvcOkp8mZPXK+nYqcb+SJhjehVrgalN1xfUOdGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684894; c=relaxed/simple;
	bh=zh3POx0tiL6/0q3OLoAod3+m7HlauKMMbQ1/vDJYWj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXkVA5z0/N2pibk8304bSPwts5d+cma16ZECXNPngrQCd/U5KbB/RpnVo2C4IWCeoxGBGi8X5m8I7LKpWk6Kz7k7BPsr+d//USw7GdH5PJ0zOfTD+he/g53t8zEMJzjQUcOFzdWy5XS7mwyvG7NNbBJnTAyHI/lxiW9eK3MMUlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqeaVPXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqeaVPXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2C7C4CEEA;
	Mon, 23 Jun 2025 13:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684894;
	bh=zh3POx0tiL6/0q3OLoAod3+m7HlauKMMbQ1/vDJYWj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqeaVPXYjQqa1eTGkNsSUEks7ju5GMsi1Xglq6VP5ZseEKRy0Zhb+C2j1znpALqry
	 +RECczEDb3M1BKO2X+lcRTSSsZdGcEJ5caSCGLQY9ezivwScUFvGZ26d3s0WmKafdX
	 hADyMzFa2gRFeBGLDVC0OjjAaAy55RM5ffqVnVE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 187/592] hv_netvsc: fix potential deadlock in netvsc_vf_setxdp()
Date: Mon, 23 Jun 2025 15:02:25 +0200
Message-ID: <20250623130704.730125655@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurabh Sengar <ssengar@linux.microsoft.com>

commit 3ec523304976648b45a3eef045e97d17122ff1b2 upstream.

The MANA driver's probe registers netdevice via the following call chain:

mana_probe()
  register_netdev()
    register_netdevice()

register_netdevice() calls notifier callback for netvsc driver,
holding the netdev mutex via netdev_lock_ops().

Further this netvsc notifier callback end up attempting to acquire the
same lock again in dev_xdp_propagate() leading to deadlock.

netvsc_netdev_event()
  netvsc_vf_setxdp()
    dev_xdp_propagate()

This deadlock was not observed so far because net_shaper_ops was never set,
and thus the lock was effectively a no-op in this case. Fix this by using
netif_xdp_propagate() instead of dev_xdp_propagate() to avoid recursive
locking in this path.

And, since no deadlock is observed on the other path which is via
netvsc_probe, add the lock exclusivly for that path.

Also, clean up the unregistration path by removing the unnecessary call to
netvsc_vf_setxdp(), since unregister_netdevice_many_notify() already
performs this cleanup via dev_xdp_uninstall().

Fixes: 97246d6d21c2 ("net: hold netdev instance lock during ndo_bpf")
Cc: stable@vger.kernel.org
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Tested-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1748513910-23963-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_bpf.c |    2 +-
 drivers/net/hyperv/netvsc_drv.c |    4 ++--
 net/core/dev.c                  |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -183,7 +183,7 @@ int netvsc_vf_setxdp(struct net_device *
 	xdp.command = XDP_SETUP_PROG;
 	xdp.prog = prog;
 
-	ret = dev_xdp_propagate(vf_netdev, &xdp);
+	ret = netif_xdp_propagate(vf_netdev, &xdp);
 
 	if (ret && prog)
 		bpf_prog_put(prog);
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2462,8 +2462,6 @@ static int netvsc_unregister_vf(struct n
 
 	netdev_info(ndev, "VF unregistering: %s\n", vf_netdev->name);
 
-	netvsc_vf_setxdp(vf_netdev, NULL);
-
 	reinit_completion(&net_device_ctx->vf_add);
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
@@ -2631,7 +2629,9 @@ static int netvsc_probe(struct hv_device
 			continue;
 
 		netvsc_prepare_bonding(vf_netdev);
+		netdev_lock_ops(vf_netdev);
 		netvsc_register_vf(vf_netdev, VF_REG_IN_PROBE);
+		netdev_unlock_ops(vf_netdev);
 		__netvsc_vf_setup(net, vf_netdev);
 		break;
 	}
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9863,6 +9863,7 @@ int netif_xdp_propagate(struct net_devic
 
 	return dev->netdev_ops->ndo_bpf(dev, bpf);
 }
+EXPORT_SYMBOL_GPL(netif_xdp_propagate);
 
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
 {



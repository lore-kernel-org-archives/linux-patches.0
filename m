Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389DD6FB1;
	Tue,  5 Dec 2023 03:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhzAJvxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C597EC433C7;
	Tue,  5 Dec 2023 03:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747148;
	bh=HmXeeHZOQsrmxgPMMxZWKzM0U+5i/DU+6tVIihsXv/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhzAJvxWK5cG3MafQChZFqstqSGnywCRTN9QUShXisjWcXcztROuprIzBMSpq3XeQ
	 nqmTVGMTNN+b46ttlCw9213F2CUO6q4to5r5YLuj2cHBdDoQx5BaQu+q/bNVV9ueBr
	 hgeevZ0t7iIv2EluncTLF2XeewDikYgCVhwQ0Zqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/107] net: ravb: Keep reverse order of operations in ravb_remove()
Date: Tue,  5 Dec 2023 12:16:52 +0900
Message-ID: <20231205031536.332967162@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit edf9bc396e05081ca281ffb0cd41e44db478ff26 ]

On RZ/G3S SMARC Carrier II board having RGMII connections b/w Ethernet
MACs and PHYs it has been discovered that doing unbind/bind for ravb
driver in a loop leads to wrong speed and duplex for Ethernet links and
broken connectivity (the connectivity cannot be restored even with
bringing interface down/up). Before doing unbind/bind the Ethernet
interfaces were configured though systemd. The sh instructions used to
do unbind/bind were:

$ cd /sys/bus/platform/drivers/ravb/
$ while :; do echo 11c30000.ethernet > unbind ; \
  echo 11c30000.ethernet > bind; done

It has been discovered that there is a race b/w IOCTLs initialized by
systemd at the response of success binding and the
"ravb_write(ndev, CCC_OPC_RESET, CCC)" call in ravb_remove() as
follows:

1/ as a result of bind success the user space open/configures the
   interfaces tough an IOCTL; the following stack trace has been
   identified on RZ/G3S:

Call trace:
dump_backtrace+0x9c/0x100
show_stack+0x20/0x38
dump_stack_lvl+0x48/0x60
dump_stack+0x18/0x28
ravb_open+0x70/0xa58
__dev_open+0xf4/0x1e8
__dev_change_flags+0x198/0x218
dev_change_flags+0x2c/0x80
devinet_ioctl+0x640/0x708
inet_ioctl+0x1e4/0x200
sock_do_ioctl+0x50/0x108
sock_ioctl+0x240/0x358
__arm64_sys_ioctl+0xb0/0x100
invoke_syscall+0x50/0x128
el0_svc_common.constprop.0+0xc8/0xf0
do_el0_svc+0x24/0x38
el0_svc+0x34/0xb8
el0t_64_sync_handler+0xc0/0xc8
el0t_64_sync+0x190/0x198

2/ this call may execute concurrently with ravb_remove() as the
   unbind/bind operation was executed in a loop
3/ if the operation mode is changed to RESET (through
   ravb_write(ndev, CCC_OPC_RESET, CCC) call in ravb_remove())
   while the above ravb_open() is in progress it may lead to MAC
   (or PHY, or MAC-PHY connection, the right point hasn't been identified
   at the moment) to be broken, thus the Ethernet connectivity fails to
   restore.

The simple fix for this is to move ravb_write(ndev, CCC_OPC_RESET, CCC))
after unregister_netdev() to avoid resetting the controller while the
netdev interface is still registered.

To avoid future issues in ravb_remove(), the patch follows the proper order
of operations in ravb_remove(): reverse order compared with ravb_probe().
This avoids described races as the IOCTLs as well as unregister_netdev()
(called now at the beginning of ravb_remove()) calls rtnl_lock() before
continuing and IOCTLs check (though devinet_ioctl()) if device is still
registered just after taking the lock:

int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
{
	// ...

        rtnl_lock();

        ret = -ENODEV;
        dev = __dev_get_by_name(net, ifr->ifr_name);
        if (!dev)
                goto done;

	// ...
done:
        rtnl_unlock();
out:
        return ret;
}

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e1c4a0ca4493f..68cb5616ef991 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2919,22 +2919,26 @@ static int ravb_remove(struct platform_device *pdev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
-	/* Stop PTP Clock driver */
-	if (info->ccc_gac)
-		ravb_ptp_stop(ndev);
-
-	clk_disable_unprepare(priv->gptp_clk);
-	clk_disable_unprepare(priv->refclk);
-
-	/* Set reset mode */
-	ravb_write(ndev, CCC_OPC_RESET, CCC);
 	unregister_netdev(ndev);
 	if (info->nc_queues)
 		netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
+
 	ravb_mdio_release(priv);
+
+	/* Stop PTP Clock driver */
+	if (info->ccc_gac)
+		ravb_ptp_stop(ndev);
+
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
+
+	/* Set reset mode */
+	ravb_write(ndev, CCC_OPC_RESET, CCC);
+
+	clk_disable_unprepare(priv->gptp_clk);
+	clk_disable_unprepare(priv->refclk);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(priv->rstc);
-- 
2.42.0




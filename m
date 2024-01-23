Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6710E23BC;
	Tue, 23 Jan 2024 02:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975776; cv=none; b=DPW0ZysgnN45z6ILQQP87wo/XWJgxED8LcZTUUNjVwF+TxbJxvNR3SVXMtSZGvnV2klgZP31K/XLed+Q8BGo3ci1WQSF66WVDBAoc3kl4h7MzScP4P8EU5rqnUWlqeR+cwgeAWOLjN/7ZaAvS1OHqrVEwU1PzchAJQdxcScTEic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975776; c=relaxed/simple;
	bh=AoP35Q6VW6gY+DQ+LTUSkS1RDWMHjoNCSXi58S7kgP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1Fe6JaVtczEpi23JzwHSwBTM0AHTh1+fCNMvjvNpMK+E1DGHeINJ0AVW+UHUKvS0BuXoibwSmpv74YbhCcVyNJuLLgEQRowcmyLuf7dkLK85G80BI0HyIdhDdYUBlrXH5EJCTHN8FpMhpY/mtDBefawh5A/+Jq/h18n+DWh5WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGvmIFed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGvmIFed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF00C433C7;
	Tue, 23 Jan 2024 02:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975776;
	bh=AoP35Q6VW6gY+DQ+LTUSkS1RDWMHjoNCSXi58S7kgP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGvmIFedF5/KLel/SBzR+gN4SMDzAykcxpU8I2MH7K10MKgLhcsPIXNhNTocKSzzm
	 6Emf1DF43iO9HoQ4RwLG42dT/alFjOwgEm3RXgT9Qg2tgV66NeDH/eoQSILzyQeXcZ
	 7POYhXIDT3BfkM9hHKO5EH6UFtJvVgspKG6Tx5a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 559/583] net: netdevsim: dont try to destroy PHC on VFs
Date: Mon, 22 Jan 2024 16:00:10 -0800
Message-ID: <20240122235829.264386963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ea937f77208323d35ffe2f8d8fc81b00118bfcda ]

PHC gets initialized in nsim_init_netdevsim(), which
is only called if (nsim_dev_port_is_pf()).

Create a counterpart of nsim_init_netdevsim() and
move the mock_phc_destroy() there.

This fixes a crash trying to destroy netdevsim with
VFs instantiated, as caught by running the devlink.sh test:

    BUG: kernel NULL pointer dereference, address: 00000000000000b8
    RIP: 0010:mock_phc_destroy+0xd/0x30
    Call Trace:
     <TASK>
     nsim_destroy+0x4a/0x70 [netdevsim]
     __nsim_dev_port_del+0x47/0x70 [netdevsim]
     nsim_dev_reload_destroy+0x105/0x120 [netdevsim]
     nsim_drv_remove+0x2f/0xb0 [netdevsim]
     device_release_driver_internal+0x1a1/0x210
     bus_remove_device+0xd5/0x120
     device_del+0x159/0x490
     device_unregister+0x12/0x30
     del_device_store+0x11a/0x1a0 [netdevsim]
     kernfs_fop_write_iter+0x130/0x1d0
     vfs_write+0x30b/0x4b0
     ksys_write+0x69/0xf0
     do_syscall_64+0xcc/0x1e0
     entry_SYSCALL_64_after_hwframe+0x6f/0x77

Fixes: b63e78fca889 ("net: netdevsim: use mock PHC driver")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2eac92f49631..d8ca82addfe1 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -369,6 +369,12 @@ static int nsim_init_netdevsim_vf(struct netdevsim *ns)
 	return err;
 }
 
+static void nsim_exit_netdevsim(struct netdevsim *ns)
+{
+	nsim_udp_tunnels_info_destroy(ns->netdev);
+	mock_phc_destroy(ns->phc);
+}
+
 struct netdevsim *
 nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 {
@@ -417,8 +423,7 @@ void nsim_destroy(struct netdevsim *ns)
 	}
 	rtnl_unlock();
 	if (nsim_dev_port_is_pf(ns->nsim_dev_port))
-		nsim_udp_tunnels_info_destroy(dev);
-	mock_phc_destroy(ns->phc);
+		nsim_exit_netdevsim(ns);
 	free_netdev(dev);
 }
 
-- 
2.43.0




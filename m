Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35FB28DBB;
	Fri, 24 Nov 2023 19:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdqzhGAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B90C433C7;
	Fri, 24 Nov 2023 19:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854091;
	bh=txIXxpMOjO/3p5T1GsStCPQSK0uDJoooPZNFGx54zFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdqzhGACiaQlfIeIuKXuEuJ1bQeWW5JlaEiywAvGdvQpJrKAoRrqneUqUv0oIgB9f
	 wL438AtzWoQ5NDZczGAcgb0CpT7uGRgqfKcwtuvOWzQxIeU/Frmua2XemopfbG9RUh
	 tzpysQYz9F9nAoMhhUYzZGO/JMjav96HFw5U4a+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 118/159] net: dsa: lan9303: consequently nested-lock physical MDIO
Date: Fri, 24 Nov 2023 17:55:35 +0000
Message-ID: <20231124171946.756175218@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 5a22fbcc10f3f7d94c5d88afbbffa240a3677057 upstream.

When LAN9303 is MDIO-connected two callchains exist into
mdio->bus->write():

1. switch ports 1&2 ("physical" PHYs):

virtual (switch-internal) MDIO bus (lan9303_switch_ops->phy_{read|write})->
  lan9303_mdio_phy_{read|write} -> mdiobus_{read|write}_nested

2. LAN9303 virtual PHY:

virtual MDIO bus (lan9303_phy_{read|write}) ->
  lan9303_virt_phy_reg_{read|write} -> regmap -> lan9303_mdio_{read|write}

If the latter functions just take
mutex_lock(&sw_dev->device->bus->mdio_lock) it triggers a LOCKDEP
false-positive splat. It's false-positive because the first
mdio_lock in the second callchain above belongs to virtual MDIO bus, the
second mdio_lock belongs to physical MDIO bus.

Consequent annotation in lan9303_mdio_{read|write} as nested lock
(similar to lan9303_mdio_phy_{read|write}, it's the same physical MDIO bus)
prevents the following splat:

WARNING: possible circular locking dependency detected
5.15.71 #1 Not tainted
------------------------------------------------------
kworker/u4:3/609 is trying to acquire lock:
ffff000011531c68 (lan9303_mdio:131:(&lan9303_mdio_regmap_config)->lock){+.+.}-{3:3}, at: regmap_lock_mutex
but task is already holding lock:
ffff0000114c44d8 (&bus->mdio_lock){+.+.}-{3:3}, at: mdiobus_read
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #1 (&bus->mdio_lock){+.+.}-{3:3}:
       lock_acquire
       __mutex_lock
       mutex_lock_nested
       lan9303_mdio_read
       _regmap_read
       regmap_read
       lan9303_probe
       lan9303_mdio_probe
       mdio_probe
       really_probe
       __driver_probe_device
       driver_probe_device
       __device_attach_driver
       bus_for_each_drv
       __device_attach
       device_initial_probe
       bus_probe_device
       deferred_probe_work_func
       process_one_work
       worker_thread
       kthread
       ret_from_fork
-> #0 (lan9303_mdio:131:(&lan9303_mdio_regmap_config)->lock){+.+.}-{3:3}:
       __lock_acquire
       lock_acquire.part.0
       lock_acquire
       __mutex_lock
       mutex_lock_nested
       regmap_lock_mutex
       regmap_read
       lan9303_phy_read
       dsa_slave_phy_read
       __mdiobus_read
       mdiobus_read
       get_phy_device
       mdiobus_scan
       __mdiobus_register
       dsa_register_switch
       lan9303_probe
       lan9303_mdio_probe
       mdio_probe
       really_probe
       __driver_probe_device
       driver_probe_device
       __device_attach_driver
       bus_for_each_drv
       __device_attach
       device_initial_probe
       bus_probe_device
       deferred_probe_work_func
       process_one_work
       worker_thread
       kthread
       ret_from_fork
other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&bus->mdio_lock);
                               lock(lan9303_mdio:131:(&lan9303_mdio_regmap_config)->lock);
                               lock(&bus->mdio_lock);
  lock(lan9303_mdio:131:(&lan9303_mdio_regmap_config)->lock);
*** DEADLOCK ***
5 locks held by kworker/u4:3/609:
 #0: ffff000002842938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work
 #1: ffff80000bacbd60 (deferred_probe_work){+.+.}-{0:0}, at: process_one_work
 #2: ffff000007645178 (&dev->mutex){....}-{3:3}, at: __device_attach
 #3: ffff8000096e6e78 (dsa2_mutex){+.+.}-{3:3}, at: dsa_register_switch
 #4: ffff0000114c44d8 (&bus->mdio_lock){+.+.}-{3:3}, at: mdiobus_read
stack backtrace:
CPU: 1 PID: 609 Comm: kworker/u4:3 Not tainted 5.15.71 #1
Workqueue: events_unbound deferred_probe_work_func
Call trace:
 dump_backtrace
 show_stack
 dump_stack_lvl
 dump_stack
 print_circular_bug
 check_noncircular
 __lock_acquire
 lock_acquire.part.0
 lock_acquire
 __mutex_lock
 mutex_lock_nested
 regmap_lock_mutex
 regmap_read
 lan9303_phy_read
 dsa_slave_phy_read
 __mdiobus_read
 mdiobus_read
 get_phy_device
 mdiobus_scan
 __mdiobus_register
 dsa_register_switch
 lan9303_probe
 lan9303_mdio_probe
...

Cc: stable@vger.kernel.org
Fixes: dc7005831523 ("net: dsa: LAN9303: add MDIO managed mode support")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20231027065741.534971-1-alexander.sverdlin@siemens.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lan9303_mdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/lan9303_mdio.c
+++ b/drivers/net/dsa/lan9303_mdio.c
@@ -32,7 +32,7 @@ static int lan9303_mdio_write(void *ctx,
 	struct lan9303_mdio *sw_dev = (struct lan9303_mdio *)ctx;
 
 	reg <<= 2; /* reg num to offset */
-	mutex_lock(&sw_dev->device->bus->mdio_lock);
+	mutex_lock_nested(&sw_dev->device->bus->mdio_lock, MDIO_MUTEX_NESTED);
 	lan9303_mdio_real_write(sw_dev->device, reg, val & 0xffff);
 	lan9303_mdio_real_write(sw_dev->device, reg + 2, (val >> 16) & 0xffff);
 	mutex_unlock(&sw_dev->device->bus->mdio_lock);
@@ -50,7 +50,7 @@ static int lan9303_mdio_read(void *ctx,
 	struct lan9303_mdio *sw_dev = (struct lan9303_mdio *)ctx;
 
 	reg <<= 2; /* reg num to offset */
-	mutex_lock(&sw_dev->device->bus->mdio_lock);
+	mutex_lock_nested(&sw_dev->device->bus->mdio_lock, MDIO_MUTEX_NESTED);
 	*val = lan9303_mdio_real_read(sw_dev->device, reg);
 	*val |= (lan9303_mdio_real_read(sw_dev->device, reg + 2) << 16);
 	mutex_unlock(&sw_dev->device->bus->mdio_lock);



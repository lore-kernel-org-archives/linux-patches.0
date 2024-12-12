Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44877215777;
	Thu, 12 Dec 2024 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017748; cv=none; b=YSpGuwfGfiZuRb1IACD9fbhNa2cVVWvuSiKBPXs/P8/w3xTerg+nbcKe80yibdbOFcEQ/BFfRofH5Nm6/8kkjCLBKR+mec/KX+CWoukZ7RFKNuGbgthIdxj5eIXdTxI4U0N2mWDFC32AuL6/Ocd2QljzthqAkysK2zN5DG27yno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017748; c=relaxed/simple;
	bh=GIAHy7+k6MgML/pXt3OKcdHV1z0ZKVhXffgX9QkyUUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmyoMe8EqE9Zac4RHVrJlNQSeSFChFxz0q8nIZ2M7UorwLA0z6Pz/VvxJNwU5LtM5t++MWSL1s6LoW1leyxEHn9yYeuegWdFUQfln4o8l/EiONi4Jorow2Xd+Zk0vbhGyIgPjxGs7qnmB85wjUJAeZPfGr7c5pKCSOMu25fxERI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bymw1Gr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bymw1Gr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AECC4CECE;
	Thu, 12 Dec 2024 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017748;
	bh=GIAHy7+k6MgML/pXt3OKcdHV1z0ZKVhXffgX9QkyUUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bymw1Gr98xusX8LcfZvIzIHkK0vxSYIbC9OPClrQAVPVq6oojUVYMhBu+a3impk3A
	 FBjFcSjSTqa8prVHTOxaPQDb3yAZpWc+e4ALLdK/jgE0gdBPNkVyT9kDAM4/QeFmG8
	 NZL6t620nwN3IV5j2qYkG6vAUxF3f8w+0x0KdDss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/356] i3c: master: support to adjust first broadcast address speed
Date: Thu, 12 Dec 2024 15:57:00 +0100
Message-ID: <20241212144248.614605599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit aef79e189ba2b32f78bd35daf2c0b41f3868a321 ]

According to I3C spec 6.2 Timing Specification, the Open Drain High Period
of SCL Clock timing for first broadcast address should be adjusted to 200ns
at least. I3C device working as i2c device will see the broadcast to close
its Spike Filter then change to work at I3C mode. After that I3C open drain
SCL high level should be adjusted back.

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240910051626.4052552-1-carlos.song@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 25bc99be5fe5 ("i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 12 ++++++++++++
 include/linux/i3c/master.h | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index bbd5dc89be229..78171a754a3f8 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1827,6 +1827,12 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 		goto err_bus_cleanup;
 	}
 
+	if (master->ops->set_speed) {
+		ret = master->ops->set_speed(master, I3C_OPEN_DRAIN_SLOW_SPEED);
+		if (ret)
+			goto err_bus_cleanup;
+	}
+
 	/*
 	 * Reset all dynamic address that may have been assigned before
 	 * (assigned by the bootloader for example).
@@ -1835,6 +1841,12 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 	if (ret && ret != I3C_ERROR_M2)
 		goto err_bus_cleanup;
 
+	if (master->ops->set_speed) {
+		master->ops->set_speed(master, I3C_OPEN_DRAIN_NORMAL_SPEED);
+		if (ret)
+			goto err_bus_cleanup;
+	}
+
 	/* Disable all slave events before starting DAA. */
 	ret = i3c_master_disec_locked(master, I3C_BROADCAST_ADDR,
 				      I3C_CCC_EVENT_SIR | I3C_CCC_EVENT_MR |
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 1cbf0baca65fe..f0aa4c549aa7f 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -269,6 +269,20 @@ enum i3c_bus_mode {
 	I3C_BUS_MODE_MIXED_SLOW,
 };
 
+/**
+ * enum i3c_open_drain_speed - I3C open-drain speed
+ * @I3C_OPEN_DRAIN_SLOW_SPEED: Slow open-drain speed for sending the first
+ *				broadcast address. The first broadcast address at this speed
+ *				will be visible to all devices on the I3C bus. I3C devices
+ *				working in I2C mode will turn off their spike filter when
+ *				switching into I3C mode.
+ * @I3C_OPEN_DRAIN_NORMAL_SPEED: Normal open-drain speed in I3C bus mode.
+ */
+enum i3c_open_drain_speed {
+	I3C_OPEN_DRAIN_SLOW_SPEED,
+	I3C_OPEN_DRAIN_NORMAL_SPEED,
+};
+
 /**
  * enum i3c_addr_slot_status - I3C address slot status
  * @I3C_ADDR_SLOT_FREE: address is free
@@ -428,6 +442,7 @@ struct i3c_bus {
  *		      NULL.
  * @enable_hotjoin: enable hot join event detect.
  * @disable_hotjoin: disable hot join event detect.
+ * @set_speed: adjust I3C open drain mode timing.
  */
 struct i3c_master_controller_ops {
 	int (*bus_init)(struct i3c_master_controller *master);
@@ -456,6 +471,7 @@ struct i3c_master_controller_ops {
 				 struct i3c_ibi_slot *slot);
 	int (*enable_hotjoin)(struct i3c_master_controller *master);
 	int (*disable_hotjoin)(struct i3c_master_controller *master);
+	int (*set_speed)(struct i3c_master_controller *master, enum i3c_open_drain_speed speed);
 };
 
 /**
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2ED4D108;
	Sat,  3 Feb 2024 04:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933791; cv=none; b=sVLR0aP85D9JisAnMVbYJFfmeA5JaaEnoiQRoEp41IGeDG7oXwoboVBNd/RYWbAMTAIo/rA/rlNlwSnc7qunyWi78plI7qBZihFuuDQXShTKcW/pH0XJDT/Zahvbijn3PLDS+X/2qagLst8+3YR/lhFHDLfFToQ5t2q7p3q8kZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933791; c=relaxed/simple;
	bh=rRbU84YNEefQz5v5r15q3WnVYWvBMiNiH2vxIHDSeDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVHRTXlv+iibHcjLTaI1nvY/L0IQbDyOkSefN2oknofSK868TXy/WOD0B9RQbQM7LKIQNAznjjZoOBR4Ls7J2I72BMkaa1YF7sUpR1J34cy1gxpfrZVqpX3lHKKnlUZwjYNU552cEZu1XEXC4EKuIGU3U2SLWTjZSPlxDLzSvNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTux8rFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTux8rFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B546BC433C7;
	Sat,  3 Feb 2024 04:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933790;
	bh=rRbU84YNEefQz5v5r15q3WnVYWvBMiNiH2vxIHDSeDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTux8rFNZRmynFCyHh2GL8hvipmoHBHqUgSSd1sc3ZHbap/9Q8ZdynISjnUlkL6OI
	 oT2SdPYHlmdpDWOG9hv7M65wPVnDWbO+QhpmW1LTYHChIqQ6xJBA3NNuyHEJRcqXWd
	 q6b/fQK/RDNZLzZUsFK4ZHx+dZhB9ncw85ltMCCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Waldekranz <tobias@waldekranz.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 100/353] net: mvmdio: Avoid excessive sleeps in polled mode
Date: Fri,  2 Feb 2024 20:03:38 -0800
Message-ID: <20240203035406.951662710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit 7dd12fe34686d89c332b1a05104d18d728591f0a ]

Before this change, when operating in polled mode, i.e. no IRQ is
available, every individual C45 access would be hit with a 150us sleep
after the bus access.

For example, on a board with a CN9130 SoC connected to an MV88X3310
PHY, a single C45 read would take around 165us:

    root@infix:~$ mdio f212a600.mdio-mii mmd 4:1 bench 0xc003
    Performed 1000 reads in 165ms

By replacing the long sleep with a tighter poll loop, we observe a 10x
increase in bus throughput:

    root@infix:~$ mdio f212a600.mdio-mii mmd 4:1 bench 0xc003
    Performed 1000 reads in 15ms

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20231204100811.2708884-3-tobias@waldekranz.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvmdio.c | 53 ++++++++-------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 89f26402f8fb..5f66f779e56f 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
@@ -58,11 +59,6 @@
  * - Armada 370       (Globalscale Mirabox):   41us to 43us (Polled)
  */
 #define MVMDIO_SMI_TIMEOUT		1000 /* 1000us = 1ms */
-#define MVMDIO_SMI_POLL_INTERVAL_MIN	45
-#define MVMDIO_SMI_POLL_INTERVAL_MAX	55
-
-#define MVMDIO_XSMI_POLL_INTERVAL_MIN	150
-#define MVMDIO_XSMI_POLL_INTERVAL_MAX	160
 
 struct orion_mdio_dev {
 	void __iomem *regs;
@@ -84,8 +80,6 @@ enum orion_mdio_bus_type {
 
 struct orion_mdio_ops {
 	int (*is_done)(struct orion_mdio_dev *);
-	unsigned int poll_interval_min;
-	unsigned int poll_interval_max;
 };
 
 /* Wait for the SMI unit to be ready for another operation
@@ -94,34 +88,23 @@ static int orion_mdio_wait_ready(const struct orion_mdio_ops *ops,
 				 struct mii_bus *bus)
 {
 	struct orion_mdio_dev *dev = bus->priv;
-	unsigned long timeout = usecs_to_jiffies(MVMDIO_SMI_TIMEOUT);
-	unsigned long end = jiffies + timeout;
-	int timedout = 0;
+	unsigned long timeout;
+	int done;
 
-	while (1) {
-	        if (ops->is_done(dev))
+	if (dev->err_interrupt <= 0) {
+		if (!read_poll_timeout_atomic(ops->is_done, done, done, 2,
+					      MVMDIO_SMI_TIMEOUT, false, dev))
+			return 0;
+	} else {
+		/* wait_event_timeout does not guarantee a delay of at
+		 * least one whole jiffie, so timeout must be no less
+		 * than two.
+		 */
+		timeout = max(usecs_to_jiffies(MVMDIO_SMI_TIMEOUT), 2);
+
+		if (wait_event_timeout(dev->smi_busy_wait,
+				       ops->is_done(dev), timeout))
 			return 0;
-	        else if (timedout)
-			break;
-
-	        if (dev->err_interrupt <= 0) {
-			usleep_range(ops->poll_interval_min,
-				     ops->poll_interval_max);
-
-			if (time_is_before_jiffies(end))
-				++timedout;
-	        } else {
-			/* wait_event_timeout does not guarantee a delay of at
-			 * least one whole jiffie, so timeout must be no less
-			 * than two.
-			 */
-			if (timeout < 2)
-				timeout = 2;
-			wait_event_timeout(dev->smi_busy_wait,
-				           ops->is_done(dev), timeout);
-
-			++timedout;
-	        }
 	}
 
 	dev_err(bus->parent, "Timeout: SMI busy for too long\n");
@@ -135,8 +118,6 @@ static int orion_mdio_smi_is_done(struct orion_mdio_dev *dev)
 
 static const struct orion_mdio_ops orion_mdio_smi_ops = {
 	.is_done = orion_mdio_smi_is_done,
-	.poll_interval_min = MVMDIO_SMI_POLL_INTERVAL_MIN,
-	.poll_interval_max = MVMDIO_SMI_POLL_INTERVAL_MAX,
 };
 
 static int orion_mdio_smi_read(struct mii_bus *bus, int mii_id,
@@ -194,8 +175,6 @@ static int orion_mdio_xsmi_is_done(struct orion_mdio_dev *dev)
 
 static const struct orion_mdio_ops orion_mdio_xsmi_ops = {
 	.is_done = orion_mdio_xsmi_is_done,
-	.poll_interval_min = MVMDIO_XSMI_POLL_INTERVAL_MIN,
-	.poll_interval_max = MVMDIO_XSMI_POLL_INTERVAL_MAX,
 };
 
 static int orion_mdio_xsmi_read_c45(struct mii_bus *bus, int mii_id,
-- 
2.43.0




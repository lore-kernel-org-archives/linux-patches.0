Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AAF6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD3CC43443;
	Mon,  3 Apr 2023 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532933;
	bh=PMwoS5I12Yjm0lwua7E+7PAUz+/vG6qCbE0OOnpxqoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EG/CSw3VS36Vaf8PJ3dxFNV6DJZPsJXq/MB2296x3QcjuJzhuCqsCTpLmHjMEblQS
	 tLcLex+XB7bWGXJwFUsEmgmnTrgxO2XqqcifM6XdG96EHMeHG2JPUa4xLBYlgY3+5J
	 hohAOqYFhxwspoaS+7u5Yf7WjRRCED5MQ55d/hDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 6.1 172/181] net: dsa: mv88e6xxx: replace ATU violation prints with trace points
Date: Mon,  3 Apr 2023 16:10:07 +0200
Message-Id: <20230403140420.719884381@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 8646384d80f3d3b4a66b3284dbbd8232d1b8799e upstream.

In applications where the switch ports must perform 802.1X based
authentication and are therefore locked, ATU violation interrupts are
quite to be expected as part of normal operation. The problem is that
they currently spam the kernel log, even if rate limited.

Create a series of trace points, all derived from the same event class,
which log these violations to the kernel's trace buffer, which is both
much faster and much easier to ignore than printing to a serial console.

New usage model:

$ trace-cmd list | grep mv88e6xxx
mv88e6xxx
mv88e6xxx:mv88e6xxx_atu_full_violation
mv88e6xxx:mv88e6xxx_atu_miss_violation
mv88e6xxx:mv88e6xxx_atu_member_violation
$ trace-cmd record -e mv88e6xxx sleep 10

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/Makefile      |    4 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |   19 ++++-----
 drivers/net/dsa/mv88e6xxx/trace.c       |    6 ++
 drivers/net/dsa/mv88e6xxx/trace.h       |   66 ++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.h

--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -15,3 +15,7 @@ mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
+mv88e6xxx-objs += trace.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "trace.h"
 
 /* Offset 0x01: ATU FID Register */
 
@@ -435,23 +436,23 @@ static irqreturn_t mv88e6xxx_g1_atu_prob
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU member violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_member_violation(chip->dev, spid,
+						     entry.portvec, entry.mac,
+						     fid);
 		chip->ports[spid].atu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU miss violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_miss_violation(chip->dev, spid,
+						   entry.portvec, entry.mac,
+						   fid);
 		chip->ports[spid].atu_miss_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU full violation for %pM fid %u portvec %x spid %d\n",
-				    entry.mac, fid, entry.portvec, spid);
+		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
+						   entry.portvec, entry.mac,
+						   fid);
 		chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/trace.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright 2022 NXP
+ */
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright 2022 NXP
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	mv88e6xxx
+
+#if !defined(_MV88E6XXX_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _MV88E6XXX_TRACE_H
+
+#include <linux/device.h>
+#include <linux/if_ether.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(mv88e6xxx_atu_violation,
+
+	TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		 const unsigned char *addr, u16 fid),
+
+	TP_ARGS(dev, spid, portvec, addr, fid),
+
+	TP_STRUCT__entry(
+		__string(name, dev_name(dev))
+		__field(int, spid)
+		__field(u16, portvec)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, fid)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->spid = spid;
+		__entry->portvec = portvec;
+		memcpy(__entry->addr, addr, ETH_ALEN);
+		__entry->fid = fid;
+	),
+
+	TP_printk("dev %s spid %d portvec 0x%x addr %pM fid %u",
+		  __get_str(name), __entry->spid, __entry->portvec,
+		  __entry->addr, __entry->fid)
+);
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_member_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, spid, portvec, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_miss_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, spid, portvec, addr, fid));
+
+DEFINE_EVENT(mv88e6xxx_atu_violation, mv88e6xxx_atu_full_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 portvec,
+		      const unsigned char *addr, u16 fid),
+	     TP_ARGS(dev, spid, portvec, addr, fid));
+
+#endif /* _MV88E6XXX_TRACE_H */
+
+/* We don't want to use include/trace/events */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE	trace
+/* This part must be outside protection */
+#include <trace/define_trace.h>



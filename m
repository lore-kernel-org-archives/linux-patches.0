Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331896FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0636C433EF;
	Mon,  3 Apr 2023 14:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532936;
	bh=GBryw6LIB+KVStlYHHYLz46JiTaoE6qGXZGaVvaGPrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5bVcGG3Y1/lqdwGwJaaSpD/Crxuh6dXppjTOUh2I8J83nvY4UR1jOImnI9PTW92R
	 vcDZ2J+nIdrN8JZL38C4lUq+Ura2HgUc10maro3M0nXt2BB+c7qRD5E2CPIbSY8hEE
	 b2M6wocFVAD6711POIPi63VDH6mwKHWvWSQ8Nifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 6.1 173/181] net: dsa: mv88e6xxx: replace VTU violation prints with trace points
Date: Mon,  3 Apr 2023 16:10:08 +0200
Message-Id: <20230403140420.749733603@linuxfoundation.org>
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

commit 9e3d9ae52b5657399a7b61258cc7482434a911bb upstream.

It is possible to trigger these VTU violation messages very easily,
it's only necessary to send packets with an unknown VLAN ID to a port
that belongs to a VLAN-aware bridge.

Do a similar thing as for ATU violation messages, and hide them in the
kernel's trace buffer.

New usage model:

$ trace-cmd list | grep mv88e6xxx
mv88e6xxx
mv88e6xxx:mv88e6xxx_vtu_miss_violation
mv88e6xxx:mv88e6xxx_vtu_member_violation
$ trace-cmd report

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |    7 +++----
 drivers/net/dsa/mv88e6xxx/trace.h       |   30 ++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -13,6 +13,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "trace.h"
 
 /* Offset 0x02: VTU FID Register */
 
@@ -628,14 +629,12 @@ static irqreturn_t mv88e6xxx_g1_vtu_prob
 	spid = val & MV88E6XXX_G1_VTU_OP_SPID_MASK;
 
 	if (val & MV88E6XXX_G1_VTU_OP_MEMBER_VIOLATION) {
-		dev_err_ratelimited(chip->dev, "VTU member violation for vid %d, source port %d\n",
-				    vid, spid);
+		trace_mv88e6xxx_vtu_member_violation(chip->dev, spid, vid);
 		chip->ports[spid].vtu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_VTU_OP_MISS_VIOLATION) {
-		dev_dbg_ratelimited(chip->dev, "VTU miss violation for vid %d, source port %d\n",
-				    vid, spid);
+		trace_mv88e6xxx_vtu_miss_violation(chip->dev, spid, vid);
 		chip->ports[spid].vtu_miss_violation++;
 	}
 
--- a/drivers/net/dsa/mv88e6xxx/trace.h
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -55,6 +55,36 @@ DEFINE_EVENT(mv88e6xxx_atu_violation, mv
 		      const unsigned char *addr, u16 fid),
 	     TP_ARGS(dev, spid, portvec, addr, fid));
 
+DECLARE_EVENT_CLASS(mv88e6xxx_vtu_violation,
+
+	TP_PROTO(const struct device *dev, int spid, u16 vid),
+
+	TP_ARGS(dev, spid, vid),
+
+	TP_STRUCT__entry(
+		__string(name, dev_name(dev))
+		__field(int, spid)
+		__field(u16, vid)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->spid = spid;
+		__entry->vid = vid;
+	),
+
+	TP_printk("dev %s spid %d vid %u",
+		  __get_str(name), __entry->spid, __entry->vid)
+);
+
+DEFINE_EVENT(mv88e6xxx_vtu_violation, mv88e6xxx_vtu_member_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 vid),
+	     TP_ARGS(dev, spid, vid));
+
+DEFINE_EVENT(mv88e6xxx_vtu_violation, mv88e6xxx_vtu_miss_violation,
+	     TP_PROTO(const struct device *dev, int spid, u16 vid),
+	     TP_ARGS(dev, spid, vid));
+
 #endif /* _MV88E6XXX_TRACE_H */
 
 /* We don't want to use include/trace/events */



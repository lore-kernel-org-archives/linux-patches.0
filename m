Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32432145B1E;
	Tue, 23 Apr 2024 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908767; cv=none; b=YPmzc36Te6qtjHeEJN2H0qAMs3F7kYFzFJo8p41S7RApeeELp++d/rbv6j/tDftvfUMWUPS1h+DmcsYo76m2rPJryjqhZeAVbQs8mxqtGxJVkQe50FWfthrfg6+vhyj0vuAHzgN3frp0RuGSMCWQieYNG2fnvErqA30zxWG7BI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908767; c=relaxed/simple;
	bh=kQHw5taQJ3dI3DQzcXK173Z7bsS9N881mB1xA/ZVXbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aGR9srixuW40ScRSF8TOx1Dj43P9ttROF9pgTWBL5aqJHRhxukDXWBzmPUdaefwX70wxYdGt2XrtAZSnleRBNI7B7bozXm2DVUpQoO54899ek9gC0gDBEpY6G9zQZpORe5x9remm8StO2wQyQGOa1wwEzggMEejAPl/tDpPYcoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8reMRbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8reMRbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07625C116B1;
	Tue, 23 Apr 2024 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908767;
	bh=kQHw5taQJ3dI3DQzcXK173Z7bsS9N881mB1xA/ZVXbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8reMRbjd535T7/TBT5+sSqzIBH6nVwcOm4iwnb492OmPvI2ZpiO6fpfIeRQWTtvF
	 Wwhe5Tap/CwDpp7OZJDws7Ct6Jl9Sgm5qQWO8HVCd7obW2bnDTYt9jzfbKSwosxChr
	 gYURsX90s8A1QIECWwkzCL8H/3WH6IBvJYUJGs94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 134/141] net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
Date: Tue, 23 Apr 2024 14:40:02 -0700
Message-ID: <20240423213857.569072539@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <olteanv@gmail.com>

commit b79d7c14f48083abb3fb061370c0c64a569edf4c upstream.

Since the introduction of the OF bindings, DSA has always had a policy that
in case multiple CPU ports are present in the device tree, the numerically
smallest one is always chosen.

The MT7530 switch family, except the switch on the MT7988 SoC, has 2 CPU
ports, 5 and 6, where port 6 is preferable on the MT7531BE switch because
it has higher bandwidth.

The MT7530 driver developers had 3 options:
- to modify DSA when the MT7531 switch support was introduced, such as to
  prefer the better port
- to declare both CPU ports in device trees as CPU ports, and live with the
  sub-optimal performance resulting from not preferring the better port
- to declare just port 6 in the device tree as a CPU port

Of course they chose the path of least resistance (3rd option), kicking the
can down the road. The hardware description in the device tree is supposed
to be stable - developers are not supposed to adopt the strategy of
piecemeal hardware description, where the device tree is updated in
lockstep with the features that the kernel currently supports.

Now, as a result of the fact that they did that, any attempts to modify the
device tree and describe both CPU ports as CPU ports would make DSA change
its default selection from port 6 to 5, effectively resulting in a
performance degradation visible to users with the MT7531BE switch as can be
seen below.

Without preferring port 6:

[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
[  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
[  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
[  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver

With preferring port 6:

[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
[  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
[  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
[  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver

Using one port for WAN and the other ports for LAN is a very popular use
case which is what this test emulates.

As such, this change proposes that we retroactively modify stable kernels
(which don't support the modification of the CPU port assignments, so as to
let user space fix the problem and restore the throughput) to keep the
mt7530 driver preferring port 6 even with device trees where the hardware
is more fully described.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |   15 +++++++++++++++
 include/net/dsa.h        |    8 ++++++++
 net/dsa/dsa2.c           |   24 +++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -419,6 +419,20 @@ static void mt7530_pll_setup(struct mt75
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 }
 
+/* If port 6 is available as a CPU port, always prefer that as the default,
+ * otherwise don't care.
+ */
+static struct dsa_port *
+mt753x_preferred_default_local_cpu_port(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp = dsa_to_port(ds, 6);
+
+	if (dsa_port_is_cpu(cpu_dp))
+		return cpu_dp;
+
+	return NULL;
+}
+
 /* Setup port 6 interface mode and TRGMII TX circuit */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -3405,6 +3419,7 @@ static int mt753x_set_mac_eee(struct dsa
 static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
+	.preferred_default_local_cpu_port = mt753x_preferred_default_local_cpu_port,
 	.get_strings		= mt7530_get_strings,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -969,6 +969,14 @@ struct dsa_switch_ops {
 	void	(*port_disable)(struct dsa_switch *ds, int port);
 
 	/*
+	 * Compatibility between device trees defining multiple CPU ports and
+	 * drivers which are not OK to use by default the numerically smallest
+	 * CPU port of a switch for its local ports. This can return NULL,
+	 * meaning "don't know/don't care".
+	 */
+	struct dsa_port *(*preferred_default_local_cpu_port)(struct dsa_switch *ds);
+
+	/*
 	 * Port's MAC EEE settings
 	 */
 	int	(*set_mac_eee)(struct dsa_switch *ds, int port,
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -425,6 +425,24 @@ static int dsa_tree_setup_default_cpu(st
 	return 0;
 }
 
+static struct dsa_port *
+dsa_switch_preferred_default_local_cpu_port(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp;
+
+	if (!ds->ops->preferred_default_local_cpu_port)
+		return NULL;
+
+	cpu_dp = ds->ops->preferred_default_local_cpu_port(ds);
+	if (!cpu_dp)
+		return NULL;
+
+	if (WARN_ON(!dsa_port_is_cpu(cpu_dp) || cpu_dp->ds != ds))
+		return NULL;
+
+	return cpu_dp;
+}
+
 /* Perform initial assignment of CPU ports to user ports and DSA links in the
  * fabric, giving preference to CPU ports local to each switch. Default to
  * using the first CPU port in the switch tree if the port does not have a CPU
@@ -432,12 +450,16 @@ static int dsa_tree_setup_default_cpu(st
  */
 static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp, *dp;
+	struct dsa_port *preferred_cpu_dp, *cpu_dp, *dp;
 
 	list_for_each_entry(cpu_dp, &dst->ports, list) {
 		if (!dsa_port_is_cpu(cpu_dp))
 			continue;
 
+		preferred_cpu_dp = dsa_switch_preferred_default_local_cpu_port(cpu_dp->ds);
+		if (preferred_cpu_dp && preferred_cpu_dp != cpu_dp)
+			continue;
+
 		/* Prefer a local CPU port */
 		dsa_switch_for_each_port(dp, cpu_dp->ds) {
 			/* Prefer the first local CPU port found */



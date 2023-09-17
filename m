Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7568B746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E23C433C7;
	Sun, 17 Sep 2023 20:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983130;
	bh=4qceMZuBcjhBqr64+cxnyBocfSBChFTDpnjMAeOd8qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A324NgcvfbIEKD3OpqqGUdaJwKKTyY8nfuDojq/h9lYJgOwDf63E3QAJePVcBXiYv
	 Xij5XqETWc/KlVFYRdpjminVdfYa3asPVt8if/lxrJbUj8WdNjSArXUsda2IX03WaJ
	 qxlzMLsV8yuBb0YdWTqmD4gP+GOubVy7B7rnEeNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanan Yang <yanan.yang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/511] net: dsa: sja1105: fix bandwidth discrepancy between tc-cbs software and offload
Date: Sun, 17 Sep 2023 21:14:39 +0200
Message-ID: <20230917191124.674508225@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 954ad9bf13c4f95a4958b5f8433301f2ab99e1f5 ]

More careful measurement of the tc-cbs bandwidth shows that the stream
bandwidth (effectively idleslope) increases, there is a larger and
larger discrepancy between the rate limit obtained by the software
Qdisc, and the rate limit obtained by its offloaded counterpart.

The discrepancy becomes so large, that e.g. at an idleslope of 40000
(40Mbps), the offloaded cbs does not actually rate limit anything, and
traffic will pass at line rate through a 100 Mbps port.

The reason for the discrepancy is that the hardware documentation I've
been following is incorrect. UM11040.pdf (for SJA1105P/Q/R/S) states
about IDLE_SLOPE that it is "the rate (in unit of bytes/sec) at which
the credit counter is increased".

Cross-checking with UM10944.pdf (for SJA1105E/T) and UM11107.pdf
(for SJA1110), the wording is different: "This field specifies the
value, in bytes per second times link speed, by which the credit counter
is increased".

So there's an extra scaling for link speed that the driver is currently
not accounting for, and apparently (empirically), that link speed is
expressed in Kbps.

I've pondered whether to pollute the sja1105_mac_link_up()
implementation with CBS shaper reprogramming, but I don't think it is
worth it. IMO, the UAPI exposed by tc-cbs requires user space to
recalculate the sendslope anyway, since the formula for that depends on
port_transmit_rate (see man tc-cbs), which is not an invariant from tc's
perspective.

So we use the offload->sendslope and offload->idleslope to deduce the
original port_transmit_rate from the CBS formula, and use that value to
scale the offload->sendslope and offload->idleslope to values that the
hardware understands.

Some numerical data points:

 40Mbps stream, max interfering frame size 1500, port speed 100M
 ---------------------------------------------------------------

 tc-cbs parameters:
 idleslope 40000 sendslope -60000 locredit -900 hicredit 600

 which result in hardware values:

 Before (doesn't work)           After (works)
 credit_hi    600                600
 credit_lo    900                900
 send_slope   7500000            75
 idle_slope   5000000            50

 40Mbps stream, max interfering frame size 1500, port speed 1G
 -------------------------------------------------------------

 tc-cbs parameters:
 idleslope 40000 sendslope -960000 locredit -1440 hicredit 60

 which result in hardware values:

 Before (doesn't work)           After (works)
 credit_hi    60                 60
 credit_lo    1440               1440
 send_slope   120000000          120
 idle_slope   5000000            5

 5.12Mbps stream, max interfering frame size 1522, port speed 100M
 -----------------------------------------------------------------

 tc-cbs parameters:
 idleslope 5120 sendslope -94880 locredit -1444 hicredit 77

 which result in hardware values:

 Before (doesn't work)           After (works)
 credit_hi    77                 77
 credit_lo    1444               1444
 send_slope   11860000           118
 idle_slope   640000             6

Tested on SJA1105T, SJA1105S and SJA1110A, at 1Gbps and 100Mbps.

Fixes: 4d7525085a9b ("net: dsa: sja1105: offload the Credit-Based Shaper qdisc")
Reported-by: Yanan Yang <yanan.yang@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ef4d8d6c2bd7a..5f70773fa8201 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2049,6 +2049,7 @@ static int sja1105_setup_tc_cbs(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_cbs_entry *cbs;
+	s64 port_transmit_rate_kbps;
 	int index;
 
 	if (!offload->enable)
@@ -2066,9 +2067,17 @@ static int sja1105_setup_tc_cbs(struct dsa_switch *ds, int port,
 	 */
 	cbs->credit_hi = offload->hicredit;
 	cbs->credit_lo = abs(offload->locredit);
-	/* User space is in kbits/sec, hardware in bytes/sec */
-	cbs->idle_slope = offload->idleslope * BYTES_PER_KBIT;
-	cbs->send_slope = abs(offload->sendslope * BYTES_PER_KBIT);
+	/* User space is in kbits/sec, while the hardware in bytes/sec times
+	 * link speed. Since the given offload->sendslope is good only for the
+	 * current link speed anyway, and user space is likely to reprogram it
+	 * when that changes, don't even bother to track the port's link speed,
+	 * but deduce the port transmit rate from idleslope - sendslope.
+	 */
+	port_transmit_rate_kbps = offload->idleslope - offload->sendslope;
+	cbs->idle_slope = div_s64(offload->idleslope * BYTES_PER_KBIT,
+				  port_transmit_rate_kbps);
+	cbs->send_slope = div_s64(abs(offload->sendslope * BYTES_PER_KBIT),
+				  port_transmit_rate_kbps);
 	/* Convert the negative values from 64-bit 2's complement
 	 * to 32-bit 2's complement (for the case of 0x80000000 whose
 	 * negative is still negative).
-- 
2.40.1




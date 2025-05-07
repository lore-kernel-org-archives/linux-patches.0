Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FBA1482F5;
	Wed,  7 May 2025 18:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644192; cv=none; b=ov9aSMUzRGJmxIBwfi2uQ0InxxRU79QQCOD1QFBy0Tf+dpd09LsCo1o7Obu8KveZ/ghOWt9KaI4BzVQLZAAJVB1frUTAeAgoIZY9CV1MnWW2vkZeemv4/z8ZMR6/AoyiG/prCKQtbOc7CpMQiVCVYC8mKk9WqdyXUIxOztiycew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644192; c=relaxed/simple;
	bh=FbYZvaIAs1v46GMFWJd74yyvIcS14wbw899nYneORGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1BwZ0C6Hp9dZ79fVhHyKe/oYLSnorF00HU/ljkteINh1S3J1cryikq2JcdA/EDmDAbKy58wbPv5uRLxdZhshbXnjwhy37ioSEm/UNFet8krulbCRmiBZXutRhHgDXzWNNCpGZXecbXeRcLpLAeSlw0dLjFU452hLtt6QajkoTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPzhaDh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPzhaDh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81DBC4CEE2;
	Wed,  7 May 2025 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644192;
	bh=FbYZvaIAs1v46GMFWJd74yyvIcS14wbw899nYneORGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPzhaDh0wshbUIlSWPG/h0meh+WviLrG+ex0n9S2jZAomd8ul4LIU0Y1qqT9h1uto
	 gblyL/jH/cgCkSKcjIU9bSHh5D0AAmyBALN5gWQA2MQm0gFUCzF8G0E5sv8m+6vMFy
	 Xa7CxSCdrsKuBmwFiXFJNQcKO8dsyHLn2TVl54JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richie Pearn <richard.pearn@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 118/183] net: dsa: felix: fix broken taprio gate states after clock jump
Date: Wed,  7 May 2025 20:39:23 +0200
Message-ID: <20250507183829.601353120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 426d487bca38b34f39c483edfc6313a036446b33 ]

Simplest setup to reproduce the issue: connect 2 ports of the
LS1028A-RDB together (eno0 with swp0) and run:

$ ip link set eno0 up && ip link set swp0 up
$ tc qdisc replace dev swp0 parent root handle 100 taprio num_tc 8 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 map 0 1 2 3 4 5 6 7 \
	base-time 0 sched-entry S 20 300000 sched-entry S 10 200000 \
	sched-entry S 20 300000 sched-entry S 48 200000 \
	sched-entry S 20 300000 sched-entry S 83 200000 \
	sched-entry S 40 300000 sched-entry S 00 200000 flags 2
$ ptp4l -i eno0 -f /etc/linuxptp/configs/gPTP.cfg -m &
$ ptp4l -i swp0 -f /etc/linuxptp/configs/gPTP.cfg -m

One will observe that the PTP state machine on swp0 starts
synchronizing, then it attempts to do a clock step, and after that, it
never fails to recover from the condition below.

ptp4l[82.427]: selected best master clock 00049f.fffe.05f627
ptp4l[82.428]: port 1 (swp0): MASTER to UNCALIBRATED on RS_SLAVE
ptp4l[83.252]: port 1 (swp0): UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[83.886]: rms 4537731277 max 9075462553 freq -18518 +/- 11467 delay   818 +/-   0
ptp4l[84.170]: timed out while polling for tx timestamp
ptp4l[84.171]: increasing tx_timestamp_timeout or increasing kworker priority may correct this issue, but a driver bug likely causes it
ptp4l[84.172]: port 1 (swp0): send peer delay request failed
ptp4l[84.173]: port 1 (swp0): clearing fault immediately
ptp4l[84.269]: port 1 (swp0): SLAVE to LISTENING on INIT_COMPLETE
ptp4l[85.303]: timed out while polling for tx timestamp
ptp4l[84.171]: increasing tx_timestamp_timeout or increasing kworker priority may correct this issue, but a driver bug likely causes it
ptp4l[84.172]: port 1 (swp0): send peer delay request failed
ptp4l[84.173]: port 1 (swp0): clearing fault immediately
ptp4l[84.269]: port 1 (swp0): SLAVE to LISTENING on INIT_COMPLETE
ptp4l[85.303]: timed out while polling for tx timestamp
ptp4l[85.304]: increasing tx_timestamp_timeout or increasing kworker priority may correct this issue, but a driver bug likely causes it
ptp4l[85.305]: port 1 (swp0): send peer delay response failed
ptp4l[85.306]: port 1 (swp0): clearing fault immediately
ptp4l[86.304]: timed out while polling for tx timestamp

A hint is given by the non-zero statistics for dropped packets which
were expecting hardware TX timestamps:

$ ethtool --include-statistics -T swp0
(...)
Statistics:
  tx_pkts: 30
  tx_lost: 11
  tx_err: 0

We know that when PTP clock stepping takes place (from ocelot_ptp_settime64()
or from ocelot_ptp_adjtime()), vsc9959_tas_clock_adjust() is called.

Another interesting hint is that placing an early return in
vsc9959_tas_clock_adjust(), so as to neutralize this function, fixes the
issue and TX timestamps are no longer dropped.

The debugging function written by me and included below is intended to
read the GCL RAM, after the admin schedule became operational, through
the two status registers available for this purpose:
QSYS_GCL_STATUS_REG_1 and QSYS_GCL_STATUS_REG_2.

static void vsc9959_print_tas_gcl(struct ocelot *ocelot)
{
	u32 val, list_length, interval, gate_state;
	int i, err;

	err = read_poll_timeout(ocelot_read, val,
				!(val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING),
				10, 100000, false, ocelot, QSYS_PARAM_STATUS_REG_8);
	if (err) {
		dev_err(ocelot->dev,
			"Failed to wait for TAS config pending bit to clear: %pe\n",
			ERR_PTR(err));
		return;
	}

	val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_3);
	list_length = QSYS_PARAM_STATUS_REG_3_LIST_LENGTH_X(val);

	dev_info(ocelot->dev, "GCL length: %u\n", list_length);

	for (i = 0; i < list_length; i++) {
		ocelot_rmw(ocelot,
			   QSYS_GCL_STATUS_REG_1_GCL_ENTRY_NUM(i),
			   QSYS_GCL_STATUS_REG_1_GCL_ENTRY_NUM_M,
			   QSYS_GCL_STATUS_REG_1);
		interval = ocelot_read(ocelot, QSYS_GCL_STATUS_REG_2);
		val = ocelot_read(ocelot, QSYS_GCL_STATUS_REG_1);
		gate_state = QSYS_GCL_STATUS_REG_1_GATE_STATE_X(val);

		dev_info(ocelot->dev, "GCL entry %d: states 0x%x interval %u\n",
			 i, gate_state, interval);
	}
}

Calling it from two places: after the initial QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE
performed by vsc9959_qos_port_tas_set(), and after the one done by
vsc9959_tas_clock_adjust(), I notice the following difference.

>From the tc-taprio process context, where the schedule was initially
configured, the GCL looks like this:

mscc_felix 0000:00:00.5: GCL length: 8
mscc_felix 0000:00:00.5: GCL entry 0: states 0x20 interval 300000
mscc_felix 0000:00:00.5: GCL entry 1: states 0x10 interval 200000
mscc_felix 0000:00:00.5: GCL entry 2: states 0x20 interval 300000
mscc_felix 0000:00:00.5: GCL entry 3: states 0x48 interval 200000
mscc_felix 0000:00:00.5: GCL entry 4: states 0x20 interval 300000
mscc_felix 0000:00:00.5: GCL entry 5: states 0x83 interval 200000
mscc_felix 0000:00:00.5: GCL entry 6: states 0x40 interval 300000
mscc_felix 0000:00:00.5: GCL entry 7: states 0x0 interval 200000

But from the ptp4l clock stepping process context, when the
vsc9959_tas_clock_adjust() hook is called, the GCL RAM of the
operational schedule now looks like this:

mscc_felix 0000:00:00.5: GCL length: 8
mscc_felix 0000:00:00.5: GCL entry 0: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 1: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 2: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 3: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 4: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 5: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 6: states 0x0 interval 0
mscc_felix 0000:00:00.5: GCL entry 7: states 0x0 interval 0

I do not have a formal explanation, just experimental conclusions.
It appears that after triggering QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE
for a port's TAS, the GCL entry RAM is updated anyway, despite what the
documentation claims: "Specify the time interval in
QSYS::GCL_CFG_REG_2.TIME_INTERVAL. This triggers the actual RAM
write with the gate state and the time interval for the entry number
specified". We don't touch that register (through vsc9959_tas_gcl_set())
from vsc9959_tas_clock_adjust(), yet the GCL RAM is updated anyway.

It seems to be updated with effectively stale memory, which in my
testing can hold a variety of things, including even pieces of the
previously applied schedule, for particular schedule lengths.

As such, in most circumstances it is very difficult to pinpoint this
issue, because the newly updated schedule would "behave strangely",
but ultimately might still pass traffic to some extent, due to some
gate entries still being present in the stale GCL entry RAM. It is easy
to miss.

With the particular schedule given at the beginning, the GCL RAM
"happens" to be reproducibly rewritten with all zeroes, and this is
consistent with what we see: when the time-aware shaper has gate entries
with all gates closed, traffic is dropped on TX, no wonder we can't
retrieve TX timestamps.

Rewriting the GCL entry RAM when reapplying the new base time fixes the
observed issue.

Fixes: 8670dc33f48b ("net: dsa: felix: update base time of time-aware shaper when adjusting PTP time")
Reported-by: Richie Pearn <richard.pearn@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250426144859.3128352-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 940f1b71226d6..7b35d24c38d76 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1543,7 +1543,7 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 	struct tc_taprio_qopt_offload *taprio;
 	struct ocelot_port *ocelot_port;
 	struct timespec64 base_ts;
-	int port;
+	int i, port;
 	u32 val;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
@@ -1575,6 +1575,9 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			   QSYS_PARAM_CFG_REG_3_BASE_TIME_SEC_MSB_M,
 			   QSYS_PARAM_CFG_REG_3);
 
+		for (i = 0; i < taprio->num_entries; i++)
+			vsc9959_tas_gcl_set(ocelot, i, &taprio->entries[i]);
+
 		ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
 			   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
 			   QSYS_TAS_PARAM_CFG_CTRL);
-- 
2.39.5




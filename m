Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646348F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853D8C433C7;
	Sun, 16 Jul 2023 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540756;
	bh=3+uk3lHB9I/y/j0MUypH9xNqMEo4gsLCJGi55I5rWzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5T29BsTV+vHMGUE1z9X8RtCvp2ZNT1pval8DGU2T4g5n8wSQ1om90LwbiPusfSNT
	 fOXMvmqQYum07Je/RHaoYnYZHLlPfCuAqzaNsEs/ueWAti7IGxPDqkVH8cNq3jIkM8
	 JJFMPSBFeHXqmE8LIqHo4muyzKWGtGHy2jvFxZGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 477/591] net: dsa: felix: dont drop PTP frames with tag_8021q when RX timestamping is disabled
Date: Sun, 16 Jul 2023 21:50:16 +0200
Message-ID: <20230716194936.242136742@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 2edcfcbb3c5946609be1d8875473a240b170673b ]

The driver implements a workaround for the fact that it doesn't have an
IRQ source to tell it whether PTP frames are available through the
extraction registers, for those frames to be processed and passed
towards the network stack. That workaround is to configure the switch,
through felix_hwtstamp_set() -> felix_update_trapping_destinations(),
to create two copies of PTP packets: one sent over Ethernet to the DSA
master, and one to be consumed through the aforementioned CPU extraction
queue registers.

The reason why we want PTP packets to be consumed through the CPU
extraction registers in the first place is because we want to see their
hardware RX timestamp. With tag_8021q, that is only visible that way,
and it isn't visible with the copy of the packet that's transmitted over
Ethernet.

The problem with the workaround implementation is that it drops the
packet received over Ethernet, in expectation of its copy being present
in the CPU extraction registers. However, if felix_hwtstamp_set() hasn't
run (aka PTP RX timestamping is disabled), the driver will drop the
original PTP frame and there will be no copy of it in the CPU extraction
registers. So, the network stack will simply not see any PTP frame.

Look at the port's trapping configuration to see whether the driver has
previously enabled the CPU extraction registers. If it hasn't, just
don't RX timestamp the frame and let it be passed up the stack by DSA,
which is perfectly fine.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index dd3a18cc89dd2..4faabc4364aa7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1705,6 +1705,18 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	u32 tstamp_hi;
 	u64 tstamp;
 
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_L2:
+		if (!(ocelot->ports[port]->trap_proto & OCELOT_PROTO_PTP_L2))
+			return false;
+		break;
+	case PTP_CLASS_IPV4:
+	case PTP_CLASS_IPV6:
+		if (!(ocelot->ports[port]->trap_proto & OCELOT_PROTO_PTP_L4))
+			return false;
+		break;
+	}
+
 	/* If the "no XTR IRQ" workaround is in use, tell DSA to defer this skb
 	 * for RX timestamping. Then free it, and poll for its copy through
 	 * MMIO in the CPU port module, and inject that into the stack from
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7CB11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8CC433C7;
	Mon, 28 Aug 2023 10:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218634;
	bh=cSYo2JDcvGfS8OItB/YroqADZ5cfWa1kXUOlZ99QxnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1j/cef37QD/24PyPk+Dt2MSVOKiQiAZP5sXcTVBOXdGV+/sq4/ZnG7jIpbUQYWWd
	 PthRr6EKZ7FJlSgVPBsvf4zelKTDjLgnE/TAqiN8F3cZDw22OKAyqMAn3V2WjxptpI
	 UR1QXvDB2iHRqxL2UkpaoYvYfFCTb0wcGtO+PLKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/122] net: dsa: felix: fix oversize frame dropping for always closed tc-taprio gates
Date: Mon, 28 Aug 2023 12:12:24 +0200
Message-ID: <20230828101157.397095281@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit d44036cad31170da0cb9c728e80743f84267da6e ]

The blamed commit resolved a bug where frames would still get stuck at
egress, even though they're smaller than the maxSDU[tc], because the
driver did not take into account the extra 33 ns that the queue system
needs for scheduling the frame.

It now takes that into account, but the arithmetic that we perform in
vsc9959_tas_remaining_gate_len_ps() is buggy, because we operate on
64-bit unsigned integers, so gate_len_ns - VSC9959_TAS_MIN_GATE_LEN_NS
may become a very large integer if gate_len_ns < 33 ns.

In practice, this means that we've introduced a regression where all
traffic class gates which are permanently closed will not get detected
by the driver, and we won't enable oversize frame dropping for them.

Before:
mscc_felix 0000:00:00.5: port 0: max frame size 1526 needs 12400000 ps, 1152000 ps for mPackets at speed 1000
mscc_felix 0000:00:00.5: port 0 tc 0 min gate len 1000000, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 1 min gate len 0, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 2 min gate len 0, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 3 min gate len 0, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 4 min gate len 0, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 5 min gate len 0, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 6 min gate len 0, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 7 min gate length 5120 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 615 octets including FCS

After:
mscc_felix 0000:00:00.5: port 0: max frame size 1526 needs 12400000 ps, 1152000 ps for mPackets at speed 1000
mscc_felix 0000:00:00.5: port 0 tc 0 min gate len 1000000, sending all frames
mscc_felix 0000:00:00.5: port 0 tc 1 min gate length 0 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 1 octets including FCS
mscc_felix 0000:00:00.5: port 0 tc 2 min gate length 0 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 1 octets including FCS
mscc_felix 0000:00:00.5: port 0 tc 3 min gate length 0 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 1 octets including FCS
mscc_felix 0000:00:00.5: port 0 tc 4 min gate length 0 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 1 octets including FCS
mscc_felix 0000:00:00.5: port 0 tc 5 min gate length 0 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 1 octets including FCS
mscc_felix 0000:00:00.5: port 0 tc 6 min gate length 0 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 1 octets including FCS
mscc_felix 0000:00:00.5: port 0 tc 7 min gate length 5120 ns not enough for max frame size 1526 at 1000 Mbps, dropping frames over 615 octets including FCS

Fixes: 11afdc6526de ("net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230817120111.3522827-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5f6af0870dfd6..0186482194d20 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1071,6 +1071,9 @@ static u64 vsc9959_tas_remaining_gate_len_ps(u64 gate_len_ns)
 	if (gate_len_ns == U64_MAX)
 		return U64_MAX;
 
+	if (gate_len_ns < VSC9959_TAS_MIN_GATE_LEN_NS)
+		return 0;
+
 	return (gate_len_ns - VSC9959_TAS_MIN_GATE_LEN_NS) * PSEC_PER_NSEC;
 }
 
-- 
2.40.1




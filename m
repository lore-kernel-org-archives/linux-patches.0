Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31DE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701DCC433EF;
	Mon, 30 Jan 2023 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087032;
	bh=0kNJ79Qm9F2GK6XzsJH1qoyerr3ZgUbpP2fFeTH9nSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G92dkKjgEOAjLNj1vi0Sxa7S0iRjQB+dTySNHCJ96qpAFGvtCrRC0aSlbMaNy2/s
	 84fV1zyOi6oP7LTRaftuC9oBMUZkiVA6zgqq5hjJJBDnWssnqbKMPo/nBfDUU7ll4k
	 E79eBVRjVqauRCc6bRhcXYvjX4JQ3RKseHENWBeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>,
	Wong Vee Khee <vee.khee.wong@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/313] net: stmmac: Fix queue statistics reading
Date: Mon, 30 Jan 2023 14:48:33 +0100
Message-Id: <20230130134340.279522556@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit c296c77efb66994d94d9f706446a115581226550 ]

Correct queue statistics reading. All queue statistics are stored as unsigned
long values. The retrieval for ethtool fetches these values as u64. However, on
some systems the size of the counters are 32 bit. That yields wrong queue
statistic counters e.g., on arm32 systems such as the stm32mp157. Fix it by
using the correct data type.

Tested on Olimex STMP157-OLinuXino-LIME2 by simple running linuxptp for a short
period of time:

Non-patched kernel:
|root@st1:~# ethtool -S eth0 | grep q0
|     q0_tx_pkt_n: 3775276254951 # ???
|     q0_tx_irq_n: 879
|     q0_rx_pkt_n: 1194000908909 # ???
|     q0_rx_irq_n: 278

Patched kernel:
|root@st1:~# ethtool -S eth0 | grep q0
|     q0_tx_pkt_n: 2434
|     q0_tx_irq_n: 1274
|     q0_rx_pkt_n: 1604
|     q0_rx_irq_n: 846

Fixes: 68e9c5dee1cf ("net: stmmac: add ethtool per-queue statistic framework")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Cc: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index f453b0d09366..35c8dd92d369 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -551,16 +551,16 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
 		p = (char *)priv + offsetof(struct stmmac_priv,
 					    xstats.txq_stats[q].tx_pkt_n);
 		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
-			*data++ = (*(u64 *)p);
-			p += sizeof(u64 *);
+			*data++ = (*(unsigned long *)p);
+			p += sizeof(unsigned long);
 		}
 	}
 	for (q = 0; q < rx_cnt; q++) {
 		p = (char *)priv + offsetof(struct stmmac_priv,
 					    xstats.rxq_stats[q].rx_pkt_n);
 		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ = (*(u64 *)p);
-			p += sizeof(u64 *);
+			*data++ = (*(unsigned long *)p);
+			p += sizeof(unsigned long);
 		}
 	}
 }
-- 
2.39.0




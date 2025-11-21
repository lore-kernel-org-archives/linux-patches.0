Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA16346E6E;
	Fri, 21 Nov 2025 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733227; cv=none; b=rj5Tf9nr+HpONsTsWehFNXUJ9aDGQ8MRMqVu4507LoD9zv8rClMpDSl/pfG2YSZZSUqkxD23KS2gS40MV6WZuD94lmwh5J/hNUsJ5X6/0LdIzbHkUxQZRlhgY3/fyHsAOTZO+GH1PlslsYUfN20oplSFKNPnotzZjtgViYXKa9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733227; c=relaxed/simple;
	bh=smd++kgRC+pjDfzp86JzRdRyqGXcw6npZk7P8A2M5U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyFLZ2iVC22mdeF4NPV5RdF590BO6HdGVWDQckWVEk4t3/d7awr1BCiuTDS1ac4APf7aSH4Z+MMJbLJbFFBOb+HZtZouWUq8CXB2SvKc69k5FYJXXoxqdyZhqSWHjzz82vyHxp1mtYwOYinMAR26N2rl463EleP1K1DnuH+zUCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fl+0UWOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fl+0UWOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4F2C116C6;
	Fri, 21 Nov 2025 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733227;
	bh=smd++kgRC+pjDfzp86JzRdRyqGXcw6npZk7P8A2M5U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl+0UWOdV/6pTC4RYFCieE1ucA/THg9OEnUinNiW5/cOb53r9JGVZXqhdkK93Zgt5
	 Gfj8bSi8GemLR0q7qJTk2IUDKPb5/8V+TTCPMJ5tmfVzR1o6oWR8p32QDjTlIXoL59
	 H9FTnkDIdFZgGyuqk2a8oqZxUroOchHPPu6w87To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/529] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Fri, 21 Nov 2025 14:11:35 +0100
Message-ID: <20251121130245.112317614@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit ad17e7e92a7c52ce70bb764813fcf99464f96903 ]

Two additional bytes in front of each frame received into the RX FIFO if
SHIFT16 is set, so we need to subtract the extra two bytes from pkt_len
to correct the statistic of rx_bytes.

Fixes: 3ac72b7b63d5 ("net: fec: align IP header in hardware")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251106021421.2096585-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 64cd72c194783..ee0306ab97714 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1776,6 +1776,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		page = rxq->rx_skb_info[index].page;
-- 
2.51.0




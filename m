Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A78B8F54;
	Tue, 17 Jun 2025 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177662; cv=none; b=eTBqChudGxSsyoIV4oAfBp1iDiKBva8qATgkWimn9erxJklg7fwfsc0CJfyGU3hYX+qKmUIGFY6ie3bHEUBI0xiZkpEyvhOAePEv1Yz+QkMALW5FpgXJ07vuOr3qz8KdMWkkV/4Mbc3RCMPrtiSlyLKZF0RVRP5OWy1shT38/kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177662; c=relaxed/simple;
	bh=pV38S/SUkuX+0gBB24UyzF2U8cBe+5hroHnBP4KkpQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6EZCT8SpHCYwu3RXygL4eDRcflBcAgCv4Vt8Nav7V/YjcN8J1tGo+Rs8Yw9uJxKAefeqtGVULLwAplbNw3gX7nhPzpfEZjemucfUFtIAwdnrGkT591xXJtqAa0fVV+cqxGWtcglC4IHrlueHbY5v2zjUTzk/So9xfVF79x1M7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhb684Zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhb684Zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D200C4CEE3;
	Tue, 17 Jun 2025 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177662;
	bh=pV38S/SUkuX+0gBB24UyzF2U8cBe+5hroHnBP4KkpQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhb684Zzw4dTlIUJNrxFeoWy7ySt9HXDpJjOd2An63iXXEOBR4jabdC4+IS9Pz/UH
	 c7IC0drFDoQ+ZZ2SvBupYKOo2Hln+qmJgIktTw13mbQygQ4/pTJOeTvxogrjmX9PP9
	 MpkO5UJhaXV3cUEMgFISHtO5HKpRz0xn911Uzzb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 378/512] net: ti: icssg-prueth: Fix swapped TX stats for MII interfaces.
Date: Tue, 17 Jun 2025 17:25:44 +0200
Message-ID: <20250617152434.911742449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 919d763d609428c2680ec8159257d9655f002f89 ]

In MII mode, Tx lines are swapped for port0 and port1, which means
Tx port0 receives data from PRU1 and the Tx port1 receives data from
PRU0. This is an expected hardware behavior and reading the Tx stats
needs to be handled accordingly in the driver. Update the driver to
read Tx stats from the PRU1 for port0 and PRU0 for port1.

Fixes: c1e10d5dc7a1 ("net: ti: icssg-prueth: Add ICSSG Stats")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250603052904.431203-1-m-malladi@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_stats.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_stats.c b/drivers/net/ethernet/ti/icssg/icssg_stats.c
index 6f0edae38ea24..172ae38381b45 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_stats.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_stats.c
@@ -29,6 +29,14 @@ void emac_update_hardware_stats(struct prueth_emac *emac)
 	spin_lock(&prueth->stats_lock);
 
 	for (i = 0; i < ARRAY_SIZE(icssg_all_miig_stats); i++) {
+		/* In MII mode TX lines are swapped inside ICSSG, so read Tx stats
+		 * from slice1 for port0 and slice0 for port1 to get accurate Tx
+		 * stats for a given port
+		 */
+		if (emac->phy_if == PHY_INTERFACE_MODE_MII &&
+		    icssg_all_miig_stats[i].offset >= ICSSG_TX_PACKET_OFFSET &&
+		    icssg_all_miig_stats[i].offset <= ICSSG_TX_BYTE_OFFSET)
+			base = stats_base[slice ^ 1];
 		regmap_read(prueth->miig_rt,
 			    base + icssg_all_miig_stats[i].offset,
 			    &val);
-- 
2.39.5




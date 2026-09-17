Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE403B1ED7;
	Thu, 17 Sep 2026 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665361; cv=none; b=eLb/naF991XTYtzT4/mVOIa1qaorHlgGuBJooSyjxeWC31CcZQ8gAQvMX+2dnf6QIowNIMIY/jObA0PEFLU3mYxKSMoDYdIfSIvs7+gOOCUsKX+0cIg1grvgP9W4xRb8lBCPGIF/ODf5GzBEWBt7w+ACr/+9Nxg7ivzjXDudPTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665361; c=relaxed/simple;
	bh=XCNT81EoNVmTqmHxhvDAuldKIC5q+ToYpDdw11cwJpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSe2ujChj5jbHGqMN3ZqhM38f/864E0W4pEI7VOmyjSHnZQ6x6o9O+bsZNy7h1rztcA6C5k1pnL4BZu91BMcSxTYdjicpgCcvtnJKxRKNIBwVD4RjhS5qops89QGi9+HsGUKR+WeBHZJbY2WFSHVNinWk08ErFbaVL1leInKgZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8vy9Y7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8vy9Y7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293451F000FF;
	Thu, 17 Sep 2026 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665359;
	bh=pf0JrzYyTCx1d6Mg0UMxmtnuwTXB4Lz5veQvRktT+dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8vy9Y7mpl1mBpb6phihgmhHu4khXmk6QXLbYdDxps4A935BAkwWuPOpTv+fbX3Ck
	 h5BXelS66pfWVHnyKkThXkPt4JO+9Z9e/3TDGH3y2MxMWqxJF5O2fvA5W0CWEAjCKD
	 vQhsH3SjYd1XfmnFRE9+3UHvKcTUeGiUzKMCHvqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0678/1250] net: ethernet: oa_tc6: Disable tx queues on fatal error
Date: Thu, 17 Sep 2026 16:07:53 +0100
Message-ID: <20260917151610.263032909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit 349c366365876b7f67120827a0deb44899f59303 ]

Previously, TX queue interface was stopped when
disable_traffic flag was set, which would indicate fatal
error. It is more appropriate to disable the queue as,
unless driver is unloaded and reloaded, there is no recovery
after disable_traffic is set.

Queues may be re-enabled inadvertently by other layers.
Intention of disable_traffic is only to stop the traffic
from flowing on fatal error.

Fixes: b542d13fab0f ("net: ethernet: oa_tc6: Interrupt is active low, level triggered.")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260824-fix-race-condition-and-crash-v7-3-4323279b18f2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index aca771674347a..e4949a310af2f 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -718,6 +718,10 @@ static void oa_tc6_disable_traffic(struct oa_tc6 *tc6)
 	skb = oa_tc6_detach_waiting_tx_skb(tc6);
 	spin_unlock_bh(&tc6->tx_skb_lock);
 
+	/* disable_traffic, when set, is a point of no return to
+	 * working state. Keeping the TX queues disabled.
+	 */
+	netif_tx_disable(tc6->netdev);
 	oa_tc6_drop_tx_skb(tc6, skb);
 	oa_tc6_free_ongoing_skbs(tc6);
 	oa_tc6_write_register(tc6, OA_TC6_REG_INT_MASK0, regval);
-- 
2.53.0




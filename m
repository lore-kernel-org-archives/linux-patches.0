Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A2D30BBA2;
	Mon, 13 Oct 2025 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367762; cv=none; b=GtTq7BrfLZBGpHjwbCekxGU02WxM1Wiuf7z2m+Bu9NM+g0TsHAQr2DGaK9x/O4QJHHp3uDIjpP5PyYLogVQjQ43DKRGP9wc3OpQCxjz/aGz6gbQnvlL8q7bJmBsBjdxOh9IsXj1uE6YY28LqfuZ0fDkpmGwZe7UrTQliOUQAOdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367762; c=relaxed/simple;
	bh=qx8OXZZnOn+kFpjp1qW7F6psKt7SFI6Zu2axctJ7xhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOzIV44tWc8RUzXy/5CR/ff/K8ZISuFKiM+VeMVT7JFtCMumbkIbEFNDKmmddknR4Fr1lzPO9B6AdhyVP9CHHNpDVx0EepQs1KpFlgDWTzYiney3xmCHYdWpqtai7XKTgTxwF6pxyqDmHRNDnBEpPLrz+frhC+7JDWvIaeYL3kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMlF5aXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMlF5aXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1B6C4CEE7;
	Mon, 13 Oct 2025 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367761;
	bh=qx8OXZZnOn+kFpjp1qW7F6psKt7SFI6Zu2axctJ7xhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMlF5aXKhRVuQr6V5kd91OX0NheQsUTRZCtt5dTaKFX1q3aSSJcu2REbzp0qiZh+l
	 yE4liY7lDFuqrPcUWw25xkII1HHp5ocHuOMaDd+hSnD6hsgTEXGjjlWC1EW+3JFX50
	 OwOQt7+KWyI/42U3HV6ukgttnQ5mSigWoiepwbxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/196] RDMA/core: Resolve MAC of next-hop device without ARP support
Date: Mon, 13 Oct 2025 16:45:15 +0200
Message-ID: <20251013144319.794716249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 200651b9b8aadfbbec852f0e5d042d9abe75e2ab ]

Currently, if the next-hop netdevice does not support ARP resolution,
the destination MAC address is silently set to zero without reporting
an error. This leads to incorrect behavior and may result in packet
transmission failures.

Fix this by deferring MAC resolution to the IP stack via neighbour
lookup, allowing proper resolution or error reporting as appropriate.

Fixes: 7025fcd36bd6 ("IB: address translation to map IP toIB addresses (GIDs)")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250916111103.84069-3-edwards@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f20dfe70fa0e4..8bf705921618c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -460,14 +460,10 @@ static int addr_resolve_neigh(const struct dst_entry *dst,
 {
 	int ret = 0;
 
-	if (ndev_flags & IFF_LOOPBACK) {
+	if (ndev_flags & IFF_LOOPBACK)
 		memcpy(addr->dst_dev_addr, addr->src_dev_addr, MAX_ADDR_LEN);
-	} else {
-		if (!(ndev_flags & IFF_NOARP)) {
-			/* If the device doesn't do ARP internally */
-			ret = fetch_ha(dst, addr, dst_in, seq);
-		}
-	}
+	else
+		ret = fetch_ha(dst, addr, dst_in, seq);
 	return ret;
 }
 
-- 
2.51.0




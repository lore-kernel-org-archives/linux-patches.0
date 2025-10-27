Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A3C1F7586;
	Mon, 27 Oct 2025 18:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591094; cv=none; b=OG3GRXjnnxmzC2TsFvH0c3QnxQiQlFQjMNXZMGfFzbFbwwCwspinhREmLOZnBtLrsBVsov5j/7Whb/Z4ZlLDtrHX8FNeMh0hlGgum2+Jb355Hyu85JmL9QtOUVTxRIPAPklE8vCqq6Fvjls3SWg9NDRSx3csDZGrfFwkyLgrQMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591094; c=relaxed/simple;
	bh=zfZ9Wyo/416OpX9G572RjvSdMe8yA5Qq6vsNRXNYsIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDwnJoWVsDy+vvv9rdMENKTkVFZAb+H3h9L+L7KSoVIchjyVECZWcdgPeS2+W/G4yYUKFrCXmmRz/VLD1Q0REgqWuVzSGSdLvg5x0+r5X7zpgp3Tpp0fW5XndNzjMjPmMkIPVGSbISsLCoWma+sI39BD0PlTX0eGO7/vNmuOAtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2hR2g/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2hR2g/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4FFC4CEF1;
	Mon, 27 Oct 2025 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591094;
	bh=zfZ9Wyo/416OpX9G572RjvSdMe8yA5Qq6vsNRXNYsIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2hR2g/uUQLzLTWv5MMFHxatF9QewTeeC8gf92tcJ1klcbeXHEMhlGZ/rz9XKh+Jq
	 a0cdMZP65zWDHKIIdNPTyWABy6a9Jvd1NDdljgv+Z6Th85tvMibgqXFYv++jgX+KCM
	 IyNDHfz1586Yy543JieFhlHPq3bDvABCO8EHbw24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/332] RDMA/core: Resolve MAC of next-hop device without ARP support
Date: Mon, 27 Oct 2025 19:31:57 +0100
Message-ID: <20251027183526.309101114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 65e3e7df8a4b0..779e9af479fdd 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -461,14 +461,10 @@ static int addr_resolve_neigh(const struct dst_entry *dst,
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




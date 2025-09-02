Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D727F261593;
	Tue,  2 Sep 2025 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820347; cv=none; b=UfJ91VzmG6//m0656f0nmMzzEarO25pFeLb2bGbZ9O6WJdN7ArXtUMZ2gWy2HJ+82PJ2HMzMia8jI5p4Qisu5g2L3fhAI9j7rYxovRpxL0gWaOS7p4L94+BbWnZyYOsFec9EBu2HuTZvXNAunIJ5NBw9dKpnXdVtp2pD1PjSxC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820347; c=relaxed/simple;
	bh=qV/1lzlt+dicd6H74Me8zmxX5Yv/lW3MqXY///o3lmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvkzcPOD/+we2nlKUzn5IwSXnhgoHJRVS/xGUHOZPmKKR5PjcgH/iB0Y/Xr2DSD+rO2wmqWrWDwU6bdYAJBO7lwBgkk/+EtSxa0T0YpLyOydEXtC3Jm1wDgRRoybm+Wvxe6HNpsmpul20nfF3RHqflBPX/zF2orhyhFzEX4pNDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13tVq17r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13tVq17r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A22BC4CEED;
	Tue,  2 Sep 2025 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820347;
	bh=qV/1lzlt+dicd6H74Me8zmxX5Yv/lW3MqXY///o3lmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13tVq17rgQQCb6RjQk4oxO4Ev/uagAG7omK01POiVIHAsZxdaNwz6rt2vw9QYWMN5
	 bTXtkuyo1NX+TWR1w9FENrCsgmSsunyV905bH6BKkAB6yHHB0J8tygtoQHcgzXwLfx
	 IOET7fz366MrQ43dMpMk+2lNUgLs7YA8mmb90Hnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/75] net: dlink: fix multicast stats being counted incorrectly
Date: Tue,  2 Sep 2025 15:20:46 +0200
Message-ID: <20250902131936.460776124@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 007a5ffadc4fd51739527f1503b7cf048f31c413 ]

`McstFramesRcvdOk` counts the number of received multicast packets, and
it reports the value correctly.

However, reading `McstFramesRcvdOk` clears the register to zero. As a
result, the driver was reporting only the packets since the last read,
instead of the accumulated total.

Fix this by updating the multicast statistics accumulatively instaed of
instantaneously.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-on: D-Link DGE-550T Rev-A3
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250823182927.6063-3-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dlink/dl2k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index fad5a72d3b167..f1208591ed67e 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1092,7 +1092,7 @@ get_stats (struct net_device *dev)
 	dev->stats.rx_bytes += dr32(OctetRcvOk);
 	dev->stats.tx_bytes += dr32(OctetXmtOk);
 
-	dev->stats.multicast = dr32(McstFramesRcvdOk);
+	dev->stats.multicast += dr32(McstFramesRcvdOk);
 	dev->stats.collisions += dr32(SingleColFrames)
 			     +  dr32(MultiColFrames);
 
-- 
2.50.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF798324B1C;
	Tue,  2 Sep 2025 13:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820762; cv=none; b=fQSXbh8lwvMBZR0OEc+q24qLyBvdEkxASi8iOVdh0koWebPHjVzDrEnV69fZm0CN5JeCMcPqK4AN64eYYIhCDIEHsK6ZVCVrX6jnLFLIjS8Apa+PMknZLObYt6BddTrlVVATtcEF2kaBw4dH3Bptb0VmGJ/8bQad38U/C1P3v5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820762; c=relaxed/simple;
	bh=AcXSJ4Nr4msoI+VkQjEms7xSt1uwEO5+gn8kVZKc7jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxyMrEQ5JSzgdEn7mwSLwSkY7OwkbFIcWHxt8wTuEnXlMWtCCdK8rsWIATSyPha0kNCmptJOjwUw+BH/VhXCdiGiuaz+WRlH7xnP2DV0buGHn/B/zG9Dzej/643MhkMptq2h6+VCtB6hz+wU7YBE4Y/D7KpE0Ge+S7PY1JO/Pmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xa1Lg/xR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xa1Lg/xR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F257C4CEED;
	Tue,  2 Sep 2025 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820761;
	bh=AcXSJ4Nr4msoI+VkQjEms7xSt1uwEO5+gn8kVZKc7jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xa1Lg/xRS1FSo7WeOUUJ1Upik+hzGtUmq52kwUeLqMmQ5y7NesoVuoIWadcGmA1pc
	 VQNi0i6tInF08f87+YjpLWvXFFrW8qqUg/KIZcr2vUpIS/ySVbDhaMeUFLhXxy8kop
	 Xz4Qw39s9aJrj4uXErUgVX/NdlAv74RKLA8QV2TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/23] net: dlink: fix multicast stats being counted incorrectly
Date: Tue,  2 Sep 2025 15:21:56 +0200
Message-ID: <20250902131925.135894331@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8d57fb5072054..b4a8d4f12087a 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1102,7 +1102,7 @@ get_stats (struct net_device *dev)
 	dev->stats.rx_bytes += dr32(OctetRcvOk);
 	dev->stats.tx_bytes += dr32(OctetXmtOk);
 
-	dev->stats.multicast = dr32(McstFramesRcvdOk);
+	dev->stats.multicast += dr32(McstFramesRcvdOk);
 	dev->stats.collisions += dr32(SingleColFrames)
 			     +  dr32(MultiColFrames);
 
-- 
2.50.1




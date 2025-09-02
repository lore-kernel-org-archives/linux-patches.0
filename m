Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E522EDD6B;
	Tue,  2 Sep 2025 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820653; cv=none; b=loKVeCC73k2EoRgZjg+rgCvWeLeSUWyc2xzozqjwwojnck2k7UUcD/XTJrWClHVw1s2bHkYs/VohQ0Sh7jxF+bci6Q568hM5Ww6wdw5vBywgHpqQ3V6MRNl9kaeR2/a1uBJf09eZa0L175dccFwfaa7UhUC0a59NOwsunfslt58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820653; c=relaxed/simple;
	bh=3QJ+RGXqyv2vT9OrKb+oySheFm09OggUQ30m2fRLbXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dvf/Kpof12OaieMM7PVYA8D7IpRYI49y3ko55myR/AV1B8sOTe82/SoELWfPICjHDdxATl3/HQOYeJlSBXaC7lFt/lXD5CXwPyLp3BsYLvt643We1oI9dy+7+Mqp3pfY+lSByWoJUbkG9MstI9GsvFAksq1MIdU4Fz/KccrVNro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEIvWVat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEIvWVat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F069CC4CEED;
	Tue,  2 Sep 2025 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820653;
	bh=3QJ+RGXqyv2vT9OrKb+oySheFm09OggUQ30m2fRLbXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEIvWVatXZGcUCiqCHaFC/dQCfjyd8MSzq2WV4R9KSxF+cx6mMLcanPLH98TvW+Ji
	 Tt5bCqxqBxbURPSltoDKNBbOp5/BmzkjxmX3K/lJ1BD8hxz4+7Wj9MOVay0/WrX1Xo
	 vRqE26SZCpnGGwAxVtamN+qDJX7M9Mx4lVwCzJEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/34] net: dlink: fix multicast stats being counted incorrectly
Date: Tue,  2 Sep 2025 15:21:38 +0200
Message-ID: <20250902131927.106989838@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b7f992103da3c..af1e96e0209fc 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1095,7 +1095,7 @@ get_stats (struct net_device *dev)
 	dev->stats.rx_bytes += dr32(OctetRcvOk);
 	dev->stats.tx_bytes += dr32(OctetXmtOk);
 
-	dev->stats.multicast = dr32(McstFramesRcvdOk);
+	dev->stats.multicast += dr32(McstFramesRcvdOk);
 	dev->stats.collisions += dr32(SingleColFrames)
 			     +  dr32(MultiColFrames);
 
-- 
2.50.1




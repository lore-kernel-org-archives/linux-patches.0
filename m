Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892512E6CA8;
	Sat, 30 May 2026 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165240; cv=none; b=CJtwreALHHNXbWDZH8ync+KCPUt1rA2e6olD4po1aC0qVpw3cnoPSOB6JXnA5rGPlWe8AhPHn9t8waILNCtisFGICRNpRvO5CT8VhWFn9qhxZglYQ4yuk0gzuI1yX9ihgMP2L1fNayGGS4mjDd9FtJRcFQ2pXiBKvw0kg302XZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165240; c=relaxed/simple;
	bh=9AsYWKLvC2UdilSII1rsv63H95co3l48DYO0wxkJQyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsgXYLzZ2xSJPQgxdfBBr6i/Tfy3TCEPtEMAHbQqN7/6UexcojMffy+442iy01gpIHqsTO96ZrWDjlWJsVfa9liY3iZgAn4X8r1NnUK11zn8T4Bxut+kCKbNaDlJuYCdVfVsK1++6nuK43u/oBrNUEyCV3xWXMlIV//sqlSNyV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFbCGGdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFbCGGdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5D1F00898;
	Sat, 30 May 2026 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165238;
	bh=nCIvSuig80kPm3f9z3zn1rsQxLjFEeIxlE8Q2pXYKJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFbCGGdE8g7VEzjV9BST5wkZMQUoo/uKSBmVSbfA8yjETnBbX5Rp0VmHlQLvVrBXQ
	 HJJsPCWAb6aTn82vYYIqGt3quPRVw4dAwu+W9RxtbbVRMrS+bNbv3rkcqjTlkiIH4d
	 KiZ2hn2mwSumipyePlnLUnrupv03l0+YvgKaDTOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie He <xie.he.0141@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/589] net: lapbether: Close the LAPB device before its underlying Ethernet device closes
Date: Sat, 30 May 2026 17:58:21 +0200
Message-ID: <20260530160225.110801162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 536e1004d273cf55d0e6c6ab6bfe74dc60464cd2 ]

When a virtual LAPB device's underlying Ethernet device closes, the LAPB
device is also closed.

However, currently the LAPB device is closed after the Ethernet device
closes. It would be better to close it before the Ethernet device closes.
This would allow the LAPB device to transmit a last frame to notify the
other side that it is disconnecting.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b120e4432f9f ("net: lapbether: handle NETDEV_PRE_TYPE_CHANGE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 24c53cc0c112f..1276071f93c04 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -415,8 +415,8 @@ static int lapbeth_device_event(struct notifier_block *this,
 		if (lapbeth_get_x25_dev(dev) == NULL)
 			lapbeth_new_device(dev);
 		break;
-	case NETDEV_DOWN:	
-		/* ethernet device closed -> close LAPB interface */
+	case NETDEV_GOING_DOWN:
+		/* ethernet device closes -> close LAPB interface */
 		lapbeth = lapbeth_get_x25_dev(dev);
 		if (lapbeth) 
 			dev_close(lapbeth->axdev);
-- 
2.53.0




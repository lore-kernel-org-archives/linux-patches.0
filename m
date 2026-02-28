Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0B0359A65
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302398; cv=none; b=FaZ6e1O9PIOHlYnaIRoSCDCIYUOs+zBhw4lByskVO+2iV3TCFQ7hM5pAIZCxhZhqtmi3JQFNCg4QnDnvfXYiVs737XrSAwCCnG8EesO+8BSxuRVb984+sW5A3zLlp8AHF1X6y3zkkN3FLK4kz22jlFPtCrzKyUub/GH1udlTCqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302398; c=relaxed/simple;
	bh=xYmLnkUdW+cFH92ZMGAppYz5pBQiBQUCVdh8WGoiyYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGN0ULfy0HKomb/pSFXxc7ynbQFRXa7OgSOOT361TshpmVIiOls5/tSPb/timtbSQmRQsuem5hc8Z4orUwlEr59ltDpJ1WbvZy48xeU5qr5mOLI/WkYnWFQW06/MJmMTd0cUpkK8NYNp6PcU3Hnksvz/rpWSfvvE2H6ZcfyF/GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkN5wMKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkN5wMKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59E1C19425;
	Sat, 28 Feb 2026 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302398;
	bh=xYmLnkUdW+cFH92ZMGAppYz5pBQiBQUCVdh8WGoiyYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkN5wMKWVg/pqzZQ79fpMsytnoT0lJ5t4GIvGeIzcxMmELssVYPHkwDEvsX5cephF
	 SerZIlL+bmz7f2+t4TW8AImpeB75z1xrffOaDO3/ZRR43zb0m3i3RLwmyAVJGhvCHy
	 BtT/r1CXxvSuNrcMj4U6w1RMZ/hXhLSJZeApowxMb1NN/tZEZlFgSAzGCdwCIQBW6X
	 x7WcYwpPpGLdwZlNkiLZvzrYbglH4C1g+1ZmNwg1iYNZq4nFdewqdLd07FHbuO3GSh
	 f8lIBx96ug7MHdq/CmS7anM7dieKE74VgkpEOUNC57PKY/ObICHygjTFmE02zOrly5
	 8ZmfVKVbiIWbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/232] ionic: Rate limit unknown xcvr type messages
Date: Sat, 28 Feb 2026 13:09:41 -0500
Message-ID: <20260228181127.1592657-128-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit cdb1634de3bf197c0d86487d1fb84c128a79cc7c ]

Running ethtool repeatedly with a transceiver unknown to the driver or
firmware will cause the driver to spam the kernel logs with "unknown
xcvr type" messages which can distract from real issues; and this isn't
interesting information outside of debugging. Fix this by rate limiting
the output so that there are still notifications but not so many that
they flood the log.

Using dev_dbg_once() would reduce the number of messages further, but
this would miss the case where a different unknown transceiver type is
plugged in, and its status is requested.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20260206224651.1491-1-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 928ef29339907..2e8744815af66 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -208,9 +208,10 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 		/* This means there's no module plugged in */
 		break;
 	default:
-		dev_info(lif->ionic->dev, "unknown xcvr type pid=%d / 0x%x\n",
-			 idev->port_info->status.xcvr.pid,
-			 idev->port_info->status.xcvr.pid);
+		dev_dbg_ratelimited(lif->ionic->dev,
+				    "unknown xcvr type pid=%d / 0x%x\n",
+				    idev->port_info->status.xcvr.pid,
+				    idev->port_info->status.xcvr.pid);
 		break;
 	}
 
-- 
2.51.0


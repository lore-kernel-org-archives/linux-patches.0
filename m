Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634E635AC12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302722; cv=none; b=O7+x5p3yf0puVohjQWjzCP9kZev6S+wZN5czg4DHs+rqcvPLStrTptuPMtv9waKoB498nBwUPga8EHdffjVbZTPD4pd5jZa5cYlR57CcFXtcUfaTQ8px1CHpBYHlp+NW3AENpwj9O+PVLJHedYW10EK21X4iyI3121JwQ2Ah7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302722; c=relaxed/simple;
	bh=P6vAvtBxVnBgS+hA7VBUmsb11w90MjKQ0nz46gHiUNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHpWrm+/wt+sKyDyIfFQ03eu2ErDf839SNN33VMedKPpRHSUB2fVDgpjWAAiMYllUUoGBNjNvVdV6wOL5vFnsppOufhTXaTlG7uw0TZSx6fvU8q/7hx1tM4M7Be1xEVSwYRw+CBIZcNW4MntIpoStJA1lMKyk9e60fwF22jqJ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQ3Qy030; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQ3Qy030"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F52C116D0;
	Sat, 28 Feb 2026 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302722;
	bh=P6vAvtBxVnBgS+hA7VBUmsb11w90MjKQ0nz46gHiUNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ3Qy030SaaN59PBLagzLz+/WFWTgQWV2UQLd/+hUygWjNos7niDI2HJ0kk7TyB+e
	 Lu1E4FkXdOi5rGcSBjOhd0XgHXo42pntrGvbzCuYNwfcdsD5S8neSDxm9+n5f7Do2+
	 mlgoYORZLycZ1sbTvBcUWuZF4qOyNSVhUVUi8eaRzS67yCP1+2wAqpJNFocRPrgPOJ
	 ObEobxKauoEQbiYDrsZFaMEyEEL/IrM0uN6W0XE/J1Ls13GDQ3mBnodA7QSRFOSYYT
	 fMQNdiHxq5a0RAXqrw+FBw4uBhD+pYv7MoQAI/f2l5peMOCBZ+xics7Lx7AM8EBD6T
	 90j5FZb59OG9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/147] ionic: Rate limit unknown xcvr type messages
Date: Sat, 28 Feb 2026 13:16:30 -0500
Message-ID: <20260228181736.1605592-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index d0a613fac9ff3..02858e8881549 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -213,9 +213,10 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
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


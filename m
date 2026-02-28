Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D726D333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301827; cv=none; b=RykgvAYtnTh8nUvLcp3G0yoQbkM0pa/9lXe2lE1BFXvX0OpmQnJJTVCuRpHvnet706PHPRWEAK1bb5KC7K5wP9OPSJ/dPLIfOOcZYQHplXaBxIXMwQP4oZvzNbvFPYIfXaJbiep+OC6wVGoCBQkYuQObDtN2B29TX/RH8ftsno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301827; c=relaxed/simple;
	bh=JymLwKkWgrXGPPIO6I7mamRXO35fYt/IIbpG4SpXeHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb8m9dZQKe1WRYWqreZYHYVoHTlxEv57RtsDTVImVgP0WNziPWzZpOki+phV7U0XKeB7uQqIig4ZtemIGLSb58R/2YMH8JzdpefZIpvMvXjsj/CbRYtFvYBA1ILx4ODqgej0dXDdPyBjk8mTvt06IWYFooR3Ba6ll+cc3320QNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csA50Rzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csA50Rzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337E4C19423;
	Sat, 28 Feb 2026 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301827;
	bh=JymLwKkWgrXGPPIO6I7mamRXO35fYt/IIbpG4SpXeHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csA50Rzr2Xwp5y3sxQLFIbW7TBOCxGOPRPI0GIiiBNZbSAeQNGTkneQVjqur4mQRq
	 7SoTTEWzAf03JeO1QOyBFIvdXcJREyf13acGFblVXRjohOdSYf7VZdwIdmSW7EFMY9
	 /WFqtNpUsCtTvzaLhFw8fHSr4B+k7QJ15G+Ds6ZfB0fpQZ5YdezENbPw2hYWI8Q0yl
	 nl07H6AdLCfe2wguUW3K8nDgKbg1x5AhADYxouYofWs0hUfyWrxr38gLRFFK8/xai7
	 zuMqJ3+LiqZ5PQ4OklXpvtWhjHKGKocWtzWNS59Ep5uqUsCFOgIyvWNCMLAl15PhjD
	 e8XH7Tn7lLs0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/385] ionic: Rate limit unknown xcvr type messages
Date: Sat, 28 Feb 2026 12:57:45 -0500
Message-ID: <20260228180011.1568201-243-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 9b7f78b6cdb1e..a632536bd7f2f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -224,9 +224,10 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
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


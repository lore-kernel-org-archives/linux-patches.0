Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E9738F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302167; cv=none; b=SVrzwXef7ERb+KsiFOQ2ZEXPGwJBgEVj2OO2x9q+mL6xpJUcSrMVvD83R1yQiOeuqlDFl9WnquU3Yd77ftRg8BBbZw8TpQupUpnQ2HTPCDI6YX9ceBs3/bVpU6K+j6gJSdGvE+mSkN9fEMqjoKFCujm6byr+z59FpnROjlTuEo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302167; c=relaxed/simple;
	bh=PkkC+irWPdJkFtjWPJ6xp5YXD8j1WVjAD7WxZ2QY6WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdhvKlpkrKyaKNQt3z1UQbA0lWwdOZ6MVWAt1wwaTGpiw/CsB+SKLEQHk9fH93bCaG9zCe0vV6A+wE2JL/FRBlQY2RVDUDB3yUmP1YirSv6+g0omaiORPXNYy8XoB2lERzArTIbd0GavUlrduxveQ1q2N0ct4I4fBnS0WxUH/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPKwP2i8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPKwP2i8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04414C116D0;
	Sat, 28 Feb 2026 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302167;
	bh=PkkC+irWPdJkFtjWPJ6xp5YXD8j1WVjAD7WxZ2QY6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPKwP2i8GNeL+8ek3ic2WRvUdIgWZgL6Ii7uyzWdcXwMWJXkPRhc5SNtIM8hWrfXJ
	 QyPydXfoF8qCXi/GZGknjd03u4NJqk7pawL479GWe0LYJIj9YtS7W2727vUGJo3f+f
	 uYDw4XFO1mPdZfO/o9DZUeD4NVEWf+y1j+wdjKWu1iUhN2Ei/cigCHylw/gGquzG3O
	 vv34CAw62UpmyG8812pDx/3DEGfLqlDZIaCwHt/zEa45zFuQ3rk5ekcZWL8RExAleU
	 0Rkh5Wv9XvGsABkJo26jaVdWuB01yiUH+pKx+wSoCl2AwEILdyA7Hvu99eSqVKi0hG
	 yz4fj3Xy8qCEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/283] ionic: Rate limit unknown xcvr type messages
Date: Sat, 28 Feb 2026 13:05:06 -0500
Message-ID: <20260228180709.1583486-164-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index d76e63f57ff1e..b07dd56b0c76d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -222,9 +222,10 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
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


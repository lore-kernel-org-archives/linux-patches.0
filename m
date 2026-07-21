Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A67E471277;
	Tue, 21 Jul 2026 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657416; cv=none; b=OUIV6gch4g19dRU0Bgv6LUysUkRT38yjFl1UDcadjI3jPJEUbjJz7eJk6vcypEgvRQ243imBDrq+p9QQ8c6Ll/59Rdukr5NiCibYOBU2fCQGhbuWlGZ2yyL3HqIzJBvtYDP4mHArzmMm7pJbeJVWAsPPVD7ckykm1MhSTyvHw6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657416; c=relaxed/simple;
	bh=qSDHdNLO2UcWSjrzQrI/rB7GnOZteDSsmZIWRPHhHdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHcOJ4JfeT8D8nyyaODxmQo7/jvBwMooXBgqi12gbOVbabKLPbq/Dz7RqCn/ob2Q3R9m6WDX258affMsY/WJHemPpxALt4/XU9kiLG0thXEc/ki5nLb1HWvNpR/MG7rcQi8B1QPVgKfAG6fz2p1y3v+JyZuEknxb5RUOzpwx5uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwdBk+y4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwdBk+y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1771F00A3A;
	Tue, 21 Jul 2026 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657414;
	bh=byWqEzsXcnSmbAERAF2qm/PtT6BrEORvNJKgxGTn2VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwdBk+y4FcNDIwFYp6aS/o48tQcejuWnDiXraM5B2D7TfseInbDVsD3GK/FIvFkVG
	 GFvn2RWan4d00EXaJPGMaUHMZExTu+cAA+jbJPBUjehHTPRlAnUOwDM/QEQihD12DN
	 RabbBXs0cuQA7JYrQ2o81K6ErYkCWO2PX3Yh+iD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0757/1611] i3c: master: Replace WARN_ON() with dev_err() in i3c_dev_free_ibi_locked()
Date: Tue, 21 Jul 2026 17:14:33 +0200
Message-ID: <20260721152532.405608165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 471895799c2f46688792e175ced936ffeb6cdf01 ]

IBI disable failures are not indicative of a software bug, so using
WARN_ON() is not appropriate.  Replace these warnings with dev_err().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 3f79dac3ea1c ("i3c: master: Defer new-device registration out of DAA caller context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 49b947f9512478..5d8afd147efa89 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -3157,8 +3157,11 @@ void i3c_dev_free_ibi_locked(struct i3c_dev_desc *dev)
 	if (!dev->ibi)
 		return;
 
-	if (WARN_ON(dev->ibi->enabled))
-		WARN_ON(i3c_dev_disable_ibi_locked(dev));
+	if (dev->ibi->enabled) {
+		dev_err(&master->dev, "Freeing IBI that is still enabled\n");
+		if (i3c_dev_disable_ibi_locked(dev))
+			dev_err(&master->dev, "Failed to disable IBI before freeing\n");
+	}
 
 	master->ops->free_ibi(dev);
 
-- 
2.53.0




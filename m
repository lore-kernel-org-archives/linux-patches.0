Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170762F12D1;
	Fri, 17 Oct 2025 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715199; cv=none; b=rUF5hA2cRMKXqVLjx0T995OHy8uP7TMDVfsFF9hLHcK6PB0p1BVs9MGWS8RNFfMtdha7OU0kPl1z//PDoEs8pOweh91ewlzmV2AAIIPuIkkB54ynnL94jfsl6veNBtCyAL5mBVr8bTsDzkbOUQ+6RU6sa3rPetWj1MYC9vIqeRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715199; c=relaxed/simple;
	bh=rWCzDd5zMfWDFRyYJysUBAAE+9GrQ6jG9weKdBTt328=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsrmklDxl1Y/4mPoFe5gPMzL/AD9ERWAfXV6lGtLxfL1yMi4VvO6aPYUya2MS1oWItdNnwv/nOB/wU9dbBBrZFbOVoswJE+lMsE8hUUnKZD5hh8FmI0j3hmWftSmmfqH19IbryharOctl15cvbmUCM5yBpAWbKol6OG8OGGKLwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIYUpfkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIYUpfkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5ABC113D0;
	Fri, 17 Oct 2025 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715199;
	bh=rWCzDd5zMfWDFRyYJysUBAAE+9GrQ6jG9weKdBTt328=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIYUpfkB6nXz1YOfK9f09VgW8qNgYlnb+fWoKHnETPPqcwTmphyc3rgWVVqQGKWi2
	 JYQ4EkFXdsY2NEZfA7fWG0WVCn6wm+FDLISIn2r2M8XedmiP8waQnahD97WhFbTBdS
	 Ay+nbtG/dqUA4OsZ2nIQKsiG8Usv3IGgpkxjkCM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/371] rtc: isl12022: Fix initial enable_irq/disable_irq balance
Date: Fri, 17 Oct 2025 16:51:40 +0200
Message-ID: <20251017145206.456284938@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 9ffe06b6ccd7a8eaa31d31625db009ea26a22a3c ]

Interrupts are automatically enabled when requested, so we need to
initialize irq_enabled accordingly to avoid causing an unbalanced enable
warning.

Fixes: c62d658e5253 ("rtc: isl12022: Add alarm support")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Link: https://lore.kernel.org/r/20250516-rtc-uie-irq-fixes-v2-2-3de8e530a39e@geanix.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-isl12022.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 9b44839a7402c..5fc52dc642130 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -413,6 +413,7 @@ static int isl12022_setup_irq(struct device *dev, int irq)
 	if (ret)
 		return ret;
 
+	isl12022->irq_enabled = true;
 	ret = devm_request_threaded_irq(dev, irq, NULL,
 					isl12022_rtc_interrupt,
 					IRQF_SHARED | IRQF_ONESHOT,
-- 
2.51.0




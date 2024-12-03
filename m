Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B511F429B;
	Tue,  3 Dec 2024 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238064; cv=none; b=u4X6IriMt5x3q5oJr95UAkzT8coVt0P9KLTSdkqh7q1NJdBILstWqR2PLyQuW+NHbcdtzZIWG6izg2ZQGFy8Pw3gA7kAVb9CORztj14eiLL+1hhUFh1rYkdV67WavOcLnkYMz0pYQeEpNX4Rq6avNRxy1QEfZfxz/XW4iESuR+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238064; c=relaxed/simple;
	bh=df9F+FekPvKw5Yykxyqs04a9/ypqm4pmq7zol0YimKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1SPC7UA2i3GC0WVSXKtsXUXSbShujtxt8a7eKEBzwf1YlYSwlNREbfWmoSxxpRCqxO78Vxco5LyymINhB9DgHYKtjo/F4cRjLt6NEbGAzFlH2WEayhHQ5FCNvxCtFWvS5DmXwu8QGE7IOJ8KKniTphpdPDV6MYcKFtywetIgGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7jfhkhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7jfhkhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB29DC4CECF;
	Tue,  3 Dec 2024 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238064;
	bh=df9F+FekPvKw5Yykxyqs04a9/ypqm4pmq7zol0YimKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7jfhkhrTxdr8M+Ap2JT0++IqHR3NdepiinbWxLAx2ZIl6GkOUqjchaGXTMJXEBuG
	 K6Qw7DFd+6LZm8/Qd8kTt7I12rK4HQAq1y4jTB9H+tdpzhSp+TTNPYPL3i+ylCxBfg
	 vcFVuMmpnW/PaUlhJDQz7oiG7fh/IcW+TczTWqFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 150/817] soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:35:22 +0100
Message-ID: <20241203144001.582184450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 16a0a69244240cfa32c525c021c40f85e090557a ]

If request_irq() fails in sr_late_init(), there is no need to enable
the irq, and if it succeeds, disable_irq() after request_irq() still has
a time gap in which interrupts can come.

request_irq() with IRQF_NO_AUTOEN flag will disable IRQ auto-enable when
request IRQ.

Fixes: 1279ba5916f6 ("OMAP3+: SR: disable interrupt by default")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240912034147.3014213-1-ruanjinjie@huawei.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/smartreflex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/smartreflex.c b/drivers/soc/ti/smartreflex.c
index d6219060b616d..38add2ab56137 100644
--- a/drivers/soc/ti/smartreflex.c
+++ b/drivers/soc/ti/smartreflex.c
@@ -202,10 +202,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
 		ret = devm_request_irq(&sr_info->pdev->dev, sr_info->irq,
-				       sr_interrupt, 0, sr_info->name, sr_info);
+				       sr_interrupt, IRQF_NO_AUTOEN,
+				       sr_info->name, sr_info);
 		if (ret)
 			goto error;
-		disable_irq(sr_info->irq);
 	}
 
 	return ret;
-- 
2.43.0




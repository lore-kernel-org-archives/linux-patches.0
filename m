Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7473123FA0D;
	Thu, 12 Dec 2024 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019135; cv=none; b=CN79jhX6oxAFER/eCg1nXDIzIjlxPYdZ5RDGGtSDnSsSb5J/qxRA+2WL20jOIil/wsSA++PkFqb8x46CSAFmYS9LCCy/WL+8vAqlfpzX6rCHwj//p0PffXBsBJKQBvMo4kV622V0GoFL5pvMRHdtkxP75VTWd9yFt9rDHXU3to4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019135; c=relaxed/simple;
	bh=qPk4QHDvTrnSIUYELzb7gOhQ24pcxcbsD9cuBwojw/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2TuoLZ9OzgEN+a+HvWxrUzzVWGH1qu+/q3/DYVWxnMptuswf+AFC0az/szNDOn+PD18tcfCQ64I6JJHi9wLn0YBnJ77Pnh/DQ+cbHy9jnZhJGmWgVHRqPNQtRQTaDlq/aK9U+QNiy/ROfHpoGBCjIo5H4/cEnqIp7/m4Hvr8Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJKmqciC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJKmqciC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4D8C4CECE;
	Thu, 12 Dec 2024 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019135;
	bh=qPk4QHDvTrnSIUYELzb7gOhQ24pcxcbsD9cuBwojw/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJKmqciCHwvGqcqEQ0EgrWoqy8Hb1Bgn3P/O81Feo3aL3gcCUIgEtRPB6Qi7BonCe
	 MPwJxRzC3kVAM/ooPBA71ZTxEWgxplTA1u3kJa+B9YOH/jxllobQl+dSx0Zi39bRnA
	 EIWWzTBlg2irjupubXt5kS2oT7ExoEuRzkBB9mf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/772] soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:50:42 +0100
Message-ID: <20241212144353.948326739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a389a6444f36..e2e06b8488227 100644
--- a/drivers/soc/ti/smartreflex.c
+++ b/drivers/soc/ti/smartreflex.c
@@ -203,10 +203,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
 		ret = devm_request_irq(&sr_info->pdev->dev, sr_info->irq,
-				       sr_interrupt, 0, sr_info->name, sr_info);
+				       sr_interrupt, IRQF_NO_AUTOEN,
+				       sr_info->name, sr_info);
 		if (ret)
 			goto error;
-		disable_irq(sr_info->irq);
 	}
 
 	if (pdata && pdata->enable_on_init)
-- 
2.43.0




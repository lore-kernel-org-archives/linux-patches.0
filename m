Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31AB436355;
	Sat, 12 Sep 2026 08:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202720; cv=none; b=oo+5NbfLi+74XUCM5DRjKmwNqBI/Q/QsVPLQG8LsMeaJKqRerxnwmUmBsWczUd02wRtkWyq2vgZmNIZ5+SWthnAUrQjhz1D5fcb0dOFWaaDOTXMgjw72KrM1I3Dw/yO9v5xR4jMMQ0rEqmXN9cZNSiTcC0iFY9ErZQJ7BvIglnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202720; c=relaxed/simple;
	bh=P9Y+a9lFBc76E0tsTTDfA4cYIIj+ZgtOmHt+kmf0a7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNKo/9i/GOeyQbJk+1Wa7Ac2Vb45HdWC+RBoIUcpTVbFwxrSuf6tPNfv+6po/zYd5UkW4mcfQaD9xgo+Y19dYIuHigZRdOsVAirRmRTl50ibo7xGCBQdSGojbugIXOCEfgpc+ZCcWmp0NUp1HnAL+b/YiMmAPDniRw41PgyjSNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DocXmDSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DocXmDSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2EC1F000FF;
	Sat, 12 Sep 2026 08:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202719;
	bh=Z9owH99ke/ELqJ2ceFp5s6rF+s3KcWWnmFF1rIVeiyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DocXmDSbNzO6BDt86fmbznnMVpRTDzbxeT+jH06k5H0Ku/qHWIUZPVo6bt3WlRkUI
	 qDU3i80qs91ths0Bfn6ObMfy0JsVmiNPNpfqTb8/9S2/tp4UxHPO+JLfjU+KPLJRak
	 QvQtNdHCVXwQM64TPR+a4D81xdHKIpKFAtgsHBJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1261/1815] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 08:50:11 +0200
Message-ID: <20260912065718.619302086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 5d89e7cbac40057f5241a0832a86ce0fe97e4818 ]

gp2ap002_runtime_suspend() disables the irq before writing OPMOD. If
the write fails, the callback returns an error with the irq still
disabled while the PM core marks the device active again.

re-enable the irq before returning the error so the irq state matches
the active state the PM core restores.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index 708a770065296..de29081fd3b20 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -649,6 +649,7 @@ static int gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0




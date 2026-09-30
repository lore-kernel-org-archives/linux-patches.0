Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5633C3450;
	Wed, 30 Sep 2026 19:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794990; cv=none; b=G5x5aLqRgQR+zquktgHAyYZkV+Kd4wQEMFx0B5b2WtcFkwXHgQav8IuZCG20VVOJp9g8JhOs22ySRvnPY/A//hrjapYyGoK+H5tKd4YlXZzEK9ZDag+CpV+1zaDOuf6qDoUNAuur60AILQ6Ponj5H8EJ4xdLuxP9j5Vlx/7AWBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794990; c=relaxed/simple;
	bh=+y29lrQcMqUGs43hKtSgFifc87SyNcmtoBbaDctseU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bokOFeU1W2as2tlpGqiX8PgfHkYP7v4NMb1XBXRUG/CL8fEe6ylNzo5PpfoyNsUp4bJiICrzKS8dtre/XflMJJ1F+Wfu2DSL9EqqsBqXafII0p43vARfuRB9bmGIBBaIJ6gWX6349xz2bp0Aow3QTCdzr2fM4GFCB7/6+NQtV4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpWauoUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpWauoUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883F81F000FF;
	Wed, 30 Sep 2026 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794989;
	bh=tLDBKF1lPtINxmX8U8YTxX/an3VHvfvLzDaW0a7jDGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpWauoUJjps1E97v9CFi/qnPz/BCVlRKm0mXZ6vjrq7EEvtatFCMxlYzSn1PXsGtd
	 MXjwoIxjRw006okpCLitnYAIvcqq5KBMKijh37cLxN0C/lpFhRqJ7jSqJPARR2G4na
	 kodMteMDH/nP9yKeTG5q0EmJ+ZhjIr2/VK3GmCMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0403/1193] watchdog: msc313e: Fix NULL pointer dereference in PM callbacks
Date: Wed, 30 Sep 2026 17:18:07 +0200
Message-ID: <20260930152443.147702838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit e3eceb76515910746e6268c4e4ac1c07516ebd7b ]

msc313e_wdt_probe() doesn't set the driver data for the platform device.
As a result, dev_get_drvdata() in msc313e_wdt_suspend() and
msc313e_wdt_resume() will return NULL, leading to a NULL pointer
dereference afterward.

Set the platform device driver data in msc313e_wdt_probe().

Fixes: e9800b799464 ("watchdog: Add Mstar MSC313e WDT driver")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260827044700.554333-2-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index 90171431fc594..3b62650375628 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -125,6 +125,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 
 	watchdog_set_drvdata(&priv->wdev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	watchdog_init_timeout(&priv->wdev, timeout, dev);
 	watchdog_stop_on_reboot(&priv->wdev);
-- 
2.53.0




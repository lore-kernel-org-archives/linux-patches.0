Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603892EF652;
	Thu, 28 May 2026 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001044; cv=none; b=E3J8i9dYEbMV+vtJ5LnEDwx3ltVynueEhgabyjlBDkVxrgggzaHetpGwbCa3qE1sp0e9j+nNINDOBVXFAnCJJlLNxG+3PzXkCa4gRZu69Pr0loPvpEjeZizdlOhVSttaRqtnKXpw13tlefUnHk0BIGVhGWMgzlpt1E7gpYFtk2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001044; c=relaxed/simple;
	bh=5uXEWKu9sFNeRr9vwncTb8NsPyTcsq28jBp8RxtGIO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+2kmNpdGNpLdmDru0ZBtdsIQTxT5wlET+Qj8DCgLd3Ndnp16Lwhwckg6R/CvJkNAxBpyPrdFFt+noI71HsOhURL+wvTv7eNJC2SjAh59bj0JnGlje9HH0eQiCXlRqJ3kBH0r6MRSGnOKjz+zjY9Lnn6ytg+AWcw0nkpd+u0NmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEYToiCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEYToiCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757D41F000E9;
	Thu, 28 May 2026 20:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001043;
	bh=MlSvcxrrBjBAcK/Fs1uSWjklokbOw0X5QXEBt26u1Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEYToiCsYmhbk4LvxvXBDKRWrHiV/RgNh0GQDfE2Dv05CD0y/BQSCTpQ7KragzFOF
	 ur2ihtXXWnqDoH3mvdjCD6GJvWwPy3AF/F1y83mFYR/vkoGB+x22mtGcAZfSDZOFwG
	 uDqEV6VEO3p8LpzwaRRoO2NEEkQ3B5W7KP2gxyCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/272] net: ag71xx: check error for platform_get_irq
Date: Thu, 28 May 2026 21:50:35 +0200
Message-ID: <20260528194636.401364254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit e7c70bf97e90d974cd575e4c90f8f9b07d056da3 ]

Complete error handling for a failed platform_get_irq() call

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260516212616.11758-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index bccc7e7b2a848..f5570061abe7f 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1861,6 +1861,9 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag71xx_int_disable(ag, AG71XX_INT_POLL);
 
 	ndev->irq = platform_get_irq(pdev, 0);
+	if (ndev->irq < 0)
+		return ndev->irq;
+
 	err = devm_request_irq(&pdev->dev, ndev->irq, ag71xx_interrupt,
 			       0x0, dev_name(&pdev->dev), ndev);
 	if (err) {
-- 
2.53.0




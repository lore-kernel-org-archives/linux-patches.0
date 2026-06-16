Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0E47CC64;
	Tue, 16 Jun 2026 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632760; cv=none; b=lG6Rs3c5lLm0pYkhOiaQtctwVGtyrl+ayPOP/itp/Wq/psYZvmb1iFChizH49t9HfWsQSv71P2VeVNTRSVHHtn5XrOMPiLK31oXKw9yLUSQ2j+bURIGNqMBz2xsjtJBdlYShHgVAgt5mZHqqyG4uW/QmvjLhF6+UkZ+XKjk9okA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632760; c=relaxed/simple;
	bh=LzZ83qNU3vuZC0/RFzYK0BrDHLP15cLn68JzPkYaMDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfsBYeF1o1/+OFw0/ZrckxTJhvlWBU/0C2EUCvQWPNsbsd0KvsrcIGTzfdkPd8HRYEPdcOp0epkyW4v/YFAG3/ks7GcQLH7UwovV718TvsIskSj/oOlG2ZMhEEpVrwmGsVo9yKr5ag7d/GIEh4NmndanONuYLqRuFaINmqjjpnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iL3Dv+JQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iL3Dv+JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5651F00A3E;
	Tue, 16 Jun 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632758;
	bh=o2k+jwtCGmLpaOX13HCoOyNTgzl3gi5/13knXGK2Kp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iL3Dv+JQkA87XI5NUZsRNe86ejD7PE79dL+wwzUNKGqrBgJlFPfgjDH5og5XsOUPX
	 rCMUrkOTcTO5GZRAoDniNow2UBGDPdQ5taNVxOioYn+pLpqZFc7+Bg87PMsp0t+d1t
	 4mnSZoAb01Wy4F0RA9g+Tv0AV3DN92wqkZzoo06I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/522] usb: musb: omap2430: Fix use-after-free in omap2430_probe()
Date: Tue, 16 Jun 2026 20:30:17 +0530
Message-ID: <20260616145147.844270971@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e194ce048f5a6c549b3a23a8c568c6470f40f772 ]

In omap2430_probe(), of_node_put(np) is called prematurely before the
last access to np, leading to a use-after-free if the node's reference
count drops to zero. Move the of_node_put() calls after the last use of
np in both the success and error paths.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260409101104.480623-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -340,7 +340,6 @@ static int omap2430_probe(struct platfor
 	} else {
 		device_set_of_node_from_dev(&musb->dev, &pdev->dev);
 	}
-	of_node_put(np);
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
@@ -458,6 +457,7 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err3;
 	}
+	of_node_put(np);
 
 	return 0;
 
@@ -467,6 +467,7 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err2:
+	of_node_put(np);
 	platform_device_put(musb);
 
 err0:



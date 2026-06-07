Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56CB2D3A69;
	Sun,  7 Jun 2026 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828632; cv=none; b=ejoAky+r2VA5I4ID4JgQ4vTawTPw/KAOOVRGF+2CuP14fU6FGhFqLOi8bVWAyQ5f0Ca8uN1dTh5ABJjDYA5/oU+qJOFGthQsnpJSV/JhVcxGQIlkrmLy/rIEmwJCNndpNQSBAWsohMamL3mvDiBanEah6vd0MrDRxOQW+UmS2ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828632; c=relaxed/simple;
	bh=yjjzU48u6eWteE80pHUQcOf4fawusy63Lb7pJtkUMVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwpnI0OcBjjL9xFWMre6NDAU66mllySEeoEi8gtUhzGXpVAtel8fjwVzruIOmgOUi/Gigpq0qv3QuewXcFCFE6Bc238dTBKjXBaasXm4W8qSQ9ngY7FVPi1cWAVHfU1f0D2IlKc2i5idhRObZ5yy+FVOOJ1noqHpl95TvntO4bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9RIdKan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9RIdKan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80C11F00893;
	Sun,  7 Jun 2026 10:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828631;
	bh=WOQ8jZoeJgQkWreFpwONeETgiCsjW9v8jC69ws39glc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9RIdKanG5G0cFa8FwARFtQXBEXSHf+LURLcg8mDFd/eO6FOuGHfo4StNC+8v3Jjo
	 ZKQnwAhZ43NbRzO8xYdRdQ6vQaJ0ZgfPh2U5I6lvPmhjcoNSnskvRB5BEd9a3ATk1P
	 5yWaJr/W/gX/IgSH5JLtMBI81g5Y+nFb3H+gE9FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.18 178/315] usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acquisition failure
Date: Sun,  7 Jun 2026 11:59:25 +0200
Message-ID: <20260607095734.120120263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Peter Chen <peter.chen@cixtech.com>

commit e6970cda63fd4b4546aeed9d0e2f53a7c95cd09c upstream.

Move usb2_phy initialization after usb3_phy acquisition.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-2-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -126,15 +126,15 @@ static int cdns3_plat_probe(struct platf
 		return dev_err_probe(dev, PTR_ERR(cdns->usb2_phy),
 				     "Failed to get cdn3,usb2-phy\n");
 
-	ret = phy_init(cdns->usb2_phy);
-	if (ret)
-		return ret;
-
 	cdns->usb3_phy = devm_phy_optional_get(dev, "cdns3,usb3-phy");
 	if (IS_ERR(cdns->usb3_phy))
 		return dev_err_probe(dev, PTR_ERR(cdns->usb3_phy),
 				     "Failed to get cdn3,usb3-phy\n");
 
+	ret = phy_init(cdns->usb2_phy);
+	if (ret)
+		return ret;
+
 	ret = phy_init(cdns->usb3_phy);
 	if (ret)
 		goto err_phy3_init;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0D22F12AE;
	Tue, 16 Jun 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632716; cv=none; b=XEK/dPLfo0wVDSoA7tKZnoLiFXY2460R+VIXiNQBP6zz7PH6aj0M9KR8k+q+zyzc/gfPA30iQIA2npdY3eE8y/AfgibssdJbsp7OKUEqcjXX0YG1S/IGeed4oYctODgPl/FJdIZ5450lU/SOwH7XxIxNqJVEWCTCLR9NqcES3E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632716; c=relaxed/simple;
	bh=l5eqIw9OSx1np9A698uxW7Tx51/4aNlhkSYUcWbQXFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc1cmH2ryV75wEMhehYXFDYj6NLt5OSfN6fXwM+6b8grGEmPdKn2kzgCvn1JgRFGJa11rlS2AKs6kUW0eFUXlFdvuqx3qkes4vZMUAP+hXoODaljuX3fx5PypXaGcwiARTdD7jWvYTXSw/e7/xYzkNpEL9WxFQ4SQFs5D0uQpfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V25ZrGIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V25ZrGIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFD81F000E9;
	Tue, 16 Jun 2026 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632715;
	bh=P9QLPJpByFvMJN5hn4gqd4FTdwFh7iNmj+KlmsDBYYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V25ZrGIaY/8KT6TahlS9Z7VPug8CBspoMa2/3NoLAjLq5opNmR9c5S8Cqh3FSnlYX
	 e79RBQ5c8LYalNj921TJVNn7c7sYAC1pqr6djIC/gzauc4kLL9uNFEmk3seO9YhIFm
	 Qvu/S9QZo1s55G2ND64bwwpNLKn42gjFq5Eq6XJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 463/522] usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acquisition failure
Date: Tue, 16 Jun 2026 20:30:10 +0530
Message-ID: <20260616145147.543497759@linuxfoundation.org>
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

From: Peter Chen <peter.chen@cixtech.com>

[ Upstream commit e6970cda63fd4b4546aeed9d0e2f53a7c95cd09c ]

Move usb2_phy initialization after usb3_phy acquisition.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-2-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -120,14 +120,14 @@ static int cdns3_plat_probe(struct platf
 	if (IS_ERR(cdns->usb2_phy))
 		return PTR_ERR(cdns->usb2_phy);
 
-	ret = phy_init(cdns->usb2_phy);
-	if (ret)
-		return ret;
-
 	cdns->usb3_phy = devm_phy_optional_get(dev, "cdns3,usb3-phy");
 	if (IS_ERR(cdns->usb3_phy))
 		return PTR_ERR(cdns->usb3_phy);
 
+	ret = phy_init(cdns->usb2_phy);
+	if (ret)
+		return ret;
+
 	ret = phy_init(cdns->usb3_phy);
 	if (ret)
 		goto err_phy3_init;



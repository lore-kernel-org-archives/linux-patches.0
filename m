Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5502D291C10;
	Sun,  7 Jun 2026 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828919; cv=none; b=r9tbCXjXtjlhz3PD79mW/J/mivWk3naiyRx/GHtoUv0MfkTRI0GLOjXuKlHP2L0K1Ntus2GWR2O9U8UYu4+C0FpEYDJqpZo8G18ueE9yYQXSOGZO3H6adA/4HVJzsa7FzBK3ILLhSW1MOXK7e4g204FU0q8peuyJwWYN4ly62zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828919; c=relaxed/simple;
	bh=gmZh01dtuI/6Sq7cG1cErXSCOyNT2n8smINk8nNmfz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+Zc2RKq2P11VPozMolsiBoHaN0MsCXGtj1J4CXWXLDr675CbITZUF4pxMMr/xkhdC/IyLCbjjPRsBAHbqYRFiOImeL3T/50CJ5Z7fEy3GXeOVVhoJ1mF4LuoFLwnTjDdGCnYhJQHE4gqpyX7lJKXhiGB8GoU924Pz4FezkkkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/j3lNW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/j3lNW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E921F00893;
	Sun,  7 Jun 2026 10:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828918;
	bh=fsOUGX/91KiE2DBrzoR4HQ+i1iQV1s5aBwqHlVOi1yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/j3lNW2NS8j+CTskQrwUisSKsj0aiHyg82l4bbgN1pvvf5Q78djb6e9r4TsWa5Db
	 5DU4uHTHEcAx2b34NgX042G6SNvYY0OvVDBpQCyfZ4hZ1UfNWXa/1wLvn4tKDfXW3M
	 Yyn6QL7hyATUQchjDkY0DnaG7/cIunY0v38yU0B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.12 179/307] usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acquisition failure
Date: Sun,  7 Jun 2026 11:59:36 +0200
Message-ID: <20260607095734.288174513@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B392F47A5D;
	Mon,  1 Apr 2024 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991327; cv=none; b=exinqvKa6FyyZuQMfjPb+AJmYc66DEw5WJsfKtTIvWipmOt6j3o12aTuOW8FBXC1rJMeWJUmndIJPm10Ph5GCt+D2Uh860QwAX+OdFdt97UkyB25VT3QpTYa1aq4jsgwxGv/f5cCzWjjUe78ehpDIMJ0VWoge6dN4gvkl80g1+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991327; c=relaxed/simple;
	bh=eUlDwWK9LnyyrLFcDVmbmbg7UaNnfmn3hf7YufRa5jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtLZo4zkWUYOndDHX5mlMBAK4DxFb8JXGNYF0/sFwLU+i5VzQJkPTdzVsUg0VCXsJty2hTha9/9PQfA2hTm24fYNxmOTQ4QweDJKhOczYE6uKhkOwDUMEfMlQzVpQIe94omngFWBIbZDQDkz2Nai37KAgA+UCy5u9L+N/L2Gi5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOIIqA+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOIIqA+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EA5C433F1;
	Mon,  1 Apr 2024 17:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991327;
	bh=eUlDwWK9LnyyrLFcDVmbmbg7UaNnfmn3hf7YufRa5jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOIIqA+ScyXQC/7SwrftDjAymaMu7zbSRbuXjgTAYMRaCYROetZScTuyFqpfiDdU/
	 AU6vwP6vjGYA6AnuinxeI6sL8Ymz9JdDCWmpNiFt290j07xa7ayGLuEKvFoREcTAOW
	 4n3fQGsfG+yowRFwit4Xv10M4WMV3rxvJZfog3mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	stable <stable@kernel.org>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 6.1 231/272] Revert "usb: phy: generic: Get the vbus supply"
Date: Mon,  1 Apr 2024 17:47:01 +0200
Message-ID: <20240401152538.192346384@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit fdada0db0b2ae2addef4ccafe50937874dbeeebe upstream.

This reverts commit 75fd6485cccef269ac9eb3b71cf56753341195ef.
This patch was applied twice by accident, causing probe failures.
Revert the accident.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 75fd6485ccce ("usb: phy: generic: Get the vbus supply")
Cc: stable <stable@kernel.org>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240314092628.1869414-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-generic.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -272,13 +272,6 @@ int usb_phy_gen_create_phy(struct device
 		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
 				     "could not get vbus regulator\n");
 
-	nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");
-	if (PTR_ERR(nop->vbus_draw) == -ENODEV)
-		nop->vbus_draw = NULL;
-	if (IS_ERR(nop->vbus_draw))
-		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
-				     "could not get vbus regulator\n");
-
 	nop->dev		= dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";



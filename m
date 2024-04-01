Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC6F1C0DE7;
	Mon,  1 Apr 2024 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989224; cv=none; b=Sff7f2Bd1Opszjk+oGwvzb15oS0LanC6agCJr1cwp1vx1fRj/yFnEQuCG2mji0Z1z/h6Jr9EUoPmtBKwfd5kuhGR71k7+53+PQQO7nxcBk2IoMS35+DNU6ez44mHtx4yHpgjaNAtr6h1z+IK3C+tXDgbC6UcSCPljVXZmLkMsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989224; c=relaxed/simple;
	bh=tGuvb5kTU50aHl6DEuFtHvl+J6AFpvu+sXb2hTvoDRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ie74aJOgnXJrNp/G5vxwPpaSgFJn/2ZCUBmTK0OzAPutQS6wcWXarF/8rghMkKkd72jZiHYBVOP3ywkQ+QPY6aT/MOGMidp3Z3UGNRBD2q9hdZvmXzwF3y7NgnOYcC1P4svdxs3o820lBb34/ilgjw4vZM//zqii2M5ZU9vkgww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BNJipi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BNJipi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F6DC433F1;
	Mon,  1 Apr 2024 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989224;
	bh=tGuvb5kTU50aHl6DEuFtHvl+J6AFpvu+sXb2hTvoDRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BNJipi3eIZqN3sJkhqy7fyz+ooKq0/FD9jxrf44Gqu4j7mWVXyHhncTyum/7KjYC
	 tsQJ1+dezLO6AJZk0Hsd5Rzall2DistPpAbC0AnkV9XQjW2ggxl+R9+nD36uo8rCtl
	 xRHLCchBdqP4NfYygCb/E6zyctwhvig0KhowlB2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	stable <stable@kernel.org>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 6.7 380/432] Revert "usb: phy: generic: Get the vbus supply"
Date: Mon,  1 Apr 2024 17:46:07 +0200
Message-ID: <20240401152604.628624402@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -268,13 +268,6 @@ int usb_phy_gen_create_phy(struct device
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



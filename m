Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE3518DB24;
	Mon, 10 Mar 2025 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628454; cv=none; b=mLCzeoJrgU16KKMSASWmC+r0s3oEBRT/FBcpzUBziZpXtQY4jT62/I3ROWfMEZdjt2DBOUav05/g2WP/Q6gkmTRovRH5l2bJjtlK9A5Mf1pkedItiRAAkDYJJ0RNIgq6mVo3jDjmP89VGweg2WyymRdXgh0q5k0zy8gz//jJEbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628454; c=relaxed/simple;
	bh=dPJv2/WYpfO87/vdzMxNu31UplwY7aKpXyBhGtg062s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miVsoO0DSJbXGWmJxRcFRuwJ9wqa6/AtjeHSb5gCCda6fr/OSag7FRHBvnGH9/4KMPQBgl0KN4HGRVTfniifL+AgxxDXSG9BJxDypsB++K9CxwUiT6aO04Lrwhn/q9xLGid+V2MqTdMzTWV/z6CVlnkz0OdvZ8PTT3bbwFhCJ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3NIXlUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3NIXlUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66562C4CEEC;
	Mon, 10 Mar 2025 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628453;
	bh=dPJv2/WYpfO87/vdzMxNu31UplwY7aKpXyBhGtg062s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3NIXlUHsJL1oeawZXtv7OhyyK5nx6gMSwtviIf2bJp2jX1TYwwBQBLvC4MZE9ln4
	 eUhPoVukgxaEWhtRIr/QmYJo+A5xPUrei1nJrr/XD6NCMQmjNnM4gdJ8KnmSreutmA
	 HH1PKwWHgzxn69cxfBoOPM5I1PIYg3yC/MEhzaD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.1 064/109] usb: renesas_usbhs: Call clk_put()
Date: Mon, 10 Mar 2025 18:06:48 +0100
Message-ID: <20250310170430.112034223@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit b5ea08aa883da05106fcc683d12489a4292d1122 upstream.

Clocks acquired with of_clk_get() need to be freed with clk_put(). Call
clk_put() on priv->clks[0] on error path.

Fixes: 3df0e240caba ("usb: renesas_usbhs: Add multiple clocks management")
Cc: stable <stable@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250225110248.870417-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -312,8 +312,10 @@ static int usbhsc_clk_get(struct device
 	priv->clks[1] = of_clk_get(dev_of_node(dev), 1);
 	if (PTR_ERR(priv->clks[1]) == -ENOENT)
 		priv->clks[1] = NULL;
-	else if (IS_ERR(priv->clks[1]))
+	else if (IS_ERR(priv->clks[1])) {
+		clk_put(priv->clks[0]);
 		return PTR_ERR(priv->clks[1]);
+	}
 
 	return 0;
 }



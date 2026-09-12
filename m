Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9863331A6E;
	Sat, 12 Sep 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226674; cv=none; b=nVicUBunbbfc+DgpPhFepibgb3QUmG6huOL0BAMWv9uc1yqj6/2XhAFJLq6+LWPlWvyfhAK/T4Tx1n1r1QliNk7k6DfTBFfrAM6n6GIph4DoQukZ7tSDOHoU1VPTE58t8gwKqBY/iLn9dh2m0ph/9PY/xp5z8x1T5+pgZsP6kqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226674; c=relaxed/simple;
	bh=sPQK9lJQnfeI7qnteOmU2wb9Apa4fXMFS9UygJmlEWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU0jIdDFS105H93o0W059/0CHCtS21N+nH3lDs+W6de+nzHE69c7HobVzklN/uN6xQ4qQXzxBhpPUbb0AEbXLxvNDVBp03FkhMvdOewVpqzMTFobP3qu8R4NUSFgfRciB/h1BCtKpBK5if6iE0PmNJPgrQnmqZZoQco2+1GI3U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeyn4808; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeyn4808"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7861F000FF;
	Sat, 12 Sep 2026 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226673;
	bh=YEitOoxcfNPdMcXN7zynqzzE/n7FljEhXSQW5nL0tjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeyn4808Z49FoXpw2DeNSEg/8RyyRVyK179SHS8LfyFYhHL907YVxy9lfwvQk+tv8
	 RguDyCNVuCBhL6h6EZTiQdcuGlKcWlhFl6eRUSGZyPWYlPSvPCTGL/a82QauR7KR3R
	 ++41rR15NwnUJOMfLNYWfbXI4cypiG7gcYaeHNOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.1 0026/1191] usb: gadget: snps_udc_plat: clean up PHY on probe deferral
Date: Sat, 12 Sep 2026 08:45:54 +0200
Message-ID: <20260912065548.708916930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 886338ea7d40e4ba5123c58204d7f7e53d825825 upstream.

When the referenced extcon device has not registered yet,
extcon_get_edev_by_phandle() returns -EPROBE_DEFER after the driver has
initialized and powered on the PHY. The direct return bypasses the common
cleanup path and leaves both operations unbalanced.

Store the lookup error first and route deferred probing through exit_phy,
while retaining the existing behavior of suppressing the error message for
deferral.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1b9f35adb0ff ("usb: gadget: udc: Add Synopsys UDC Platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260804140510.37639-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/snps_udc_plat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -161,10 +161,9 @@ static int udc_plat_probe(struct platfor
 	if (of_get_property(dev->of_node, "extcon", NULL)) {
 		udc->edev = extcon_get_edev_by_phandle(dev, 0);
 		if (IS_ERR(udc->edev)) {
-			if (PTR_ERR(udc->edev) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
-			dev_err(dev, "Invalid or missing extcon\n");
 			ret = PTR_ERR(udc->edev);
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "Invalid or missing extcon\n");
 			goto exit_phy;
 		}
 



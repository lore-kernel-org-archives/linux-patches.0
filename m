Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD8E22576A;
	Mon, 10 Mar 2025 18:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631035; cv=none; b=Il4Ugn9RsqKlRfOL1HLCuFs21iUsSJOXgyYvWv9b0RP2z0VoSGpItacgGRIIq3jblwe6Ec5Xtvu3kPWLtcDl/xkx7Vi74ibyG7JknFGurpgb/HYnYGi4cfk4gW6EXayYH2GaoC2I+HOYPmJV2AoV0heu4m4bDjojN7ysjUD4WDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631035; c=relaxed/simple;
	bh=gRYv8h5x0PQVtcEXtrHWHE5TdwK1vDyaaIeM1DkUpdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE7D99bUQGz4IIz/1pvbqQ3JDbu5G618IKgaD4JS75VPWr3P2iEJslTEykdEpKlG4xOllCE+1pmAgEvX58JXNRgb7hAJ+Tl6dXsCypLjUetzPsMbbINjZyUq4UU+/qMFK6skzOu1ljfdt4iEhu1SUP+DCW37sSDJ13X856E9iTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfWTP2Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfWTP2Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BD8C4CEE5;
	Mon, 10 Mar 2025 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631035;
	bh=gRYv8h5x0PQVtcEXtrHWHE5TdwK1vDyaaIeM1DkUpdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfWTP2Zr27W+V/FxONDMN+NF4+IbMt/LY/pex1Zr0SiP0LhAKWi6xJ3eIJhXU4nax
	 4PO44Q3bECC5nt+tuVZFUeCg/Ny7b71KCRaxg4RCrwOz8PaldXt+GcOBIREfIllDfa
	 6hnGR/CyQH/kkSZ5mAz9R/W9NUC7slVr1RmBYO2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5.15 592/620] usb: gadget: Fix setting self-powered state on suspend
Date: Mon, 10 Mar 2025 18:07:18 +0100
Message-ID: <20250310170608.900724689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c783e1258f29c5caac9eea0aea6b172870f1baf8 upstream.

cdev->config might be NULL, so check it before dereferencing.

CC: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250220120314.3614330-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2476,7 +2476,8 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+	if (cdev->config &&
+	    cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
 		usb_gadget_set_selfpowered(gadget);
 
 	usb_gadget_vbus_draw(gadget, 2);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F711A6827;
	Mon,  4 May 2026 14:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904111; cv=none; b=dX6ekiEtIvD20PHm2SZIt4sD71LjKFmKfpmCgvX8foRWuC1ZPYIdV//AI4zOxqYNIwKO2nZH4iNxQlCmZg1ILvlvvtB3/fsO1PTmlnxGKCqUDR3lL5QliavkOmKydsbSJ2u9ifRRuwiS+8loWb+6TDYknlSvL8ZWrLgykLvPvOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904111; c=relaxed/simple;
	bh=HxhPJDyZ4Q1JKtlR2cZoQWIKbjpvFCmPh8f2/x32K1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQsdajqYruC89MjTCTAcYtz9R+GMLx1bABITgofGRxdp//nH1YR+s5MDW4/UBW4J0A0Fy8HWQVEC78u2MUsk9VxeQEtdz1T5bfuyzesjf3JprhEH7Hrf9ooNzD3iEbvooGym1msn1sqOILX0EwL76WDRyZ5DTFC2VjirFSZdLQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMD616TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMD616TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854A6C2BCF4;
	Mon,  4 May 2026 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904110;
	bh=HxhPJDyZ4Q1JKtlR2cZoQWIKbjpvFCmPh8f2/x32K1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMD616TJjiEqNYut7l/YMHGd79vjXtK3jPKf/A8uawzSAUAKuQjhtBVLIqMCcXtOV
	 OuvijXOfZO9s11PLGXegTFQRlcCadpURRtlUCIr7+J4dNxp5NlHUa6IGv3VtvXZigz
	 bVEv1Vs9+hKdxwSqGLy0PgZzfvwRlIw5np+dOpKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 160/275] rtc: ntxec: fix OF node reference imbalance
Date: Mon,  4 May 2026 15:51:40 +0200
Message-ID: <20260504135148.991486266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 30c4d2f26bb3538c328035cea2e6265c8320539e upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 435af89786c6 ("rtc: New driver for RTC in Netronix embedded controller")
Cc: stable@vger.kernel.org	# 5.13
Cc: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260407122717.2676774-1-johan@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ntxec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ntxec.c
+++ b/drivers/rtc/rtc-ntxec.c
@@ -110,7 +110,7 @@ static int ntxec_rtc_probe(struct platfo
 	struct rtc_device *dev;
 	struct ntxec_rtc *rtc;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)



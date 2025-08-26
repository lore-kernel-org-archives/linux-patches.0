Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92752345726;
	Tue, 26 Aug 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216572; cv=none; b=Aoiz57R8vI/ZhluVXHqN//7z+e04uIGa6G4c3Jl8KwkyFokajQ/dgREgOjpaM2SyJF2v5FewibkAyQi/bfQBuTrMIf5Aj8Fn2MNYyNvS2A/j2QQTTqlFLA37FnJhOv4vWEO9oMK5qrHl+wG6nf0goqggsb3cRNe//unJjy4rnXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216572; c=relaxed/simple;
	bh=y4yruIGLKLx8a8tlW5WWP/p4Ur9zbotlzGyrIgmJZGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyXlUoayVk609rqQ7tJbve11VxqKMSld7srq7KtRYmW6sKwMU4M/49rvXcP1iyFG9XjIlZJLz56fzy24MeblxM4lxFIs8yIj/6ySpmLju6TZooD/d5rtOBFL7Vcc9AOb0FtWJ8gMey7dX+JEvuZi4g5kPVLCctjwmFicqanONG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMTD7Z1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMTD7Z1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22471C113D0;
	Tue, 26 Aug 2025 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216572;
	bh=y4yruIGLKLx8a8tlW5WWP/p4Ur9zbotlzGyrIgmJZGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMTD7Z1vEsKWxyANuwxRjpauUQp2jUnPtfUGMODTm2VyeaT4oX5kQNc8OxYNdBkHC
	 KIcoOYpnmpUVEJu/emqXgTAVszrrGAsCi8DANkOexritQ3T4ErdubDzvzimF97AfAX
	 d6cYeo74zOJ0lrL7HcoVxqNg9GP1i23kEpy59AV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.15 461/644] usb: dwc3: meson-g12a: fix device leaks at unbind
Date: Tue, 26 Aug 2025 13:09:12 +0200
Message-ID: <20250826110957.900601308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 93b400f4951404d040197943a25d6fef9f8ccabb upstream.

Make sure to drop the references taken to the child devices by
of_find_device_by_node() during probe on driver unbind.

Fixes: c99993376f72 ("usb: dwc3: Add Amlogic G12A DWC3 glue")
Cc: stable@vger.kernel.org	# 5.2
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250724091910.21092-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -847,6 +847,9 @@ static int dwc3_meson_g12a_remove(struct
 	if (priv->drvdata->otg_switch_supported)
 		usb_role_switch_unregister(priv->role_switch);
 
+	put_device(priv->switch_desc.udc);
+	put_device(priv->switch_desc.usb2_port);
+
 	of_platform_depopulate(dev);
 
 	for (i = 0 ; i < PHY_COUNT ; ++i) {



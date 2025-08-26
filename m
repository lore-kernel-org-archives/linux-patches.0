Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE89B3568E6;
	Tue, 26 Aug 2025 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219272; cv=none; b=k/UuhsXuywNOLGVjtm0Srr3ZECJK+KUQGM760VOXXJujhffBo/CGj+1BPOC2H3Vu0erZ13N5PP3tHY4BWNc8M7A9RiaDKPx1nXw9yubYMzWZo5RRqqGjjCAd5/Oxk/lXIQaZgX68KETSEeevX8/JdNPGFDtuSv8TrezYQsDLH+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219272; c=relaxed/simple;
	bh=gaRCeB4hw11yYWC1Wgn3Rr2UN9m3Kl3EcvBtC9YRsz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCoG41FVZzzltNQxpJncoqND+ewYmVCFLxpqV1tm1tx3MVwxCECecGJG2AV92RFpnOv9eVFHUDpzbU0P7KwchagRaWoxRBl7ZjThbt3mtlbym88E1VNaVhvqO9qDilodpw9mDVTObfyTiugvyP+GCQ+x/0RLrGKnRxKopYrLw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRl5hNOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRl5hNOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E02AC4CEF1;
	Tue, 26 Aug 2025 14:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219271;
	bh=gaRCeB4hw11yYWC1Wgn3Rr2UN9m3Kl3EcvBtC9YRsz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRl5hNOFyQBlyCX2b7FfcaN04oHTqa7Hm2Pw5dgdR6rpUyPY60dqyKyK4KbCSyyca
	 6U1cudNcTns4GqrRntDD7mpwrxYJ1zPJSZyj9oZvusKRq9kpAfDyj+daRVhtIwg3T5
	 xsumWHELq1ggSGqGUt+LMeFHU0TOhRgOXaMyTVik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.4 287/403] usb: dwc3: meson-g12a: fix device leaks at unbind
Date: Tue, 26 Aug 2025 13:10:13 +0200
Message-ID: <20250826110914.739199680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -529,6 +529,9 @@ static int dwc3_meson_g12a_remove(struct
 
 	usb_role_switch_unregister(priv->role_switch);
 
+	put_device(priv->switch_desc.udc);
+	put_device(priv->switch_desc.usb2_port);
+
 	of_platform_depopulate(dev);
 
 	for (i = 0 ; i < PHY_COUNT ; ++i) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9980187554;
	Tue, 26 Aug 2025 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214795; cv=none; b=QPrQ+LUhffZM7FJVjvp5Y15F/txVXLsqIjkiDJ6BsayWIQCL8kNeXpPmq2/W6D5MRg3NNTN5tgAWFQ5SEL/8XEtwdtk9vgTJeUWZYcfdH9DH9jipLeqmf0myvx5LzxqlHnu7EpuhLplnvTS6Gim3McZtG/yh98t4iTzSe+L9+F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214795; c=relaxed/simple;
	bh=t0pWQJOUy578nc17cdp0/ZH/VTyhlynEX1+oxZfQbj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt9meybHFJhBC4GLnquovxTrJWFNdowjCK0jLm4NVu65VtNCYDziPu1d/X/zLwwo1w37B+HIbJTyKdg81vABLoWtR98h4OkoRB5uDxXVsN59Lydq8zDLLG/U2QlDhq2IaaKvV1cwweNP8/mPwlSzGOJE3nwFsyKSVo1RGvAd/iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+2R/gTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+2R/gTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24542C4CEF1;
	Tue, 26 Aug 2025 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214795;
	bh=t0pWQJOUy578nc17cdp0/ZH/VTyhlynEX1+oxZfQbj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+2R/gTUj5qU/jHcLqhSSni1ToxLfE2vSIwRMJs7xnyjWRKe35vv+C8wPD0qTH13D
	 r+pA9smq6QX2zgfIv2PCYc98t1Em8uv8Muh4A/aMAwLkrDWwsJCXuB6s37TQmZW4D4
	 V8RnVh42ST+Y5Lb9033YhH5qAmu7HRF6WYXhvAsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 6.1 272/482] usb: dwc3: meson-g12a: fix device leaks at unbind
Date: Tue, 26 Aug 2025 13:08:45 +0200
Message-ID: <20250826110937.490998024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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



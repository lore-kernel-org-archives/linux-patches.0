Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D9D2BEC34;
	Tue, 26 Aug 2025 11:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208179; cv=none; b=MnowbuvsVJ01T1z0cPJui6NAUxW1YMN4iIJ6BzwhezfPjGRds3LqX2Q2ZU8GiM0qygmY2Dg4YF91BXc+KA2L1OST1Mo9idM7P5y75MZJEPrhAaU2SXpoQv7BTGOFL3oEDG4ON6uGk+RB5X44d65retfJKv5RDJl9V8e5X1vm2hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208179; c=relaxed/simple;
	bh=KHR+mUHy2di2bVh/izGch6c7PWhgLDEevpTdzd/98yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAwa1CKYriKmDpk/hc7AVcDl1nxg1hz6ehWN676uA+JEYdbnYTCNkCfPlcjnNzoA5cdrWjVRf2+Xb0g+wVTSvm6e7TtoEhvlsov81o9lNhCCujsfYToQ0hS9NL+x+zkHjz59gJaESJ1s7mstcHP9jiUW0i9ECqmAPc1OKLfUrqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9/XmEj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9/XmEj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE56C4CEF1;
	Tue, 26 Aug 2025 11:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208178;
	bh=KHR+mUHy2di2bVh/izGch6c7PWhgLDEevpTdzd/98yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9/XmEj9sjLJrfEWw5nS0B1KxNs3GyfQCtXdUH8ZeC62fDmk2dZtgMpbAz+LXPMUv
	 SeKk/VZNBpO4dxyIm0tPXsymjdqZ1BpeHz5WXCsWRQzsdVtx8bbK/DZJPWsS2NcAcM
	 Yj1VLPz2DUYVEE6aifwNvrgwZZZMYJmxFd074/d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 6.12 012/322] usb: dwc3: meson-g12a: fix device leaks at unbind
Date: Tue, 26 Aug 2025 13:07:07 +0200
Message-ID: <20250826110915.537898126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -837,6 +837,9 @@ static void dwc3_meson_g12a_remove(struc
 
 	usb_role_switch_unregister(priv->role_switch);
 
+	put_device(priv->switch_desc.udc);
+	put_device(priv->switch_desc.usb2_port);
+
 	of_platform_depopulate(dev);
 
 	for (i = 0 ; i < PHY_COUNT ; ++i) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD6814A4C7;
	Tue, 25 Jun 2024 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309215; cv=none; b=sRRHt5nSOkUsRuNPCiFyceG/Hc/FE94vbnV4wtsS39hfSNLbgWGhk5vhMuiMNQs9eaWsZ+TY/QwHvZL0BWyYd+XtCIrM9SsouW2jDu/UTCeLtE1d4J7sAcaLHQ8lglbgeWpv5pMpYXPBqCaveTMiMKvpQgb5P9zUCOaWYRfbzrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309215; c=relaxed/simple;
	bh=0Y2JA/jJxGM//bXz0DyIk5YmOnoz//lV1jzjrwc4V5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ifyj3Gr7QsWhJw0hpszqGIxeCake/TBv3p09E9MHhYszT2MoUuf1ek7/Q33nra7zaxbRiboRl/COOTFsKRrWNTSehvs+jLGpsO2vFlwfcHnxI//aKNiub7OYOhArSd8PAEozJPsMsD7fDsU8Tf5+COqlRkJcbjAVjCEA9w0iEBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBUVBgbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBUVBgbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36322C32789;
	Tue, 25 Jun 2024 09:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309215;
	bh=0Y2JA/jJxGM//bXz0DyIk5YmOnoz//lV1jzjrwc4V5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBUVBgbuP/GjtQQFh0XLNfmqFetI9Vjj6OXCP3ULenk6tiXaU93K2dwSk9uv+BX5K
	 Z8VP/iiM2ZTUFGw2ah/RVZ7J5gEqBGV5xIc2Zily34HLV2mUisBqByYOKjNImNUH5M
	 eMBRhhHTdcy7/nrem47DNK0MYwlzlwAAj4XQ8yw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	=?UTF-8?q?Antje=20Miederh=C3=B6fer?= <a.miederhoefer@gmx.de>,
	Arne Fitzenreiter <arne_f@ipfire.org>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 134/192] net: usb: ax88179_178a: improve reset check
Date: Tue, 25 Jun 2024 11:33:26 +0200
Message-ID: <20240625085542.302152334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 7be4cb7189f747b4e5b6977d0e4387bde3204e62 upstream.

After ecf848eb934b ("net: usb: ax88179_178a: fix link status when link is
set to down/up") to not reset from usbnet_open after the reset from
usbnet_probe at initialization stage to speed up this, some issues have
been reported.

It seems to happen that if the initialization is slower, and some time
passes between the probe operation and the open operation, the second reset
from open is necessary too to have the device working. The reason is that
if there is no activity with the phy, this is "disconnected".

In order to improve this, the solution is to detect when the phy is
"disconnected", and we can use the phy status register for this. So we will
only reset the device from reset operation in this situation, that is, only
if necessary.

The same bahavior is happening when the device is stopped (link set to
down) and later is restarted (link set to up), so if the phy keeps working
we only need to enable the mac again, but if enough time passes between the
device stop and restart, reset is necessary, and we can detect the
situation checking the phy status register too.

cc: stable@vger.kernel.org # 6.6+
Fixes: ecf848eb934b ("net: usb: ax88179_178a: fix link status when link is set to down/up")
Reported-by: Yongqin Liu <yongqin.liu@linaro.org>
Reported-by: Antje Miederhöfer <a.miederhoefer@gmx.de>
Reported-by: Arne Fitzenreiter <arne_f@ipfire.org>
Tested-by: Yongqin Liu <yongqin.liu@linaro.org>
Tested-by: Antje Miederhöfer <a.miederhoefer@gmx.de>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -174,7 +174,6 @@ struct ax88179_data {
 	u32 wol_supported;
 	u32 wolopts;
 	u8 disconnecting;
-	u8 initialized;
 };
 
 struct ax88179_int_data {
@@ -1676,12 +1675,21 @@ static int ax88179_reset(struct usbnet *
 
 static int ax88179_net_reset(struct usbnet *dev)
 {
-	struct ax88179_data *ax179_data = dev->driver_priv;
+	u16 tmp16;
 
-	if (ax179_data->initialized)
+	ax88179_read_cmd(dev, AX_ACCESS_PHY, AX88179_PHY_ID, GMII_PHY_PHYSR,
+			 2, &tmp16);
+	if (tmp16) {
+		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+				 2, 2, &tmp16);
+		if (!(tmp16 & AX_MEDIUM_RECEIVE_EN)) {
+			tmp16 |= AX_MEDIUM_RECEIVE_EN;
+			ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+					  2, 2, &tmp16);
+		}
+	} else {
 		ax88179_reset(dev);
-	else
-		ax179_data->initialized = 1;
+	}
 
 	return 0;
 }



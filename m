Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3512EBEA;
	Tue, 25 Jun 2024 09:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308618; cv=none; b=ItBCKMd5L5OnZliyJ0aOfxSnwZ+OGz8GdZyX8ZWJ6PoQkNQw27PrbyNaiqNaVtLoc9KF9OhcnqLM94SjqeOrUBWjYWxOTM7W/OapCrU5HjRjMQioUyAPgpUslDh8qR0xe9wXQeuNHdo3HRMi2OstDrnCH92NysuFwID41Wc8fow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308618; c=relaxed/simple;
	bh=NDB8jtIqUnZQ1eMVRinRwgqUhyb5Xt/4kfdU2bDDgyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U4bozj769//lP56MPoX+kQmBPrnb+LdwWvT/7EAdMYu9Q4vpRi+qYeyjhoPzP7UyR4c/yUIh5x/2ndZd+v2MnpWkza3LW9/9bt5qUv8kRtPID86XP+aZ+zGmuFK47KA2HQWzt3vEbDb+LPTc7NQT7BG5+qtjmAYBqBAvNUk0A9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzOG9VMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzOG9VMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E877EC32781;
	Tue, 25 Jun 2024 09:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308618;
	bh=NDB8jtIqUnZQ1eMVRinRwgqUhyb5Xt/4kfdU2bDDgyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzOG9VMvYg71mGSjE8hJnr14nSzq6cdDW8kHK6xO2q77tYqD1dLpdaLJiErXyTL0p
	 JSWB8bxlt+YVonqWN+OCAex+amjbtnoI/1wDnD+be8pWzckKeQlIe7pgXbSjpcStAV
	 PZzbNq7SQVs2aiqs4mzAoYr0dnYVT+jZI/ZhsBDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	=?UTF-8?q?Antje=20Miederh=C3=B6fer?= <a.miederhoefer@gmx.de>,
	Arne Fitzenreiter <arne_f@ipfire.org>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.9 182/250] net: usb: ax88179_178a: improve reset check
Date: Tue, 25 Jun 2024 11:32:20 +0200
Message-ID: <20240625085555.036831395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



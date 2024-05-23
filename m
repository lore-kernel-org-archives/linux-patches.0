Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB381E4B0;
	Thu, 23 May 2024 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470223; cv=none; b=p8WLp8ujc7DWPJtzWuswzmWGWgT6kkeEgBnKvn8QrDyWFDZllJgId720iiqro9L8EGp6tc4hLt7N+C1FcG+ZrB0QFfJfFm0vEIW3sYe7at/WIDTSrM4wsFcg5C8tsU7E6oDxHaD1+YRgYkZy4gtebCfQxOljLVwemSqlrODDeOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470223; c=relaxed/simple;
	bh=BTwqio0Z+CBcrRDOMoYbtt7HfAnXQMGCI4AI3O7koOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEahu1V+YKMzKM945x/8yEaVhxovFlzhKUBcuYVGekQi3ZlPbFPdKoxiDpGIkb6qor+8DEt7T48SlBRL7sLX9xHpSLqxWZr3Bj6D+YzJrSMF2KtTKJ0ArXfv66V2r3F+QEMS3NNA8Vrxuwjzi9Tu8KjnHUVwx0X4TbTueaRWjUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVGb2OoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVGb2OoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B4AC2BD10;
	Thu, 23 May 2024 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470222;
	bh=BTwqio0Z+CBcrRDOMoYbtt7HfAnXQMGCI4AI3O7koOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVGb2OoXOcqsnPW3CeDIZ5jnuh0CRAF4V8y5PhKuKzn/E+5m9sfGqNwpq9q8wvsUV
	 e+ZPLJPDR6N9QJlPARxCN96puZxLzRbMPrd49aNymi6gKqLpQbWt1kyn74ivrl+EfF
	 FYkR/LVtbeWeufZYh2Ibaq1tcEe6Oc7gaHTRZK1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Ganoung <inventor500@vivaldi.net>,
	Yongqin Liu <yongqin.liu@linaro.org>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 12/25] net: usb: ax88179_178a: fix link status when link is set to down/up
Date: Thu, 23 May 2024 15:12:57 +0200
Message-ID: <20240523130330.852282367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit ecf848eb934b03959918f5269f64c0e52bc23998 upstream.

The idea was to keep only one reset at initialization stage in order to
reduce the total delay, or the reset from usbnet_probe or the reset from
usbnet_open.

I have seen that restarting from usbnet_probe is necessary to avoid doing
too complex things. But when the link is set to down/up (for example to
configure a different mac address) the link is not correctly recovered
unless a reset is commanded from usbnet_open.

So, detect the initialization stage (first call) to not reset from
usbnet_open after the reset from usbnet_probe and after this stage, always
reset from usbnet_open too (when the link needs to be rechecked).

Apply to all the possible devices, the behavior now is going to be the same.

cc: stable@vger.kernel.org # 6.6+
Fixes: 56f78615bcb1 ("net: usb: ax88179_178a: avoid writing the mac address before first reading")
Reported-by: Isaac Ganoung <inventor500@vivaldi.net>
Reported-by: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240510090846.328201-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -174,6 +174,7 @@ struct ax88179_data {
 	u32 wol_supported;
 	u32 wolopts;
 	u8 disconnecting;
+	u8 initialized;
 };
 
 struct ax88179_int_data {
@@ -1673,6 +1674,18 @@ static int ax88179_reset(struct usbnet *
 	return 0;
 }
 
+static int ax88179_net_reset(struct usbnet *dev)
+{
+	struct ax88179_data *ax179_data = dev->driver_priv;
+
+	if (ax179_data->initialized)
+		ax88179_reset(dev);
+	else
+		ax179_data->initialized = 1;
+
+	return 0;
+}
+
 static int ax88179_stop(struct usbnet *dev)
 {
 	u16 tmp16;
@@ -1692,6 +1705,7 @@ static const struct driver_info ax88179_
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1704,6 +1718,7 @@ static const struct driver_info ax88178a
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1716,7 +1731,7 @@ static const struct driver_info cypress_
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1729,7 +1744,7 @@ static const struct driver_info dlink_du
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1742,7 +1757,7 @@ static const struct driver_info sitecom_
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1755,7 +1770,7 @@ static const struct driver_info samsung_
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1768,7 +1783,7 @@ static const struct driver_info lenovo_i
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset = ax88179_reset,
+	.reset = ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1781,7 +1796,7 @@ static const struct driver_info belkin_i
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset	= ax88179_reset,
+	.reset	= ax88179_net_reset,
 	.stop	= ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1794,7 +1809,7 @@ static const struct driver_info toshiba_
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset	= ax88179_reset,
+	.reset	= ax88179_net_reset,
 	.stop = ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1807,7 +1822,7 @@ static const struct driver_info mct_info
 	.unbind	= ax88179_unbind,
 	.status	= ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset	= ax88179_reset,
+	.reset	= ax88179_net_reset,
 	.stop	= ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1820,7 +1835,7 @@ static const struct driver_info at_umc20
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset  = ax88179_reset,
+	.reset  = ax88179_net_reset,
 	.stop   = ax88179_stop,
 	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1833,7 +1848,7 @@ static const struct driver_info at_umc20
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset  = ax88179_reset,
+	.reset  = ax88179_net_reset,
 	.stop   = ax88179_stop,
 	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
@@ -1846,7 +1861,7 @@ static const struct driver_info at_umc20
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
-	.reset  = ax88179_reset,
+	.reset  = ax88179_net_reset,
 	.stop   = ax88179_stop,
 	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,



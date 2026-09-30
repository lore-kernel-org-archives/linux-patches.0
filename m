Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D9251B16C;
	Wed, 30 Sep 2026 18:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792634; cv=none; b=mGvQfvqEGoe2IvgEGr4FMSH33XstlV5+7u8XYngeuB4aMi3Z9qJElYEHoD6WY2tzfxJUC5t79LxYKc+UoHgqlZuUouEvoHcY+t9/4hJD4ADsoBEnjVw0Qoq5DJ+EGWKh6GkAGnVk+0UDokhfWudntG40/hcPwso3viEDNgCfwzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792634; c=relaxed/simple;
	bh=w/12m1h6b33cwhOf+lvXaoKlkXuyk5VwHPdvo0D0pgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRSgFg/CPxWMo6xehl9ep383bdP6AZj14ETQj7hFay/trk8VTzytINW4rswsHgq3BNqIp6jnHkGVKcwkVLjFlXlP6kmYc1IBs7AP6MwqpmSMDUhfL1XnqZQ0mC4fVy2wVJsfOE/cSTURw1GBpcJkuQV5ph2Sdn85gLZY4v8N1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbF99Ze1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbF99Ze1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE8E1F000FF;
	Wed, 30 Sep 2026 18:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792633;
	bh=cTgn1GESVZNj07J6Y4LPjchdtRrGzxN/X4vitDrAsI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbF99Ze1WTeEljTyzIiiiUxpG2FNvyzuzkOOmF9cSebj9MwRw3c5GYFjFCZbNRDIM
	 LVN3jcs7kWs4dGUQRTFwO9BBVNS6nQ9LAwgJwmJwjZN4ttwNfGSl8/6x99QdGnwATH
	 KTHRAE2GVJuTKj6MYt1bfhE4ujPy79WKkpd4XuSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 724/752] net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist
Date: Wed, 30 Sep 2026 17:29:54 +0200
Message-ID: <20260930152413.886454008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Wang <wangming01@loongson.cn>

commit f75f21ef36285e5f56ee0c428bd2909ee81165b9 upstream.

The MeiG Smart SRM821 5G module (0x2dee:0x4d53) crashes and drops off
the USB bus when it receives a Zero Length Packet (ZLP) after sending
or receiving an NTB of exactly 16384 bytes (tx_max).

According to the MBIM specification, devices do not require a ZLP
if the NTB size is exactly dwNtbOutMaxSize. However, the cdc_mbim
driver defaults to sending ZLPs for devices not explicitly whitelisted
to accommodate non-conformant hardware. This default behavior breaks
the strictly conformant MeiG SRM821 module.

Add this device to the ZLP conformance whitelist (cdc_mbim_info) so
the driver will pad the NTB to avoid sending ZLPs, preventing the
device firmware from crashing.

Cc: stable@vger.kernel.org
Signed-off-by: Ming Wang <wangming01@loongson.cn>
Link: https://patch.msgid.link/20260920074500.826121-1-wangming01@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_mbim.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -633,6 +633,11 @@ static const struct usb_device_id mbim_d
 	  .driver_info = (unsigned long)&cdc_mbim_info,
 	},
 
+	/* MeiG Smart SRM821 ZLP conformance */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2dee, 0x4d53, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info,
+	},
+
 	/* Some Huawei devices, ME906s-158 (12d1:15c1) and E3372
 	 * (12d1:157d), are known to fail unless the NDP is placed
 	 * after the IP packets.  Applying the quirk to all Huawei



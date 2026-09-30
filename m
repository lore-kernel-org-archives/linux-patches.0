Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2239A5208D1;
	Wed, 30 Sep 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789549; cv=none; b=OB9VIXABB1yOxnVulf+nQ7M0zOCT2Z6fBiLX1eVEhrFdmey7gwKsMt8aFiCbobG0LvBXJgkmsnXnZg0NX4FqyYNB2b97+6W7/X36cjQ+IA6CBkO2QvcRyBwROkRkvwOaHrKkmyrOvSeBTGEEn/KfSxwQEZe5M58go4qw1jDJX90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789549; c=relaxed/simple;
	bh=sdkSt3rW4qXcbKTw5wOo4AVCnve3TOmCR24EXX1+FlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob/RveJXflQGbHUeyMDQ1AkvNqD3T9AsusOlVOnRmQ/COFbuWbtvEpbWdlpfaf4i9BbxAfAML9KMX749CYs2xheiqIE0fCYpTDW1h2BP/uYO/HMJqgWeUjcoGInIHaeXCT624yh0+c3IyaIqJXYzgcT73QCf+ULcmSFGcLb0yao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pANFDUcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pANFDUcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E57B1F000FF;
	Wed, 30 Sep 2026 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789547;
	bh=0rHQGCONAgjN46z813BrHfUxKG4PJy1bi8gm07GtJlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pANFDUcSL/8J/OiSGj+exeiulSvMjBno3j/VSVBeeRppSvshwV3Y3MUA3bRNAVH/S
	 MKx4HPDxRVTLfeMgm0bJBUBz1Ar5BroJ2SHes3JbLT84yJJ71WplzMxnlLKnTfRN0h
	 T4Fw1hoYOK7oeLW5Vhd8KaHEYwf4akPCXdxLFS5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 516/877] net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist
Date: Wed, 30 Sep 2026 17:23:47 +0200
Message-ID: <20260930152425.789270430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -634,6 +634,11 @@ static const struct usb_device_id mbim_d
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



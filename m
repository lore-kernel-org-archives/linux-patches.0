Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F754E01FA;
	Wed, 30 Sep 2026 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783954; cv=none; b=Pvk7ZZOtqtnzya+QCKn0RbhXl8mD/UYqvG6HJiHB5h8bUxWycjceBXa4p9ceQ024YtbiklLwVjVzjNlZ1SNCalDVpUd9OV3wu46s9gTY7qzOIV/esXXYj99joVs9QtURE3UG7GUye5hBMimHLL0wu0XShf3Ki4jllziAoWcBkpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783954; c=relaxed/simple;
	bh=gVcDVO8JLkzBbFi7TGy/Ht8jk0izFaZojdg+2CJ977Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpanGJPLTw8TsrMNTyaSl3hbheKYq4QSSgcpj+qFzdXObgRuh1Il+ls5vdDkzPuKULae+dHxOhw1RixoxSqorutFBhmH5z5LGzgW/g6maH7Mhs8+8lSWQCkrFkegjD7dxcwGed62J4U3ipyUQATqWD+Oo1j6Y8ebyTMbmyQdzrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxAaHe/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxAaHe/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7949D1F00893;
	Wed, 30 Sep 2026 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783952;
	bh=FfHvAE3ZhPX6xBYlJ7BNDqM5kulTdKYqDq6+u2/g4gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxAaHe/ZMPdRFR0qIxq7QXaK1SOi0N+bQ9Y8Qy3Gr6njQMs1Ve1KYKqEE5uMmNtLx
	 w38NMkY+HrM5SaetB3FQqqjgskVkhPqM9hQhihDWEEklVyCeUOk94vMLOrm5Qgkao0
	 RSeiG5391l6BNfbi1CPHP4yQj/8wkIC1tbII5+N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 579/595] net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist
Date: Wed, 30 Sep 2026 17:27:52 +0200
Message-ID: <20260930152400.187324198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -632,6 +632,11 @@ static const struct usb_device_id mbim_d
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



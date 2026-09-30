Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D684E4F5E18;
	Wed, 30 Sep 2026 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793533; cv=none; b=a2ETNylrHUlZcXHTUNDIP/JM2IQwHlKrm3+QYPjVKTZBOsQn60OScwtBkeTx2RrsCIcyTaRmMIY/kRD5VmyP6HCCzVE76SSdCj5VrC5bQZi2vVMO030S7qhu4Um1TAC0baSxnwfNwwSa45sLr8/G7J4/iQhviaQUctHN9CXx330=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793533; c=relaxed/simple;
	bh=1jxkCdgPqevviy6cgjfE2fqNHT6cbpLczH53RXzY16o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhxvcqG9RCnsZ82ShnxvWg+r0dSlWDxT9DbeJDa32kKm5H2DPRzk7eqy22sKr/q527164kM5QSlaIdbyml6prxb0+Y5Qv1n+e5RpNDDrgk0g6ol+ZycMmrZ7nGbtL1bCnxuud5Iv9fk5kVYoBkgDrxn4JgXhK6vXu88ZU9n5xOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPJzc9uv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPJzc9uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335421F00898;
	Wed, 30 Sep 2026 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793531;
	bh=IoTKdLL6aYJZI5+y77utXr0fYJ7fV1X3lqjRlNNoWYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPJzc9uv1kG47vhoQ0ic/CfbxA59qgA81pJCbILxW69tyHjUu33H/IZCMXNvWj/dS
	 ZAc5cUXG8hQ4rQEsT5F8c+jEde2ZVgmPIPVjiM0oKPjNZmRcdRzfVb1pO3AU4xWGaC
	 Gak4R5Yrjr++YK8Z6fk0Zp9ELVrtNv4WK0vz/Ws0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming01@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 288/395] net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist
Date: Wed, 30 Sep 2026 17:29:10 +0200
Message-ID: <20260930152346.907090250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



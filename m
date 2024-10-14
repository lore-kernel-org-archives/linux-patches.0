Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FC17C69;
	Mon, 14 Oct 2024 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920028; cv=none; b=I2KKZ3rO0J7/XKZLNhSSI3ibt1g+tH2IJrphbS8pw1uFGcDipNSr/LZj/3sWVyeHXVHYPr8ItVRjiONtyuDts6x5nIdQdqSzyrGe9T72AzHP47TW+G4zaJu+5Dac0uCiADwFC10XLSr2IBEgMv6LnIbMZbrYyN21SaJ0nim+jN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920028; c=relaxed/simple;
	bh=a6FiCbUSnPGK0IazHF0rTFCDsQpkksjabomSkATyW8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCfGxy7lzalmjLLVCZpObQ4OPeawQs+yEY/rE2rmIsAIdQhV6jMjbM0Rv17xGhp1Z/6GhQhTPfPpDxlYI63hTdswBNfeAhvBotNFJMmRTRBVBQI5Xr+/rN424L5nwy8ezWATrBcVjHBEN0+jVwnVTmG6xXVX5rYp5Fjk6DtpEcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxnA+ohO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxnA+ohO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E95C4CEC3;
	Mon, 14 Oct 2024 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920028;
	bh=a6FiCbUSnPGK0IazHF0rTFCDsQpkksjabomSkATyW8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxnA+ohOUtjn0vUcJagvLqK1lwqxzOY4Jwk4S0YpiiH8VL6bG2wYsMJK9xh1koQCz
	 LoZBkqHM0zanUkvOjLKhCcFxA9NUjvFiypTPNGR9I18HXA+wy3H3nD4aGOEzh4w5iX
	 /Byn87+6Arcr+i5i/Yvkt1Qd/KRywQqr1ycZ8oAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 778/798] usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
Date: Mon, 14 Oct 2024 16:22:12 +0200
Message-ID: <20241014141248.630396823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

commit a6555cb1cb69db479d0760e392c175ba32426842 upstream.

JieLi tends to use SCSI via USB Mass Storage to implement their own
proprietary commands instead of implementing another USB interface.
Enumerating it as a generic mass storage device will lead to a Hardware
Error sense key get reported.

Ignore this bogus device to prevent appearing a unusable sdX device
file.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241001083407.8336-1-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2423,6 +2423,17 @@ UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NOT_LOCKABLE),
 
+/*
+ * Reported by Icenowy Zheng <uwu@icenowy.me>
+ * This is an interface for vendor-specific cryptic commands instead
+ * of real USB storage device.
+ */
+UNUSUAL_DEV(  0xe5b7, 0x0811, 0x0100, 0x0100,
+		"ZhuHai JieLi Technology",
+		"JieLi BR21",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_DEVICE),
+
 /* Reported by Andrew Simmons <andrew.simmons@gmail.com> */
 UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x0001,
 		"DataStor",



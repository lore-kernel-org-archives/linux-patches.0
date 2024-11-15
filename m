Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A53185924;
	Fri, 15 Nov 2024 06:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653481; cv=none; b=rzf/DqtGhP4kbUxCOux+Q6tbhptCNvYWVCkd5x0525Sj6IPMrKzZ4U/rGfE5oAxfc/d7UTv77zEavbJ8jn5gjogku1R2exTNXYSOSu/BbBwcuTactJnCUHd5GGYSD3teeTKf2yNs/fLrpgOuk6dppZ3lQguVm17izEV9mDAlh5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653481; c=relaxed/simple;
	bh=i374AB5Jr/KSAp4liQ7ii5ThTt65EmIkkMt3QPlvzyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4pXbB0yGpxhsm5JCP/n1ES0DDcpwq6ko5fwwSjZ/yo/fPP+1eBAuGCP9iUdaCi/ELNkA1DVBoyajXN4OZTKj2l2Nmzbped7dTnAn5DMYHiiJrUPzKYP4kvaryYTF9VqePfhR6OtfCQKBt0x+hi9p7HeQRjwokW0HixQEcATPco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSB+kpdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSB+kpdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C0CC4CECF;
	Fri, 15 Nov 2024 06:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653480;
	bh=i374AB5Jr/KSAp4liQ7ii5ThTt65EmIkkMt3QPlvzyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSB+kpduA3Gm1V3jpFQKnA6Xt7Blf8rWPeaD3bjJO5cYuz/bWgD81XMxrrwS5HT4a
	 CfND4HZWND+OunelGvihnmMMG8fWVM3UdyKRAvrWH5N79PfbiBC7W2pRckmfl9ozyV
	 eMdGT5EBjs4fEirVlSt9qx31UTLqKDF+3eOiEOis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Blum <stefan.blum@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/48] HID: multitouch: Add support for B2402FVA track point
Date: Fri, 15 Nov 2024 07:37:56 +0100
Message-ID: <20241115063723.228770343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Blum <stefanblum2004@gmail.com>

[ Upstream commit 1a5cbb526ec4b885177d06a8bc04f38da7dbb1d9 ]

By default the track point does not work on the Asus Expertbook B2402FVA.

>From libinput record i got the ID of the track point device:
  evdev:
    # Name: ASUE1201:00 04F3:32AE
    # ID: bus 0x18 vendor 0x4f3 product 0x32ae version 0x100

I found that the track point is functional, when i set the
MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU class for the reported device.

Signed-off-by: Stefan Blum <stefan.blum@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e7199ae2e3d91..7584e5a3aafeb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2020,6 +2020,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x3148) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x32ae) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
-- 
2.43.0




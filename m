Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC263350D75;
	Tue, 26 Aug 2025 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219320; cv=none; b=kvccIa4/t9y7wIHlOkYiq2+iGZCnHduZBuKx5rQ4l8e9pTzvKJ04OF9pkQrKNDd8YuayxZpct77IfLFiO09khXUAXJ8lw8gAu/pZVkdV79Bagb0hBoEH7awXulUbh/v6ZW2fipNqIV9zugUMMqLTAUBiY7Gb7OlHWXEpTdXMBG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219320; c=relaxed/simple;
	bh=hpDYuBygdIJZjsNipRWlnFBXSvuCelLzJ1UsZreDKbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FbBP+k+5iPqeqT6NmvTYWR4qDIdFbmyDMNzps1yn32hFxhVu/yRiwDZLVIRTyKoOGYPVjtX5kDbY/l01keCTEfQLfXeNpCqdddBVYVsYEYyLM6suujKFkaWDOdcloHQ6XD7VrQFS59PSC0pZ6AAgiZ5s4ZJDvCiySpvRCT4C7tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuOM8Qde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuOM8Qde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E84C4CEF1;
	Tue, 26 Aug 2025 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219320;
	bh=hpDYuBygdIJZjsNipRWlnFBXSvuCelLzJ1UsZreDKbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuOM8QdeByOcH2ziSeLDrbZ0Yh6MoFSKNrtw53ONC3p16cHmiYij19iUW7zwzTz0M
	 4j8giotwVOjIwTXs1/5HbLgq1o0WBK3She68qkH9W+/cEuJ/nGpfjI6PIau9jNFLjC
	 bovxDgiT2tfQpltdgYYbpSpkZNaIBxpIlRzGNlsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mael GUERIN <mael.guerin@murena.io>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 319/403] USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera
Date: Tue, 26 Aug 2025 13:10:45 +0200
Message-ID: <20250826110915.624294119@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mael GUERIN <mael.guerin@murena.io>

commit 6ca8af3c8fb584f3424a827f554ff74f898c27cd upstream.

Add the US_FL_BULK_IGNORE_TAG quirk for Novatek NTK96550-based camera
to fix USB resets after sending SCSI vendor commands due to CBW and
CSW tags difference, leading to undesired slowness while communicating
with the device.

Please find below the copy of /sys/kernel/debug/usb/devices with my
device plugged in (listed as TechSys USB mass storage here, the
underlying chipset being the Novatek NTK96550-based camera):

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0603 ProdID=8611 Rev= 0.01
S:  Manufacturer=TechSys
S:  Product=USB Mass Storage
S:  SerialNumber=966110000000100
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Mael GUERIN <mael.guerin@murena.io>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250806164406.43450-1-mael.guerin@murena.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -934,6 +934,13 @@ UNUSUAL_DEV(  0x05e3, 0x0723, 0x9451, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_SANE_SENSE ),
 
+/* Added by Maël GUERIN <mael.guerin@murena.io> */
+UNUSUAL_DEV(  0x0603, 0x8611, 0x0000, 0xffff,
+		"Novatek",
+		"NTK96550-based camera",
+		USB_SC_SCSI, USB_PR_BULK, NULL,
+		US_FL_BULK_IGNORE_TAG ),
+
 /*
  * Reported by Hanno Boeck <hanno@gmx.de>
  * Taken from the Lycoris Kernel



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A659D22AE5D;
	Tue, 26 Aug 2025 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213906; cv=none; b=qy3G1j1aY1zF+vUxAO5LWwtOuf17vmp8kYYXYEvG8aHXgvlEji5Sroq8TIf7ZgPkFdsUkzob5S9SApngRt4AypAk3SNwIiJwJNdVptQNVKz+om2tdFprtVUJ371hNtnO+7rrHvYHmMexi+U1dhQRPYiYjJiIM6QnNLaAjfC5zrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213906; c=relaxed/simple;
	bh=8+oqSpJcLVvtoc4pKraivdneiPCCHxU4aZOiEZ1s0kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDzxHxKjU8CL43FCUj5aaaQqLDX53xWeX1Fvlv/Wr7WkgnfmNEgUEl7VDRRAUPskDQpmAAmpg0cD6cJaeYFukFQODulrbF31rzEPLbih9q6hS1kEBHXB55iBHF1Cj6jtLaFd+GnydB15ClvHX3fgV0y56FFQLliO6fT7kwZA4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rev2Ehk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rev2Ehk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFDFC4CEF1;
	Tue, 26 Aug 2025 13:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213906;
	bh=8+oqSpJcLVvtoc4pKraivdneiPCCHxU4aZOiEZ1s0kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rev2Ehk6YGon3FDuJtRMhKolNwKl7Xoz2qo3OprWo16c2xEnyxgyRCgPxVfzEsYgL
	 7ZV3NNam2cLoYkJgU7F0tR2zX/IxcOxaIJWMgNiGur9avBqAmv4YJoLlIXDml2F2YN
	 AZlmvPeKnUlwv06AnAM3eA6YbYUyJs6Fim+MmkvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mael GUERIN <mael.guerin@murena.io>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 525/587] USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera
Date: Tue, 26 Aug 2025 13:11:14 +0200
Message-ID: <20250826111006.355755626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


